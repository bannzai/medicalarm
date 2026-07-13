// sendMedicationRecordNotificationHandler のユニットテスト。
// debug_mode 除外・無効トークンのクリーンアップ・push 本文のサーバ導出・500 件チャンク分割を検証する。

type OnCallResult = {
  result: "OK" | "NG";
  statusCode: number;
  data?: Record<string, unknown>;
  error?: { message: string };
};
type Handler = (req: {
  auth?: { uid?: string | null } | null;
  data?: Record<string, unknown>;
}) => Promise<OnCallResult>;

const mockCollection = jest.fn();
const mockSendEach = jest.fn();
const mockMessaging = jest.fn(() => ({ sendEachForMulticast: mockSendEach }));
const mockFirestoreInstance = { collection: mockCollection };
const mockFirestore = Object.assign(jest.fn(() => mockFirestoreInstance), {
  FieldValue: {
    serverTimestamp: jest.fn(() => "SERVER_TIMESTAMP"),
    arrayRemove: jest.fn((...ids: string[]) => ({ arrayRemove: ids })),
  },
});

jest.mock("firebase-admin", () => ({
  firestore: mockFirestore,
  messaging: mockMessaging,
}));

jest.mock("firebase-admin/firestore", () => ({
  FieldValue: mockFirestore.FieldValue,
}));

jest.mock("firebase-functions/v2/https", () => ({
  onCall: (_opts: unknown, handler: unknown) => handler,
}));

jest.mock("firebase-functions", () => ({
  logger: { info: jest.fn(), error: jest.fn(), warn: jest.fn() },
}));

// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require("./function") as Handler;

type PrivateRef = { get: jest.Mock; update: jest.Mock };

const senderProfileRef = { get: jest.fn() };
const medicineRef = { get: jest.fn() };
const groupDocRef = {
  get: jest.fn(),
  collection: jest.fn((name: string) => ({
    doc: jest.fn(() => (name === "medicines" ? medicineRef : senderProfileRef)),
  })),
};
let privateRefs: Record<string, PrivateRef> = {};

function makePrivateRef(tokens: string[] | null): PrivateRef {
  return {
    get: jest.fn().mockResolvedValue(
      tokens === null
        ? { exists: false, data: () => undefined }
        : { exists: true, data: () => ({ fcmTokens: tokens }) }
    ),
    update: jest.fn().mockResolvedValue(undefined),
  };
}

function setup(args: {
  members: string[];
  senderDisplayName?: string | null;
  medicineExists?: boolean;
  medicineName?: string;
  doseReceiverName?: string;
  tokensByUser: Record<string, string[] | null>;
}): void {
  groupDocRef.get.mockResolvedValue({
    exists: true,
    data: () => ({ memberUserIDs: args.members }),
  });
  medicineRef.get.mockResolvedValue(
    args.medicineExists === false
      ? { exists: false, data: () => undefined }
      : { exists: true, data: () => ({ name: args.medicineName ?? "ロキソニン", doseReceiver: { name: args.doseReceiverName ?? "太郎" } }) }
  );
  senderProfileRef.get.mockResolvedValue({
    data: () => ({ displayName: args.senderDisplayName ?? null }),
  });
  privateRefs = {};
  for (const [userID, tokens] of Object.entries(args.tokensByUser)) {
    privateRefs[userID] = makePrivateRef(tokens);
  }
  mockCollection.mockImplementation((path: string) => {
    if (path === "groups") {
      return { doc: jest.fn(() => groupDocRef) };
    }
    if (path === "users") {
      return {
        doc: jest.fn((userID: string) => ({
          collection: jest.fn(() => ({
            doc: jest.fn(() => privateRefs[userID]),
          })),
        })),
      };
    }
    return {};
  });
}

describe("sendMedicationRecordNotification", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("debug_mode トークンは送信対象から除外する", async () => {
    setup({
      members: ["me", "other"],
      senderDisplayName: "田中",
      tokensByUser: { other: ["real-token", "debug_mode"] },
    });
    mockSendEach.mockResolvedValue({
      successCount: 1,
      failureCount: 0,
      responses: [{ success: true }],
    });

    const result = await handler({
      auth: { uid: "me" },
      data: { groupID: "group-1", medicineID: "med-1" },
    });

    expect(result.result).toBe("OK");
    expect(mockSendEach).toHaveBeenCalledWith(
      expect.objectContaining({ tokens: ["real-token"] })
    );
    // 送信者名がタイトルに反映される
    expect(mockSendEach).toHaveBeenCalledWith(
      expect.objectContaining({
        notification: expect.objectContaining({
          title: "田中さんが服薬を記録しました",
        }),
      })
    );
  });

  test("push 本文は薬ドキュメントからサーバ側で導出する (クライアント引数は使わない)", async () => {
    setup({
      members: ["me", "other"],
      senderDisplayName: "田中",
      medicineName: "ロキソニン",
      doseReceiverName: "太郎",
      tokensByUser: { other: ["real-token"] },
    });
    mockSendEach.mockResolvedValue({
      successCount: 1,
      failureCount: 0,
      responses: [{ success: true }],
    });

    // クライアントは groupID / medicineID のみを渡す
    const result = await handler({
      auth: { uid: "me" },
      data: { groupID: "group-1", medicineID: "med-1" },
    });

    expect(result.result).toBe("OK");
    expect(mockSendEach).toHaveBeenCalledWith(
      expect.objectContaining({
        notification: expect.objectContaining({
          body: "太郎の「ロキソニン」を記録しました",
        }),
      })
    );
  });

  test("薬が見つからない場合は 404", async () => {
    setup({
      members: ["me", "other"],
      medicineExists: false,
      tokensByUser: { other: ["real-token"] },
    });

    const result = await handler({
      auth: { uid: "me" },
      data: { groupID: "group-1", medicineID: "med-1" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(404);
    expect(mockSendEach).not.toHaveBeenCalled();
  });

  test("500 件を超えるトークンはチャンクに分割して送信し、件数を集約する", async () => {
    // 501 件のトークンを 1 ユーザーに持たせる
    const tokens = Array.from({ length: 501 }, (_, i) => `token-${i}`);
    setup({
      members: ["me", "other"],
      tokensByUser: { other: tokens },
    });
    // チャンクごとにトークン数分の成功レスポンスを返す
    mockSendEach.mockImplementation((message: { tokens: string[] }) =>
      Promise.resolve({
        successCount: message.tokens.length,
        failureCount: 0,
        responses: message.tokens.map(() => ({ success: true })),
      })
    );

    const result = await handler({
      auth: { uid: "me" },
      data: { groupID: "group-1", medicineID: "med-1" },
    });

    expect(result.result).toBe("OK");
    // 500 + 1 の 2 チャンクに分割される
    expect(mockSendEach).toHaveBeenCalledTimes(2);
    expect(mockSendEach.mock.calls[0][0].tokens).toHaveLength(500);
    expect(mockSendEach.mock.calls[1][0].tokens).toHaveLength(1);
    expect(result.data?.successCount).toBe(501);
    expect(result.data?.failureCount).toBe(0);
  });

  test("無効トークンは arrayRemove でクリーンアップする", async () => {
    setup({
      members: ["me", "other"],
      tokensByUser: { other: ["good-token", "bad-token"] },
    });
    mockSendEach.mockResolvedValue({
      successCount: 1,
      failureCount: 1,
      responses: [
        { success: true },
        {
          success: false,
          error: { code: "messaging/registration-token-not-registered" },
        },
      ],
    });

    const result = await handler({
      auth: { uid: "me" },
      data: { groupID: "group-1", medicineID: "med-1" },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.failureCount).toBe(1);
    expect(privateRefs["other"].update).toHaveBeenCalledWith(
      expect.objectContaining({ fcmTokens: { arrayRemove: ["bad-token"] } })
    );
  });

  test("送信対象トークンが 0 件なら送信をスキップする", async () => {
    setup({
      members: ["me", "other"],
      tokensByUser: { other: [] },
    });

    const result = await handler({
      auth: { uid: "me" },
      data: { groupID: "group-1", medicineID: "med-1" },
    });

    expect(result.result).toBe("OK");
    expect(result.data).toEqual({ successCount: 0, failureCount: 0 });
    expect(mockSendEach).not.toHaveBeenCalled();
  });

  test("非メンバーは 403", async () => {
    setup({ members: ["someone"], tokensByUser: {} });

    const result = await handler({
      auth: { uid: "outsider" },
      data: { groupID: "group-1", medicineID: "med-1" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(403);
  });

  test("未認証は 401", async () => {
    const result = await handler({
      auth: null,
      data: { groupID: "group-1", medicineID: "med-1" },
    });
    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(401);
  });
});

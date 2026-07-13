// sendMedicationRecordNotificationHandler のユニットテスト。debug_mode 除外・無効トークンのクリーンアップを検証する。

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
const groupDocRef = {
  get: jest.fn(),
  collection: jest.fn(() => ({ doc: jest.fn(() => senderProfileRef) })),
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
  tokensByUser: Record<string, string[] | null>;
}): void {
  groupDocRef.get.mockResolvedValue({
    exists: true,
    data: () => ({ memberUserIDs: args.members }),
  });
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
      data: {
        groupID: "group-1",
        medicineID: "med-1",
        medicineName: "ロキソニン",
        doseReceiverName: "太郎",
      },
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

// acceptGroupInvitationHandler のユニットテスト。
// 期限切れ / 使用済み / 既メンバー冪等 / accepted 済みリトライ / 招待者除名済みの無効化を検証する。

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

const DAY_MS = 24 * 60 * 60 * 1000;

const mockCollection = jest.fn();
const mockRunTransaction = jest.fn();
const mockFirestoreInstance = {
  collection: mockCollection,
  runTransaction: mockRunTransaction,
};
const mockFirestore = Object.assign(jest.fn(() => mockFirestoreInstance), {
  FieldValue: {
    serverTimestamp: jest.fn(() => "SERVER_TIMESTAMP"),
    arrayUnion: jest.fn((...ids: string[]) => ({ arrayUnion: ids })),
  },
});

jest.mock("firebase-admin", () => ({ firestore: mockFirestore }));

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

const invitationRefObj = { update: jest.fn() };
const profileRef = { __ref: "profileRef" };
const groupRef = {
  collection: jest.fn(() => ({ doc: jest.fn(() => profileRef) })),
};

const mockTransaction = {
  get: jest.fn(),
  set: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};

/** 招待検索・トランザクション読み取りをセットアップする。 */
function setup(args: {
  found: boolean;
  expiresOffsetMs?: number;
  // 検索時 / トランザクション再読み込み時の招待ステータス
  invitationStatus?: string;
  txInvitationStatus?: string;
  // 招待者 (デフォルトはグループメンバーの owner)
  inviterUserID?: string;
  groupMembers?: string[];
}): void {
  const inviterUserID = args.inviterUserID ?? "owner";
  const invitationStatus = args.invitationStatus ?? "pending";
  const invitationDoc = {
    ref: invitationRefObj,
    data: () => ({
      groupID: "group-1",
      inviterUserID,
      status: invitationStatus,
      expiresDateTime: {
        toDate: () => new Date(Date.now() + (args.expiresOffsetMs ?? DAY_MS)),
      },
    }),
  };
  mockCollection.mockImplementation((path: string) => {
    if (path === "groupInvitations") {
      // invitationCode のみで検索する (status フィルタは付けない)
      return {
        where: jest.fn(() => ({
          limit: jest.fn(() => ({
            get: jest.fn().mockResolvedValue(
              args.found
                ? { empty: false, docs: [invitationDoc] }
                : { empty: true, docs: [] }
            ),
          })),
        })),
      };
    }
    if (path === "groups") {
      return { doc: jest.fn(() => groupRef) };
    }
    return {};
  });
  mockTransaction.get.mockImplementation((ref: unknown) => {
    if (ref === groupRef) {
      return Promise.resolve({
        exists: true,
        data: () => ({ memberUserIDs: args.groupMembers ?? ["owner"] }),
      });
    }
    if (ref === invitationRefObj) {
      return Promise.resolve({
        data: () => ({
          status: args.txInvitationStatus ?? invitationStatus,
          inviterUserID,
        }),
      });
    }
    return Promise.resolve({ exists: false, data: () => undefined });
  });
  mockRunTransaction.mockImplementation(
    (fn: (tx: typeof mockTransaction) => Promise<unknown>) => fn(mockTransaction)
  );
}

describe("acceptGroupInvitation", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    invitationRefObj.update.mockResolvedValue(undefined);
  });

  test("正常系: 未参加ユーザーがグループに参加する", async () => {
    setup({ found: true, groupMembers: ["owner"] });

    const result = await handler({
      auth: { uid: "newbie" },
      data: { invitationCode: "ABCD3456" },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.groupID).toBe("group-1");
    // グループへの arrayUnion 追加・招待 accepted 化・プロフィール作成
    expect(mockTransaction.update).toHaveBeenCalledWith(
      groupRef,
      expect.objectContaining({ memberUserIDs: { arrayUnion: ["newbie"] } })
    );
    expect(mockTransaction.set).toHaveBeenCalledWith(
      profileRef,
      expect.objectContaining({ userID: "newbie", groupID: "group-1" })
    );
  });

  test("期限切れの招待は 410 を返し status を expired に更新する", async () => {
    setup({ found: true, expiresOffsetMs: -DAY_MS });

    const result = await handler({
      auth: { uid: "newbie" },
      data: { invitationCode: "ABCD3456" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(410);
    expect(invitationRefObj.update).toHaveBeenCalledWith(
      expect.objectContaining({ status: "expired" })
    );
    expect(mockRunTransaction).not.toHaveBeenCalled();
  });

  test("使用済み(accepted)で呼び出し者が未参加なら NG", async () => {
    setup({
      found: true,
      invitationStatus: "accepted",
      txInvitationStatus: "accepted",
      groupMembers: ["owner"],
    });

    const result = await handler({
      auth: { uid: "newbie" },
      data: { invitationCode: "ABCD3456" },
    });

    expect(result.result).toBe("NG");
    expect(result.error?.message).toBe("この招待コードは既に使用されています");
    expect(mockTransaction.update).not.toHaveBeenCalled();
  });

  test("accepted 済みでも呼び出し者が既にメンバーなら冪等に groupID を返す (リトライ対応)", async () => {
    setup({
      found: true,
      invitationStatus: "accepted",
      txInvitationStatus: "accepted",
      groupMembers: ["owner", "newbie"],
    });

    const result = await handler({
      auth: { uid: "newbie" },
      data: { invitationCode: "ABCD3456" },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.groupID).toBe("group-1");
    expect(mockTransaction.update).not.toHaveBeenCalled();
    expect(mockTransaction.set).not.toHaveBeenCalled();
  });

  test("既にメンバーなら冪等にグループ ID を返し、書き込みを行わない", async () => {
    setup({ found: true, groupMembers: ["owner", "newbie"] });

    const result = await handler({
      auth: { uid: "newbie" },
      data: { invitationCode: "ABCD3456" },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.groupID).toBe("group-1");
    expect(mockTransaction.update).not.toHaveBeenCalled();
    expect(mockTransaction.set).not.toHaveBeenCalled();
  });

  test("招待者が既にグループから除名されている場合は無効な招待として NG", async () => {
    // inviter "ghost" は現在のメンバー ["owner"] に含まれない
    setup({ found: true, inviterUserID: "ghost", groupMembers: ["owner"] });

    const result = await handler({
      auth: { uid: "newbie" },
      data: { invitationCode: "ABCD3456" },
    });

    expect(result.result).toBe("NG");
    expect(result.error?.message).toBe("この招待コードは無効です");
    expect(mockTransaction.update).not.toHaveBeenCalled();
    expect(mockTransaction.set).not.toHaveBeenCalled();
  });

  test("招待が見つからないと 404", async () => {
    setup({ found: false });

    const result = await handler({
      auth: { uid: "newbie" },
      data: { invitationCode: "NOPE0000" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(404);
  });

  test("未認証は 401", async () => {
    const result = await handler({
      auth: null,
      data: { invitationCode: "ABCD3456" },
    });
    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(401);
  });
});

// createGroupHandler のユニットテスト。firebase-admin / premium をモックしてハンドラを直接実行する。

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
const mockRunTransaction = jest.fn();
const mockFirestoreInstance = {
  collection: mockCollection,
  runTransaction: mockRunTransaction,
};
const mockFirestore = Object.assign(jest.fn(() => mockFirestoreInstance), {
  FieldValue: { serverTimestamp: jest.fn(() => "SERVER_TIMESTAMP") },
});

jest.mock("firebase-admin", () => ({ firestore: mockFirestore }));

jest.mock("firebase-functions/v2/https", () => ({
  onCall: (_opts: unknown, handler: unknown) => handler,
}));

jest.mock("firebase-functions", () => ({
  logger: { info: jest.fn(), error: jest.fn(), warn: jest.fn() },
}));

const mockHasPremium = jest.fn();
jest.mock("../utils/premium", () => ({
  hasPremiumEntitlement: mockHasPremium,
  revenueCatAPISecretParam: { value: () => "test-secret" },
}));

// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require("./function") as Handler;

const groupRef = { id: "new-group-id" };
const userRef = { __ref: "userRef" };
const profileRef = { id: "profile-id" };
const ownedGroupsQuery = { __ref: "ownedGroupsQuery" };

const mockTransaction = {
  get: jest.fn(),
  set: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};

function setupCollections(): void {
  mockCollection.mockImplementation((path: string) => {
    if (path === "groups") {
      return {
        doc: jest.fn(() => groupRef),
        where: jest.fn(() => ownedGroupsQuery),
      };
    }
    if (path === "users") {
      return { doc: jest.fn(() => userRef) };
    }
    if (path.startsWith("groups/") && path.endsWith("/userProfiles")) {
      return { doc: jest.fn(() => profileRef) };
    }
    return {};
  });
  mockRunTransaction.mockImplementation(
    (fn: (tx: typeof mockTransaction) => Promise<unknown>) =>
      fn(mockTransaction)
  );
}

describe("createGroup", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    setupCollections();
  });

  test("未認証はエラーになる", async () => {
    const result = await handler({ auth: null, data: { name: "家族" } });
    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(401);
  });

  test("無料ユーザーが上限(ソロ+1)に達しているとき作成を拒否する", async () => {
    mockHasPremium.mockResolvedValue(false);
    mockTransaction.get.mockImplementation((ref: unknown) => {
      if (ref === userRef) {
        return Promise.resolve({ data: () => ({ defaultGroupID: "solo" }) });
      }
      if (ref === ownedGroupsQuery) {
        // 既にソロ+1 の 2 グループを所有している
        return Promise.resolve({ size: 2 });
      }
      return Promise.resolve({ data: () => undefined });
    });

    const result = await handler({
      auth: { uid: "user-1" },
      data: { name: "追加グループ", setAsDefault: false },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(403);
    expect(mockTransaction.set).not.toHaveBeenCalled();
  });

  test("無料ユーザーでも上限未満なら作成できる(group/profile/user を書き込む)", async () => {
    mockHasPremium.mockResolvedValue(false);
    mockTransaction.get.mockImplementation((ref: unknown) => {
      if (ref === userRef) {
        return Promise.resolve({ data: () => ({ defaultGroupID: null }) });
      }
      if (ref === ownedGroupsQuery) {
        return Promise.resolve({ size: 1 });
      }
      return Promise.resolve({ data: () => undefined });
    });

    const result = await handler({
      auth: { uid: "user-1" },
      data: { name: "家族", setAsDefault: false, iconName: "family" },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.groupID).toBe("new-group-id");
    // group, profile, user(defaultGroupID 未設定なので設定) の 3 write
    expect(mockTransaction.set).toHaveBeenCalledTimes(3);
    expect(mockTransaction.set).toHaveBeenCalledWith(
      groupRef,
      expect.objectContaining({
        ownerUserID: "user-1",
        memberUserIDs: ["user-1"],
        name: "家族",
        iconName: "family",
      }),
      { merge: true }
    );
  });

  test("プレミアムユーザーは所有グループ数に関わらず作成できる(上限 read をしない)", async () => {
    mockHasPremium.mockResolvedValue(true);
    mockTransaction.get.mockImplementation((ref: unknown) => {
      if (ref === userRef) {
        return Promise.resolve({ data: () => ({ defaultGroupID: "solo" }) });
      }
      return Promise.resolve({ data: () => undefined });
    });

    const result = await handler({
      auth: { uid: "user-1" },
      data: { name: "3 つめ", setAsDefault: true },
    });

    expect(result.result).toBe("OK");
    // ownedGroupsQuery の read は行われない
    expect(mockTransaction.get).not.toHaveBeenCalledWith(ownedGroupsQuery);
  });

  test("不正な iconName は home にフォールバックする", async () => {
    mockHasPremium.mockResolvedValue(true);
    mockTransaction.get.mockImplementation(() =>
      Promise.resolve({ data: () => ({ defaultGroupID: "solo" }) })
    );

    await handler({
      auth: { uid: "user-1" },
      data: { name: "x", iconName: "not-allowed" },
    });

    expect(mockTransaction.set).toHaveBeenCalledWith(
      groupRef,
      expect.objectContaining({ iconName: "home" }),
      { merge: true }
    );
  });
});

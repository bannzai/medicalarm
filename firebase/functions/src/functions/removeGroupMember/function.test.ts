// removeGroupMemberHandler のユニットテスト。オーナー権限・自己削除拒否・defaultGroupID 付け替えを検証する。

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
  FieldValue: {
    serverTimestamp: jest.fn(() => "SERVER_TIMESTAMP"),
    arrayRemove: jest.fn((...ids: string[]) => ({ arrayRemove: ids })),
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

const profileRef = { __ref: "profileRef" };
const notificationSettingRef = { __ref: "notificationSettingRef" };
const groupRef = {
  get: jest.fn(),
  collection: jest.fn((name: string) => ({
    doc: jest.fn(() =>
      name === "memberNotificationSettings" ? notificationSettingRef : profileRef
    ),
  })),
};
const userRef = { __ref: "userRef" };
const memberGroupsQuery = { __ref: "memberGroupsQuery" };

const mockTransaction = {
  get: jest.fn(),
  set: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};

/** createdDateTime を持つ所属グループの QueryDocumentSnapshot 相当を作る。 */
function memberGroupDoc(id: string, createdMillis: number): unknown {
  return { id, data: () => ({ createdDateTime: { toMillis: () => createdMillis } }) };
}

function setup(args: {
  ownerUserID: string | null;
  members?: string[];
  targetExists?: boolean;
  targetDefaultGroupID?: string | null;
  memberDocs?: unknown[];
}): void {
  groupRef.get.mockResolvedValue({
    exists: true,
    data: () => ({ ownerUserID: args.ownerUserID }),
  });
  mockCollection.mockImplementation((path: string) => {
    if (path === "groups") {
      return {
        doc: jest.fn(() => groupRef),
        where: jest.fn(() => memberGroupsQuery),
      };
    }
    if (path === "users") {
      return { doc: jest.fn(() => userRef) };
    }
    return {};
  });
  mockTransaction.get.mockImplementation((ref: unknown) => {
    if (ref === groupRef) {
      return Promise.resolve({
        data: () => ({ memberUserIDs: args.members ?? [] }),
      });
    }
    if (ref === userRef) {
      return Promise.resolve({
        exists: args.targetExists ?? true,
        data: () => ({ defaultGroupID: args.targetDefaultGroupID ?? null }),
      });
    }
    if (ref === memberGroupsQuery) {
      return Promise.resolve({ docs: args.memberDocs ?? [] });
    }
    return Promise.resolve({ exists: false, data: () => undefined });
  });
  mockRunTransaction.mockImplementation(
    (fn: (tx: typeof mockTransaction) => Promise<unknown>) => fn(mockTransaction)
  );
}

describe("removeGroupMember", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("オーナー以外は削除できない(403)", async () => {
    setup({ ownerUserID: "owner" });

    const result = await handler({
      auth: { uid: "not-owner" },
      data: { groupID: "group-1", targetUserID: "member" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(403);
    expect(mockRunTransaction).not.toHaveBeenCalled();
  });

  test("オーナー自身は削除できない(400)", async () => {
    setup({ ownerUserID: "owner" });

    const result = await handler({
      auth: { uid: "owner" },
      data: { groupID: "group-1", targetUserID: "owner" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(400);
  });

  test("メンバーでない対象は冪等に何もしない", async () => {
    setup({ ownerUserID: "owner", members: ["owner"] });

    const result = await handler({
      auth: { uid: "owner" },
      data: { groupID: "group-1", targetUserID: "ghost" },
    });

    expect(result.result).toBe("OK");
    expect(mockTransaction.update).not.toHaveBeenCalled();
    expect(mockTransaction.delete).not.toHaveBeenCalled();
  });

  test("削除時に対象の userProfile と memberNotificationSettings を delete する", async () => {
    setup({ ownerUserID: "owner", members: ["owner", "target"] });

    const result = await handler({
      auth: { uid: "owner" },
      data: { groupID: "group-1", targetUserID: "target" },
    });

    expect(result.result).toBe("OK");
    // userProfiles と memberNotificationSettings の両方を削除する
    expect(mockTransaction.delete).toHaveBeenCalledWith(profileRef);
    expect(mockTransaction.delete).toHaveBeenCalledWith(notificationSettingRef);
  });

  test("対象の defaultGroupID が当該グループなら最古の所属グループへ付け替える", async () => {
    setup({
      ownerUserID: "owner",
      members: ["owner", "target"],
      targetDefaultGroupID: "group-1",
      memberDocs: [memberGroupDoc("g-new", 200), memberGroupDoc("g-old", 100)],
    });

    const result = await handler({
      auth: { uid: "owner" },
      data: { groupID: "group-1", targetUserID: "target" },
    });

    expect(result.result).toBe("OK");
    expect(mockTransaction.update).toHaveBeenCalledWith(
      groupRef,
      expect.objectContaining({ memberUserIDs: { arrayRemove: ["target"] } })
    );
    expect(mockTransaction.delete).toHaveBeenCalledWith(profileRef);
    expect(mockTransaction.update).toHaveBeenCalledWith(
      userRef,
      expect.objectContaining({ defaultGroupID: "g-old" })
    );
  });

  test("付け替え先は所有ではなくメンバーとして所属する他グループでよい", async () => {
    // 対象が owner でなくメンバーとしてのみ所属するグループ (g-member) が候補になる。
    // 除外対象 (group-1) はクエリ結果に含まれても JS 側で除外される。
    setup({
      ownerUserID: "owner",
      members: ["owner", "target"],
      targetDefaultGroupID: "group-1",
      memberDocs: [memberGroupDoc("group-1", 50), memberGroupDoc("g-member", 300)],
    });

    const result = await handler({
      auth: { uid: "owner" },
      data: { groupID: "group-1", targetUserID: "target" },
    });

    expect(result.result).toBe("OK");
    expect(mockTransaction.update).toHaveBeenCalledWith(
      userRef,
      expect.objectContaining({ defaultGroupID: "g-member" })
    );
  });

  test("対象が他に所属グループを持たなければ defaultGroupID は null にする", async () => {
    setup({
      ownerUserID: "owner",
      members: ["owner", "target"],
      targetDefaultGroupID: "group-1",
      memberDocs: [],
    });

    const result = await handler({
      auth: { uid: "owner" },
      data: { groupID: "group-1", targetUserID: "target" },
    });

    expect(result.result).toBe("OK");
    expect(mockTransaction.update).toHaveBeenCalledWith(
      userRef,
      expect.objectContaining({ defaultGroupID: null })
    );
  });

  test("対象の defaultGroupID が別グループなら user は更新しない", async () => {
    setup({
      ownerUserID: "owner",
      members: ["owner", "target"],
      targetDefaultGroupID: "other-group",
    });

    const result = await handler({
      auth: { uid: "owner" },
      data: { groupID: "group-1", targetUserID: "target" },
    });

    expect(result.result).toBe("OK");
    // userRef への update(defaultGroupID 付け替え)は行われない
    expect(mockTransaction.update).not.toHaveBeenCalledWith(
      userRef,
      expect.anything()
    );
  });
});

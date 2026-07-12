// createGroupInvitationHandler のユニットテスト。招待コードの形式は実際の crypto で生成して検証する。

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

// 招待コードで許容される文字集合(紛らわしい文字を除外した 28 文字)
const ALLOWED_CODE_PATTERN = /^[ABCDEFGHJKMNPQRSTVWXY3456789]{8}$/;
const DAY_MS = 24 * 60 * 60 * 1000;
const FIXED_NOW_MS = Date.UTC(2026, 0, 1, 0, 0, 0);

const mockCollection = jest.fn();
const mockFirestoreInstance = { collection: mockCollection };
const mockFirestore = Object.assign(jest.fn(() => mockFirestoreInstance), {
  FieldValue: { serverTimestamp: jest.fn(() => "SERVER_TIMESTAMP") },
  Timestamp: {
    now: jest.fn(() => ({ toMillis: () => FIXED_NOW_MS })),
    fromMillis: jest.fn((ms: number) => ({
      toMillis: () => ms,
      toDate: () => new Date(ms),
    })),
  },
});

jest.mock("firebase-admin", () => ({ firestore: mockFirestore }));

jest.mock("firebase-admin/firestore", () => ({
  FieldValue: mockFirestore.FieldValue,
  Timestamp: mockFirestore.Timestamp,
}));

jest.mock("firebase-functions/v2/https", () => ({
  onCall: (_opts: unknown, handler: unknown) => handler,
}));

jest.mock("firebase-functions", () => ({
  logger: { info: jest.fn(), error: jest.fn(), warn: jest.fn() },
}));

// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require("./function") as Handler;

const invitationRef = { id: "invitation-1", set: jest.fn() };

function setupCollections(memberUserIDs: string[] | null): void {
  mockCollection.mockImplementation((path: string) => {
    if (path === "groups") {
      return {
        doc: jest.fn(() => ({
          get: jest.fn().mockResolvedValue(
            memberUserIDs === null
              ? { exists: false, data: () => undefined }
              : { exists: true, data: () => ({ memberUserIDs }) }
          ),
        })),
      };
    }
    if (path === "groupInvitations") {
      return {
        doc: jest.fn(() => invitationRef),
        where: jest.fn(() => ({
          limit: jest.fn(() => ({
            get: jest.fn().mockResolvedValue({ empty: true }),
          })),
        })),
      };
    }
    return {};
  });
}

describe("createGroupInvitation", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    invitationRef.set.mockResolvedValue(undefined);
  });

  test("メンバーは招待を作成でき、コードは 8 桁の許可文字のみで構成される", async () => {
    setupCollections(["user-1", "user-2"]);

    // rejection sampling の実装を実際の crypto で複数回検証する
    for (let i = 0; i < 20; i++) {
      const result = await handler({
        auth: { uid: "user-1" },
        data: { groupID: "group-1" },
      });
      expect(result.result).toBe("OK");
      expect(result.data?.invitationCode as string).toMatch(ALLOWED_CODE_PATTERN);
    }
    expect(invitationRef.set).toHaveBeenCalledWith(
      expect.objectContaining({
        groupID: "group-1",
        inviterUserID: "user-1",
        status: "pending",
      })
    );
  });

  test("expiresDateTime は now から 7 日後の ISO8601 文字列", async () => {
    setupCollections(["user-1"]);

    const result = await handler({
      auth: { uid: "user-1" },
      data: { groupID: "group-1" },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.expiresDateTime).toBe(
      new Date(FIXED_NOW_MS + 7 * DAY_MS).toISOString()
    );
  });

  test("非メンバーは拒否される", async () => {
    setupCollections(["user-1", "user-2"]);

    const result = await handler({
      auth: { uid: "outsider" },
      data: { groupID: "group-1" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(403);
  });

  test("存在しないグループは 404", async () => {
    setupCollections(null);

    const result = await handler({
      auth: { uid: "user-1" },
      data: { groupID: "missing" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(404);
  });

  test("未認証は 401", async () => {
    const result = await handler({ auth: null, data: { groupID: "group-1" } });
    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(401);
  });
});

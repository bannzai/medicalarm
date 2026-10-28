// submitFeatureRequest のユニットテスト。axios と Slack のエラー通知をモックしてハンドラを直接実行し、
// Slack Incoming Webhook へ送る本文の形式を確かめる。

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

jest.mock("firebase-functions/v2/https", () => ({
  onCall: (_opts: unknown, handler: unknown) => handler,
}));

jest.mock("firebase-functions", () => ({
  logger: { info: jest.fn(), error: jest.fn(), warn: jest.fn() },
}));

jest.mock("firebase-functions/params", () => ({
  defineSecret: () => ({ value: () => "https://hooks.slack.test/feature-request" }),
}));

const mockPost = jest.fn();
jest.mock("axios", () => ({ __esModule: true, default: { post: mockPost } }));

const mockReport = jest.fn();
jest.mock("../../core/slack", () => ({ report: mockReport }));

// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require("./function") as Handler;

describe("submitFeatureRequest", () => {
  beforeEach(() => {
    mockPost.mockReset();
    mockReport.mockReset();
  });

  it("全項目を指定した時、Slack に区切り線で囲んだ内容と付帯情報を送る", async () => {
    mockPost.mockResolvedValue({ status: 200 });

    const response = await handler({
      auth: { uid: "user-1" },
      data: { content: "通知音を選びたい", emailAddress: "test@example.com", appVersion: "1.2.3", platform: "iOS" },
    });

    expect(response).toEqual({ result: "OK", statusCode: 200, data: { ok: true } });
    expect(mockPost).toHaveBeenCalledWith("https://hooks.slack.test/feature-request", {
      text: [
        "💡 新規機能要望",
        "",
        "[UserID] user-1",
        "[Email] test@example.com",
        "[AppVersion] 1.2.3",
        "[Platform] iOS",
        "━━━━━━━━━━━━━━━━━━━━",
        "内容:",
        "通知音を選びたい",
        "━━━━━━━━━━━━━━━━━━━━",
      ].join("\n"),
    });
  });

  it("メールアドレスが空文字の時、[Email] の行を送らない", async () => {
    mockPost.mockResolvedValue({ status: 200 });

    await handler({ auth: { uid: "user-1" }, data: { content: "要望", emailAddress: "" } });

    expect(mockPost.mock.calls[0][1].text).toBe(
      ["💡 新規機能要望", "", "[UserID] user-1", "━━━━━━━━━━━━━━━━━━━━", "内容:", "要望", "━━━━━━━━━━━━━━━━━━━━"].join("\n")
    );
  });

  it("未認証の時、Slack に送らず 401 を返す", async () => {
    const response = await handler({ auth: null, data: { content: "要望" } });

    expect(response.statusCode).toBe(401);
    expect(mockPost).not.toHaveBeenCalled();
  });

  it("内容が空の時、Slack に送らず 400 を返す", async () => {
    const response = await handler({ auth: { uid: "user-1" }, data: { content: "" } });

    expect(response.statusCode).toBe(400);
    expect(mockPost).not.toHaveBeenCalled();
  });

  it("Slack への送信に失敗した時、エラーチャンネルへ通知して 500 を返す", async () => {
    mockPost.mockRejectedValue(new Error("webhook down"));

    const response = await handler({ auth: { uid: "user-1" }, data: { content: "要望" } });

    expect(response).toEqual({ result: "NG", statusCode: 500, error: { message: "webhook down" } });
    expect(mockReport).toHaveBeenCalledWith("user-1", "submitFeatureRequest", expect.any(Error));
  });
});

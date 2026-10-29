// submitFeatureRequest のユニットテスト。axios と Slack のエラー通知をモックしてハンドラを直接実行し、
// Slack Incoming Webhook へ送る本文の形式を確かめる。

import type { OnCallResponse } from "../../core/response";

/** onCall のモックが返す、テストから直接呼ぶハンドラ。 */
type Handler = (req: {
  auth?: { uid?: string | null } | null;
  data?: Record<string, unknown>;
}) => Promise<OnCallResponse>;

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
    expect(mockPost).toHaveBeenCalledWith(
      "https://hooks.slack.test/feature-request",
      {
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
      },
      { timeout: 10000 }
    );
  });

  it("メールアドレスが空文字の時、[Email] の行を送らない", async () => {
    mockPost.mockResolvedValue({ status: 200 });

    await handler({ auth: { uid: "user-1" }, data: { content: "要望", emailAddress: "" } });

    expect(mockPost.mock.calls[0][1].text).toBe(
      ["💡 新規機能要望", "", "[UserID] user-1", "━━━━━━━━━━━━━━━━━━━━", "内容:", "要望", "━━━━━━━━━━━━━━━━━━━━"].join("\n")
    );
  });

  it("内容のメンション・リンクの記法を Slack の制御構文として解釈させないようエスケープして送る", async () => {
    mockPost.mockResolvedValue({ status: 200 });

    await handler({ auth: { uid: "user-1" }, data: { content: "<!channel> A&B <https://example.com|x>" } });

    expect(mockPost.mock.calls[0][1].text).toContain("&lt;!channel&gt; A&amp;B &lt;https://example.com|x&gt;");
  });

  it("絵文字だけで 5000 文字の本文は、アプリの文字数の数え方と同じく上限内として受け付ける", async () => {
    mockPost.mockResolvedValue({ status: 200 });

    const response = await handler({ auth: { uid: "user-1" }, data: { content: "😀".repeat(5000) } });

    expect(response.statusCode).toBe(200);
  });

  it("5001 文字の本文は 400 を返す", async () => {
    const response = await handler({ auth: { uid: "user-1" }, data: { content: "あ".repeat(5001) } });

    expect(response.statusCode).toBe(400);
    expect(mockPost).not.toHaveBeenCalled();
  });

  it("アプリの判定を通るメールアドレス (末尾が 1 文字) は受け付ける", async () => {
    mockPost.mockResolvedValue({ status: 200 });

    const response = await handler({ auth: { uid: "user-1" }, data: { content: "要望", emailAddress: "a@b.c" } });

    expect(response.statusCode).toBe(200);
  });

  it("@ を含まないメールアドレスは 400 を返す", async () => {
    const response = await handler({ auth: { uid: "user-1" }, data: { content: "要望", emailAddress: "invalid" } });

    expect(response.statusCode).toBe(400);
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

  it("エラーチャンネルへの通知も失敗した時も、500 を返す", async () => {
    mockPost.mockRejectedValue(new Error("webhook down"));
    mockReport.mockRejectedValue(new Error("report down"));

    const response = await handler({ auth: { uid: "user-1" }, data: { content: "要望" } });

    expect(response).toEqual({ result: "NG", statusCode: 500, error: { message: "webhook down" } });
  });
});

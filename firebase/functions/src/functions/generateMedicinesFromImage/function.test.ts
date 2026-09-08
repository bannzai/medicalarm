// generateMedicinesFromImageHandler のユニットテスト。
// 入力検証・月間利用回数の上限判定とカウント更新・AI 出力のサニタイズ・空応答フォールバックを検証する。

type OnCallResult = {
  result: "OK" | "NG";
  statusCode: number;
  data?: {
    medicines: {
      name: string;
      schedules: { hour: number; minute: number; quantityMemo: string }[];
    }[];
  };
  error?: { message: string };
};
type Handler = (req: {
  auth?: { uid?: string | null } | null;
  data?: Record<string, unknown>;
}) => Promise<OnCallResult>;

const mockTransactionGet = jest.fn();
const mockTransactionSet = jest.fn();
const mockTransactionUpdate = jest.fn();
const mockRunTransaction = jest.fn(
  async (
    callback: (transaction: {
      get: jest.Mock;
      set: jest.Mock;
      update: jest.Mock;
    }) => Promise<unknown>
  ) =>
    callback({
      get: mockTransactionGet,
      set: mockTransactionSet,
      update: mockTransactionUpdate,
    })
);
const aiUsageRef = { id: "aiUsageRef" };
const mockCollection = jest.fn(() => ({
  doc: jest.fn(() => ({
    collection: jest.fn(() => ({ doc: jest.fn(() => aiUsageRef) })),
  })),
}));

jest.mock("../../core/database", () => ({
  database: {
    collection: (...args: unknown[]) => mockCollection(...(args as [])),
    runTransaction: (callback: never) => mockRunTransaction(callback),
  },
}));

jest.mock("firebase-admin/firestore", () => ({
  FieldValue: {
    serverTimestamp: jest.fn(() => "SERVER_TIMESTAMP"),
    increment: jest.fn((value: number) => ({ increment: value })),
  },
}));

jest.mock("firebase-functions/v2/https", () => ({
  onCall: (_opts: unknown, handler: unknown) => handler,
}));

jest.mock("firebase-functions", () => ({
  logger: { info: jest.fn(), error: jest.fn(), warn: jest.fn() },
}));

jest.mock("firebase-functions/params", () => ({
  defineSecret: jest.fn(() => ({ value: () => "test-api-key" })),
}));

const mockHasPremiumEntitlement = jest.fn();
jest.mock("../utils/premium", () => ({
  hasPremiumEntitlement: (uid: string) => mockHasPremiumEntitlement(uid),
  revenueCatAPISecretParam: { value: () => "test-revenuecat-secret" },
}));

const mockChatCompletionsCreate = jest.fn();
jest.mock("openai", () => ({
  __esModule: true,
  default: jest.fn(() => ({
    chat: { completions: { create: mockChatCompletionsCreate } },
  })),
}));

// eslint-disable-next-line @typescript-eslint/no-var-requires
const handler = require("./function") as Handler;

/// サイズ検証 (非 0 バイト) を通すための最小 base64。
const validBase64Image = Buffer.from("dummy-image-bytes").toString("base64");

function setup(args: {
  isPremium?: boolean;
  currentImageRecognitionCount?: number;
  aiUsageDocExists?: boolean;
  // OpenAI が返す Structured Outputs の JSON (オブジェクト)。null は content 無し (応答空) を表す。
  aiResponse?: Record<string, unknown> | null;
}): void {
  jest.clearAllMocks();
  mockHasPremiumEntitlement.mockResolvedValue(args.isPremium ?? false);
  mockTransactionGet.mockResolvedValue({
    exists: args.aiUsageDocExists ?? true,
    data: () =>
      (args.aiUsageDocExists ?? true)
        ? { imageRecognitionCount: args.currentImageRecognitionCount ?? 0 }
        : undefined,
  });
  const aiResponse = args.aiResponse === undefined ? { medicines: [] } : args.aiResponse;
  mockChatCompletionsCreate.mockResolvedValue({
    choices: [
      {
        message: {
          content: aiResponse === null ? null : JSON.stringify(aiResponse),
          refusal: null,
        },
      },
    ],
  });
}

describe("generateMedicinesFromImage", () => {
  test("正常系: 抽出結果を返し AI 利用回数がインクリメントされる (既存ドキュメント)", async () => {
    setup({
      currentImageRecognitionCount: 1,
      aiResponse: {
        medicines: [
          {
            name: "ロキソニン",
            schedules: [
              { hour: 8, minute: 0, quantityMemo: "1錠" },
              { hour: 19, minute: 30, quantityMemo: "" },
            ],
          },
        ],
      },
    });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.medicines).toEqual([
      {
        name: "ロキソニン",
        schedules: [
          { hour: 8, minute: 0, quantityMemo: "1錠" },
          { hour: 19, minute: 30, quantityMemo: "" },
        ],
      },
    ]);
    expect(mockTransactionUpdate).toHaveBeenCalledWith(
      aiUsageRef,
      expect.objectContaining({ imageRecognitionCount: { increment: 1 } })
    );
    expect(mockTransactionSet).not.toHaveBeenCalled();
  });

  test("正常系: AI 利用回数ドキュメントが無い場合は新規作成される", async () => {
    setup({ aiUsageDocExists: false });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("OK");
    expect(mockTransactionSet).toHaveBeenCalledWith(
      aiUsageRef,
      expect.objectContaining({ userID: "me", imageRecognitionCount: 1 })
    );
    expect(mockTransactionUpdate).not.toHaveBeenCalled();
  });

  test("境界: AI 応答に medicines キーが無くても空配列で OK を返す", async () => {
    setup({ aiResponse: {} });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.medicines).toEqual([]);
  });

  test("サニタイズ: 名前が空の薬と時刻が範囲外のスケジュールは捨てられる", async () => {
    setup({
      aiResponse: {
        medicines: [
          { name: "  ", schedules: [{ hour: 8, minute: 0, quantityMemo: "" }] },
          {
            name: "ガスター",
            schedules: [
              { hour: 24, minute: 0, quantityMemo: "範囲外" },
              { hour: 8, minute: 60, quantityMemo: "範囲外" },
              { hour: 8.5, minute: 0, quantityMemo: "非整数" },
              { hour: 22, minute: 0, quantityMemo: "1錠" },
            ],
          },
          { name: "スケジュールなし" },
        ],
      },
    });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("OK");
    expect(result.data?.medicines).toEqual([
      {
        name: "ガスター",
        schedules: [{ hour: 22, minute: 0, quantityMemo: "1錠" }],
      },
      { name: "スケジュールなし", schedules: [] },
    ]);
  });

  test("異常系: 未認証ユーザーはエラーになり利用回数を消費しない", async () => {
    setup({});

    const result = await handler({
      auth: null,
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(401);
    expect(mockRunTransaction).not.toHaveBeenCalled();
  });

  test("異常系: 非許可 MIME type はエラーになり利用回数を消費しない", async () => {
    setup({});

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "application/pdf", base64Image: validBase64Image },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(400);
    expect(mockRunTransaction).not.toHaveBeenCalled();
  });

  test("異常系: 空の画像データはエラーになり利用回数を消費しない", async () => {
    setup({});

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: "" },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(400);
    expect(mockRunTransaction).not.toHaveBeenCalled();
  });

  test("異常系: 無料ユーザーは月 5 回の上限到達でエラーになる", async () => {
    setup({ isPremium: false, currentImageRecognitionCount: 5 });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(429);
    expect(result.error?.message).toContain("5回");
    expect(mockTransactionUpdate).not.toHaveBeenCalled();
    expect(mockTransactionSet).not.toHaveBeenCalled();
    expect(mockChatCompletionsCreate).not.toHaveBeenCalled();
  });

  test("正常系: プレミアムユーザーは 5 回以上でも利用できる", async () => {
    setup({ isPremium: true, currentImageRecognitionCount: 5 });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("OK");
    expect(mockTransactionUpdate).toHaveBeenCalled();
  });

  test("異常系: プレミアムユーザーも月 50 回の上限到達でエラーになる", async () => {
    setup({ isPremium: true, currentImageRecognitionCount: 50 });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(429);
    expect(result.error?.message).toContain("50回");
  });

  test("異常系: AI 応答の content が空の場合は NG を返す", async () => {
    setup({ aiResponse: null });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(500);
    expect(result.error?.message).toBe("AI からの応答が空でした");
  });

  test("異常系: AI 呼び出しが失敗した場合は NG を返す (利用回数は戻さない)", async () => {
    setup({});
    mockChatCompletionsCreate.mockRejectedValueOnce(new Error("OpenAI API error"));

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(500);
    expect(result.error?.message).toBe("OpenAI API error");
    expect(mockTransactionUpdate).toHaveBeenCalled();
  });
});

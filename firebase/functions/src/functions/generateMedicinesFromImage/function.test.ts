// generateMedicinesFromImageHandler のユニットテスト。
// 入力検証・月間利用回数の上限判定とカウント更新・AI 出力のサニタイズ・空応答フォールバックを検証する。

import { IN_MAINTENANCE_WITH_BUTTON_JSON, NOT_IN_MAINTENANCE_JSON } from "../../lib/maintenance/test/support/fixtures";

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
  // メンテナンス中の判定が投げる HttpsError は本物を使い、クライアントへ返る code と details を確かめる
  HttpsError: jest.requireActual("firebase-functions/v2/https").HttpsError,
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

/// 状態を返す Worker (service-maintenance) への読み取りの代わり。実際の Worker へ通信しないよう global の fetch を差し替える
const mockFetch = jest.fn();
global.fetch = mockFetch as unknown as typeof fetch;

/// 状態を返す Worker が返す、メンテナンス中の状態の JSON
const inMaintenanceStateJSON = { ...IN_MAINTENANCE_WITH_BUTTON_JSON, button: null };

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
  mockFetch.mockImplementation(async () => new Response(JSON.stringify(NOT_IN_MAINTENANCE_JSON), { status: 200 }));
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

  test("異常系: AI が読み取りを拒否した場合、refusal の文面を含まない固定メッセージで NG を返す", async () => {
    setup({});
    mockChatCompletionsCreate.mockResolvedValueOnce({
      choices: [
        {
          message: {
            content: null,
            refusal: "この画像には患者の氏名が含まれるため読み取れません",
          },
        },
      ],
    });

    const result = await handler({
      auth: { uid: "me" },
      data: { mimeType: "image/jpeg", base64Image: validBase64Image },
    });

    expect(result.result).toBe("NG");
    expect(result.statusCode).toBe(500);
    expect(result.error?.message).toBe(
      "AI が画像の読み取りを拒否しました。お薬の情報が写った画像でもう一度お試しください"
    );
    expect(result.error?.message).not.toContain("患者の氏名");
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

describe("generateMedicinesFromImage のメンテナンス中の判定", () => {
  /// 読んだ状態を 60 秒覚える読み手をテストごとに作り直すため、関数のモジュールを読み直す
  function freshHandler(): Handler {
    let isolatedHandler: Handler | undefined;
    jest.isolateModules(() => {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      isolatedHandler = require("./function") as Handler;
    });
    return isolatedHandler as Handler;
  }

  test("メンテナンス中は unavailable で断り、利用回数を数えず OpenAI を 1 回も呼ばない", async () => {
    setup({});
    mockFetch.mockImplementation(async () => new Response(JSON.stringify(inMaintenanceStateJSON), { status: 200 }));

    await expect(
      freshHandler()({
        auth: { uid: "me" },
        data: { mimeType: "image/jpeg", base64Image: validBase64Image },
      })
    ).rejects.toMatchObject({
      code: "unavailable",
      details: { maintenance: inMaintenanceStateJSON },
    });
    expect(mockFetch).toHaveBeenCalledWith(
      "https://service-maintenance.star-kojiki.workers.dev/medicalarm",
      expect.anything()
    );
    expect(mockChatCompletionsCreate).toHaveBeenCalledTimes(0);
    expect(mockRunTransaction).toHaveBeenCalledTimes(0);
  });

  test("メンテナンス中でなければ OpenAI を呼んで抽出結果を返す", async () => {
    setup({});

    expect(
      (
        await freshHandler()({
          auth: { uid: "me" },
          data: { mimeType: "image/jpeg", base64Image: validBase64Image },
        })
      ).result
    ).toBe("OK");
    expect(mockChatCompletionsCreate).toHaveBeenCalledTimes(1);
  });

  test.each([
    ["通信の失敗", async () => Promise.reject(new TypeError("fetch failed"))],
    ["200 以外の応答", async () => new Response("error", { status: 500 })],
    ["形の違う応答", async () => new Response(JSON.stringify({ maintenance: "yes" }), { status: 200 })],
  ])("状態を読めない時 (%s) は通常どおり OpenAI を呼ぶ", async (_label, fetchImpl) => {
    setup({});
    mockFetch.mockImplementation(fetchImpl);

    expect(
      (
        await freshHandler()({
          auth: { uid: "me" },
          data: { mimeType: "image/jpeg", base64Image: validBase64Image },
        })
      ).result
    ).toBe("OK");
    expect(mockChatCompletionsCreate).toHaveBeenCalledTimes(1);
  });
});

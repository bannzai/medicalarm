import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { FieldValue } from "firebase-admin/firestore";
import OpenAI from "openai";
import { database } from "../../core/database";
import { OnCallResponse } from "../../core/response";
import { hasPremiumEntitlement, revenueCatAPISecretParam } from "../utils/premium";

/// OpenAI の API キー。Secret Manager 経由で取得する。
const openAIApiKey = defineSecret("OPENAI_API_KEY");

/// OpenAI の画像入力がサポートする形式のうち、クライアント(utils/image/image.dart の mimeType)が送りうるもの。
/// クライアントは base64CompressImage で JPEG に再エンコードして送るため、実際にはほぼ image/jpeg のみが届く。
const allowedMimeTypes = new Set(["image/jpeg", "image/png", "image/webp"]);

/// callable ペイロードの実用上限に収めるための画像サイズ上限。
/// クライアントは長辺 1000px の JPEG に圧縮してから送るため、通常はこの上限に達しない。
const maxImageBytes = 10 * 1024 * 1024;

/// 無料ユーザーの月間画像読み取り回数上限。参考実装 (shoppinglist) と同じ値。
const freeMonthlyImageRecognitionLimit = 5;

/// プレミアムユーザーの月間画像読み取り回数上限。参考実装 (shoppinglist) と同じ値。
const premiumMonthlyImageRecognitionLimit = 50;

/// AI 出力の異常肥大を防ぐ足切り値。処方箋 1 枚に載る薬数・1 薬あたりの服用時刻数として十分に大きい値。
const maxMedicinesPerImage = 20;
const maxSchedulesPerMedicine = 10;

/// AI 出力の文字列フィールドの足切り長。クライアントの表示・保存を壊さないための異常値ガード。
const maxTextLength = 100;

/// 画像抽出に使う OpenAI モデル。リポジトリ既存の OpenAI 利用 (scripts/translation) と同じ
/// gpt-4.1-mini に揃える。vision 入力と Structured Outputs (json_schema strict) をサポートし、
/// 処方箋 1 枚のテキスト抽出には十分な性能で単価が安い。
const openAIModel = "gpt-4.1-mini";

/** 画像から抽出した薬 1 件分のスケジュール。クライアントの MedicationSchedule の入力素材になる。 */
interface GeneratedMedicineSchedule {
  hour: number;
  minute: number;
  quantityMemo: string;
}

/** 画像から抽出した薬 1 件。クライアントの Medicine の入力素材になる。 */
interface GeneratedMedicine {
  name: string;
  schedules: GeneratedMedicineSchedule[];
}

/// OpenAI への抽出指示。服用タイミングの時刻変換規則もここで与える。
const extractionPrompt =
  "この画像はお薬手帳・処方箋・薬袋・薬のパッケージなどの写真です。" +
  "記載されている薬の名前(name)と、服用タイミングの時刻(schedules)、1回あたりの服用量(quantityMemo。例: 1錠)を抽出してください。" +
  "服用タイミングが「朝」「昼」「夕」「就寝前」のような表記の場合は、朝=8時0分、昼=12時0分、夕=19時0分、就寝前=22時0分として時刻に変換してください。" +
  "読み取れない項目は省略してください。薬が写っていない場合は空の配列を返してください。";

/**
 * AI の Structured Outputs を検証・正規化する。
 * AI 出力は型保証を過信できないため、名前が空・時刻が範囲外の要素は捨て、文字列は足切りし、件数上限を適用する。
 */
function sanitizeGeneratedMedicines(rawMedicines: unknown): GeneratedMedicine[] {
  if (!Array.isArray(rawMedicines)) {
    return [];
  }
  const medicines: GeneratedMedicine[] = [];
  for (const rawMedicine of rawMedicines) {
    if (medicines.length >= maxMedicinesPerImage) {
      break;
    }
    const name =
      typeof rawMedicine?.name === "string" ? rawMedicine.name.trim() : "";
    if (name.length === 0) {
      continue;
    }
    const schedules: GeneratedMedicineSchedule[] = [];
    if (Array.isArray(rawMedicine?.schedules)) {
      for (const rawSchedule of rawMedicine.schedules) {
        if (schedules.length >= maxSchedulesPerMedicine) {
          break;
        }
        const hour = Number(rawSchedule?.hour);
        const minute = Number(rawSchedule?.minute);
        if (!Number.isInteger(hour) || hour < 0 || hour > 23) {
          continue;
        }
        if (!Number.isInteger(minute) || minute < 0 || minute > 59) {
          continue;
        }
        schedules.push({
          hour,
          minute,
          quantityMemo:
            typeof rawSchedule?.quantityMemo === "string"
              ? rawSchedule.quantityMemo.trim().slice(0, maxTextLength)
              : "",
        });
      }
    }
    medicines.push({ name: name.slice(0, maxTextLength), schedules });
  }
  return medicines;
}

/**
 * 画像(お薬手帳・処方箋・薬袋など)から薬の登録候補を抽出して返す。
 * 抽出結果は保存せずクライアントに返すだけで、Firestore への薬の登録はユーザーがレビュー後にクライアントから行う。
 * 月間利用回数は users/{uid}/aiUsage/{yyyy-MM} でカウントし、無料 5 回 / プレミアム 50 回に制限する。
 */
async function generateMedicinesFromImageHandler(req: {
  auth?: { uid?: string | null } | null;
  data?: {
    mimeType?: string;
    base64Image?: string;
  };
}): Promise<OnCallResponse> {
  const uid = req.auth?.uid;
  // 月間利用回数ドキュメントの ID。タイムゾーンによる月境界のブレを避けるため UTC 基準で揃える。
  const yearMonth = new Date().toISOString().slice(0, 7);
  try {
    if (uid == null) {
      return {
        result: "NG",
        statusCode: 401,
        error: { message: "認証されていません" },
      };
    }

    const mimeType = req.data?.mimeType;
    const base64Image = req.data?.base64Image;
    if (mimeType == null || base64Image == null) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "mimeType / base64Image が指定されていません" },
      };
    }
    if (!allowedMimeTypes.has(mimeType)) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "画像形式がサポートされていません" },
      };
    }
    const imageBytesLength = Buffer.from(base64Image, "base64").length;
    if (imageBytesLength === 0 || imageBytesLength > maxImageBytes) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "画像サイズが制限を超えています" },
      };
    }

    // プレミアム判定はサーバー管理データ (RevenueCat) から行う。クライアントの申告値は信用しない。
    const monthlyLimit = (await hasPremiumEntitlement(uid))
      ? premiumMonthlyImageRecognitionLimit
      : freeMonthlyImageRecognitionLimit;

    const aiUsageRef = database
      .collection("users")
      .doc(uid)
      .collection("aiUsage")
      .doc(yearMonth);
    // 上限判定とカウント更新は同一トランザクション内で行う。
    // 冪等にしない理由: 月間利用上限を正確に適用するため、成功リクエストごとに 1 回だけ加算する必要がある。
    // カウントは AI 呼び出しの前に加算し、AI 側が失敗しても戻さない (失敗リトライの連打で無制限に呼ばれるのを防ぐ)。
    const isLimitReached = await database.runTransaction(async (transaction) => {
      const aiUsageDoc = await transaction.get(aiUsageRef);
      if ((aiUsageDoc.data()?.imageRecognitionCount ?? 0) >= monthlyLimit) {
        return true;
      }
      if (aiUsageDoc.exists) {
        transaction.update(aiUsageRef, {
          imageRecognitionCount: FieldValue.increment(1),
          serverUpdatedDateTime: FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(aiUsageRef, {
          id: yearMonth,
          userID: uid,
          imageRecognitionCount: 1,
          serverCreatedDateTime: FieldValue.serverTimestamp(),
          serverUpdatedDateTime: FieldValue.serverTimestamp(),
        });
      }
      return false;
    });
    if (isLimitReached) {
      logger.warn("generateMedicinesFromImage monthly limit reached", {
        uid,
        yearMonth,
        monthlyLimit,
      });
      return {
        result: "NG",
        statusCode: 429,
        error: {
          message: `画像読み取りの月間利用回数（${monthlyLimit}回）に達しました`,
        },
      };
    }

    const openai = new OpenAI({ apiKey: openAIApiKey.value() });
    const completion = await openai.chat.completions.create({
      model: openAIModel,
      messages: [
        {
          role: "user",
          content: [
            {
              type: "image_url",
              image_url: { url: `data:${mimeType};base64,${base64Image}` },
            },
            { type: "text", text: extractionPrompt },
          ],
        },
      ],
      // Structured Outputs でレスポンスをスキーマに固定し、自由文の混入と JSON 破損を防ぐ
      response_format: {
        type: "json_schema",
        json_schema: {
          name: "generate_medicines_from_image",
          strict: true,
          schema: {
            type: "object",
            properties: {
              medicines: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    name: { type: "string", description: "薬の名前" },
                    schedules: {
                      type: "array",
                      items: {
                        type: "object",
                        properties: {
                          hour: {
                            type: "integer",
                            description: "服用時刻の時 (0-23)",
                          },
                          minute: {
                            type: "integer",
                            description: "服用時刻の分 (0-59)",
                          },
                          quantityMemo: {
                            type: "string",
                            description: "1回あたりの服用量 (例: 1錠)",
                          },
                        },
                        required: ["hour", "minute", "quantityMemo"],
                        additionalProperties: false,
                      },
                    },
                  },
                  required: ["name", "schedules"],
                  additionalProperties: false,
                },
              },
            },
            required: ["medicines"],
            additionalProperties: false,
          },
        },
      },
    });

    const message = completion.choices[0]?.message;
    if (message?.refusal != null) {
      throw new Error(message.refusal);
    }
    if (message?.content == null) {
      throw new Error("AI からの応答が空でした");
    }
    return {
      result: "OK",
      statusCode: 200,
      data: {
        medicines: sanitizeGeneratedMedicines(
          (JSON.parse(message.content) as { medicines?: unknown }).medicines ?? []
        ),
      },
    };
  } catch (error) {
    // 機密データ (base64Image / API キー) はログに出力しない
    logger.error("generateMedicinesFromImage failed", {
      uid,
      yearMonth,
      errorName: error instanceof Error ? error.name : "unknown",
      errorMessage: error instanceof Error ? error.message : String(error),
    });
    return {
      result: "NG",
      statusCode: 500,
      error: {
        message:
          error instanceof Error ? error.message : "薬の読み取りに失敗しました",
      },
    };
  }
}

module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
    secrets: [openAIApiKey, revenueCatAPISecretParam],
  },
  generateMedicinesFromImageHandler
);

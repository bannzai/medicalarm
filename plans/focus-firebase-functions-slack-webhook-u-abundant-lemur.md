# 機能要望機能（起動時ダイアログ + 設定画面導線 + Firebase Functions → Slack 通知）

## Context

ユーザーから機能要望をアプリ内で集める仕組みを追加する。これまで `lib/components/button/inquiry.dart` の Google フォームへの導線（設定画面 > お問い合わせ）しか無く、要望と問い合わせが混在し集計しづらい状態だった。

参考実装は同じ作者の Focus アプリ (`/Users/bannzai/ghq/github.com/bannzai/Focus`)。Focus は `LaunchPageResolver` でアプリ起動時に `.alert` を出して要望フォームへ誘導し、設定画面の `AppSettingSupportSection` にも常時導線を持たせている。medicalarm でも同じ構造で導入する。

medicalarm 固有の制約:
- `onDocumentCreated` / `onDocumentUpdated` トリガー禁止（CLAUDE.md）。Focus と違い Firestore 書き込みではなく **Cloud Functions の onCall** で受けて、その場で Slack に通知して終わり。
- Slack Webhook URL は **GCP Secret Manager (`defineSecret`)** に保存。既存の `REVENUECAT_API_SECRET` と同じパターン。Channel ID は Webhook URL 側で固定されるため不要。

## 採用する設計方針

### サーバー側（Firebase Functions）
- 新規 onCall 関数 `submitFeatureRequest` を `asia-northeast1` / 256MiB で作る。
- リクエストを zod で検証し、Slack Incoming Webhook へ `{ text: ... }` 形式の単純なテキストを `axios.post` で送る。
- Slack 投稿の組み立ては関数内に直書きする（1関数だけのため `core/featureRequestSlack.ts` のような中間モジュールは作らない／中間表現禁止ルール）。
- Webhook URL は `defineSecret('SLACK_FEATURE_REQUEST_WEBHOOK_URL')` で取得。
- エラー時は既存 `core/slack.ts` の `report(userID, "submitFeatureRequest", error)` でエラーチャンネル (`SLACK_URL_ERROR`) にも通知。

### クライアント側
- 起動時ダイアログ (Focus の `LaunchPageResolver` 相当)
  - `lib/features/feature_request/feature_request_prompt_resolver.dart` を新設し、既存の `InAppReviewResolver` と並べて `lib/features/root/page.dart` の `Stack` に追加。
  - 表示条件: `AppUser.createdDateTime` から 3 日以上経過 + 前回表示から 30 日以上経過 + リリースモード (`kReleaseMode`)。
  - 再表示防止: `shared_preferences` に `featureRequestPromptShownDateTimeInterval`（double, epoch sec）を保存。
- フォーム本体 `lib/features/feature_request/page.dart` を新設。`MedicineFormPage` と同じく `showModalBottomSheet + DraggableScrollableSheet + Scaffold + FormTheme`。
- 設定画面 `lib/features/settings/page.dart` の「アプリについて」セクション、`L.inquiry` ListTile の上に「機能要望」ListTile を追加。
- ホーム画面の AppBar (`MedicationsPage`) には **ボタンを置かない**（起動時ダイアログ + 設定画面の二経路）。

### シークレット
- `SLACK_FEATURE_REQUEST_WEBHOOK_URL` のみ。Channel ID は不要（Incoming Webhook がチャンネルを固定する）。

## 棄却した案
- Firestore に `featureRequests/{id}` を書き込み `onDocumentCreated` で Slack 通知 → CLAUDE.md 規約違反のため不可。
- `core/slack.ts` の `notify()` (defineString) を流用 → 既存 `SLACK_URL_NOTIFICATION` はエラー以外の汎用通知で混雑するため、機能要望専用チャンネルを切れる別 Webhook にする。
- ホーム画面 AppBar に lightbulb ボタンを追加 → ユーザー要望は「起動時ダイアログ + 設定画面」。

---

## 変更ファイル一覧

| ファイル | 種別 | 内容 |
| --- | --- | --- |
| `functions/src/functions/submitFeatureRequest/function.ts` | 新規 | onCall 関数本体 |
| `functions/src/index.ts` | 変更 | 遅延 require 追記 |
| `lib/utils/functions/firebase_functions.dart` | 変更 | `submitFeatureRequest` メソッド追加 |
| `lib/provider/feature_request.dart` | 新規 | `FeatureRequestSubmit` クラス + Provider |
| `lib/features/feature_request/page.dart` | 新規 | フォーム + `showFeatureRequestForm` 関数 |
| `lib/features/feature_request/feature_request_prompt_resolver.dart` | 新規 | 起動時ダイアログ（`InAppReviewResolver` 相当） |
| `lib/utils/shared_preferences/keys.dart` | 変更 | `DoubleKey` extension に `featureRequestPromptShownDateTimeInterval` を追加 |
| `lib/features/root/page.dart` | 変更 | `Stack` に `FeatureRequestPromptResolver` を追加 |
| `lib/features/settings/page.dart` | 変更 | 「機能要望」ListTile 追加 |
| `lib/l10n/app_ja.arb`, `lib/l10n/app_en.arb` | 変更 | 文言追加 |
| `functions/test/submitFeatureRequest.test.ts` | 新規 | Jest ユニットテスト（要 jest 導入） |
| `test/features/feature_request/page_test.dart` | 新規 | Widget テスト |

`*.g.dart` / `*.freezed.dart` は build_runner で再生成（コミット対象）。

---

## 実装コード提案

### 1. Functions: `functions/src/functions/submitFeatureRequest/function.ts`（新規）

```ts
import functions = require("firebase-functions");
import { onCall } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import axios from "axios";
import { z } from "zod";
import { OnCallResponse } from "../../core/response";
import { report } from "../../core/slack";

/** 機能要望通知用 Slack Incoming Webhook の URL。チャンネルは URL 側で固定されるため Channel ID は不要。 */
const slackWebhookUrlSecret = defineSecret("SLACK_FEATURE_REQUEST_WEBHOOK_URL");

/** クライアントから送られてくる機能要望リクエスト。 */
const RequestSchema = z.object({
  /** ユーザーが入力した要望本文。空文字は弾く。 */
  content: z.string().min(1).max(5000),
  /** 任意の連絡先メールアドレス。空文字は undefined に正規化。 */
  emailAddress: z
    .string()
    .email()
    .optional()
    .or(z.literal("").transform(() => undefined)),
  /** クライアントの pubspec.yaml の version。例: "202601.26.124539"。 */
  appVersion: z.string().max(50).optional(),
  /** クライアントのプラットフォーム。 */
  platform: z.enum(["iOS", "Android"]).optional(),
});

module.exports = onCall(
  {
    memory: "256MiB",
    region: "asia-northeast1",
    secrets: [slackWebhookUrlSecret],
  },
  async (req): Promise<OnCallResponse> => {
    const userID = req.auth?.uid;
    if (userID == null) {
      functions.logger.warn("auth user is not found");
      return { result: "NG", statusCode: 401, error: { message: "auth user is not found" } };
    }

    const parsed = RequestSchema.safeParse(req.data);
    if (!parsed.success) {
      functions.logger.warn("invalid feature request payload", parsed.error.flatten());
      return { result: "NG", statusCode: 400, error: { message: parsed.error.message } };
    }
    const { content, emailAddress, appVersion, platform } = parsed.data;

    const lines: string[] = ["💡 新規機能要望", "", `[UserID] ${userID}`];
    if (emailAddress) lines.push(`[Email] ${emailAddress}`);
    if (appVersion) lines.push(`[AppVersion] ${appVersion}`);
    if (platform) lines.push(`[Platform] ${platform}`);
    lines.push(
      "━━━━━━━━━━━━━━━━━━━━",
      "内容:",
      content,
      "━━━━━━━━━━━━━━━━━━━━"
    );

    try {
      await axios.post(slackWebhookUrlSecret.value(), { text: lines.join("\n") });
      functions.logger.info("feature request notified", { userID });
      return { result: "OK", statusCode: 200, data: { ok: true } };
    } catch (error) {
      functions.logger.error("slack post failed", error);
      await report(userID, "submitFeatureRequest", error);
      return {
        result: "NG",
        statusCode: 500,
        error: { message: error instanceof Error ? error.message : String(error) },
      };
    }
  }
);
```

### 2. `functions/src/index.ts`（変更・末尾に追記）

```ts
if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "submitFeatureRequest"
) {
  exports.submitFeatureRequest = require("./functions/submitFeatureRequest/function");
}
```

### 3. `lib/utils/functions/firebase_functions.dart`（変更・extension に追加）

```dart
/// 機能要望を Cloud Functions (submitFeatureRequest) 経由で Slack に通知する。
/// emailAddress は任意。空文字は呼び出し側で null に正規化してから渡す。
Future<void> submitFeatureRequest({
  required String content,
  required String? emailAddress,
  required String appVersion,
  required String platform,
}) async {
  final result = await httpsCallable('submitFeatureRequest').call({
    'content': content,
    if (emailAddress != null && emailAddress.isNotEmpty) 'emailAddress': emailAddress,
    'appVersion': appVersion,
    'platform': platform,
  });
  final response = mapToJSON(result.data);
  if (response['result'] != 'OK') {
    throw Exception(response['error']['message']);
  }
}
```

### 4. `lib/provider/feature_request.dart`（新規）

```dart
import 'dart:io';

import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_request.g.dart';

/// 機能要望を Cloud Functions 経由で Slack に通知する mutation。
/// 既存の `MedicineAdd` 等と同じく専用 class + Provider の組み合わせで提供する。
class FeatureRequestSubmit {
  FeatureRequestSubmit();

  Future<void> call({required String content, required String? emailAddress}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    await functions.submitFeatureRequest(
      content: content.trim(),
      emailAddress: emailAddress?.trim(),
      appVersion: packageInfo.version,
      platform: Platform.isIOS ? 'iOS' : 'Android',
    );
  }
}

@Riverpod(dependencies: [])
FeatureRequestSubmit featureRequestSubmit(FeatureRequestSubmitRef ref) {
  return FeatureRequestSubmit();
}
```

### 5. `lib/features/feature_request/page.dart`（新規）

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/feature_request.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class FeatureRequestFormPage extends HookConsumerWidget {
  const FeatureRequestFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = useState('');
    final emailAddress = useState('');
    final isSubmitting = useState(false);
    final featureRequestSubmit = ref.watch(featureRequestSubmitProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final primaryColor = Theme.of(context).colorScheme.primary;

    final canSubmit = content.value.trim().isNotEmpty && !isSubmitting.value;

    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FormTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Text(L.featureRequestTitle, style: TextStyle(color: primaryColor)),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SafeArea(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(L.featureRequestContentLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          minLines: 6,
                          maxLines: 12,
                          maxLength: 5000,
                          decoration: InputDecoration(hintText: L.featureRequestContentHint),
                          onChanged: (v) => content.value = v,
                        ),
                        const SizedBox(height: 4),
                        Text(L.featureRequestContentFooter, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 24),
                        Text(L.featureRequestEmailLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(hintText: 'name@example.com'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v) ? null : L.featureRequestEmailInvalid;
                          },
                          onChanged: (v) => emailAddress.value = v,
                        ),
                        const SizedBox(height: 4),
                        Text(L.featureRequestEmailFooter, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canSubmit
                                ? () async {
                                    if (!(formKey.currentState?.validate() ?? false)) return;
                                    isSubmitting.value = true;
                                    try {
                                      analytics.logEvent(name: 'feature_request_submitted', parameters: {
                                        'has_email': emailAddress.value.isNotEmpty ? 'true' : 'false',
                                        'content_length': content.value.length,
                                      });
                                      await featureRequestSubmit.call(
                                        content: content.value,
                                        emailAddress: emailAddress.value.isEmpty ? null : emailAddress.value,
                                      );
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(L.featureRequestThanks)),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) showErrorAlert(context, e.toString());
                                    } finally {
                                      isSubmitting.value = false;
                                    }
                                  }
                                : null,
                            child: Loading(isLoading: isSubmitting.value, child: Text(L.send)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 機能要望フォームを BottomSheet で開く。起動時ダイアログ・設定画面の双方から呼ぶ。
void showFeatureRequestForm(BuildContext context) {
  analytics.logEvent(name: 'feature_request_form_opened');
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const FeatureRequestFormPage(),
  );
}
```

### 6. `lib/features/feature_request/feature_request_prompt_resolver.dart`（新規）

```dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/feature_request/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/shared_preferences/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// アプリ起動時に「機能要望を送ってみませんか？」ダイアログを出す Resolver。
/// 表示条件:
///   1. リリースビルドであること（kReleaseMode）。開発時は煩いため出さない。
///   2. AppUser.createdDateTime から 3 日以上経過していること。
///   3. 前回ダイアログ表示から 30 日以上経過していること（再表示頻度の上限）。
/// 表示後は SharedPreferences に表示日時 (epoch sec) を保存して再表示を抑止する。
class FeatureRequestPromptResolver extends HookConsumerWidget {
  const FeatureRequestPromptResolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider).asData?.value;
    useEffect(() {
      if (!kReleaseMode) return null;
      final createdDateTime = appUser?.createdDateTime;
      if (createdDateTime == null) return null;
      unawaited(_maybeShowPrompt(context: context, createdDateTime: createdDateTime));
      return null;
    }, [appUser?.id]);
    return const SizedBox.shrink();
  }
}

Future<void> _maybeShowPrompt({required BuildContext context, required DateTime createdDateTime}) async {
  if (DateTime.now().difference(createdDateTime).inDays < 3) return;

  final prefs = await SharedPreferences.getInstance();
  final lastShownEpoch = prefs.getDouble(DoubleKey.featureRequestPromptShownDateTimeInterval) ?? 0;
  final lastShown = DateTime.fromMillisecondsSinceEpoch((lastShownEpoch * 1000).toInt());
  if (DateTime.now().difference(lastShown).inDays < 30) return;

  if (!context.mounted) return;
  await prefs.setDouble(
    DoubleKey.featureRequestPromptShownDateTimeInterval,
    DateTime.now().millisecondsSinceEpoch / 1000.0,
  );
  analytics.logEvent(name: 'feature_request_prompt_shown');

  final accepted = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(L.featureRequestPromptTitle),
      content: Text(L.featureRequestPromptMessage),
      actions: [
        TextButton(
          onPressed: () {
            analytics.logEvent(name: 'feature_request_prompt_dismissed');
            Navigator.of(dialogContext).pop(false);
          },
          child: Text(L.later),
        ),
        TextButton(
          onPressed: () {
            analytics.logEvent(name: 'feature_request_prompt_accepted');
            Navigator.of(dialogContext).pop(true);
          },
          child: Text(L.featureRequestPromptCta),
        ),
      ],
    ),
  );
  if (accepted == true && context.mounted) {
    showFeatureRequestForm(context);
  }
}
```

### 7. `lib/utils/shared_preferences/keys.dart`（変更）

```dart
extension BoolKey on String {}

extension StringKey on String {
  static const String lastSignInFirebaseAuthUserID = 'lastSignInFirebaseAuthUserID';
}

extension ReleaseNoteKey on String {}

extension IntKey on String {}

extension DoubleKey on String {
  /// 起動時の機能要望ダイアログを最後に表示した時刻（epoch 秒）。
  /// 30日以内の再表示を抑止するために使用。
  static const String featureRequestPromptShownDateTimeInterval = 'featureRequestPromptShownDateTimeInterval';
}
```

### 8. `lib/features/root/page.dart`（変更・Stack に追加）

```dart
return Stack(
  children: [
    const InAppReviewResolver(),
    const FeatureRequestPromptResolver(), // 追加
    AppUserStreamResolver(stream: (user) => analyticsDebugIsEnabled = user.analyticsDebugIsEnabled),
    const HomePage(),
  ],
);
```

import に `import 'package:medicalarm/features/feature_request/feature_request_prompt_resolver.dart';` を追加。

### 9. `lib/features/settings/page.dart`（変更・「アプリについて」セクションの `L.inquiry` の上に追加）

```dart
const _Divider(),
ListTile(
  title: Text(L.featureRequestTitle),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {
    analytics.logEvent(name: 'did_select_feature_request');
    showFeatureRequestForm(context);
  },
),
const _Divider(),
ListTile(
  title: Text(L.inquiry),
  // ...既存
),
```

import に `import 'package:medicalarm/features/feature_request/page.dart';` を追加。

### 10. `lib/l10n/app_ja.arb`（追記キー）

```json
"featureRequestTitle": "機能要望",
"@featureRequestTitle": { "description": "機能要望フォーム/設定画面メニューのタイトル" },
"featureRequestPromptTitle": "Medicalarmに機能要望を送ってみませんか？",
"@featureRequestPromptTitle": { "description": "起動時に表示する機能要望ダイアログのタイトル" },
"featureRequestPromptMessage": "あったらうれしい機能や改善のアイデアを教えてください。設定画面の「機能要望」からいつでも送れます。",
"@featureRequestPromptMessage": { "description": "起動時ダイアログの本文" },
"featureRequestPromptCta": "要望を送る",
"@featureRequestPromptCta": { "description": "起動時ダイアログの肯定ボタン" },
"later": "あとで",
"@later": { "description": "起動時ダイアログの否定ボタン" },
"featureRequestContentLabel": "ご要望の内容",
"@featureRequestContentLabel": { "description": "機能要望フォームの本文ラベル" },
"featureRequestContentHint": "どんな機能が欲しいかご自由にお書きください",
"@featureRequestContentHint": { "description": "機能要望フォーム本文のプレースホルダー" },
"featureRequestContentFooter": "具体的にどのような場面で使いたいか書いていただけると検討の参考になります",
"@featureRequestContentFooter": { "description": "機能要望フォーム本文の補足説明" },
"featureRequestEmailLabel": "メールアドレス（任意）",
"@featureRequestEmailLabel": { "description": "機能要望フォームのメール欄ラベル" },
"featureRequestEmailFooter": "詳細を確認させていただく際に使用する場合があります。返信は約束できません",
"@featureRequestEmailFooter": { "description": "機能要望フォームのメール欄補足" },
"featureRequestEmailInvalid": "メールアドレスの形式が正しくありません",
"@featureRequestEmailInvalid": { "description": "メール形式バリデーションエラー" },
"featureRequestThanks": "ご要望をお送りしました。ありがとうございます",
"@featureRequestThanks": { "description": "送信完了 SnackBar" },
"send": "送信",
"@send": { "description": "送信ボタン汎用" }
```

### 11. `lib/l10n/app_en.arb`（追記キー）

```json
"featureRequestTitle": "Feature Request",
"@featureRequestTitle": { "description": "Title of the feature request form / settings menu item" },
"featureRequestPromptTitle": "Would you like to send a feature request to Medicalarm?",
"@featureRequestPromptTitle": { "description": "Title of the launch-time feature request dialog" },
"featureRequestPromptMessage": "Tell us what you'd like to see in Medicalarm. You can also send requests anytime from Settings > Feature Request.",
"@featureRequestPromptMessage": { "description": "Body of the launch-time dialog" },
"featureRequestPromptCta": "Send Feature Request",
"@featureRequestPromptCta": { "description": "Affirmative button of the launch-time dialog" },
"later": "Later",
"@later": { "description": "Dismiss button of the launch-time dialog" },
"featureRequestContentLabel": "Your request",
"@featureRequestContentLabel": { "description": "Label for the request body field" },
"featureRequestContentHint": "What feature would you like?",
"@featureRequestContentHint": { "description": "Placeholder for the request body field" },
"featureRequestContentFooter": "It helps us if you describe how you'd use it in your daily routine.",
"@featureRequestContentFooter": { "description": "Helper text under the body field" },
"featureRequestEmailLabel": "Email address (optional)",
"@featureRequestEmailLabel": { "description": "Label for the email field" },
"featureRequestEmailFooter": "We may use it to ask for details, but we can't promise a reply.",
"@featureRequestEmailFooter": { "description": "Helper text under the email field" },
"featureRequestEmailInvalid": "Please enter a valid email address",
"@featureRequestEmailInvalid": { "description": "Email validation error" },
"featureRequestThanks": "Thanks for your feedback!",
"@featureRequestThanks": { "description": "Success snackbar text" },
"send": "Send",
"@send": { "description": "Generic send button" }
```

未対応のロケール (zh, ko, ar, ...) はテンプレート (ja) にフォールバック。

---

## シークレット設定手順（ユーザー手動）

```bash
cd /Users/bannzai/ghq/github.com/bannzai/medicalarm/functions
firebase functions:secrets:set SLACK_FEATURE_REQUEST_WEBHOOK_URL
# プロンプトに Slack Incoming Webhook URL を貼り付け
```

エミュレータ検証時は `functions/.secret.local` または `functions/.runtimeconfig.json` でローカル値を渡す。

---

## 実装順序

1. `functions/src/functions/submitFeatureRequest/function.ts` 作成 → `cd functions && npm run lint && npm run build` で TS エラーゼロを確認。
2. `functions/src/index.ts` に require 追記。
3. ユーザーが `firebase functions:secrets:set SLACK_FEATURE_REQUEST_WEBHOOK_URL` を実行。
4. `cd functions && npm run serve` でエミュレータ起動 → curl/手動で動作確認。
5. `lib/utils/functions/firebase_functions.dart` に `submitFeatureRequest` 追加。
6. `lib/provider/feature_request.dart` 作成。
7. `lib/utils/shared_preferences/keys.dart` に `DoubleKey` extension 追加。
8. `lib/l10n/app_ja.arb` / `app_en.arb` にキー追加。
9. `flutter pub run build_runner build --delete-conflicting-outputs; dart format lib -l 150` で `feature_request.g.dart` と `app_localizations*.dart` を再生成。
10. `lib/features/feature_request/page.dart` 作成。
11. `lib/features/feature_request/feature_request_prompt_resolver.dart` 作成。
12. `lib/features/root/page.dart` に Resolver 追加。
13. `lib/features/settings/page.dart` に ListTile 追加。
14. `flutter analyze` / `flutter test` / `flutter build ios` / Maestro 実行。
15. `functions/test/submitFeatureRequest.test.ts` 作成 + jest 導入 → `npm test`。

---

## 検証方法

### 自動テスト

#### Functions ユニットテスト（新規・要 jest 導入）

`functions/package.json` に `jest`, `ts-jest`, `@types/jest` を `--save-dev` で追加（ユーザー判断）。

```ts
// functions/test/submitFeatureRequest.test.ts
import axios from "axios";
jest.mock("axios");
process.env.SLACK_FEATURE_REQUEST_WEBHOOK_URL = "https://hooks.slack.com/services/test";

const fnTest = require("firebase-functions-test")();
const wrapped = fnTest.wrap(require("../src/functions/submitFeatureRequest/function"));

afterAll(() => fnTest.cleanup());

describe("submitFeatureRequest", () => {
  it("rejects without auth", async () => {
    const res = await wrapped({ data: { content: "hi" } });
    expect(res.result).toBe("NG");
    expect(res.statusCode).toBe(401);
  });

  it("rejects empty content", async () => {
    const res = await wrapped({ data: { content: "" }, auth: { uid: "u1" } });
    expect(res.result).toBe("NG");
    expect(res.statusCode).toBe(400);
  });

  it("posts to slack on success", async () => {
    (axios.post as jest.Mock).mockResolvedValue({ status: 200 });
    const res = await wrapped({
      data: { content: "want X", emailAddress: "a@b.com", appVersion: "1.0", platform: "iOS" },
      auth: { uid: "u1" },
    });
    expect(res.result).toBe("OK");
    expect(axios.post).toHaveBeenCalledTimes(1);
    const [, body] = (axios.post as jest.Mock).mock.calls[0];
    expect(body.text).toContain("want X");
    expect(body.text).toContain("[UserID] u1");
    expect(body.text).toContain("[Email] a@b.com");
  });

  it("returns 500 when slack throws", async () => {
    (axios.post as jest.Mock).mockRejectedValue(new Error("boom"));
    const res = await wrapped({ data: { content: "x" }, auth: { uid: "u1" } });
    expect(res.result).toBe("NG");
    expect(res.statusCode).toBe(500);
  });
});
```

#### Flutter ウィジェットテスト（新規）

`test/features/feature_request/page_test.dart`

- `featureRequestSubmitProvider` を `overrideWith` でモックに差し替え。
- 「初期は送信ボタン disabled」「内容入力で enabled」「メール `abc` でバリデーションエラー表示」「送信中は二重押下不能」「成功で SnackBar 表示 + Navigator.pop」を検証。
- `MaterialApp` をテストハーネスに包み、`L10n.delegate` を流し込む。

#### Maestro E2E（新規）

`maestro/flows/feature_request.yaml`

```yaml
appId: com.bannzai.medicalarm
---
- launchApp
- runFlow: ../sub/setup_user.yaml  # 既存セットアップフロー想定
- tapOn: "設定"
- tapOn: "機能要望"
- assertVisible: "ご要望の内容"
- inputText: "テスト要望: 朝の通知を5分前にもう1回鳴らしてほしい"
- tapOn: "送信"
- assertVisible: "ご要望をお送りしました"
```

### 手動チェックリスト

- [ ] `functions/.env` 不要、`firebase functions:secrets:set SLACK_FEATURE_REQUEST_WEBHOOK_URL` 実行済みであることを `firebase functions:secrets:access SLACK_FEATURE_REQUEST_WEBHOOK_URL` で確認
- [ ] `cd functions && npm run lint` でゼロ警告
- [ ] `cd functions && npm run build` でゼロエラー
- [ ] `cd functions && npm test`（jest 導入後）が全件 pass
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` 成功 → `feature_request.g.dart` / `app_localizations*.dart` 生成
- [ ] `flutter analyze` ゼロエラー
- [ ] `flutter test` 全件 pass（feature_request widget test 含む）
- [ ] `flutter build ios` 成功
- [ ] `cd functions && npm run serve` でエミュレータ起動 → 端末から submit → 一時 Slack Webhook に指定フォーマット（💡新規機能要望/[UserID]/[AppVersion]/[Platform]/━━━/内容/━━━）が届く
- [ ] エミュレータで `auth` を渡さず submit → 401 が返り Slack に投稿されない
- [ ] エミュレータで `content: ""` を送信 → 400 が返り Slack に投稿されない
- [ ] iOS 実機/シミュレータでアプリ起動 → 起動時ダイアログは「アプリ使用開始から3日未満」では出ない（debug ビルドでは常に出ない）
- [ ] release ビルドでクライアント時間を 4 日後にずらす or `featureRequestPromptShownDateTimeInterval` を消去 → ダイアログが表示される
- [ ] ダイアログで「あとで」 → 閉じる、Analytics に `feature_request_prompt_dismissed` が記録される
- [ ] ダイアログで「要望を送る」 → BottomSheet が開く、Analytics に `feature_request_prompt_accepted` が記録される
- [ ] フォームで内容空欄時は送信ボタン disabled
- [ ] フォームで `abc` をメール欄 → バリデーションエラー表示
- [ ] フォームでメール空でも送信できる
- [ ] 送信中は Loading インジケータが出てボタン押下不能（二重送信防止）
- [ ] 送信成功 → BottomSheet が閉じ、`ご要望をお送りしました` SnackBar 表示
- [ ] 送信失敗（Webhook URL を不正値にしてエミュレータで再現）→ `showErrorAlert` が出る
- [ ] 設定画面 → アプリについて → 機能要望 タップ → 同じフォームが開く
- [ ] 同セッション内で再度起動しても、SharedPreferences の保存により 30 日間ダイアログは出ない（手動で `featureRequestPromptShownDateTimeInterval` を消すと再表示される）
- [ ] Analytics に `feature_request_form_opened`, `feature_request_submitted` が記録される
- [ ] 英語ロケールに切り替え → ダイアログ・フォーム・SnackBar が英訳される
- [ ] 中国語ロケール（未対応）に切り替え → ja にフォールバックして表示される（クラッシュしない）

---

## クリティカルファイル

- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/functions/src/functions/submitFeatureRequest/function.ts`（新規）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/functions/src/index.ts`（追記）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/functions/src/core/slack.ts`（既存 `report` を流用、変更なし）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/functions/src/core/response.ts`（既存型を流用、変更なし）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/utils/functions/firebase_functions.dart`（追記）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/provider/feature_request.dart`（新規）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/features/feature_request/page.dart`（新規）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/features/feature_request/feature_request_prompt_resolver.dart`（新規）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/features/root/page.dart`（変更）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/features/settings/page.dart`（変更）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/utils/shared_preferences/keys.dart`（変更）
- `/Users/bannzai/ghq/github.com/bannzai/medicalarm/lib/l10n/app_ja.arb`, `lib/l10n/app_en.arb`（追記）

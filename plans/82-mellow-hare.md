# Issue #82: 薬の一時停止機能を追加

## Context
登録した薬の「通知・表示」を一時停止できる機能を追加する（Issue #82）。

使い分けのイメージ:
- 服用を一時的に中断したい薬がある（旅行で数日飲まない、体調で処方が切り替わった等）
- 削除（`MedicineDelete`）だと履歴も辿りにくく再登録の手間も発生
- 「停止して通知と服薬チェックリストから外す。再開したら戻す」という可逆的な状態を用意する

要件（ユーザー確認済み）:
- 服薬画面（`MedicationsPage`）・通知・服薬履歴対象からは外す
- 薬一覧画面（`MedicinesPage`）には残し、カード右下の Switch で停止/再開可能
- 編集画面（`MedicineFormPage`）にも一時停止セクションを追加し、Toggle で停止/再開
- Toggle 操作時は Snackbar で「一時停止しました」「再開しました」を表示
- 保存フィールドは `Medicine` に新規 `pausedDateTime: DateTime?` を追加（既存の `archivedDateTime` は将来のアーカイブ機能と分離するため流用しない）

## 設計方針

### フィルタ戦略
- `activeMedicinesProvider`（`lib/provider/medicine.dart:12`）は現状 `archivedDateTime == null` のみでフィルタ → 変更しない（一覧画面は一時停止中の薬も表示する）
- 服薬画面と通知登録は両方とも `medicationGroups()`（`lib/features/medications/entity/grouped.dart:61`）を通っている → ここで `pausedDateTime != null` の薬をスキップすれば、一箇所の変更で両方に波及する

### Mutation
- `MedicineAdd` / `MedicineUpdate` のシグネチャは変更しない（保存ボタンの動線に一時停止は絡ませない）
- `Medicine.pausedDateTime` だけを単独で更新する専用 `MedicineSetPaused` クラス + `medicineSetPausedProvider` を新設（既存の `MedicineAdd` 同型）
- Toggle 操作時に即時 `docRef.set(..., merge: true)` → Snackbar → `registerReminderLocalNotification()` を呼ぶ

### 通知
- 既存の `RegisterReminderLocalNotification.call()`（`lib/utils/local_notification/client.dart:153`）は `activeMedicinesProvider.future` → `medicationGroups()` 経由なので、`medicationGroups` 側で除外すれば自動的に通知対象外になる
- Toggle 操作のたびに `registerReminderLocalNotification()` を呼ぶ（既存の追加・編集・削除と同じ流儀）

## 変更ファイル

| ファイル | 内容 |
| --- | --- |
| `lib/entity/medicine.dart` | `Medicine` に `pausedDateTime` 追加 |
| `lib/entity/medicine.g.dart` / `medicine.freezed.dart` | 再生成 |
| `lib/provider/medicine.dart` | `MedicineSetPaused` クラスと Provider 追加 |
| `lib/provider/medicine.g.dart` | 再生成 |
| `lib/features/medications/entity/grouped.dart` | `pausedDateTime != null` スキップを追加 |
| `lib/features/medicine_form/components/pause/tile.dart` | 新規。編集画面のトグル Tile |
| `lib/features/medicine_form/page.dart` | 編集モード時に `MedicationPauseTile` を表示 |
| `lib/features/medicines/page.dart` | カード右下に `Switch` を追加 |
| `lib/l10n/app_ja.arb` / `app_en.arb` | `medicationPause`, `medicinePausedSnackbar`, `medicineResumedSnackbar` を追加 |

## 実装コード提案

### 1. Entity: `lib/entity/medicine.dart`

```dart
@freezed
abstract class Medicine with _$Medicine {
  @JsonSerializable(explicitToJson: true)
  const factory Medicine({
    required String id,
    required String userID,
    required String name,
    required MedicationFrequency frequency,
    required List<MedicationSchedule> schedules,
    required DoseReceiver doseReceiver,
    required String memo,
    required String memoImageURL,
    @NullableTimestampConverter() DateTime? archivedDateTime,
    // 服薬画面・通知対象から外す「一時停止中」の印。nullなら稼働中。再開時は null に戻す。
    @NullableTimestampConverter() DateTime? pausedDateTime,
    @TimestampConverter() required DateTime beganDateTime,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Medicine;
  const Medicine._();

  factory Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);

  static int maxCount({required bool? hasPremiumEntitlement}) => hasPremiumEntitlement == true ? 10 : 2;
}
```

### 2. Provider: `lib/provider/medicine.dart`（末尾に追加）

```dart
/// 指定した薬の一時停止フラグ（`pausedDateTime`）のみを更新する。
/// - 停止: `pausedDateTime` に `DateTime.now()` を渡す
/// - 再開: `pausedDateTime` に `null` を渡す
class MedicineSetPaused {
  final UserDatabase database;

  MedicineSetPaused({required this.database});

  Future<Medicine> call({
    required String medicineID,
    required Medicine medicine,
    required DateTime? pausedDateTime,
  }) async {
    final docRef = database.medicineReference(medicineID: medicineID);
    final newMedicine = medicine.copyWith(pausedDateTime: pausedDateTime);
    await docRef.set(newMedicine, SetOptions(merge: true));
    return newMedicine;
  }
}

@Riverpod(dependencies: [userDatabase])
MedicineSetPaused medicineSetPaused(Ref ref) {
  final database = ref.watch(userDatabaseProvider);
  return MedicineSetPaused(database: database);
}
```

### 3. `lib/features/medications/entity/grouped.dart`（2つのループに条件を追加）

```dart
// scheduleTime&doseReceiverごとのtileValuesを構築するループ
for (final medicine in medicines) {
  if (medicine.pausedDateTime != null) {
    continue;
  }
  final doseReceiver = medicine.doseReceiver;
  if (medicine.beganDateTime.date().isAfter(date.date())) {
    continue;
  }
  // ... (既存のまま)
}

// dosingRowsを構築するループ
for (final medicine in medicines) {
  if (medicine.pausedDateTime != null) {
    continue;
  }
  final doseReceiver = medicine.doseReceiver;
  if (medicine.beganDateTime.date().isAfter(date.date())) {
    continue;
  }
  // ... (既存のまま)
}
```

### 4. 新規コンポーネント: `lib/features/medicine_form/components/pause/tile.dart`

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/utils/local_notification/client.dart';

/// MedicineFormPage の編集モードで表示する「一時停止」トグル。
/// トグル即時に Firestore へ反映し、Snackbar 表示と通知再登録を行う。
class MedicinePauseTile extends HookConsumerWidget {
  final Medicine medicine;
  const MedicinePauseTile({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: SwitchListTile(
          title: Text(L.medicationPause),
          subtitle: Text(L.medicationPauseDescription),
          value: medicine.pausedDateTime != null,
          onChanged: (value) async {
            try {
              await ref.read(medicineSetPausedProvider).call(
                    medicineID: medicine.id,
                    medicine: medicine,
                    pausedDateTime: value ? DateTime.now() : null,
                  );
              unawaited(ref.read(registerReminderLocalNotificationProvider).call());
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? L.medicinePausedSnackbar : L.medicineResumedSnackbar)),
                );
              }
            } catch (e) {
              if (context.mounted) {
                showErrorAlert(context, e.toString());
              }
            }
          },
        ),
      ),
    );
  }
}
```

### 5. `lib/features/medicine_form/page.dart`（body 部分の組み換え）

`MedicineFormPage.build` の本文内 `Column` に、編集モードの時だけ `MedicinePauseTile` を挿入する。`useState` で管理している他フィールドは保存ボタン経由で反映するが、一時停止トグルのみ即時反映のため、現行 `medicine` そのものを渡す。

```dart
// imports 追加
import 'package:medicalarm/features/medicine_form/components/pause/tile.dart';

// Body の children 変更箇所
Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0),
  child: Column(
    children: [
      MedicineFormNameTextField(name: name, focusNode: nameFocusNode),
      const SizedBox(height: 6),
      MedicationFrequencyTile(frequency: frequency),
      const SizedBox(height: 6),
      MedicationBeginTile(begin: begin),
      if (medicine != null) ...[
        const SizedBox(height: 6),
        MedicinePauseTile(medicine: medicine),
      ],
    ],
  ),
),
```

注意: `medicine` は編集モードなら `ref.watch(activeMedicinesProvider)` に含まれる最新を使うよう、`MedicineFormPage` を `HookConsumerWidget` のまま watch して合成する手もあるが、Page 初期化時にだけ渡ってくる immutable な引数を直接渡す既存スタイルを踏襲する。トグル反映後はリスナーが拾い、次回モーダル再表示時には最新値になる。

### 6. `lib/features/medicines/page.dart`（カード右下に Switch を追加）

`MedicinesPageSection` を `HookConsumerWidget` に変更し、`Stack` の `Positioned` 内に Switch を追加。既存の右上の編集アイコンと棲み分けるため、右下 (`bottom: 4, right: 8`) に配置。Material 標準の `Switch` をそのまま使い、説明文は置かない。

```dart
class MedicinesPageSection extends HookConsumerWidget {
  final Medicine medicine;
  const MedicinesPageSection({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medicine.doseReceiver.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                for (final schedule in medicine.schedules) ...[
                  MedicinesPageMedicationScheduleRow(schedule: schedule),
                ],
                if (medicine.memo.isNotEmpty) ...[
                  Text(medicine.memo),
                ],
                // カード右下の Switch と重ならないための下余白
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showMedicineForm(context, medicine);
            },
            icon: const Icon(Icons.edit, size: 20),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 4,
          child: Switch(
            value: medicine.pausedDateTime == null,
            onChanged: (value) async {
              try {
                await ref.read(medicineSetPausedProvider).call(
                      medicineID: medicine.id,
                      medicine: medicine,
                      pausedDateTime: value ? null : DateTime.now(),
                    );
                unawaited(ref.read(registerReminderLocalNotificationProvider).call());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(value ? L.medicineResumedSnackbar : L.medicinePausedSnackbar)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorAlert(context, e.toString());
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
```

注意: Switch の on/off と `pausedDateTime` の関係は「ON = 稼働中（pausedDateTime == null）」「OFF = 停止中（pausedDateTime != null）」とする。ユーザーの直感（Switch OFF = 通知なし）と一致させる。

### 7. Localization: `.arb`

```arb
// app_ja.arb に追加
"medicationPause": "一時停止",
"medicationPauseDescription": "停止中は服薬画面・通知から除外されます",
"medicinePausedSnackbar": "一時停止しました",
"medicineResumedSnackbar": "再開しました",

// app_en.arb に追加
"medicationPause": "Pause",
"medicationPauseDescription": "While paused, this medicine is excluded from the daily list and notifications.",
"medicinePausedSnackbar": "Paused",
"medicineResumedSnackbar": "Resumed",
```

（プロジェクトのローカライゼーション運用に合わせてキー定義を `L` に反映する）

## 実行順序

1. `lib/entity/medicine.dart` に `pausedDateTime` を追加
2. `dart run build_runner build --delete-conflicting-outputs` でコード生成
3. `lib/provider/medicine.dart` に `MedicineSetPaused` と Provider を追加 → 再度 `build_runner`
4. `lib/features/medications/entity/grouped.dart` のフィルタ追加
5. `.arb` ローカリゼーション追加（`L.medicationPause` 等）
6. `lib/features/medicine_form/components/pause/tile.dart` を新規作成
7. `lib/features/medicine_form/page.dart` の body に Tile を挿入
8. `lib/features/medicines/page.dart` の `MedicinesPageSection` を `HookConsumerWidget` 化して Switch 追加
9. `flutter analyze` / `flutter test`
10. 動作確認（下記チェックリスト）

## 動作確認チェックリスト

### 基本動作
- [ ] アプリを起動して薬を1件登録できる（既存機能のリグレッション確認）
- [ ] 薬一覧（MedicinesPage）に登録した薬が表示される
- [ ] カード右下の Switch が初期状態 ON（稼働中）になっている
- [ ] 服薬画面（MedicationsPage）の該当日に薬が表示される

### 一時停止（MedicinesPage 側）
- [ ] カードの Switch を OFF にすると Snackbar「一時停止しました」が表示される
- [ ] OFF 状態の薬は服薬画面（MedicationsPage）から消える
- [ ] OFF 状態の薬は薬一覧（MedicinesPage）には残っている
- [ ] アプリを再起動しても OFF 状態が維持されている（Firestore 反映確認）

### 再開（MedicinesPage 側）
- [ ] Switch を ON に戻すと Snackbar「再開しました」が表示される
- [ ] ON に戻した薬が服薬画面（MedicationsPage）に戻る
- [ ] アプリを再起動しても ON 状態が維持されている

### 一時停止（MedicineFormPage 側）
- [ ] 既存の薬をタップして編集画面を開くと「一時停止」セクションが表示される
- [ ] 新規薬登録画面（`medicine == null`）には「一時停止」セクションが表示されない
- [ ] Toggle を ON にすると Snackbar「一時停止しました」が表示される
- [ ] Toggle を OFF にすると Snackbar「再開しました」が表示される
- [ ] MedicineFormPage と MedicinesPage のカード Switch 状態が連動する

### 通知
- [ ] 一時停止中の薬は通知の予定に現れない
  - Debug で `localNotificationService.pendingReminderNotifications()` の結果を確認、あるいは `registerReminderLocalNotification` 呼び出し後の iOS シミュレータの予定通知を確認
- [ ] 再開した薬の通知が再登録される
- [ ] 一時停止中の薬を含むグループで、他の稼働中の薬の通知は維持される

### 服薬履歴
- [ ] 過去に記録した服薬履歴は、その薬を一時停止しても MedicationHistoriesPage に残る（`MedicationHistory.medicine` はスナップショットのため）

### エラーハンドリング
- [ ] オフライン状態で Switch 操作してもクラッシュせず、ネットワーク復帰後に同期される、もしくは ErrorAlert が表示される

### 回帰
- [ ] 既存の薬の追加・編集・削除が従来通り動作する
- [ ] `archivedDateTime` を使った既存のフィルタ（`activeMedicinesProvider`）は挙動変更なし

## 検証コマンド

```sh
# コード生成
dart run build_runner build --delete-conflicting-outputs
dart format lib -l 150

# 静的解析
flutter analyze

# ユニット/Widget テスト
flutter test

# iOS ビルド確認
flutter build ios --no-codesign

# Android ビルド確認
flutter build apk --debug
```

### 追加で書くべきテスト
- `test/features/medications/entity/grouped_test.dart` に「`pausedDateTime != null` の薬が `medicationGroups()` の結果から除外される」ケースを追加
- `test/provider/medicine_test.dart` に `MedicineSetPaused.call` の正/負ケース（`pausedDateTime` 設定/null 戻し）のテストを追加

### Maestro E2E（任意）
既存の `maestro/flows/` に `medicine_pause_toggle.yaml` を追加し、以下を自動化できる:
1. 薬を1件追加
2. 服薬画面に現れることを確認
3. 薬一覧カードの Switch を OFF
4. 服薬画面から消えることを確認
5. Switch を ON に戻し、再び現れることを確認

## 備考

- `archivedDateTime` は今回も未使用のまま残る。将来「完全アーカイブ（履歴は残すが一覧からも消す）」を導入する際は同じ要領で Provider とフィルタを拡張する想定。
- AlarmKit / FocusConnect は `medicationGroups()` 経由で除外されるため、追加対応不要。再開時は `registerReminderLocalNotification()` の内部で既存キャンセル→再登録が走る。
- `MedicinesPageSection` の Switch は小さいスペースに置くため、カード本文に `SizedBox(height: 28)` の下余白を追加して重なりを避ける。

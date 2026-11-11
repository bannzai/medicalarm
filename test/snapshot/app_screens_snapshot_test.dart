@Tags(['snapshot'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/button/user_delete.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/calendar/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medications/page.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/medicines/page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/features/settings/page.dart';
import 'package:medicalarm/l10n/app_localizations.dart';
import 'package:medicalarm/main.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/provider/user_groups.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 画面が描く日付の基準。基準画像が実行日で変わらないように固定する。
/// 週カレンダーが月をまたがず、月カレンダーの週の行が埋まる日付として 2026-01-15 (木) を使う
final _fixedNow = DateTime(2026, 1, 15, 9, 30);

/// 画面の論理幅。iPhone 13 / 14 (利用者の多い 6.1 インチ) に合わせた。変えたら基準画像を撮り直す
const _screenWidth = 390.0;

/// 1 画面に収まる画面の論理高さ。iPhone 13 / 14 に合わせた。変えたら基準画像を撮り直す
const _screenHeight = 844.0;

/// 基準画像を撮る画素密度 (論理 1 px あたりの画像の px)。iPhone 13 / 14 の実機は 3 倍だが、基準画像の画素数を
/// 3 倍の (2/3)^2 ≒ 44% に抑えるため 2 倍にする。変えたら基準画像を撮り直す
const _devicePixelRatio = 2.0;

/// 薬の登録フォームを末尾まで写す論理高さ。実測でフォームの内容 (服用者の行) がスクロールせずに収まる高さ
const _medicineFormHeight = 1300.0;

/// 文字を最大にした薬の登録フォームを末尾まで写す論理高さ。実測で内容がスクロールせずに収まる高さ
const _medicineFormLargestTextHeight = 3200.0;

/// 設定画面を末尾まで写す論理高さ。実測で内容がスクロールせずに収まる高さ
const _settingsHeight = 1000.0;

/// 文字を最大にした時の倍率。iOS のアクセシビリティの文字サイズの最大 (AX5) が本文の約 3 倍のため 3.0 を使う
const _largestTextScaleFactor = 3.0;

/// ローカル通知プラグインに触れないテスト用の RegisterReminderLocalNotification。
class _FakeRegisterReminderLocalNotification extends RegisterReminderLocalNotification {
  _FakeRegisterReminderLocalNotification(super.ref);

  @override
  Future<void> call() async {}
}

/// 主要な画面を言語ごとに描き、基準画像 (goldens/) と比べる。
/// 基準画像は CI (.github/workflows/snapshot-testing.yml) の runner で撮ったものだけを使う (OS でフォントの描画が変わるため)。
void main() {
  // 週カレンダーのデータソースが最初の参照で today() を読むトップレベルの final のため、どのテストよりも先に固定する
  fixedNowForTesting = _fixedNow;
  setUpAll(_loadFonts);

  for (final locale in const [Locale('ja'), Locale('en')]) {
    _snapshotTest(name: 'medications', locale: locale, screen: () => const MedicationsPage());
    _snapshotTest(name: 'medicines', locale: locale, screen: () => const MedicinesPage());
    _snapshotTest(name: 'calendar', locale: locale, screen: () => const CalendarPage());
    _snapshotTest(name: 'settings', locale: locale, height: _settingsHeight, screen: () => const SettingPage());
    _snapshotTest(name: 'medicine_form_new', locale: locale, height: _medicineFormHeight, screen: () => const MedicineFormPage(medicine: null));
    _snapshotTest(
      name: 'medicine_form_edit',
      locale: locale,
      height: _medicineFormHeight,
      screen: () => MedicineFormPage(medicine: _medicines().first),
    );
  }

  // 英語・文字サイズ最大は、単語の途中の折り返しやはみ出しが起きやすい条件 (#474)
  _snapshotTest(
    name: 'medicine_form_new_largest_text',
    locale: const Locale('en'),
    height: _medicineFormLargestTextHeight,
    textScaleFactor: _largestTextScaleFactor,
    screen: () => const MedicineFormPage(medicine: null),
  );
  _snapshotTest(
    name: 'medicine_form_edit_largest_text',
    locale: const Locale('en'),
    height: _medicineFormLargestTextHeight,
    textScaleFactor: _largestTextScaleFactor,
    screen: () => MedicineFormPage(medicine: _medicines().first),
  );
}

/// [screen] が返す画面を [locale] で描いて `goldens/<name>_<言語>.png` と比べるテストを登録する。
/// [screen] は固定データが表示言語の文言を読めるよう、L を [locale] に切り替えた後に呼ぶ。
void _snapshotTest({
  required String name,
  required Locale locale,
  required Widget Function() screen,
  // 多くの画面はスクロールせずに 1 画面に収まるため、端末の 1 画面ぶんを既定にする
  double height = _screenHeight,
  // 利用者の多くは端末の文字サイズを変えていないため、OS の既定の倍率 1.0 を既定にする
  double textScaleFactor = 1.0,
}) {
  testWidgets(
    '$name (${locale.languageCode})',
    (tester) async {
      tester.view.physicalSize = Size(_screenWidth, height) * _devicePixelRatio;
      tester.view.devicePixelRatio = _devicePixelRatio;
      tester.platformDispatcher.textScaleFactorTestValue = textScaleFactor;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      L = lookupAppLocalizations(locale);
      addTearDown(() => L = lookupAppLocalizations(const Locale('ja')));
      // AppLocalizationResolver が画面の表示言語に合わせて DateFormat の既定の言語を切り替えるのと同じにする
      Intl.defaultLocale = locale.languageCode;
      addTearDown(() => Intl.defaultLocale = null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: _userID)),
            currentGroupDatabaseProvider.overrideWith((ref) => GroupDatabase(groupID: 'snapshot-group')),
            appUserIDProvider.overrideWith((ref) => _userID),
            userGroupsProvider.overrideWith((ref) => Stream.value([])),
            isAppleLinkedProvider.overrideWith((ref) => false),
            isGoogleLinkedProvider.overrideWith((ref) => false),
            customerInfoProvider.overrideWith((ref) => Stream.value(_premiumCustomerInfo())),
            activeMedicinesProvider.overrideWith((ref) => Stream.value(_medicines())),
            medicationHistoriesByDateProvider.overrideWith((ref, date) => Stream.value([_takenMedicationHistory()])),
            diariesForDateTimeRangeProvider.overrideWith((ref, dateTimeRange) => Stream.value([_diary()])),
            registerReminderLocalNotificationProvider.overrideWith((ref) => _FakeRegisterReminderLocalNotification(ref)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: locale,
            theme: _themeData(fontFamily: locale.languageCode == 'ja' ? 'NotoSansJP' : 'NotoSans'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: screen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'));
    },
    // アプリの主な配信先が iOS のため、スクロールやタイトルの配置を iOS の見た目で撮る
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );
}

/// アプリのテーマの文字を [fontFamily] で描くようにしたテーマを返す。
/// flutter test には端末のフォントが無く、フォント未指定の文字が四角になるため。
ThemeData _themeData({required String fontFamily}) {
  final theme = appThemeData();
  const fontFamilyFallback = ['NotoSansJP', 'NotoEmoji'];
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamily: fontFamily, fontFamilyFallback: fontFamilyFallback),
    primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: fontFamily, fontFamilyFallback: fontFamilyFallback),
    // ボタンのテーマの文字スタイルは継承せず置き換わるため、フォントを個別に指定する
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: theme.elevatedButtonTheme.style!.copyWith(
        textStyle: WidgetStatePropertyAll(
          theme.elevatedButtonTheme.style!.textStyle!.resolve({})!.copyWith(fontFamily: fontFamily, fontFamilyFallback: fontFamilyFallback),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: theme.textButtonTheme.style!.copyWith(
        textStyle: WidgetStatePropertyAll(
          theme.textButtonTheme.style!.textStyle!.resolve({})!.copyWith(fontFamily: fontFamily, fontFamilyFallback: fontFamilyFallback),
        ),
      ),
    ),
  );
}

/// pubspec と SDK が同梱するフォント (Material Icons 等) と、scripts/snapshot_testing/fetch_fonts.sh が取得した Noto フォントを読み込む。
/// フォントが無いと文字が四角になり文言の違いを比べられないため、無ければ fail する
Future<void> _loadFonts() async {
  for (final entry in (json.decode(await rootBundle.loadString('FontManifest.json')) as List<dynamic>).cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
  for (final family in const ['NotoSans', 'NotoSansJP', 'NotoEmoji']) {
    final file = File('test/snapshot/fonts/$family.ttf');
    if (!file.existsSync()) {
      fail('${file.path} がありません。先に `bash scripts/snapshot_testing/fetch_fonts.sh` を実行してください');
    }
    await (FontLoader(family)..addFont(Future.value(ByteData.view(Uint8List.fromList(await file.readAsBytes()).buffer)))).load();
  }
}

/// 固定データの作成者のユーザー ID。
const _userID = 'snapshot-user';

/// 朝の服用スケジュール。容量のメモの表示も写すためメモを入れる。
const _morningSchedule = MedicationSchedule(
  id: 'schedule-morning',
  hour: 8,
  minute: 0,
  quantityMemo: '1',
  notificationSetting: MedicineScheduleNotificationSetting(isReminderEnabled: true, isFollowupEnabled: true, useCriticalAlert: false),
  focusConnectSetting: null,
);

/// 夜の服用スケジュール。
const _eveningSchedule = MedicationSchedule(
  id: 'schedule-evening',
  hour: 20,
  minute: 30,
  quantityMemo: '',
  notificationSetting: MedicineScheduleNotificationSetting(isReminderEnabled: true, isFollowupEnabled: false, useCriticalAlert: false),
  focusConnectSetting: null,
);

/// 登録済みの薬の固定データ。文言は表示言語に合わせる。
List<Medicine> _medicines() {
  final doseReceiver = DoseReceiver(id: 'firstUser', userID: _userID, name: L.defaultDoseReceiver);
  return [
    Medicine(
      id: 'medicine-1',
      userID: _userID,
      name: L.localeName == 'ja' ? 'ロキソニン' : 'Loxonin',
      frequency: const MedicationFrequency.daily(),
      schedules: const [_morningSchedule, _eveningSchedule],
      doseReceiver: doseReceiver,
      memo: L.localeName == 'ja' ? '食後に飲む' : 'Take after meals',
      memoImageURL: '',
      minimumDoseIntervalHours: null,
      beganDateTime: DateTime(2026, 1, 1),
    ),
    Medicine(
      id: 'medicine-2',
      userID: _userID,
      name: L.localeName == 'ja' ? 'ビタミンC' : 'Vitamin C',
      frequency: const MedicationFrequency.daily(),
      schedules: const [_morningSchedule],
      doseReceiver: doseReceiver,
      memo: '',
      memoImageURL: '',
      minimumDoseIntervalHours: null,
      beganDateTime: DateTime(2026, 1, 1),
    ),
  ];
}

/// 1 件目の薬の朝の分を服用済みにする記録。チェック済みの行と記録時刻の表示を写すために使う。
MedicationHistory _takenMedicationHistory() {
  return MedicationHistory(
    id: 'history-1',
    userID: _userID,
    recordedByUserID: _userID,
    medicine: _medicines().first,
    actionKind: MedicationHistoryActionKind.take,
    action: MedicationHistoryAction.take(medicationSchedule: _morningSchedule, scheduledRecordedDate: _fixedNow.date()),
    memo: '',
    recordedDateTime: DateTime(2026, 1, 15, 8, 5),
    scheduledRecordedDate: _fixedNow.date(),
    // 記録の保持期限はこの画面の表示に関わらないため、基準の日付の 1 年後 (本番の既定の保持期間) にする
    ttlExpiresDateTime: DateTime(2027, 1, 15),
  );
}

/// カレンダーの日付タイルの日記の印を写すための日記。基準の日付の 2 日前は同じ週・同じ月に入る。
Diary _diary() {
  return Diary(id: 'diary-1', userID: _userID, memo: '', diaryDate: DateTime(2026, 1, 13));
}

/// プレミアム会員の CustomerInfo。無料会員の広告 (AdMob) はプラットフォームのビューで snapshot に写らないため、広告が出ない状態にする。
/// entitlement の形は purchases_flutter の EntitlementInfo.fromJson に合わせた。
CustomerInfo _premiumCustomerInfo() {
  const premiumEntitlement = {
    'identifier': premiumEntitlementIdentifier,
    'isActive': true,
    'willRenew': true,
    'latestPurchaseDate': '2026-01-01T00:00:00Z',
    'originalPurchaseDate': '2026-01-01T00:00:00Z',
    // プロモーション中の表示を出さないため rc_promo_Premium で始めない
    'productIdentifier': 'premium_monthly',
    'isSandbox': false,
    'ownershipType': 'PURCHASED',
    'store': 'APP_STORE',
    'periodType': 'NORMAL',
    'verification': 'NOT_REQUESTED',
  };
  return CustomerInfo.fromJson({
    'entitlements': {
      'all': {premiumEntitlementIdentifier: premiumEntitlement},
      'active': {premiumEntitlementIdentifier: premiumEntitlement},
      'verification': 'NOT_REQUESTED',
    },
    'allPurchaseDates': <String, dynamic>{},
    'activeSubscriptions': const ['premium_monthly'],
    'allPurchasedProductIdentifiers': const ['premium_monthly'],
    'nonSubscriptionTransactions': const <dynamic>[],
    'firstSeen': '2026-01-01T00:00:00Z',
    'originalAppUserId': _userID,
    'allExpirationDates': <String, dynamic>{},
    'requestDate': '2026-01-01T00:00:00Z',
  });
}

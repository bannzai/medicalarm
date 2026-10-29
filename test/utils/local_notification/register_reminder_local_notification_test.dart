import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// 10:00 にリマインダーとフォローアップを送る服用時刻。AlarmKit の platform channel に触れないよう useAlarmKit は false のままにする。
MedicationSchedule buildSchedule({required String scheduleID}) {
  return MedicationSchedule(
    id: scheduleID,
    hour: 10,
    minute: 0,
    quantityMemo: '',
    notificationSetting: const MedicineScheduleNotificationSetting(isReminderEnabled: true, isFollowupEnabled: true, useCriticalAlert: false),
    focusConnectSetting: null,
  );
}

/// [doseReceiverName] の服用者が毎日 10:00 に飲む薬。
Medicine buildMedicine({required String medicineID, required String medicineName, required String doseReceiverName}) {
  return Medicine(
    id: medicineID,
    userID: 'user-a',
    name: medicineName,
    frequency: const MedicationFrequency.daily(),
    schedules: [buildSchedule(scheduleID: '$medicineID-schedule')],
    doseReceiver: DoseReceiver(id: '$doseReceiverName-id', userID: 'user-a', name: doseReceiverName),
    memo: '',
    memoImageURL: '',
    minimumDoseIntervalHours: null,
    beganDateTime: DateTime(2026, 1, 1),
  );
}

/// [medicine] を [scheduledRecordedDate] の分として服用済みにする記録。
MedicationHistory buildTakeMedicationHistory({required Medicine medicine, required DateTime scheduledRecordedDate}) {
  return MedicationHistory(
    id: '${medicine.id}-history',
    userID: 'user-a',
    recordedByUserID: 'user-a',
    medicine: medicine,
    actionKind: MedicationHistoryActionKind.take,
    action: MedicationHistoryAction.take(medicationSchedule: medicine.schedules.first, scheduledRecordedDate: scheduledRecordedDate),
    memo: '',
    recordedDateTime: scheduledRecordedDate,
    scheduledRecordedDate: scheduledRecordedDate,
    ttlExpiresDateTime: DateTime(2027, 1, 1),
  );
}

/// 同じ時刻に服用者の違う薬がある時に、通知 id の衝突で片方の薬が通知から消えないことを検証する (#428)。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  late List<MethodCall> zonedScheduleCalls;

  setUp(() async {
    zonedScheduleCalls = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'zonedSchedule') {
        zonedScheduleCalls.add(call);
      }
      return true;
    });
    tz_data.initializeTimeZones();
    IOSFlutterLocalNotificationsPlugin.registerWith();
    await localNotificationService.initialize();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  final momMedicine = buildMedicine(medicineID: 'loxonin', medicineName: 'Loxonin', doseReceiverName: 'Mom');
  final userMedicine = buildMedicine(medicineID: 'aspirin', medicineName: 'Aspirin', doseReceiverName: 'User');

  test('同じ時刻に服用者の違う薬があると、各通知 id は 1 回だけ予約され両方の薬を含む', () async {
    await RegisterReminderLocalNotification.run(
      medicines: [momMedicine, userMedicine],
      medicationHistories: [],
      recentMedicationHistories: [],
      memberNotificationSettings: null,
      currentUserID: 'user-a',
      loopCount: 1,
    );

    final callsByID = groupBy(zonedScheduleCalls, (call) => call.arguments['id'] as int);
    // 翌日以降の 4 日分は必ず未来の時刻になるため、リマインダーとフォローアップで少なくとも 8 件
    expect(callsByID.length, greaterThanOrEqualTo(8));
    for (final calls in callsByID.values) {
      expect(calls.length, 1);
      expect(calls.single.arguments['body'], allOf(contains('Mom Loxonin'), contains('User Aspirin')));
    }
  });

  test('片方の服用者の薬を服用済みの日は、未服用の服用者の薬だけを通知に含める', () async {
    // run は tz.local の現在日時から日付を数えるため、端末のタイムゾーンではなく tz.local の翌日にする
    final tomorrow = tz.TZDateTime.now(tz.local).date().addDays(1);
    await RegisterReminderLocalNotification.run(
      medicines: [momMedicine, userMedicine],
      medicationHistories: [buildTakeMedicationHistory(medicine: momMedicine, scheduledRecordedDate: tomorrow)],
      recentMedicationHistories: [],
      memberNotificationSettings: null,
      currentUserID: 'user-a',
      loopCount: 1,
    );

    final tomorrowCalls = zonedScheduleCalls.where((call) {
      final scheduledDateTime = DateTime.parse(call.arguments['scheduledDateTime'] as String);
      return isSameDay(scheduledDateTime, tomorrow);
    }).toList();
    expect(tomorrowCalls.length, 2);
    for (final call in tomorrowCalls) {
      expect(call.arguments['body'], allOf(isNot(contains('Mom Loxonin')), contains('User Aspirin')));
    }
  });
}

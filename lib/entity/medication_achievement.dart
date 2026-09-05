import 'package:collection/collection.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

/// ある日の服薬予定に対する達成状態 (#278)。
/// 予定が 1 件も無い日はこの enum では表現せず、[dayMedicationAchievement] が null を返す
enum DayMedicationAchievement {
  /// その日の予定をすべて服用した
  allTaken,

  /// その日の予定の一部だけを服用した
  partiallyTaken,

  /// その日の予定を 1 件も服用していない
  noneTaken,
}

/// 連続記録([consecutiveAchievedDaysCount])で過去へ遡る日数の上限。
/// 服薬記録の ttlExpiresDateTime が記録日から 365 日後(lib/provider/medication_history.dart の MedicationHistoryTake)のため、
/// それより古い日は記録が残っておらず必ず未達成と判定されてしまう。遡っても意味が無い範囲で打ち切る
const _maxConsecutiveLookbackDays = 365;

/// [medicine] が [date] の服薬予定に該当するかどうか (#278)。
/// 開始前・停止中・アーカイブ済みの期間を除外したうえで、服用頻度([MedicationFrequency.isScheduledOnDate])で判定する。
/// 停止・アーカイブはその操作日当日から予定に数えない。当日途中の操作で、その日の残りの予定が未達成として数えられるのを避けるため
bool isMedicineScheduledOnDate({required Medicine medicine, required DateTime date}) {
  if (medicine.beganDateTime.date().isAfter(date.date())) {
    return false;
  }
  final archivedDateTime = medicine.archivedDateTime;
  if (archivedDateTime != null && !date.date().isBefore(archivedDateTime.date())) {
    return false;
  }
  final pausedDateTime = medicine.pausedDateTime;
  if (pausedDateTime != null && !date.date().isBefore(pausedDateTime.date())) {
    return false;
  }
  return medicine.frequency.isScheduledOnDate(beganDateTime: medicine.beganDateTime, date: date);
}

/// [date] に服用が予定されている回数。予定に該当する薬のスケジュール(時刻)の件数を合計する (#278)
int scheduledDoseCountOnDate({required List<Medicine> medicines, required DateTime date}) {
  return medicines
      .where((medicine) => isMedicineScheduledOnDate(medicine: medicine, date: date))
      .fold(0, (count, medicine) => count + medicine.schedules.length);
}

/// [date] に実際に服用した回数 (#278)。
/// 取消(revert)で打ち消された記録は数えず([effectiveTakeMedicationHistories])、
/// 同じ薬・同じスケジュールに対する複数の記録は 1 回として数える
int takenDoseCountOnDate({required List<MedicationHistory> medicationHistories, required DateTime date}) {
  return effectiveTakeMedicationHistories(medicationHistories)
      .where((history) => isSameDay(history.scheduledRecordedDate, date))
      .map((history) => '${history.medicine.id}/${history.action.medicationSchedule.id}')
      .toSet()
      .length;
}

/// [date] の達成状態。予定が無い日は null を返す (#278)
DayMedicationAchievement? dayMedicationAchievement({
  required List<Medicine> medicines,
  required List<MedicationHistory> medicationHistories,
  required DateTime date,
}) {
  final scheduledCount = scheduledDoseCountOnDate(medicines: medicines, date: date);
  if (scheduledCount == 0) {
    return null;
  }
  final takenCount = _cappedTakenDoseCountOnDate(medicationHistories: medicationHistories, date: date, scheduledCount: scheduledCount);
  if (takenCount >= scheduledCount) {
    return DayMedicationAchievement.allTaken;
  }
  if (takenCount == 0) {
    return DayMedicationAchievement.noneTaken;
  }
  return DayMedicationAchievement.partiallyTaken;
}

/// [date] を含む週(日曜始まり)の服薬回数と予定回数 (#278)。
/// 予定回数は未来の曜日も含めた週全体の合計で、「今週の服薬 x/y 回」の分母になる
({int takenCount, int scheduledCount}) weeklyMedicationCounts({
  required List<Medicine> medicines,
  required List<MedicationHistory> medicationHistories,
  required DateTime date,
}) {
  return _medicationCountsInDateRange(
    medicines: medicines,
    medicationHistories: medicationHistories,
    startDate: firstDayOfWeekday(date.date()).date(),
    dayCount: 7,
  );
}

/// 予定をすべて服用できた日が [today] から何日連続しているか (#278)。
/// [today] 当日は集計途中のため、未達成でも連続を切らずに数えないだけにする。
/// 予定が無い日は連続を切らず、日数にも数えない
int consecutiveAchievedDaysCount({
  required List<Medicine> medicines,
  required List<MedicationHistory> medicationHistories,
  required DateTime today,
}) {
  final earliestBeganDate = medicines.map((medicine) => medicine.beganDateTime.date()).minOrNull;
  if (earliestBeganDate == null) {
    return 0;
  }

  var count = 0;
  final todayScheduledCount = scheduledDoseCountOnDate(medicines: medicines, date: today);
  if (todayScheduledCount > 0 &&
      _cappedTakenDoseCountOnDate(medicationHistories: medicationHistories, date: today, scheduledCount: todayScheduledCount) >=
          todayScheduledCount) {
    count += 1;
  }

  for (var offset = 1; offset <= _maxConsecutiveLookbackDays; offset++) {
    final date = today.date().addDays(-offset);
    if (date.isBefore(earliestBeganDate)) {
      break;
    }
    final scheduledCount = scheduledDoseCountOnDate(medicines: medicines, date: date);
    if (scheduledCount == 0) {
      continue;
    }
    if (_cappedTakenDoseCountOnDate(medicationHistories: medicationHistories, date: date, scheduledCount: scheduledCount) < scheduledCount) {
      break;
    }
    count += 1;
  }
  return count;
}

/// [month] の月の服薬回数と予定回数 (#278)。
/// 集計する範囲は月初から「月末と [today] のうち早い方」までで、まだ来ていない日を分母に含めて達成率を下げない。
/// [month] が [today] より後の月の場合は集計対象が無いため (0, 0) を返す
({int takenCount, int scheduledCount}) monthlyMedicationCounts({
  required List<Medicine> medicines,
  required List<MedicationHistory> medicationHistories,
  required DateTime month,
  required DateTime today,
}) {
  final firstDate = DateTime(month.year, month.month, 1);
  if (firstDate.isAfter(today.date())) {
    return (takenCount: 0, scheduledCount: 0);
  }
  final lastDateOfMonth = DateTime(month.year, month.month + 1, 0);
  return _medicationCountsInDateRange(
    medicines: medicines,
    medicationHistories: medicationHistories,
    startDate: firstDate,
    dayCount: daysBetween(firstDate, lastDateOfMonth.isAfter(today.date()) ? today.date() : lastDateOfMonth) + 1,
  );
}

/// [startDate] から [dayCount] 日分の服薬回数と予定回数の合計。
/// 服薬回数は日ごとにその日の予定回数で頭打ちにしてから合算する([_cappedTakenDoseCountOnDate])
({int takenCount, int scheduledCount}) _medicationCountsInDateRange({
  required List<Medicine> medicines,
  required List<MedicationHistory> medicationHistories,
  required DateTime startDate,
  required int dayCount,
}) {
  var takenCount = 0;
  var scheduledCount = 0;
  for (var offset = 0; offset < dayCount; offset++) {
    final date = startDate.addDays(offset);
    final scheduledCountOnDate = scheduledDoseCountOnDate(medicines: medicines, date: date);
    scheduledCount += scheduledCountOnDate;
    takenCount += _cappedTakenDoseCountOnDate(medicationHistories: medicationHistories, date: date, scheduledCount: scheduledCountOnDate);
  }
  return (takenCount: takenCount, scheduledCount: scheduledCount);
}

/// [date] の服薬回数を、その日の予定回数 [scheduledCount] で頭打ちにして返す。
/// 予定から外れた薬(停止・アーカイブ・頻度変更後)の記録が残っていても達成率が 100% を超えないようにするため
int _cappedTakenDoseCountOnDate({
  required List<MedicationHistory> medicationHistories,
  required DateTime date,
  required int scheduledCount,
}) {
  return takenDoseCountOnDate(medicationHistories: medicationHistories, date: date).clamp(0, scheduledCount);
}

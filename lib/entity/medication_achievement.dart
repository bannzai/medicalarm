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
/// それより古い日は記録が残っておらず必ず未達成と判定されてしまう。遡っても意味が無い範囲で打ち切る。
/// 履歴タブの達成サマリーが服薬記録を読む範囲(medicationAchievementLookbackDateTimeRange)もこの上限に合わせる
const maxConsecutiveLookbackDays = 365;

/// [date] の服薬記録がまだ保持期間([maxConsecutiveLookbackDays])内に残っているかどうか (#278)。
/// 保持期間を過ぎた日は薬ドキュメントから予定(分母)だけを組み立てられてしまい、実際は服用していても
/// 「記録が残っていない」だけで未服用と判定される。記録が無いことを未服用の根拠にできない範囲を除外するために使う
bool isDateWithinHistoryRetention({required DateTime date, required DateTime today}) {
  return !date.date().isBefore(today.date().addDays(-maxConsecutiveLookbackDays));
}

/// [month] の達成状況(月間達成率・日別の達成ドット)を表示してよいかどうか (#278)。
/// 過去の服薬記録の振り返りは履歴画面・日付詳細シートと同じくプレミアム加入者に限定するため、
/// 今月より前の月は加入者にだけ表示する。今月は続けている実感を非加入でも得られるように制限しない。
/// [hasPremiumEntitlement] が null (課金状態が未解決) の間も表示しない。解決が遅い・失敗した場合に
/// 制限を迂回して過去の達成状況を閲覧できてしまうため
bool canDisplayMonthlyAchievement({required DateTime month, required DateTime today, required bool? hasPremiumEntitlement}) {
  if (!DateTime(month.year, month.month).isBefore(DateTime(today.year, today.month))) {
    return true;
  }
  return hasPremiumEntitlement == true;
}

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

/// [date] に服用が予定されている「薬とスケジュール(時刻)の組」の集合 (#278)。
/// 服用記録との突き合わせに使うため、[effectiveTakeDoseKeysByDate] と同じ形式のキーで表す
Set<String> scheduledDoseKeysOnDate({required List<Medicine> medicines, required DateTime date}) {
  return medicines
      .where((medicine) => isMedicineScheduledOnDate(medicine: medicine, date: date))
      .expand((medicine) => medicine.schedules.map((schedule) => '${medicine.id}/${schedule.id}'))
      .toSet();
}

/// 有効な服用記録を、予定日([MedicationHistory.scheduledRecordedDate])ごとの服用キーの集合へ索引化する (#278)。
/// 日ごとの集計で毎回全履歴を走査し直さないための索引。
/// 取消(revert)で打ち消された記録は含めず([effectiveTakeMedicationHistories])、
/// 同じ薬・同じスケジュールに対する複数の記録は集合により 1 回として数える
Map<DateTime, Set<String>> effectiveTakeDoseKeysByDate(List<MedicationHistory> medicationHistories) {
  final doseKeysByDate = <DateTime, Set<String>>{};
  for (final history in effectiveTakeMedicationHistories(medicationHistories)) {
    doseKeysByDate
        .putIfAbsent(history.scheduledRecordedDate.date(), () => <String>{})
        .add('${history.medicine.id}/${history.action.medicationSchedule.id}');
  }
  return doseKeysByDate;
}

/// [date] の達成状態。予定が無い日は null を返す (#278)。
/// 服用記録は [effectiveTakeDoseKeysByDate] で索引化したものを受け取る。カレンダーのように 1 か月分をまとめて求める
/// 呼び出し元が、日数分だけ全履歴を走査し直さずに同じ索引を使い回せるようにするため
DayMedicationAchievement? dayMedicationAchievement({
  required List<Medicine> medicines,
  required Map<DateTime, Set<String>> takeDoseKeysByDate,
  required DateTime date,
}) {
  final scheduledDoseKeys = scheduledDoseKeysOnDate(medicines: medicines, date: date);
  if (scheduledDoseKeys.isEmpty) {
    return null;
  }
  final takenCount = _achievedDoseCountOnDate(scheduledDoseKeys: scheduledDoseKeys, takeDoseKeysByDate: takeDoseKeysByDate, date: date);
  if (takenCount >= scheduledDoseKeys.length) {
    return DayMedicationAchievement.allTaken;
  }
  if (takenCount == 0) {
    return DayMedicationAchievement.noneTaken;
  }
  return DayMedicationAchievement.partiallyTaken;
}

/// [date] を含む週(日曜始まり)の服薬回数と予定回数 (#278)。
/// 予定回数は未来の曜日も含めた週全体の合計で、「今週の服薬 x/y 回」の分母になる。
/// 服用記録は [effectiveTakeDoseKeysByDate] で索引化したものを受け取る。同じ画面で複数の集計を並べる
/// 呼び出し元が、集計ごとに全履歴を走査し直さずに同じ索引を使い回せるようにするため
({int takenCount, int scheduledCount}) weeklyMedicationCounts({
  required List<Medicine> medicines,
  required Map<DateTime, Set<String>> takeDoseKeysByDate,
  required DateTime date,
}) {
  return _medicationCountsInDateRange(
    medicines: medicines,
    takeDoseKeysByDate: takeDoseKeysByDate,
    startDate: firstDayOfWeekday(date.date()).date(),
    dayCount: 7,
  );
}

/// 予定をすべて服用できた日が [today] から何日連続しているか (#278)。
/// [today] 当日は集計途中のため、未達成でも連続を切らずに数えないだけにする。
/// 予定が無い日は連続を切らず、日数にも数えない
int consecutiveAchievedDaysCount({
  required List<Medicine> medicines,
  required Map<DateTime, Set<String>> takeDoseKeysByDate,
  required DateTime today,
}) {
  final earliestBeganDate = medicines.map((medicine) => medicine.beganDateTime.date()).minOrNull;
  if (earliestBeganDate == null) {
    return 0;
  }

  var count = 0;
  final todayScheduledDoseKeys = scheduledDoseKeysOnDate(medicines: medicines, date: today);
  if (todayScheduledDoseKeys.isNotEmpty &&
      _achievedDoseCountOnDate(scheduledDoseKeys: todayScheduledDoseKeys, takeDoseKeysByDate: takeDoseKeysByDate, date: today) >=
          todayScheduledDoseKeys.length) {
    count += 1;
  }

  for (var offset = 1; offset <= maxConsecutiveLookbackDays; offset++) {
    final date = today.date().addDays(-offset);
    if (date.isBefore(earliestBeganDate)) {
      break;
    }
    final scheduledDoseKeys = scheduledDoseKeysOnDate(medicines: medicines, date: date);
    if (scheduledDoseKeys.isEmpty) {
      continue;
    }
    if (_achievedDoseCountOnDate(scheduledDoseKeys: scheduledDoseKeys, takeDoseKeysByDate: takeDoseKeysByDate, date: date) <
        scheduledDoseKeys.length) {
      break;
    }
    count += 1;
  }
  return count;
}

/// [month] の月の服薬回数と予定回数 (#278)。
/// 集計する範囲は「月初と保持期間の開始日([isDateWithinHistoryRetention])のうち遅い方」から
/// 「月末と [today] のうち早い方」まで。まだ来ていない日を分母に含めて達成率を下げず、
/// 服薬記録が失効して残っていない日も分母・分子の両方から外す。
/// 範囲が成立しない([month] が [today] より後、または保持期間より完全に古い)場合は集計対象が無いため (0, 0) を返す
({int takenCount, int scheduledCount}) monthlyMedicationCounts({
  required List<Medicine> medicines,
  required Map<DateTime, Set<String>> takeDoseKeysByDate,
  required DateTime month,
  required DateTime today,
}) {
  final firstDate = DateTime(month.year, month.month, 1);
  final lastDateOfMonth = DateTime(month.year, month.month + 1, 0);
  final startDate = isDateWithinHistoryRetention(date: firstDate, today: today) ? firstDate : today.date().addDays(-maxConsecutiveLookbackDays);
  final endDate = lastDateOfMonth.isAfter(today.date()) ? today.date() : lastDateOfMonth;
  if (startDate.isAfter(endDate)) {
    return (takenCount: 0, scheduledCount: 0);
  }
  return _medicationCountsInDateRange(
    medicines: medicines,
    takeDoseKeysByDate: takeDoseKeysByDate,
    startDate: startDate,
    dayCount: daysBetween(startDate, endDate) + 1,
  );
}

/// [startDate] から [dayCount] 日分の服薬回数と予定回数の合計。
/// 服薬回数は日ごとにその日の予定と突き合わせてから合算する([_achievedDoseCountOnDate])
({int takenCount, int scheduledCount}) _medicationCountsInDateRange({
  required List<Medicine> medicines,
  required Map<DateTime, Set<String>> takeDoseKeysByDate,
  required DateTime startDate,
  required int dayCount,
}) {
  var takenCount = 0;
  var scheduledCount = 0;
  for (var offset = 0; offset < dayCount; offset++) {
    final date = startDate.addDays(offset);
    final scheduledDoseKeys = scheduledDoseKeysOnDate(medicines: medicines, date: date);
    scheduledCount += scheduledDoseKeys.length;
    takenCount += _achievedDoseCountOnDate(scheduledDoseKeys: scheduledDoseKeys, takeDoseKeysByDate: takeDoseKeysByDate, date: date);
  }
  return (takenCount: takenCount, scheduledCount: scheduledCount);
}

/// [date] に予定されていて、実際に服用した回数。
/// その日の予定キー [scheduledDoseKeys] と有効な服用キー([takeDoseKeysByDate])の交差だけを数える。
/// 予定から外れた薬(停止・アーカイブ・頻度変更後)の記録が、別の薬の未服用分を埋めて
/// 達成扱いになるのを防ぐため。交差は必ず予定数以下になる
int _achievedDoseCountOnDate({
  required Set<String> scheduledDoseKeys,
  required Map<DateTime, Set<String>> takeDoseKeysByDate,
  required DateTime date,
}) {
  return scheduledDoseKeys.intersection(takeDoseKeysByDate[date.date()] ?? const <String>{}).length;
}

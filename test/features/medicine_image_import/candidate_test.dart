// medicineImageImportCandidate (Functions の抽出結果 → レビューシート候補への変換) のユニットテスト。
// スケジュール数のプレミアム制限による切り捨て・時刻未抽出時の既定スケジュール・値の変換を検証する。

import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/features/medicine_image_import/import_button.dart';

void main() {
  test('抽出されたスケジュールが名前・時刻・服用量つきで変換される', () {
    final candidate = medicineImageImportCandidate(
      generatedMedicine: {
        'name': 'ロキソニン',
        'schedules': [
          {'hour': 8, 'minute': 0, 'quantityMemo': '1錠'},
          {'hour': 19, 'minute': 30, 'quantityMemo': ''},
        ],
      },
      scheduleMaxCount: 5,
    );

    expect(candidate.name, 'ロキソニン');
    expect(candidate.selected, true);
    expect(candidate.schedules.map((schedule) => schedule.toTimeString()), ['08:00', '19:30']);
    expect(candidate.schedules.first.quantityMemo, '1錠');
    expect(candidate.isScheduleTimeFallback, false);
    expect(candidate.droppedScheduleCount, 0);
  });

  test('スケジュール数が上限を超える場合は変換時に切り捨てられ、シート表示と保存内容が一致する', () {
    final candidate = medicineImageImportCandidate(
      generatedMedicine: {
        'name': 'レバミピド',
        'schedules': [
          {'hour': 8, 'minute': 0, 'quantityMemo': '1錠'},
          {'hour': 12, 'minute': 0, 'quantityMemo': '1錠'},
          {'hour': 19, 'minute': 0, 'quantityMemo': '1錠'},
        ],
      },
      // 無料ユーザーの MedicationSchedule.maxCount と同じ値
      scheduleMaxCount: 2,
    );

    expect(candidate.schedules.map((schedule) => schedule.toTimeString()), ['08:00', '12:00']);
    // 除外された件数がシートの注意書き表示に使われる
    expect(candidate.droppedScheduleCount, 1);
  });

  test('服用時刻を読み取れなかった薬はフォームの新規スケジュールと同じ 10:00 が既定になる', () {
    final candidate = medicineImageImportCandidate(
      generatedMedicine: {'name': 'ムコダイン'},
      scheduleMaxCount: 2,
    );

    expect(candidate.schedules.map((schedule) => schedule.toTimeString()), ['10:00']);
    expect(candidate.schedules.single.quantityMemo, '');
    // 仮時刻であることがシートの注意書き表示に使われる
    expect(candidate.isScheduleTimeFallback, true);
  });
}

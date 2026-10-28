import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/diary.dart';

void main() {
  group('DiaryFirestoreKey', () {
    // カレンダーの日記取得は diaryDate の範囲クエリに依存するため、
    // where 句のキーがシリアライズ結果のキーからずれると日記が一切取得できなくなる (#62)
    test('diaryDate は Diary のシリアライズ結果のキーと一致する', () {
      final diaryJson = Diary(
        id: 'diary-1',
        userID: 'user-a',
        memo: '体調は良い',
        diaryDate: DateTime(2026, 8, 10),
      ).toJson();

      expect(diaryJson.containsKey(DiaryFirestoreKey.diaryDate), isTrue);
    });
  });
}

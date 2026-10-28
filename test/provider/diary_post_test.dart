import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'diary_post_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GroupDatabase>(),
  MockSpec<DocumentReference<Diary>>(as: #MockDiaryDocumentReference),
])
void main() {
  late MockGroupDatabase database;
  late MockDiaryDocumentReference documentReference;
  late DiaryPost diaryPost;

  setUp(() {
    database = MockGroupDatabase();
    documentReference = MockDiaryDocumentReference();
    when(database.diaryReference(diaryID: anyNamed('diaryID'))).thenReturn(documentReference);
    when(documentReference.id).thenReturn('generated-diary-id');
    when(documentReference.set(any, any)).thenAnswer((_) async {});
    diaryPost = DiaryPost(database: database, userID: 'user-a');
  });

  group('DiaryPost', () {
    test('新規作成では入力した memo と diaryDate を持つ Diary を保存する', () async {
      final savedDiary = await diaryPost.call(
        diary: null,
        memo: '体調は良い',
        diaryDate: DateTime(2026, 8, 10),
      );

      expect(savedDiary.id, 'generated-diary-id');
      expect(savedDiary.userID, 'user-a');
      expect(savedDiary.memo, '体調は良い');
      expect(savedDiary.diaryDate, DateTime(2026, 8, 10));
      expect(verify(documentReference.set(captureAny, any)).captured.single, savedDiary);
    });

    // 複数メンバーが同じ日の空の日記を同時に作成しても 1 ドキュメントに収束する(重複日記の防止)
    test('新規作成では日付から決定したドキュメント ID を使う', () async {
      await diaryPost.call(
        diary: null,
        memo: '体調は良い',
        diaryDate: DateTime(2026, 8, 10),
      );

      verify(database.diaryReference(diaryID: 'diary-20260810'));
    });

    test('既存日記の保存は既存のドキュメント ID を使い続ける', () async {
      await diaryPost.call(
        diary: Diary(id: 'legacy-auto-id', userID: 'user-a', memo: '編集前', diaryDate: DateTime(2026, 8, 10)),
        memo: '編集後',
        diaryDate: DateTime(2026, 8, 10),
      );

      verify(database.diaryReference(diaryID: 'legacy-auto-id'));
    });

    // 既存日記をそのまま書き戻して編集内容が失われる退行を防ぐ (#62)
    test('既存日記の編集では入力した memo を反映して保存する', () async {
      final storedDiary = Diary(
        id: 'diary-1',
        userID: 'user-a',
        memo: '編集前のメモ',
        diaryDate: DateTime(2026, 8, 10),
      );

      final savedDiary = await diaryPost.call(
        diary: storedDiary,
        memo: '編集後のメモ',
        diaryDate: DateTime(2026, 8, 10),
      );

      expect(savedDiary.id, 'diary-1');
      expect(savedDiary.memo, '編集後のメモ');
      expect(savedDiary.diaryDate, DateTime(2026, 8, 10));
      expect(verify(documentReference.set(captureAny, any)).captured.single, savedDiary);
    });
  });
}

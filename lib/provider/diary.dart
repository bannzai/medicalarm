import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary.g.dart';

@Riverpod(dependencies: [currentGroupDatabase])
Stream<List<Diary>> diariesForDateTimeRange(DiariesForDateTimeRangeRef ref, {required DateTimeRange dateTimeRange}) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return database
      .diariesReference()
      .where(
        DiaryFirestoreKey.diaryDate,
        isGreaterThanOrEqualTo: dateTimeRange.start,
        isLessThanOrEqualTo: dateTimeRange.end,
      )
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).toList())
      .map((diaries) => _sortedDiaries(diaries));
}

class DiaryPost {
  final GroupDatabase database;
  // 作成者(creator)の uid。Diary.userID に設定する。
  final String userID;

  DiaryPost({required this.database, required this.userID});

  Future<Diary> call({
    required Diary? diary,
    required String memo,
    required DateTime diaryDate,
  }) async {
    final docRef = database.diaryReference(diaryID: diary?.id);
    // 既存日記の編集時も入力された memo を反映する。diary をそのまま書き戻すと編集内容が保存されない
    final newDiary = diary?.copyWith(memo: memo) ??
        Diary(
          id: docRef.id,
          userID: userID,
          memo: memo,
          diaryDate: diaryDate,
        );

    await docRef.set(newDiary, SetOptions(merge: true));
    return newDiary;
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
DiaryPost diaryPost(DiaryPostRef ref) {
  return DiaryPost(database: ref.watch(currentGroupDatabaseProvider), userID: ref.watch(appUserIDProvider));
}

int _sortDiary(Diary a, Diary b) => a.diaryDate.compareTo(b.diaryDate);
List<Diary> _sortedDiaries(List<Diary> diaries) {
  diaries.sort(_sortDiary);
  return diaries;
}

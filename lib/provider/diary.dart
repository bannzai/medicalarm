import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<List<Diary>> diariesForDateTimeRange(DiariesForDateTimeRangeRef ref, {required DateTimeRange dateTimeRange}) {
  final database = ref.watch(userDatabaseProvider);
  return database
      .diariesReference()
      .where(
        DiaryFirestoreKey.date,
        isGreaterThanOrEqualTo: dateTimeRange.start,
        isLessThanOrEqualTo: dateTimeRange.end,
      )
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).toList())
      .map((diaries) => _sortedDiaries(diaries));
}

class DiaryPost {
  final UserDatabase database;

  DiaryPost(this.database);

  Future<Diary> call({
    required Diary? diary,
    required List<String> tags,
    required List<DiaryMemo> memos,
    required String memo,
    required DateTime diaryDate,
  }) async {
    final docRef = database.diaryReference(diaryID: diary?.id);
    final newDiary = diary ??
        Diary(
          id: docRef.id,
          userID: database.userID,
          tags: tags,
          memos: memos,
          memo: memo,
          diaryDate: diaryDate,
        );

    await docRef.set(newDiary, SetOptions(merge: true));
    return newDiary;
  }
}

@Riverpod(dependencies: [userDatabase])
Future<DiaryPost> diaryPost(DiaryPostRef ref) async {
  final database = ref.watch(userDatabaseProvider);
  return DiaryPost(database);
}

int _sortDiary(Diary a, Diary b) => a.diaryDate.compareTo(b.diaryDate);
List<Diary> _sortedDiaries(List<Diary> diaries) {
  diaries.sort(_sortDiary);
  return diaries;
}

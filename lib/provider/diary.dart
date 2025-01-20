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

int _sortDiary(Diary a, Diary b) => a.diaryDate.compareTo(b.diaryDate);
List<Diary> _sortedDiaries(List<Diary> diaries) {
  diaries.sort(_sortDiary);
  return diaries;
}

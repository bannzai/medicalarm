// import 'package:medicalarm/entity/diary_setting.dart';
// import 'package:medicalarm/features/resolver/database.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'diary_setting.g.dart';

// [DiarySetting:WIP] 服用者ごとのタグをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
// @Riverpod(dependencies: [userDatabase])
// Stream<DiarySetting> diarySetting(DiarySettingRef ref) {
//   final database = ref.watch(userDatabaseProvider);
//   return database.diarySettingReference().snapshots().map((event) => event.data()!);
// }

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_create.g.dart';

/// サーバー側で作成数上限チェックを行った上でグループを作成する。
class CreateGroup {
  /// [iconName] は home / family / hospital / medication / elderly / favorite のいずれか。
  /// 戻り値は作成されたグループの ID。
  Future<String> call({
    required String? name,
    required bool setAsDefault,
    required String iconName,
  }) {
    return functions.createGroup(name: name, setAsDefault: setAsDefault, iconName: iconName);
  }
}

@riverpod
CreateGroup createGroup(Ref ref) {
  return CreateGroup();
}

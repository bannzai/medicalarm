import 'package:cloud_functions/cloud_functions.dart';

final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

extension FirebaseFunctionsExt on FirebaseFunctions {
  Future<bool> startPromotion({required int promotionDayCount}) async {
    final result = await httpsCallable('startPromotion').call(
      {
        'promotionDayCount': promotionDayCount,
      },
    );
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return response['data']['isAlreadyExist'] as bool;
  }

  // グループを作成する。auth uid をサーバー側で使用するため createUserID は渡さない。
  // iconName は home / family / hospital / medication / elderly / favorite のいずれか。戻り値は作成されたグループの ID。
  Future<String> createGroup({required String? name, required bool setAsDefault, required String iconName}) async {
    final result = await httpsCallable('createGroup').call({
      'name': name,
      'setAsDefault': setAsDefault,
      'iconName': iconName,
    });
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return response['data']['groupID'] as String;
  }

  // 招待コードと有効期限を発行する。expiresDateTime は Functions が ISO8601 文字列で返す。
  Future<({String invitationCode, DateTime expiresDateTime})> createGroupInvitation({required String groupID}) async {
    final result = await httpsCallable('createGroupInvitation').call({'groupID': groupID});
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return (
      invitationCode: response['data']['invitationCode'] as String,
      expiresDateTime: DateTime.parse(response['data']['expiresDateTime'] as String),
    );
  }

  // 服薬記録を追加した際に、同じグループの他メンバーへ FCM push 通知を送る。
  // 記録者の表示名はサーバー側が userProfiles から解決するため渡さない。送信失敗は記録の成否に影響させないため、
  // 呼び出し側は unawaited で呼び catch する。ソログループなど送信対象 0 件の場合はサーバー側でスキップされる。
  Future<void> sendMedicationRecordNotification({
    required String groupID,
    required String medicineID,
    required String medicineName,
    required String doseReceiverName,
  }) async {
    final result = await httpsCallable('sendMedicationRecordNotification').call({
      'groupID': groupID,
      'medicineID': medicineID,
      'medicineName': medicineName,
      'doseReceiverName': doseReceiverName,
    });
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
  }

  // 招待コードを使ってグループに参加する。戻り値は参加したグループの ID。
  Future<String> acceptGroupInvitation({required String invitationCode}) async {
    final result = await httpsCallable('acceptGroupInvitation').call({'invitationCode': invitationCode});
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return response['data']['groupID'] as String;
  }
}

// Map<String, dynamic>.fromだけだとネストした子要素が_Map<Object? Object?>のままになる
// 以下のエラーを回避する _TypeError (type '_Map<Object?, Object?>' is not a subtype of type 'Map<String, dynamic>' in type cast)
Map<String, dynamic> mapToJSON(Map<dynamic, dynamic> map) {
  for (var key in map.keys) {
    if (map[key] is Map) {
      map[key] = mapToJSON(map[key]);
    } else if (map[key] is List) {
      map[key] = map[key].map((e) {
        if (e is Map) {
          return mapToJSON(e);
        }
        return e;
      }).toList();
    }
  }
  return Map<String, dynamic>.from(map);
}

import 'package:cloud_functions/cloud_functions.dart';

final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

extension FirebaseFunctionsExt on FirebaseFunctions {
  Future<bool> startPromotion({required int promotionDayCount}) async {
    final result = await httpsCallable('startPromotion').call({'promotionDayCount': promotionDayCount});
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return response['data']['isAlreadyExist'] as bool;
  }

  // グループを作成する。auth uid をサーバー側で使用するため createUserID は渡さない。
  // iconName は home / family / hospital / medication / elderly / favorite のいずれか。戻り値は作成されたグループの ID。
  Future<String> createGroup({required String? name, required bool setAsDefault, required String iconName}) async {
    final result = await httpsCallable('createGroup').call({'name': name, 'setAsDefault': setAsDefault, 'iconName': iconName});
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
  // push 本文(薬名・記録者の表示名)はサーバー側が groupID / medicineID から解決するため渡さない。
  // medicationHistoryID はサーバー側が「実際に書かれた履歴」を検証するために渡す。
  // 送信失敗は記録の成否に影響させないため、呼び出し側は unawaited で呼び catch する。
  // ソログループなど送信対象 0 件の場合はサーバー側でスキップされる。
  Future<void> sendMedicationRecordNotification({required String groupID, required String medicineID, required String medicationHistoryID}) async {
    final result = await httpsCallable(
      'sendMedicationRecordNotification',
    ).call({'groupID': groupID, 'medicineID': medicineID, 'medicationHistoryID': medicationHistoryID});
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

  // グループからメンバーを削除する。オーナーのみが実行でき、オーナー自身は削除できない。冪等（既に非メンバーなら何もしない）。
  Future<void> removeGroupMember({required String groupID, required String targetUserID}) async {
    final result = await httpsCallable('removeGroupMember').call({'groupID': groupID, 'targetUserID': targetUserID});
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
  }

  // 画像(お薬手帳・処方箋・薬袋など)から薬の登録候補を抽出する。
  // 戻り値は薬ごとの { name: String, schedules: [{ hour, minute, quantityMemo }] } の Map。
  // 抽出結果は保存前にユーザーがレビューシートで取捨選択するため、entity には変換せずそのまま返す。
  // 月間利用回数の上限(無料/プレミアム)を超えた場合はサーバーがエラーメッセージを返す。
  Future<List<Map<String, dynamic>>> generateMedicinesFromImage({required String mimeType, required String base64Image}) async {
    final result = await httpsCallable('generateMedicinesFromImage').call({'mimeType': mimeType, 'base64Image': base64Image});
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return (response['data']['medicines'] as List<dynamic>).cast<Map<String, dynamic>>();
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

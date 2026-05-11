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

  /// 機能要望を Cloud Functions (submitFeatureRequest) 経由で Slack に通知する。
  /// emailAddress は任意。空文字は呼び出し側で null に正規化してから渡す。
  Future<void> submitFeatureRequest({
    required String content,
    required String? emailAddress,
    required String appVersion,
    required String platform,
  }) async {
    final result = await httpsCallable('submitFeatureRequest').call({
      'content': content,
      if (emailAddress != null && emailAddress.isNotEmpty) 'emailAddress': emailAddress,
      'appVersion': appVersion,
      'platform': platform,
    });
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
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

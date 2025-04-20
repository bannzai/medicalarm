import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:replai/entity/chat_message.dart';
import 'package:replai/entity/chat_partner.dart';
import 'package:replai/features/chat_messages/components/image_picker_button.dart';
import 'package:replai/features/chat_partner_form/components/image_picker_button.dart';

// GenKitがus-central1のサポートになるt a
final functions = FirebaseFunctions.instanceFor(region: 'us-central1');

extension FirebaseFunctionsExt on FirebaseFunctions {
  Future<String> chatReview({required UserChatMessage userChatMessage}) async {
    final result = await httpsCallable('chatReview').call(
      {
        "userChatMessage": {
          'id': userChatMessage.id,
          'chatPartnerID': userChatMessage.chatPartnerID,
        },
      },
    );
    debugPrint("chatReview.result: ${result.data}");
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return response['data']['review'] as String;
  }

  Future<String> generateReply({required ChatPartner chatPartner}) async {
    final result = await httpsCallable('generateReply').call(
      {
        "chatPartner": {
          'id': chatPartner.id,
          'nationality': chatPartner.nationality,
          'biography': chatPartner.biography,
          'relationshipDetails': chatPartner.relationshipDetails,
        },
      },
    );
    debugPrint("generateReply.result: ${result.data}");
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return response['data']['reply'] as String;
  }

  Future<ChatPartnerFormInfo> generateChatPartnerFormFromImage({required String mimeType, required String base64Image}) async {
    final result = await httpsCallable('generateChatPartnerFormFromImage').call(
      {
        "mimeType": mimeType,
        "base64Image": base64Image,
      },
    );
    final response = mapToJSON(result.data);

    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }

    return ChatPartnerFormInfo(
      name: response['data']['name'] as String,
      biography: response['data']['biography'] as String,
      relationshipDetails: response['data']['relationshipDetails'] as String,
    );
  }

  Future<List<ChatMessageFormFromImage>> generateChatMessagesFromImage({required String mimeType, required String base64Image}) async {
    final result = await httpsCallable('generateChatMessagesFromImage').call(
      {
        "mimeType": mimeType,
        "base64Image": base64Image,
      },
    );
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }

    final chatMessages = response['data']['chatMessages'] as List<dynamic>;
    return chatMessages.map((e) {
      return ChatMessageFormFromImage(
        isRight: e['isRight'] as bool,
        message: e['message'] as String,
      );
    }).toList();
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

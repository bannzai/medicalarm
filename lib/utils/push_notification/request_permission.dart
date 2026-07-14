import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_permission.g.dart';

Future<void> requestNotificationPermissions(RegisterRemotePushNotificationToken registerRemotePushNotificationToken) async {
  // requestPermission は Android 13+(API 33+)で POST_NOTIFICATIONS の実行時許可ダイアログを出し、
  // API 33 未満はダイアログなしで authorized を返すため iOS/Android 共通で呼ぶ(firebase_messaging プラグインの実装で確認済み)。
  await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);

  // 前景表示オプション・APNs トークン取得・iOSローカル通知許可は iOS 固有(localNotificationService.requestPermission は iOS 実装のみを解決する)。
  String? apnsToken;
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await localNotificationService.requestPermission();
    apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  }

  // FCM トークンの登録は iOS/Android 共通で行い、Android メンバーにもグループの服薬記録 push が届くようにする。
  // SimulatorではFCMトークンが取得できないため、デバッグモードでは取得しない。次のリンクのやり方を参考。https://github.com/firebase/flutterfire/issues/13575
  if (kDebugMode) {
    // デバッグモードではFCMトークンを'debug_mode'として登録する
    registerRemotePushNotificationToken(fcmToken: 'debug_mode', apnsToken: apnsToken);
  } else {
    // 本番モードではFCMトークンを取得する
    final fcmToken = await FirebaseMessaging.instance.getToken();
    registerRemotePushNotificationToken(fcmToken: fcmToken, apnsToken: apnsToken);
  }
}

class RegisterRemotePushNotificationToken {
  final UserDatabase database;

  RegisterRemotePushNotificationToken(this.database);

  Future<void> call({required String? fcmToken, required String? apnsToken}) {
    return database.userPrivateRawReference().set(
      {
        'fcmToken': fcmToken,
        'apnsToken': apnsToken,
        // グループ内の複数端末へ push するため、Functions は fcmTokens[] を参照する。arrayUnion で重複なく追記する。
        if (fcmToken != null) 'fcmTokens': FieldValue.arrayUnion([fcmToken]),
      },
      SetOptions(merge: true),
    );
  }
}

@Riverpod(dependencies: [userDatabase])
RegisterRemotePushNotificationToken registerRemotePushNotificationToken(RegisterRemotePushNotificationTokenRef ref) =>
    RegisterRemotePushNotificationToken(ref.watch(userDatabaseProvider));

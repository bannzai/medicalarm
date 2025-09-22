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
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, announcement: true);
    await localNotificationService.requestPermission();
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
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
}

class RegisterRemotePushNotificationToken {
  final UserDatabase database;

  RegisterRemotePushNotificationToken(this.database);

  Future<void> call({required String? fcmToken, required String? apnsToken}) {
    return database.userPrivateRawReference().set(
      {'fcmToken': fcmToken, 'apnsToken': apnsToken},
      SetOptions(merge: true),
    );
  }
}

@Riverpod(dependencies: [userDatabase])
RegisterRemotePushNotificationToken registerRemotePushNotificationToken(RegisterRemotePushNotificationTokenRef ref) =>
    RegisterRemotePushNotificationToken(ref.watch(userDatabaseProvider));

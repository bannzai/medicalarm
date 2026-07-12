import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// フォアグラウンドで受信した FCM 通知を SnackBar 表示するための ScaffoldMessenger キー。
/// [MaterialApp.scaffoldMessengerKey] に設定して、任意の画面(モーダル含む)の上に SnackBar を出す。
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// FCM 通知の受信ハンドリングを初期化する。アプリ起動後に一度だけ [initialize] を呼び出す。
///
/// フォアグラウンド受信時のみを扱う薄いハンドラ。バックグラウンド/バックグラウンド復帰時の表示は
/// OS 標準の通知バナーに委ねる。
class FcmNotificationHandler {
  bool _isInitialized = false;

  void initialize() {
    // onMessage.listen の多重登録を避けるため冪等にする
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) {
        return;
      }
      final body = notification.body;
      if (body == null || body.isEmpty) {
        return;
      }
      // MaterialApp がまだマウントされていない場合(currentState == null)は表示をスキップする
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.title != null && notification.title!.isNotEmpty) ...[
                Text(notification.title!, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
              Text(body),
            ],
          ),
        ),
      );
    });
  }
}

final fcmNotificationHandler = FcmNotificationHandler();

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// app_links の EventChannel を、テストから URL を流せるストリームに差し替える。
/// Focus Connect の戻りを受ける widget (服薬の一覧の行・通知設定の画面) は描画時にこの EventChannel を購読し、
/// テストにはプラグインの実装が無いため、差し替えないと MissingPluginException でテストが失敗する。
/// 返す関数は、アプリが [uri] で開かれた時と同じく購読中の widget へ [uri] を届ける。購読が無い間に呼んだ分は捨てる。
void Function(String uri) mockAppLinksEventChannel() {
  MockStreamHandlerEventSink? eventSink;
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockStreamHandler(
    const EventChannel('com.llfbandit.app_links/events'),
    MockStreamHandler.inline(
      onListen: (arguments, events) {
        eventSink = events;
      },
      onCancel: (arguments) {
        eventSink = null;
      },
    ),
  );
  return (uri) => eventSink?.success(uri);
}

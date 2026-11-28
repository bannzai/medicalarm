import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// 開いた URL を記録し、実際には開かない [UrlLauncherPlatform]。Focus を開く URL をテストで取り出すために使う。
/// どの URL も開けるものとして答える
class RecordingUrlLauncherPlatform extends UrlLauncherPlatform with MockPlatformInterfaceMixin {
  /// [launchUrl] に渡された URL。開いた順に並ぶ
  final launchedURLs = <String>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedURLs.add(url);
    return true;
  }
}

/// テストの間だけ url_launcher の実装を [RecordingUrlLauncherPlatform] に差し替え、差し替えた実装を返す。
/// テストの終わりに元の実装へ戻す。setUp かテストの本体から呼ぶ
RecordingUrlLauncherPlatform useRecordingUrlLauncherPlatform() {
  final originalUrlLauncherPlatform = UrlLauncherPlatform.instance;
  final recordingUrlLauncherPlatform = RecordingUrlLauncherPlatform();
  UrlLauncherPlatform.instance = recordingUrlLauncherPlatform;
  addTearDown(() => UrlLauncherPlatform.instance = originalUrlLauncherPlatform);
  return recordingUrlLauncherPlatform;
}

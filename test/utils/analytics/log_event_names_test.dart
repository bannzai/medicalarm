import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// lib 配下のソースから `analytics.logEvent(name: '...')` の文字列リテラルを抽出する。
/// 文字列補間(`$`)を含む動的な name (例: 'screen_$screenName') は対象外とする。
List<({String name, String path})> collectLogEventNames() {
  final pattern = RegExp(r"logEvent\(\s*name:\s*'([^']+)'");
  return Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart') && !file.path.endsWith('.g.dart') && !file.path.endsWith('.freezed.dart'))
      .expand((file) => pattern
          .allMatches(file.readAsStringSync())
          .map((match) => (name: match.group(1)!, path: file.path))
          .where((entry) => !entry.name.contains(r'$')))
      .toList();
}

void main() {
  // Firebase Analytics のイベント名制約(issue #61): 40 文字以内・イベント名は一意にする
  group('analytics.logEvent のイベント名', () {
    test('全イベント名が 40 文字以内(Firebase Analytics の制限)', () {
      final tooLongNames = collectLogEventNames().where((entry) => entry.name.length > 40).toList();
      expect(tooLongNames, isEmpty, reason: '40 文字を超えるイベント名: $tooLongNames');
    });

    test('イベント名が lib 全体で一意', () {
      final entries = collectLogEventNames();
      final duplicatedNames = entries
          .map((entry) => entry.name)
          .where((name) => entries.where((entry) => entry.name == name).length > 1)
          .toSet();
      expect(duplicatedNames, isEmpty,
          reason: '重複しているイベント名: ${entries.where((entry) => duplicatedNames.contains(entry.name)).toList()}');
    });

    test('イベント名が 1 件以上抽出できている(抽出ロジックの自己検証)', () {
      expect(collectLogEventNames(), isNotEmpty);
    });
  });
}

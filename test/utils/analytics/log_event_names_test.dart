import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// [source] 中の [openParenIndex] (`logEvent(` の `(` の位置) から、対応する閉じ括弧までの引数文字列を返す。
/// 文字列リテラル内の括弧を数えないよう、シングルクオート区間は読み飛ばす。
String extractArgumentSource({required String source, required int openParenIndex}) {
  var depth = 0;
  var isInString = false;
  for (var index = openParenIndex; index < source.length; index++) {
    final char = source[index];
    if (isInString) {
      if (char == r'\') {
        index++;
      } else if (char == "'") {
        isInString = false;
      }
      continue;
    }
    switch (char) {
      case "'":
        isInString = true;
      case '(':
        depth++;
      case ')':
        depth--;
        if (depth == 0) {
          return source.substring(openParenIndex + 1, index);
        }
    }
  }
  return source.substring(openParenIndex + 1);
}

/// lib 配下のソースから `analytics.logEvent` 呼び出しの `name:` 文字列リテラルを抽出する。
/// 名前付き引数の順序に依存しないよう、括弧の対応で引数領域を切り出してから `name:` を探す。
/// 文字列補間(`$`)を含む動的な name (例: 'screen_$screenName') と、リテラルでない name は対象外とする。
List<({String name, String path})> collectLogEventNames() {
  final namePattern = RegExp(r"name:\s*'([^']+)'");
  return Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart') && !file.path.endsWith('.g.dart') && !file.path.endsWith('.freezed.dart'))
      .expand((file) {
        final source = file.readAsStringSync();
        return RegExp(r'logEvent\(').allMatches(source).map((match) {
          final name = namePattern.firstMatch(extractArgumentSource(source: source, openParenIndex: match.end - 1))?.group(1);
          return name == null ? null : (name: name, path: file.path);
        });
      })
      .nonNulls
      .where((entry) => !entry.name.contains(r'$'))
      .toList();
}

void main() {
  group('extractArgumentSource', () {
    test('name が第 2 引数でも引数領域に含まれる', () {
      const source = "logEvent(parameters: {'key': 'value'}, name: 'second_arg_name');";
      expect(extractArgumentSource(source: source, openParenIndex: source.indexOf('(')), contains("name: 'second_arg_name'"));
    });

    test('文字列リテラル内の括弧で引数領域が途切れない', () {
      const source = "logEvent(name: 'with_paren', parameters: {'msg': 'foo)bar'}); other();";
      expect(extractArgumentSource(source: source, openParenIndex: source.indexOf('(')), contains("'foo)bar'"));
      expect(extractArgumentSource(source: source, openParenIndex: source.indexOf('(')), isNot(contains('other')));
    });
  });

  // Firebase Analytics のイベント名制約(issue #61): 40 文字以内・イベント名は一意にする
  group('analytics.logEvent のイベント名', () {
    test('全イベント名が 40 文字以内(Firebase Analytics の制限)', () {
      final tooLongNames = collectLogEventNames().where((entry) => entry.name.length > 40).toList();
      expect(tooLongNames, isEmpty, reason: '40 文字を超えるイベント名: $tooLongNames');
    });

    test('イベント名が lib 全体で一意', () {
      final entries = collectLogEventNames();
      final duplicatedNames = entries.map((entry) => entry.name).where((name) => entries.where((entry) => entry.name == name).length > 1).toSet();
      expect(duplicatedNames, isEmpty, reason: '重複しているイベント名: ${entries.where((entry) => duplicatedNames.contains(entry.name)).toList()}');
    });

    test('イベント名が 1 件以上抽出できている(抽出ロジックの自己検証)', () {
      expect(collectLogEventNames(), isNotEmpty);
    });
  });
}

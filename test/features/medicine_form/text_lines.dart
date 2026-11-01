import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// [text] の各行が、[text] を空白で区切った単語だけでできていること (単語の途中で折り返されていないこと) を検証する。
void expectWrappedAtWordBoundaries(WidgetTester tester, {required String text}) {
  final words = text.split(' ');
  for (final lineText in lineTexts(tester, text: text)) {
    expect(lineText.trim().split(' ').every(words.contains), isTrue, reason: '「$lineText」の行で単語が途中で折り返されている');
  }
}

/// [text] を表示している Text の、各行の文字列。文字ごとの描画位置の top が変わった所を行の境目とする。
List<String> lineTexts(WidgetTester tester, {required String text}) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  final lineTexts = <String>[];
  double? lineTop;
  for (var index = 0; index < text.length; index++) {
    final boxes = paragraph.getBoxesForSelection(TextSelection(baseOffset: index, extentOffset: index + 1));
    // 行末の空白は幅を持たず box が返らないことがあるため、直前の行に含める
    if (boxes.isEmpty || boxes.first.top == lineTop) {
      lineTexts.last += text[index];
      continue;
    }
    lineTop = boxes.first.top;
    lineTexts.add(text[index]);
  }
  return lineTexts;
}

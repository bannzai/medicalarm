import 'dart:math';

String randomEmoji() {
  final elements = emojis();
  return elements[Random().nextInt(elements.length - 1)];
}

List<String> emojis() {
  return _range().map((e) => String.fromCharCode(e)).toList();
}

Iterable<int> _range() sync* {
  const start = 0x1F601;
  const stop = 0x1F64F;

  for (int value = start; value < stop; value += 1) {
    yield value;
  }
}

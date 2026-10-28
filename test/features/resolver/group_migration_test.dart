import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/features/resolver/group_migration.dart';

void main() {
  // WriteBatch(最大 500 件)へ分割する純粋関数を検証する。
  group('chunkList', () {
    test('空リストは空の結果になる', () {
      expect(chunkList<int>([], size: 500), isEmpty);
    });

    test('上限ちょうどは 1 チャンクになる', () {
      final chunks = chunkList(List.generate(500, (i) => i), size: 500);
      expect(chunks, hasLength(1));
      expect(chunks.first, hasLength(500));
    });

    test('上限+1 は 500 と 1 の 2 チャンクに分割される', () {
      final chunks = chunkList(List.generate(501, (i) => i), size: 500);
      expect(chunks, hasLength(2));
      expect(chunks[0], hasLength(500));
      expect(chunks[1], hasLength(1));
    });

    test('分割しても全要素が順序どおり保存される', () {
      final source = List.generate(1250, (i) => i);
      final chunks = chunkList(source, size: 500);
      expect(chunks.map((c) => c.length).toList(), [500, 500, 250]);
      expect(chunks.expand((c) => c).toList(), source);
    });

    test('小さい size でも境界が正しい', () {
      expect(chunkList([1, 2, 3, 4, 5], size: 2), [
        [1, 2],
        [3, 4],
        [5],
      ]);
    });
  });
}

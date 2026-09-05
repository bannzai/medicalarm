import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/avatar/dose_receiver_avatar.dart';
import 'package:medicalarm/entity/dose_receiver.dart';

DoseReceiver buildDoseReceiver({required String id, required String name}) {
  return DoseReceiver(id: id, userID: 'user-a', name: name);
}

void main() {
  // 識別色は DoseReceiver.id から決定的に決まる。全画面で同じ服用者が同じ色になることが前提 (#277)
  group('doseReceiverIdentificationColor', () {
    test('同じ ID からは常に同じ色が返る', () {
      expect(doseReceiverIdentificationColor(doseReceiverID: 'dose-receiver-1'), doseReceiverIdentificationColor(doseReceiverID: 'dose-receiver-1'));
      expect(
        doseReceiverIdentificationColor(doseReceiverID: DoseReceiver.firstUserID),
        doseReceiverIdentificationColor(doseReceiverID: DoseReceiver.firstUserID),
      );
    });

    test('戻り値はパレットの6色のいずれかになる', () {
      const palette = [Color(0xFF4678C8), Color(0xFFB96A4A), Color(0xFF3E8B85), Color(0xFF8B6BB5), Color(0xFF55885C), Color(0xFFB05C86)];
      for (final doseReceiverID in ['firstUser', 'dose-receiver-1', 'dose-receiver-2', '', 'あいうえお', '0123456789abcdef']) {
        expect(palette, contains(doseReceiverIdentificationColor(doseReceiverID: doseReceiverID)));
      }
    });

    test('代表的な ID の色が固定値として決まる(実行環境に依らない安定ハッシュ)', () {
      // String.hashCode に依存しないコード単位の畳み込みのため、期待値を固定値で確認できる
      expect(doseReceiverIdentificationColor(doseReceiverID: 'firstUser'), const Color(0xFFB96A4A));
      expect(doseReceiverIdentificationColor(doseReceiverID: 'dose-receiver-1'), const Color(0xFFB96A4A));
      expect(doseReceiverIdentificationColor(doseReceiverID: 'dose-receiver-2'), const Color(0xFF3E8B85));
    });

    test('異なる ID には異なる色が割り当てられうる', () {
      expect(doseReceiverIdentificationColor(doseReceiverID: 'firstUser'), isNot(doseReceiverIdentificationColor(doseReceiverID: 'dose-receiver-2')));
    });
  });

  group('DoseReceiverAvatar', () {
    Future<void> pumpAvatar(WidgetTester tester, {required DoseReceiver doseReceiver, required double size}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoseReceiverAvatar(doseReceiver: doseReceiver, size: size),
          ),
        ),
      );
    }

    testWidgets('服用者名の先頭1文字が白の bold で表示される', (tester) async {
      await pumpAvatar(
        tester,
        doseReceiver: buildDoseReceiver(id: 'dose-receiver-1', name: 'ママ'),
        size: 32,
      );

      expect(find.text('マ'), findsOneWidget);
      final textStyle = tester.widget<Text>(find.text('マ')).style!;
      expect(textStyle.color, Colors.white);
      expect(textStyle.fontWeight, FontWeight.bold);
      // デザインモックの比率 (32px アバターに fontSize 15)
      expect(textStyle.fontSize, 15);
    });

    testWidgets('背景色が doseReceiverIdentificationColor と一致し、円形で描画される', (tester) async {
      await pumpAvatar(
        tester,
        doseReceiver: buildDoseReceiver(id: 'dose-receiver-1', name: 'ママ'),
        size: 28,
      );

      final decoration =
          tester.widget<Container>(find.descendant(of: find.byType(DoseReceiverAvatar), matching: find.byType(Container))).decoration!
              as BoxDecoration;
      expect(decoration.color, doseReceiverIdentificationColor(doseReceiverID: 'dose-receiver-1'));
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('名前が空文字でも例外にならず、文字なしで描画される', (tester) async {
      await pumpAvatar(
        tester,
        doseReceiver: buildDoseReceiver(id: 'dose-receiver-1', name: ''),
        size: 32,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DoseReceiverAvatar), findsOneWidget);
      expect(tester.widget<Text>(find.descendant(of: find.byType(DoseReceiverAvatar), matching: find.byType(Text))).data, '');
    });

    testWidgets('サロゲートペア(絵文字)の名前でも先頭1文字が壊れずに表示される', (tester) async {
      await pumpAvatar(
        tester,
        doseReceiver: buildDoseReceiver(id: 'dose-receiver-1', name: '👨‍👩‍👧 パパ'),
        size: 32,
      );

      expect(tester.takeException(), isNull);
      expect(tester.widget<Text>(find.descendant(of: find.byType(DoseReceiverAvatar), matching: find.byType(Text))).data, '👨‍👩‍👧');
    });
  });
}

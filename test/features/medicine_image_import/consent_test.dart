// generateMedicinesFromImageAfterConsent のウィジェットテスト (#548)。
// 外部の AI に画像を送る前の確認ダイアログで「送信」を選んだ時だけ generateMedicinesFromImage が呼ばれることを検証する。

import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_image_import/import_button.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'consent_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseFunctions>(), MockSpec<HttpsCallable>(), MockSpec<HttpsCallableResult<dynamic>>()])
void main() {
  late MockFirebaseFunctions firebaseFunctions;
  late MockHttpsCallable httpsCallable;
  late MockHttpsCallableResult httpsCallableResult;
  late Directory temporaryDirectory;
  late File imageFile;

  setUp(() async {
    firebaseFunctions = MockFirebaseFunctions();
    httpsCallable = MockHttpsCallable();
    httpsCallableResult = MockHttpsCallableResult();
    when(firebaseFunctions.httpsCallable(any)).thenReturn(httpsCallable);
    when(httpsCallable.call(any)).thenAnswer((_) async => httpsCallableResult);
    // mapToJSON が Map を書き換えるため、呼び出しごとに新しい Map を返す。
    // 型は実機の cloud_functions が返す Map<Object?, Object?> に合わせる (推論された型のままだと mapToJSON の書き換えで型エラーになる)
    when(httpsCallableResult.data).thenAnswer(
      (_) => <Object?, Object?>{
        'result': 'OK',
        'data': <Object?, Object?>{
          'medicines': <Object?>[
            <Object?, Object?>{'name': 'ロキソニン', 'schedules': <Object?>[]},
          ],
        },
      },
    );
    temporaryDirectory = Directory.systemTemp.createTempSync('consent_test');
    // base64CompressImage が実際にデコードできる画像を用意する
    imageFile = File('${temporaryDirectory.path}/image.png')..writeAsBytesSync(img.encodePng(img.Image(width: 4, height: 4)));
  });

  tearDown(() {
    temporaryDirectory.deleteSync(recursive: true);
  });

  /// 確認ダイアログを経て送信する関数を呼ぶボタンだけの画面を pump し、ボタンを押してダイアログを開く。
  /// 戻り値は関数の結果を返す関数 (呼び出しが終わるまでは null)。
  Future<List<Map<String, dynamic>>? Function()> pumpAndOpenDialog(WidgetTester tester) async {
    List<Map<String, dynamic>>? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await generateMedicinesFromImageAfterConsent(context: context, firebaseFunctions: firebaseFunctions, imageFile: imageFile);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return () => result;
  }

  testWidgets('送る前に送り先を説明する確認ダイアログが出る', (tester) async {
    await pumpAndOpenDialog(tester);

    expect(find.text(L.medicineImageImportConsentTitle), findsOneWidget);
    expect(find.text(L.medicineImageImportConsentMessage), findsOneWidget);
    expect(find.text(L.send), findsOneWidget);
    expect(find.text(L.cancel), findsOneWidget);
    verifyNever(firebaseFunctions.httpsCallable(any));
  });

  testWidgets('「キャンセル」を選ぶと generateMedicinesFromImage を呼ばずに null を返す', (tester) async {
    final result = await pumpAndOpenDialog(tester);

    await tester.tap(find.text(L.cancel));
    await tester.pumpAndSettle();

    expect(find.text(L.medicineImageImportConsentTitle), findsNothing);
    expect(result(), isNull);
    verifyNever(firebaseFunctions.httpsCallable(any));
  });

  testWidgets('ダイアログの外側をタップして閉じると generateMedicinesFromImage を呼ばずに null を返す', (tester) async {
    final result = await pumpAndOpenDialog(tester);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.text(L.medicineImageImportConsentTitle), findsNothing);
    expect(result(), isNull);
    verifyNever(firebaseFunctions.httpsCallable(any));
  });

  testWidgets('「送信」を選ぶと generateMedicinesFromImage を呼び、抽出結果を返す', (tester) async {
    final result = await pumpAndOpenDialog(tester);

    await tester.tap(find.text(L.send));
    // base64CompressImage のファイル読み込みは実際の I/O で、その続きは fake async 側で動くため、
    // 実時間を進める runAsync と fake async を進める pump を交互に行う。
    // 送信されない不具合でテストが止まらないよう、待つのは最大 5 秒 (10ms × 500 回) にする
    for (var i = 0; i < 500 && result() == null; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    verify(firebaseFunctions.httpsCallable('generateMedicinesFromImage')).called(1);
    final payload = verify(httpsCallable.call(captureAny)).captured.single as Map<String, dynamic>;
    expect(payload['mimeType'], 'image/jpeg');
    expect(payload['base64Image'], isNotEmpty);
    expect(result(), [
      {'name': 'ロキソニン', 'schedules': <dynamic>[]},
    ]);
  });
}

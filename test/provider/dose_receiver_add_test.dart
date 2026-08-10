import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/dose_receiver.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dose_receiver_add_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GroupDatabase>(),
  MockSpec<CollectionReference<DoseReceiver>>(as: #MockDoseReceiverCollectionReference),
  MockSpec<DocumentReference<DoseReceiver>>(as: #MockDoseReceiverDocumentReference),
])
void main() {
  late MockGroupDatabase database;
  late MockDoseReceiverCollectionReference collectionReference;
  late MockDoseReceiverDocumentReference documentReference;
  late DoseReceiverAdd doseReceiverAdd;

  setUp(() {
    database = MockGroupDatabase();
    collectionReference = MockDoseReceiverCollectionReference();
    documentReference = MockDoseReceiverDocumentReference();
    when(database.doseReceiversReference()).thenReturn(collectionReference);
    when(collectionReference.doc(any)).thenReturn(documentReference);
    when(documentReference.set(any, any)).thenAnswer((_) async {});
    doseReceiverAdd = DoseReceiverAdd(database: database, userID: 'user-a');
  });

  // #246: add() で書き込むと id フィールドと実際のドキュメント ID が食い違い、
  // firstUser のような固定 ID 指定が読み込み時の id 上書きで一致しなくなる
  group('DoseReceiverAdd.call の書き込み先ドキュメント ID', () {
    test('id 指定(firstUser)の場合は指定 ID のドキュメントへ書き込み、id フィールドと一致する', () async {
      when(documentReference.id).thenReturn(DoseReceiver.firstUserID);

      final result = await doseReceiverAdd.call(id: DoseReceiver.firstUserID, name: '自分');

      verify(collectionReference.doc(DoseReceiver.firstUserID)).called(1);
      expect(result.id, DoseReceiver.firstUserID);
      final DoseReceiver written = verify(documentReference.set(captureAny, captureAny)).captured.first;
      expect(written.id, DoseReceiver.firstUserID);
      expect(written.userID, 'user-a');
      expect(written.name, '自分');
    });

    test('id が null の場合は自動採番の doc へ書き込み、id フィールドが採番 ID と一致する', () async {
      when(documentReference.id).thenReturn('generated-id');

      final result = await doseReceiverAdd.call(id: null, name: 'あたらしい服用者');

      verify(collectionReference.doc(null)).called(1);
      expect(result.id, 'generated-id');
      final DoseReceiver written = verify(documentReference.set(captureAny, captureAny)).captured.first;
      expect(written.id, 'generated-id');
    });
  });
}

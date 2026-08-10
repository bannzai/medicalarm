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
  MockSpec<DocumentSnapshot<DoseReceiver>>(as: #MockDoseReceiverDocumentSnapshot),
  MockSpec<FirebaseFirestore>(),
  MockSpec<Transaction>(),
])
void main() {
  late MockGroupDatabase database;
  late MockDoseReceiverCollectionReference collectionReference;
  late MockDoseReceiverDocumentReference documentReference;

  setUp(() {
    database = MockGroupDatabase();
    collectionReference = MockDoseReceiverCollectionReference();
    documentReference = MockDoseReceiverDocumentReference();
  });

  // #246: add() で書き込むと id フィールドと実際のドキュメント ID が食い違い、
  // 読み込み時の id 上書きで一覧側の id と一致しなくなる
  group('DoseReceiverAdd.call の書き込み先ドキュメント ID', () {
    test('自動採番の doc へ書き込み、id フィールドが採番 ID と一致する', () async {
      when(database.doseReceiversReference()).thenReturn(collectionReference);
      when(collectionReference.doc(any)).thenReturn(documentReference);
      when(documentReference.id).thenReturn('generated-id');
      when(documentReference.set(any, any)).thenAnswer((_) async {});

      final result = await DoseReceiverAdd(database: database, userID: 'user-a').call(name: 'あたらしい服用者');

      verify(collectionReference.doc(null)).called(1);
      expect(result.id, 'generated-id');
      expect(result.userID, 'user-a');
      final DoseReceiver written = verify(documentReference.set(captureAny, captureAny)).captured.first;
      expect(written.id, 'generated-id');
    });
  });

  // #246 レビュー指摘: 空キャッシュの snapshot や複数メンバーの同時初期化で FirstDoseReceiverAdd が
  // 呼ばれても、既存の firstUser ドキュメント(編集済みの name 等)を上書きしない
  group('FirstDoseReceiverAdd.call の create-if-absent', () {
    late MockFirebaseFirestore firestore;
    late MockTransaction transaction;
    late MockDoseReceiverDocumentSnapshot snapshot;

    setUp(() {
      firestore = MockFirebaseFirestore();
      transaction = MockTransaction();
      snapshot = MockDoseReceiverDocumentSnapshot();
      when(database.doseReceiverReference(doseReceiverID: anyNamed('doseReceiverID'))).thenReturn(documentReference);
      when(documentReference.firestore).thenReturn(firestore);
      when(firestore.runTransaction<void>(any, timeout: anyNamed('timeout'), maxAttempts: anyNamed('maxAttempts')))
          .thenAnswer((invocation) async {
        await (invocation.positionalArguments.first as Future<void> Function(Transaction))(transaction);
      });
      when(transaction.get<DoseReceiver>(any)).thenAnswer((_) async => snapshot);
    });

    test('firstUser ドキュメントが存在しない場合は固定 ID で作成する', () async {
      when(snapshot.exists).thenReturn(false);

      await FirstDoseReceiverAdd(database: database, userID: 'user-a').call();

      verify(database.doseReceiverReference(doseReceiverID: DoseReceiver.firstUserID)).called(1);
      final DoseReceiver written = verify(transaction.set<DoseReceiver>(documentReference, captureAny)).captured.first;
      expect(written.id, DoseReceiver.firstUserID);
      expect(written.userID, 'user-a');
      expect(written.name, DoseReceiver.firstUserName);
    });

    test('firstUser ドキュメントが既に存在する場合は書き込まない(上書きしない)', () async {
      when(snapshot.exists).thenReturn(true);

      await FirstDoseReceiverAdd(database: database, userID: 'user-a').call();

      verifyNever(transaction.set<DoseReceiver>(any, any));
    });
  });
}

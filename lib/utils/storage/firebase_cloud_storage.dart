import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;
final rootRef = storage.ref();

Reference userRef = rootRef.child('users');
Reference medicinesRef({required String userID}) => userRef.child(userID).child('medicines');

Future<String> uploadImage(Reference ref, File file) async {
  final uploadTask = ref.putFile(file);
  final snapshot = await uploadTask.whenComplete(() => null);
  final url = await snapshot.ref.getDownloadURL();
  return url;
}

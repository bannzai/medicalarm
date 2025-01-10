import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final storage = FirebaseStorage.instance;
final rootRef = storage.ref();
final chartPartnersRef = rootRef.child('chat_partners');

Future<String> uploadImage(Reference ref, File file) async {
  final uuid = const Uuid().v4();
  final uploadTask = ref.child(uuid).putFile(file);
  final snapshot = await uploadTask.whenComplete(() => null);
  final url = await snapshot.ref.getDownloadURL();
  return url;
}

import 'dart:io';

String get storeName {
  return Platform.isIOS ? "App Store" : "Google Play";
}

String get accountName {
  return Platform.isIOS ? "Apple ID" : "Google アカウント";
}

// TODO: ここにアプリのURLを入れる
String get forceUpdateStoreURL {
  return Platform.isIOS ? "" : "";
}

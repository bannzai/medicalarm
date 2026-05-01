extension BoolKey on String {}

extension StringKey on String {
  static const String lastSignInFirebaseAuthUserID = 'lastSignInFirebaseAuthUserID';
}

extension ReleaseNoteKey on String {}

extension IntKey on String {}

extension DoubleKey on String {
  /// 起動時の機能要望ダイアログを最後に表示した時刻（epoch 秒）。
  /// 30日以内の再表示を抑止するために使用。
  static const String featureRequestPromptShownDateTimeInterval = 'featureRequestPromptShownDateTimeInterval';
}

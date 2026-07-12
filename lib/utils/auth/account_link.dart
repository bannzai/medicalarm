import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// 匿名認証中の [FirebaseAuth.instance.currentUser] に Apple アカウントを linkWithCredential でひも付ける。
///
/// uid は変わらないため Firestore / RevenueCat のデータはそのまま引き継がれる。
/// `credential-already-in-use` / `provider-already-linked` は [FirebaseAuthException] として呼び出し側へ伝播する。
class AppleAccountLink {
  /// Apple サインインを起動してリンクする。リンクした場合は true、ユーザーがキャンセルした場合は false を返す。
  Future<bool> call() async {
    final rawNonce = generateNonce();
    // Apple には SHA-256 でハッシュした nonce を渡し、Firebase には rawNonce を渡すことでリプレイ攻撃を防ぐ
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: hashedNonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return false;
      }
      rethrow;
    }

    final idToken = appleCredential.identityToken;
    if (idToken == null) {
      throw Exception('No identity token');
    }

    await FirebaseAuth.instance.currentUser?.linkWithCredential(
      AppleAuthProvider.credentialWithIDToken(
        idToken,
        rawNonce,
        AppleFullPersonName(givenName: appleCredential.givenName, familyName: appleCredential.familyName),
      ),
    );
    return true;
  }
}

/// 匿名認証中の [FirebaseAuth.instance.currentUser] に Google アカウントを linkWithCredential でひも付ける。
///
/// 前提として main.dart で `GoogleSignIn.instance.initialize()` が一度呼ばれている必要がある(google_sign_in v7 の仕様)。
class GoogleAccountLink {
  /// Google サインインを起動してリンクする。リンクした場合は true、ユーザーがキャンセルした場合は false を返す。
  Future<bool> call() async {
    final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return false;
      }
      rethrow;
    }

    final authorization = await googleUser.authorizationClient.authorizationForScopes(['email', 'profile']);
    await FirebaseAuth.instance.currentUser?.linkWithCredential(
      GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleUser.authentication.idToken,
      ),
    );
    return true;
  }
}

final appleAccountLinkProvider = Provider((ref) => AppleAccountLink());
final googleAccountLinkProvider = Provider((ref) => GoogleAccountLink());

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/alert/discard.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class DeleteUserButton extends HookConsumerWidget {
  const DeleteUserButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: OutlinedButton(
            onPressed: () async {
              analytics.logEvent(name: 'user_delete_btn_pressed');
              if (isLoading.value) {
                return;
              }

              showDiscardDialog(
                context,
                title: L.deleteAccountConfirm,
                message: L.deleteAccountMessage,
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      L.cancel,
                      style: const TextStyle(
                        color: TextColor.gray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      analytics.logEvent(name: 'user_delete_confirm_pressed');
                      if (!isLoading.value) {
                        isLoading.value = true;
                        await _delete(
                          context,
                          isAppleLinked: isAppleLinked,
                          isGoogleLinked: isGoogleLinked,
                        );
                        isLoading.value = false;
                      }
                    },
                    child: Text(L.delete, style: const TextStyle(color: TextColor.danger, fontWeight: FontWeight.w600)),
                  ),
                ],
              );
            },
            child: Text(L.deleteAccount),
          ),
        ),
        if (isLoading.value)
          const Center(
            child: Indicator(),
          ),
      ],
    );
  }

  Future<void> _delete(
    BuildContext context, {
    required bool isAppleLinked,
    required bool isGoogleLinked,
  }) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const _CompletedDialog(),
        );
      }
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'requires-recent-login') {
        if (!context.mounted) return;
        showDiscardDialog(
          context,
          title: L.reloginRequired,
          message: L.reloginMessage,
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text(
                L.cancel,
                style: const TextStyle(
                  color: TextColor.gray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                analytics.logEvent(name: 'user_delete_relogin_pressed');
                final navigator = Navigator.of(context);
                if (isAppleLinked) {
                  await appleReauthentification();
                } else if (isGoogleLinked) {
                  await googleReauthentification();
                } else {
                  errorLogger.log('it is not cooperate account');
                  exit(1);
                }
                navigator.pop();
                // ignore: use_build_context_synchronously
                await _delete(context, isAppleLinked: isAppleLinked, isGoogleLinked: isGoogleLinked);
              },
              child: Text(
                L.relogin,
                style: const TextStyle(
                  color: TextColor.main,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      } else {
        errorLogger.recordError(error, stackTrace);
        if (context.mounted) showErrorAlert(context, error);
      }
    } catch (error) {
      if (context.mounted) {
        showErrorAlert(context, error);
      }
    }
  }
}

class _CompletedDialog extends StatelessWidget {
  const _CompletedDialog();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.accountDeleted,
            style: const TextStyle(
              color: TextColor.main,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            L.confirmExit,
            style: const TextStyle(
              color: TextColor.main,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: TextButton(
              onPressed: () async {
                analytics.logEvent(name: 'user_delete_exit_pressed');
                exit(0);
              },
              child: Text(
                L.exit,
                style: const TextStyle(
                  color: TextColor.main,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> appleReauthentification() async {
  try {
    final provider = AppleAuthProvider().addScope('email');
    await FirebaseAuth.instance.currentUser?.reauthenticateWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // Googleのcodeとは違うので注意
    if (e.code == 'canceled') {
      return Future.value();
    }
    rethrow;
  }
}

Future<void> googleReauthentification() async {
  try {
    final provider = GoogleAuthProvider().addScope('email');
    await FirebaseAuth.instance.currentUser?.reauthenticateWithProvider(provider);
  } on FirebaseAuthException catch (e) {
    // sign-in-failed という code で返ってくるが、コードを読んでると該当するエラーが多かったので実際にdumpしてみたメッセージでマッチしている
    // Appleのcodeとは違うので注意
    if (e.toString().contains('The interaction was cancelled by the user')) {
      return;
    }
    rethrow;
  }
}

bool isLinkedGoogleFor(User user) {
  return user.providerData.where((element) => element.providerId == GoogleAuthProvider.PROVIDER_ID).isNotEmpty;
}

bool isLinkedAppleFor(User user) {
  return user.providerData.where((element) => element.providerId == AppleAuthProvider.PROVIDER_ID).isNotEmpty;
}

final isAppleLinkedProvider = Provider((ref) {
  final user = ref.watch(firebaseUserChangesProvider);
  final userValue = user.valueOrNull;
  if (userValue == null) {
    return false;
  }
  return isLinkedAppleFor(userValue);
});

final isGoogleLinkedProvider = Provider((ref) {
  final user = ref.watch(firebaseUserChangesProvider);
  final userValue = user.valueOrNull;
  if (userValue == null) {
    return false;
  }
  return isLinkedGoogleFor(userValue);
});

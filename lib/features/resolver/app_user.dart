import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/provider/app_user.dart';

class AppUserStreamResolver extends HookConsumerWidget {
  final Function(AppUser) stream;

  const AppUserStreamResolver({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserProvider).asData?.value;
    if (user != null) {
      Future.microtask(() => stream(user));
    }
    return const SizedBox();
  }
}

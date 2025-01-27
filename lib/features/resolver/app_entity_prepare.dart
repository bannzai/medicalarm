import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/provider/dose_receiver.dart';

class AppEntityPrepareResolver extends HookConsumerWidget {
  final String userID;
  final Widget Function(BuildContext context) builder;

  const AppEntityPrepareResolver({
    super.key,
    required this.userID,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doseReceivers = ref.watch(doseReceiversProvider);
    final firstDoseReceiverAdd = ref.watch(firstDoseReceiverAddProvider);

    useEffect(() {
      void f() async {
        if (doseReceivers is AsyncData && doseReceivers.value?.isEmpty == true) {
          await firstDoseReceiverAdd.call();
        }
      }

      f();
      return null;
    }, [doseReceivers]);

    if (doseReceivers.valueOrNull?.isEmpty == true) {
      return const IndicatorPage();
    }
    return builder(context);
  }
}

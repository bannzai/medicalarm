import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/group_create.dart';
import 'package:medicalarm/utils/analytics/error.dart';

/// currentGroupID を確定させてから子を描画する Resolver。
///
/// 親(GroupMigrationResolver)が移行を終え defaultGroupID の存在を保証済みのため、
/// ここでは currentGroupID が未設定の間だけ appUser.defaultGroupID を流し込む。
/// removeGroupMember 等で移行済みなのに defaultGroupID を失った場合は、
/// ソログループを作り直すフォールバックを持つ。
class CurrentGroupResolver extends HookConsumerWidget {
  final Widget Function(BuildContext context) builder;

  const CurrentGroupResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGroupID = ref.watch(currentGroupIDProvider);
    final appUser = ref.watch(appUserProvider).valueOrNull;
    final defaultGroupID = appUser?.defaultGroupID;
    final migrated = appUser?.groupMigratedDateTime != null;
    final currentGroupIDNotifier = ref.watch(currentGroupIDProvider.notifier);
    final createGroup = ref.watch(createGroupProvider);
    final isCreatingFallbackGroup = useState(false);

    // フォールバック: 移行済みなのに defaultGroupID が null(ソログループを失った)場合はソログループを作り直す。
    useEffect(() {
      void f() async {
        if (migrated && defaultGroupID == null && !isCreatingFallbackGroup.value) {
          isCreatingFallbackGroup.value = true;
          try {
            await createGroup.call(name: null, setAsDefault: true, iconName: 'home');
          } catch (e, st) {
            errorLogger.recordError(e, st);
          } finally {
            isCreatingFallbackGroup.value = false;
          }
        }
      }

      f();
      return null;
    }, [migrated, defaultGroupID]);

    // currentGroupID が未設定の時だけ defaultGroupID で初期化する。手動切替後(非null)は上書きしない。
    // build 中の state 変更を避けるため postFrame で反映する。
    useEffect(() {
      if (currentGroupID == null && defaultGroupID != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentGroupIDNotifier.update(defaultGroupID);
        });
      }
      return null;
    }, [currentGroupID, defaultGroupID]);

    if (currentGroupID == null) {
      return const IndicatorPage();
    }
    return builder(context);
  }
}

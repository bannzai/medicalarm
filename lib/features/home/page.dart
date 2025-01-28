import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/medications_histories/page.dart';
import 'package:medicalarm/features/medications/page.dart';
import 'package:medicalarm/features/settings/page.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/push_notification/request_permission.dart';
import 'package:medicalarm/features/localization/l.dart';

enum HomePageTabType { medications, medicationHistories, settings }

extension HomePageTabFunctions on HomePageTabType {
  String get screenName {
    switch (this) {
      case HomePageTabType.medications:
        return 'MedicationsPage';
      case HomePageTabType.medicationHistories:
        return 'MedicationHistoriesPage';
      case HomePageTabType.settings:
        return 'SettingsPage';
    }
  }
}

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final ticker = useSingleTickerProvider();
    final tabController = useTabController(initialLength: HomePageTabType.values.length, vsync: ticker);
    final registerRemotePushNotificationToken = ref.watch(registerRemotePushNotificationTokenProvider);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      _screenTracking(tabController.index);
    });

    useEffect(() {
      requestNotificationPermissions(registerRemotePushNotificationToken);
      return null;
    }, []);

    return DefaultTabController(
      length: HomePageTabType.values.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: null,
        bottomNavigationBar: Ink(
          child: SafeArea(
            child: TabBar(
              controller: tabController,
              labelColor: AppColors.primary,
              labelStyle: const TextStyle(fontSize: 12),
              indicatorColor: Colors.transparent,
              unselectedLabelColor: TextColor.gray,
              tabs: <Tab>[
                Tab(
                  text: L.medication,
                  icon: const Icon(Icons.timer_outlined),
                ),
                Tab(
                  text: L.history,
                  icon: const Icon(Icons.list_alt_outlined),
                ),
                Tab(
                  text: L.settings,
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: const [
            MedicationsPage(),
            MedicationHistoriesPage(),
            SettingPage(),
          ],
        ),
      ),
    );
  }

  void _screenTracking(int index) {
    analytics.setCurrentScreen(
      screenName: HomePageTabType.values[index].screenName,
    );
  }
}

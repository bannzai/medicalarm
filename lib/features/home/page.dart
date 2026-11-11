import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/calendar/page.dart';
import 'package:medicalarm/features/medications_histories/page.dart';
import 'package:medicalarm/features/medications/page.dart';
import 'package:medicalarm/features/settings/page.dart';
import 'package:medicalarm/provider/group_member_notification_settings.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/push_notification/request_permission.dart';
import 'package:medicalarm/features/localization/l.dart';

enum HomePageTabType { medications, medicationHistories, calendar, settings }

extension HomePageTabFunctions on HomePageTabType {
  String get screenName {
    switch (this) {
      case HomePageTabType.medications:
        return 'MedicationsPage';
      case HomePageTabType.medicationHistories:
        return 'MedicationHistoriesPage';
      case HomePageTabType.calendar:
        return 'CalendarPage';
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

    // 他メンバーの薬変更・服薬記録が snapshot で届いたらローカル通知を再登録する。
    // 再登録はローカル通知の操作のみで Firestore へ書き込まないため、この listen が無限ループになることはない。
    ref.listen(activeMedicinesProvider, (previous, next) {
      if (next is AsyncData) {
        unawaited(ref.read(registerReminderLocalNotificationProvider).call());
      }
    });
    ref.listen(medicationHistoriesByDateProvider(today()), (previous, next) {
      if (next is AsyncData) {
        unawaited(ref.read(registerReminderLocalNotificationProvider).call());
      }
    });
    // 通知個別設定(Critical Alert / Focus 連携等)の変更は端末のローカル通知内容に影響するため、再登録する。
    ref.listen(groupMemberNotificationSettingsProvider, (previous, next) {
      if (next is AsyncData) {
        unawaited(ref.read(registerReminderLocalNotificationProvider).call());
      }
    });

    return DefaultTabController(
      length: HomePageTabType.values.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: null,
        bottomNavigationBar: Ink(
          child: SafeArea(child: HomePageTabBar(tabController: tabController)),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: const [MedicationsPage(), MedicationHistoriesPage(), CalendarPage(), SettingPage()],
        ),
      ),
    );
  }

  void _screenTracking(int index) {
    analytics.setCurrentScreen(screenName: HomePageTabType.values[index].screenName);
  }
}

/// ホーム画面の下のタブ (服薬・履歴・カレンダー・設定)。
/// HomePage の provider を用意せずに文字サイズごとの表示を widget test で確かめるため、HomePage から分けている。
class HomePageTabBar extends StatelessWidget {
  final TabController tabController;
  const HomePageTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    // 文字の倍率は 1.0 を上限にする。タブの文字に使える幅は iPhone 17 (幅 402) で 68.5 しかなく、
    // 「カレンダー」(12pt × 5 文字 = 60) が収まる倍率は約 1.14 までのため。Flutter の BottomNavigationBar・CupertinoTabBar・
    // iOS 標準のタブバーも、下のタブの文字は大きくしない (#543)
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.0,
      child: TabBar(
        controller: tabController,
        labelColor: AppColors.primary,
        labelStyle: const TextStyle(fontSize: 12),
        indicatorColor: Colors.transparent,
        unselectedLabelColor: TextColor.gray,
        tabs: <Tab>[
          Tab(text: L.medication, icon: const Icon(Icons.timer_outlined)),
          Tab(text: L.history, icon: const Icon(Icons.list_alt_outlined)),
          Tab(text: L.calendar, icon: const Icon(Icons.calendar_month_outlined)),
          Tab(text: L.settings, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
    );
  }
}

import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/button/buttons.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/entity/diary_setting.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/provider/diary_setting.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class DiaryPostPage extends HookConsumerWidget {
  final DateTime date;
  final Diary? diary;

  const DiaryPostPage(this.date, this.diary, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diarySetting = ref.watch(diarySettingProvider);

    return Retry(
      retry: () => ref.refresh(diarySettingProvider),
      child: diarySetting.when(
        data: (diarySetting) => DiaryPostPageBody(
          date: date,
          diary: diary,
          diarySetting: diarySetting,
        ),
        error: (error, stackTrace) => RetryPage(
          exception: error,
        ),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

extension DiaryPostPageRoute on DiaryPostPage {
  static Route<dynamic> route(DateTime date, Diary? diary) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'DiaryPostPage'),
      builder: (_) => DiaryPostPage(date, diary),
      fullscreenDialog: true,
    );
  }
}

class DiaryPostPageBody extends HookConsumerWidget {
  final DateTime diaryDate;
  final Diary? diary;
  final DiarySetting? diarySetting;

  const DiaryPostPageBody({
    super.key,
    required this.diaryDate,
    required this.diary,
    required this.diarySetting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = useState(diarySetting?.tags ?? DiarySetting.defaultTags);
    final memos = useState(diary?.memos ?? []);
    final memo = useState(diary?.memo ?? '');
    final diaryPost = ref.watch(diaryPostProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          AlertButton(
              text: L.save,
              onPressed: () async {
                analytics.logEvent(name: 'diary_post_button_tapped');

                final navigator = Navigator.of(context);
                await diaryPost.call(
                  diary: diary,
                  tags: tags.value,
                  memos: memos.value,
                  memo: memo.value,
                );

                navigator.pop();
              }),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  Text(DateFormat(DateFormat.YEAR_MONTH_DAY).format(diaryDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: TextColor.main,
                      )),
                  const SizedBox(height: 20),
                  DiaryPostPhysicalCondition(physicalCondition: physicalCondition),
                  const SizedBox(height: 20),
                  DiaryPostPhysicalConditionDetails(
                      user: user, diarySetting: diarySetting, context: context, physicalConditionDetails: physicalConditionDetails),
                  const SizedBox(height: 20),
                  DiaryPostSex(sex: sex),
                  const SizedBox(height: 20),
                  DiaryPostMemo(textEditingController: memoTextEditingController, focusNode: focusNode),
                ],
              ),
            ),
            if (focusNode.hasPrimaryFocus) ...[
              KeyboardToolbar(
                doneButton: AlertButton(
                  text: L.completed,
                  onPressed: () async {
                    analytics.logEvent(name: 'post_diary_done_button_pressed');
                    focusNode.unfocus();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

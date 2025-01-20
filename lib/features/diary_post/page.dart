import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/entity/diary_setting.dart';
import 'package:medicalarm/provider/diary_setting.dart';

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
  final DateTime date;
  final Diary? diary;
  final DiarySetting? diarySetting;

  const DiaryPostPageBody({
    super.key,
    required this.date,
    required this.diary,
    required this.diarySetting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoTextEditingController = useTextEditingController(text: diary?.memo ?? '');
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    final physicalCondition = useState<PhysicalConditionStatus?>(diary.physicalConditionStatus);
    final physicalConditionDetails = useState(diary.physicalConditions);
    final sex = useState(diary.hasSex);

    final setDiary = ref.watch(setDiaryProvider);

    // FIXME: なぜかFocusScope.of(context).hasFocusになりKeyboardToolbarが表示されてしまうのでunfocusする
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        FocusScope.of(context).unfocus();
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppColors.white,
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
                await setDiary(diary.copyWith(
                  physicalConditionStatus: physicalCondition.value,
                  physicalConditions: physicalConditionDetails.value,
                  hasSex: sex.value,
                  memo: memoTextEditingController.text,
                ));

                navigator.pop();
              }),
        ],
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                controller: scrollController,
                children: [
                  Text(DateTimeFormatter.yearAndMonthAndDay(date),
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
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

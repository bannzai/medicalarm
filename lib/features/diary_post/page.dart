import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/button/buttons.dart';
import 'package:medicalarm/components/keyboard/toolbar.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/features/diary_post/components/memo.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class DiaryPostPage extends HookConsumerWidget {
  final DateTime diaryDate;
  final Diary? diary;

  const DiaryPostPage({
    super.key,
    required this.diaryDate,
    required this.diary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DiaryPostPageBody(
      diaryDate: diaryDate,
      diary: diary,
    );
  }
}

extension DiaryPostPageRoute on DiaryPostPage {
  static Route<dynamic> route(DateTime diaryDate, Diary? diary) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'DiaryPostPage'),
      builder: (_) => DiaryPostPage(diaryDate: diaryDate, diary: diary),
      fullscreenDialog: true,
    );
  }
}

class DiaryPostPageBody extends HookConsumerWidget {
  final DateTime diaryDate;
  final Diary? diary;

  const DiaryPostPageBody({
    super.key,
    required this.diaryDate,
    required this.diary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final memo = useState(diary?.memo ?? '');
    final diaryPost = ref.watch(diaryPostProvider);

    return FormTheme(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
                      DiaryPostMemo(memo: memo, focusNode: focusNode),
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
        ),
      ),
    );
  }
}

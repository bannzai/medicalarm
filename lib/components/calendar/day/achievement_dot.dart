import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medication_achievement.dart';
import 'package:medicalarm/style/color.dart';

/// カレンダーの日付の下に置く、その日の服薬達成状態を表すドット (#278)。
/// カレンダー本体と達成率カードの凡例で同じ見た目を使うために切り出している
class CalendarDayAchievementDot extends StatelessWidget {
  /// ドットの一辺。日付数字(fontSize 16)の下に添えても行の高さを押し上げない大きさ
  static const double size = 6;

  final DayMedicationAchievement achievement;
  const CalendarDayAchievementDot({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: switch (achievement) {
          DayMedicationAchievement.allTaken => AppColors.primary,
          // 一部服用は輪郭だけで表し、全部服用の塗りつぶしと一目で区別できるようにする
          DayMedicationAchievement.partiallyTaken => null,
          DayMedicationAchievement.noneTaken => AppColors.achievementNone,
        },
        border: achievement == DayMedicationAchievement.partiallyTaken ? Border.all(color: AppColors.primary, width: 1.5) : null,
      ),
    );
  }
}

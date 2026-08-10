import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';

// AI が画像から抽出した薬の登録候補。
// Firestore 未保存の一時データで対応する entity が存在しないため、
// レビューシートでの選択・名前編集の状態を持つ専用クラスを定義する。
class MedicineImageImportCandidate {
  /// 薬の名前。シート上で編集できる。
  final String name;

  /// 服用スケジュール。抽出した時刻・服用量を既定の通知設定で包んだもの。
  final List<MedicationSchedule> schedules;

  /// シート上で登録対象として選択されているか。
  final bool selected;

  /// 服用時刻を読み取れず仮の時刻を設定したか。シートで仮時刻である旨を表示する。
  final bool isScheduleTimeFallback;

  /// スケジュール数のプレミアム制限で除外された服用時刻の件数。シートで除外された旨を表示する。
  final int droppedScheduleCount;

  MedicineImageImportCandidate({
    required this.name,
    required this.schedules,
    required this.selected,
    required this.isScheduleTimeFallback,
    required this.droppedScheduleCount,
  });

  MedicineImageImportCandidate copyWith({String? name, bool? selected}) => MedicineImageImportCandidate(
        name: name ?? this.name,
        schedules: schedules,
        selected: selected ?? this.selected,
        isScheduleTimeFallback: isScheduleTimeFallback,
        droppedScheduleCount: droppedScheduleCount,
      );
}

/// 画像から読み取った候補をユーザーが取捨選択・名前編集するシートを表示する。
/// 戻り値: キャンセル時は null、確定時は選択された候補 (名前が空のものは除く)。
Future<List<MedicineImageImportCandidate>?> showMedicineImageImportReviewSheet({
  required BuildContext context,
  required List<MedicineImageImportCandidate> candidates,
  required int maxSelectableCount,
}) {
  return showModalBottomSheet<List<MedicineImageImportCandidate>>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MedicineImageImportReviewSheet(candidates: candidates, maxSelectableCount: maxSelectableCount),
  );
}

/// 画像から読み取った薬の候補一覧を表示し、登録する候補の選択と名前の編集を行うシート。
class MedicineImageImportReviewSheet extends HookWidget {
  /// 画像から読み取った薬の候補。
  final List<MedicineImageImportCandidate> candidates;

  /// 選択できる候補数の上限。お薬の登録数のプレミアム制限 (Medicine.maxCount) の残り枠。
  final int maxSelectableCount;

  const MedicineImageImportReviewSheet({super.key, required this.candidates, required this.maxSelectableCount});

  @override
  Widget build(BuildContext context) {
    // 初期選択は残り登録枠まで。全選択のまま確定すると薬の登録数制限を超えるため。
    final editedCandidates = useState([
      for (final (index, candidate) in candidates.indexed) candidate.copyWith(selected: index < maxSelectableCount),
    ]);
    final selectedCount = editedCandidates.value.where((candidate) => candidate.selected).length;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FormTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Text(L.medicineImageImportReviewTitle, style: TextStyle(color: primaryColor)),
              ),
              body: SafeArea(
                child: candidates.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(L.medicineImageImportEmpty),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(null);
                              },
                              child: Text(L.close),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          if (candidates.length > maxSelectableCount) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(L.medicineImageImportSelectableLimit(maxSelectableCount), style: const TextStyle(color: TextColor.danger)),
                            ),
                          ],
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              itemCount: editedCandidates.value.length,
                              itemBuilder: (context, index) {
                                final candidate = editedCandidates.value[index];
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: candidate.selected,
                                      // 未選択の候補は、残り登録枠を使い切っている間は追加で選択できない
                                      onChanged: !candidate.selected && selectedCount >= maxSelectableCount
                                          ? null
                                          : (value) {
                                              final copied = [...editedCandidates.value];
                                              copied[index] = candidate.copyWith(selected: value ?? false);
                                              editedCandidates.value = copied;
                                            },
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                            initialValue: candidate.name,
                                            // フォームの名前欄 (MedicineFormNameTextField) と同じ上限
                                            maxLength: 50,
                                            onChanged: (value) {
                                              final copied = [...editedCandidates.value];
                                              copied[index] = candidate.copyWith(name: value);
                                              editedCandidates.value = copied;
                                            },
                                          ),
                                          Text(
                                            candidate.schedules
                                                .map(
                                                  (schedule) =>
                                                      '${schedule.toTimeString()}${schedule.quantityMemo.isNotEmpty ? ' ${schedule.quantityMemo}' : ''}',
                                                )
                                                .join(' / '),
                                            style: const TextStyle(fontSize: 12, color: TextColor.gray),
                                          ),
                                          if (candidate.isScheduleTimeFallback) ...[
                                            Text(
                                              L.medicineImageImportTimeFallbackCaption,
                                              style: const TextStyle(fontSize: 12, color: TextColor.danger),
                                            ),
                                          ],
                                          if (candidate.droppedScheduleCount > 0) ...[
                                            Text(
                                              L.medicineImageImportDroppedSchedulesCaption(candidate.droppedScheduleCount),
                                              style: const TextStyle(fontSize: 12, color: TextColor.danger),
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(null);
                                  },
                                  child: Text(L.cancel),
                                ),
                                ElevatedButton(
                                  onPressed: selectedCount > 0
                                      ? () {
                                          Navigator.of(context).pop([
                                            for (final candidate in editedCandidates.value)
                                              if (candidate.selected && candidate.name.trim().isNotEmpty)
                                                candidate.copyWith(name: candidate.name.trim()),
                                          ]);
                                        }
                                      : null,
                                  child: Text(L.medicineImageImportAddCount(selectedCount)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

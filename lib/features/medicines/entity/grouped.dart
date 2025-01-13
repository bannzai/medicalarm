import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';

part 'grouped.freezed.dart';

@freezed
class ScheduleTime with _$ScheduleTime {
  const factory ScheduleTime({
    required int hour,
    required int minute,
  }) = _ScheduleTime;
  const ScheduleTime._();

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

@freezed
class MedicineDosingRowValue with _$MedicineDosingRowValue {
  const factory MedicineDosingRowValue({
    required MedicationHistory? medicationHistory,
    required String medicineName,
    required String quantityMemo,
  }) = _MedicineDosingRowValue;
}

@freezed
// scheduleTime(id無し。値一致)とdoseReceiverごとのdosingRowsを管理する
class MedicineTileValue with _$MedicineTileValue {
  const factory MedicineTileValue({
    required ScheduleTime scheduleTime,
    required MedicineDoseReceiver doseReceiver,
    required List<MedicineDosingRowValue> dosingRows,
  }) = _MedicineTileValue;
}

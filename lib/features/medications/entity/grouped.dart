import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';

part 'grouped.freezed.dart';

@freezed
// scheduleTime(id無し。値一致)とdoseReceiverごとのdosingRowsを管理する
class MedicineTileValue with _$MedicineTileValue {
  const factory MedicineTileValue({
    required ScheduleTime scheduleTime,
    required DoseReceiver doseReceiver,
    required List<MedicineDosingRowValue> dosingRows,
  }) = _MedicineTileValue;
}

@freezed
class MedicineDosingRowValue with _$MedicineDosingRowValue {
  const factory MedicineDosingRowValue({
    required MedicationHistory? medicationHistory,
    required Medicine medicine,
    required MedicationSchedule medicationSchedule,
    required String quantityMemo,
  }) = _MedicineDosingRowValue;
}

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

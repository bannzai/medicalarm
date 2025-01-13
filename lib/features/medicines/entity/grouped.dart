import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';

typedef ScheduleTime = (int hour, int minute);

extension ScheduleTimeExtension on ScheduleTime {
  int get hour => this.$1;
  int get minute => this.$2;

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class MedicineDosingRowValue {
  final MedicationHistory? medicationHistory;
  final String medicineName;
  final String quantityMemo;

  MedicineDosingRowValue({
    required this.medicationHistory,
    required this.medicineName,
    required this.quantityMemo,
  });
}

class MedicineTileValue {
  final ScheduleTime scheduleTime;
  final MedicineDoseReceiver doseReceiver;
  final List<MedicineDosingRowValue> dosingRows;

  MedicineTileValue({
    required this.scheduleTime,
    required this.doseReceiver,
    required this.dosingRows,
  });
}

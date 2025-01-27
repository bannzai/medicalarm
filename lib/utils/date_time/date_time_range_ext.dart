import 'package:flutter/material.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

extension DateTimeRangeExtension on DateTimeRange {
  bool contains(DateTime date) {
    final isBefore = start.isBefore(date) || isSameDay(start, date);
    final isAfter = end.isAfter(date) || isSameDay(end, date);
    return isBefore && isAfter;
  }
}

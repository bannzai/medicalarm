import 'package:flutter/material.dart';

extension DateTimeRangeExtension on DateTimeRange {
  bool contains(DateTime date) {
    return start.isBefore(date) && end.isAfter(date);
  }
}

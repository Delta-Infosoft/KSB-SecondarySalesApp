import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateFormatExtention on DateTime{
  String format(String formatString){
    return DateFormat(formatString).format(this);
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String formatTimeOfDay() {
    final hour = hourOfPeriod.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }


}
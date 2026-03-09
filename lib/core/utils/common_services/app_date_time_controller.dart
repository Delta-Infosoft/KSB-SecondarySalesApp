import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/date_time_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/string_extentions.dart';

class AppDateTimeController extends GetxController{
  Future<String> pickDate(BuildContext context, String defaultValue,
      {DateTime? firstDate, DateTime? lastDate}) async {
    final date = await showDatePicker(
        context: context,
        firstDate: firstDate ?? DateTime(1990),
        initialDate: defaultValue.isNotEmpty
            ? defaultValue.convertToDateTime('dd-MMM-yyyy')
            : null,
        lastDate: lastDate ?? DateTime(2030));
    if (date != null) {
      return date.format('dd-MMM-yyyy');
    }
    return defaultValue;
  }

}
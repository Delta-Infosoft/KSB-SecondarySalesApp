import 'package:intl/intl.dart';

extension StringExtention on String {
  String get firstCapital => this[0].toUpperCase() + substring(1);
  DateTime convertToDateTimeObject(String format){
    return DateFormat(format).parse(this);
  }
  //Example:
  //DateTime fromDate = "23/02/2023".convertToDateTimeObject('dd/MM/yyyy');
}

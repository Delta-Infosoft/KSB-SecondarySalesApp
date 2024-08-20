import 'package:intl/intl.dart';

extension StringExtention on String {
  String get firstCapital => this[0].toUpperCase() + substring(1);
  DateTime convertToDateTimeObject(String format){
    return DateFormat(format).parse(this);
  }


  String get formatAmount {
    int salaryInt = int.parse(this);
    NumberFormat numberFormat = NumberFormat.decimalPattern('en_IN');
    return numberFormat.format(salaryInt);
  }
  //Example:
  //DateTime fromDate = "23/02/2023".convertToDateTimeObject('dd/MM/yyyy');
  DateTime convertToDateTime(String format){
    print('convertToDateTime');
    print(this);
    print(format);
    return DateFormat(format).parse(this);
  }
}

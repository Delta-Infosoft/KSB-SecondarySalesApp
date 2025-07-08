import 'dart:convert';

import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_data_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/constants/api_url.dart';
import '../../../core/utils/constants/app_constants.dart';

class SalesViewRepo{
  static Future<List<SalesData>> getSalesList() async {
    // try {
      print('getCustomerById');
      final response = await http.post(
        Uri.parse(ApiUrl.salesList),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': LocalDb.getString(AppConstants.userIdKey)}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = data['data'];

        print('Sales view Data>>>>${data}');

        return jsonData.map((json) => SalesData.fromJson(json)).toList();
      } else {
        return [];
      }
    // } catch (e) {
    //   print('e.toString()');
    //   print(e.toString());
    //   return [];
    // }
  }
}
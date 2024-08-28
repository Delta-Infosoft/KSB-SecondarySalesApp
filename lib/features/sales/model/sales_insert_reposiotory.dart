import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/constants/api_url.dart';
import '../view_model/sales_insert_controller.dart';


class SalesInsertRepository{
  static Future<List> getAddressFromPinCode(String pinCode) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.postalpincode.in/pincode/$pinCode'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]['PostOffice'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> insertSalesRecord(Map<String, dynamic> salesData) async {
    try {
      await Future.delayed(3.seconds);
      salesRecord.add(salesData);
      return true;
      // final response = await http.post(
      //   Uri.parse(ApiUrl.insertSalesEntryUrl),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode(salesData),
      // );
      //
      // if (response.statusCode == 200) {
      //   return true;
      // } else {
      //   // Handle other status codes here if needed
      //   return false;
      // }
    } catch (e) {
      print('Error inserting sales record: $e');
      return false;
    }
  }

  static Future<List<ProductModel>> getProductList() async {
    try {
      final response = await http
          .post(Uri.parse(ApiUrl.textListApi),);
      final data = jsonDecode(response.body);
      if (data['message'] == 'Successful') {
        return data['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }


}

List salesRecord = [];
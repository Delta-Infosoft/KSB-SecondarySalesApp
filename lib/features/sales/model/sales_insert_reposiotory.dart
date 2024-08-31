import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
import 'package:dio/dio.dart' as dio;
import '../../../core/utils/constants/api_url.dart';
import '../view_model/sales_insert_controller.dart';

class SalesInsertRepository {
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
      final response = await http.post(
        Uri.parse(ApiUrl.insertSalesEntryUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(salesData),
      );
      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error inserting sales record: $e');
      return false;
    }
  }

  static Future<List<ProductModel>> getProductList() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.getProductListUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              {'UserName': LocalDb.getString(AppConstants.userNameKey)}));
      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        return (data['data'] as List)
            .map(
              (e) => ProductModel.fromJson(e),
            )
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<ProductModel>> getFiltersData(String serialNo,
      String salesOrder, String invoiceNumber, String invoiceDate) async {
    try {
      print(salesOrder);
      final response = await http.post(Uri.parse(ApiUrl.getFilterProductsUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'soldToCode': LocalDb.getString(AppConstants.userNameKey),
            'serialNumber': serialNo,
            'salesOrder': salesOrder,
            'invoiceNumber': invoiceNumber,
            'invoiceDate': invoiceDate
          }));
      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        return (data['data'] as List)
            .map(
              (e) => ProductModel.fromJson(e),
            )
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

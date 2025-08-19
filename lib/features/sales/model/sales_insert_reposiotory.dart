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

  static Future<Map> getAddressFromPinCode2(String pinCode) async {
    try {
      final response = await http.get(Uri.parse(
          "https://nominatim.openstreetmap.org/search?format=json&q=$pinCode&limit=5&countrycodes=in"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0];
      }
      return {};
    } catch (e) {
      return {};
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
      String salesOrder, String invoiceNumber, String invoiceDate,String poNumber) async {
    try {
      print(salesOrder);
      print('Serial No     : $serialNo');
      print('Sales Order   : $salesOrder');
      print('Invoice Number: $invoiceNumber');
      print('Invoice Date  : $invoiceDate');
      print('PO Number     : $poNumber');

      print('PO NUMBER >>>>${poNumber}');
      final response = await http.post(Uri.parse(ApiUrl.getFilterProductsUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'soldToCode': '',
            'serialNumber': serialNo,
            'salesOrder': salesOrder,
            'invoiceNumber': invoiceNumber,
            'invoiceDate': invoiceDate,
            'poNumber': poNumber,

            // 'soldToCode': null,
            // 'serialNumber': "",
            // 'salesOrder': "",
            // 'invoiceNumber': "",
            // 'invoiceDate': ""
          }));

      print('Filter body>>>${response.headers}');

      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        print('Filtered Response>>>>>>${data}');
        final rawList = data['data'] as List;
        print('Raw item count: ${rawList.length}');
        for (var item in rawList) {
          print('Raw item: $item');
        }

        final mapped = rawList.map((e) => ProductModel.fromJson(e)).toList();
        print('Mapped items count: ${mapped.length}');
        for (var item in mapped) {
          print('Mapped item: ${item.serialNumber}, ${item.serialNumber}');
        }

        return mapped;
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}

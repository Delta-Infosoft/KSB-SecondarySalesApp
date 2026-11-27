import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ksb_secondary_sales/features/sales/model/get_all_pending_invoice_model.dart';
import '../../../core/utils/constants/api_url.dart';
import '../view_model/sales_insert_controller.dart';

/// Result of [SalesInsertRepository.reportMissingSerial].
class ReportSerialResult {
  const ReportSerialResult(this.success, this.message);
  final bool success;
  final String message;
}

class SalesInsertRepository {
  /// Tells Admin / HO that [serialNo] couldn't be found, so they can add it.
  /// Mirrors the web's "Notify Admin / HO" button (same payload/messages).
  static Future<ReportSerialResult> reportMissingSerial(String serialNo) async {
    final userId = LocalDb.getString(AppConstants.userIdKey);
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.reportMissingSerial),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'serialNo': serialNo,
          'userId': userId.isEmpty ? null : userId,
        }),
      );
      final data = jsonDecode(response.body);
      final message = data is Map ? data['message']?.toString() ?? '' : '';
      if (data is Map && data['isSuccessful'] == 200) {
        return ReportSerialResult(
          true,
          message.isNotEmpty
              ? message
              : 'Admin and HO have been notified. You will be told when the '
                  'Serial No is added.',
        );
      }
      return ReportSerialResult(
          false, message.isNotEmpty ? message : 'Unable to notify Admin / HO.');
    } catch (e) {
      return const ReportSerialResult(false, 'Unable to notify Admin / HO.');
    }
  }

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
        print('Sales record inserted successfully: ${data['message']}');
        return true;
      } else {
        print('Failed to insert sales record: ${data['message']}');
        return false;
      }
    } catch (e) {
      print('Error inserting sales record: $e');
      return false;
    }
  }

  static Future<List<GetAllPendingInvoiceData>> getProductListSerialNumber(String value) async {
    try {
      print("=== SERIAL API CALLED ===");
      print("URL: ${ApiUrl.getProductListSerialNumber}");
      print("Search Text: $value");

      final response = await http.post(
        Uri.parse(ApiUrl.getProductListSerialNumber),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'searchSerialNo': value,
          // 'searchMaterialNumber':value
        }), // as you want
      );

      print("Status Code: ${response.statusCode}");
      print("Raw Response: ${response.body}");

      final data = jsonDecode(response.body);

      print("Decoded isSuccessful: ${data['isSuccessful']}");
      print("Decoded data length: ${(data['data'] as List?)?.length}");

      if (data['isSuccessful'] == 200) {
        return (data['data'] as List)
            .map((e) => GetAllPendingInvoiceData.fromJson(e))
            .toList();
      }

      return [];
    } catch (e, stack) {
      print("API ERROR: $e");
      print("STACK TRACE: $stack");
      return [];
    }
  }



  // static Future<List<GetAllPendingInvoiceData>> getProductListSerialNumber(String value) async {
  //   try {
  //
  //     print("API URL>>>>>>>: ${ApiUrl.getProductListSerialNumber}");
  //     print("Request Serial Value>>>>>>>>: $value");
  //
  //     final response = await http.post(Uri.parse(ApiUrl.getProductListSerialNumber),
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode(
  //             {
  //
  //             }));
  //
  //     print("Status Code>>>: ${response.statusCode}");
  //     print("Raw Response>>>>: ${response.body}");
  //
  //     final data = jsonDecode(response.body);
  //     if (data['isSuccessful'] == 200) {
  //       print('Pending Invoice Data>>>>>>: ${data['data']}');
  //       return (data['data'] as List)
  //           .map(
  //             (e) => GetAllPendingInvoiceData.fromJson(e),
  //       )
  //           .toList();
  //     }
  //     return [];
  //   } catch (e) {
  //     return [];
  //   }
  // }


  static Future<List<ProductModel>> getProductList() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.getProductListUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              {
                'userName': LocalDb.getString(AppConstants.userNameKey),
                'ksbSalesInvoiceId': '',
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

          /// sold to code is user name

          body: jsonEncode({
            'soldToCode': LocalDb.getString(AppConstants.userNameKey),
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

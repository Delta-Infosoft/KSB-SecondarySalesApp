import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/api_url.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
import 'package:ksb_secondary_sales/features/customers/model/customer_model.dart';

import '../../home/view/screens/home.dart';

class CustomerRepository {
  static Future<String> createCustomer(CustomerInsertModel customer) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.insertCustomer),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(customer.toJson()),
      );
      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        Fluttertoast.showToast(msg: 'Customer Inserted Successfully');
        return 'Successfully';
      } else {
        Fluttertoast.showToast(
            msg: (data['message'] ?? 'Something went wrong') ==
                    'GSTNo already exists'
                ? 'Customer already inserted with this GST number'
                : (data['message'] ?? 'Something went wrong'));
        return '';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      return '';
    }
  }

  static Future<List<Customer>> getCustomerById() async {
    // try {
    print('getCustomerById');
    final response = await http.post(
      Uri.parse(ApiUrl.getCustomerById),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': LocalDb.getString(AppConstants.userIdKey)}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = data['data'];
      return jsonData.map((json) => Customer.fromJson(json)).toList();
    } else {
      return [];
    }
    // } catch (e) {
    //   print('e.toString()');
    //   print(e.toString());
    //   return [];
    // }
  }

  static Future<List> getTestListFromGroup(String groupName) async {
    try {
      final response = await http
          .post(Uri.parse(ApiUrl.textListApi), body: {'Group': groupName});
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

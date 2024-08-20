import 'dart:convert';

import 'package:http/http.dart' as http;


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
}
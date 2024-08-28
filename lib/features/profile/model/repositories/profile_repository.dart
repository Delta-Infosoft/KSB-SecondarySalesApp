import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/api_url.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';

import '../../../../core/utils/common_services/helper.dart';
import '../../../auth/model/models/user_model.dart';

class ProfileRepository {
  static Future<Map?> getUserData() async {
    try {
    final response = await http.post(Uri.parse(ApiUrl.getUserByID),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
      'userId':LocalDb.getString(AppConstants.userIdKey)
    }));
    final data = jsonDecode(response.body);
    if(data['isSuccessful']==200){
      return data['data'][0];
    }
    return null;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Opps something went wrong $e');
      return null;
    }
  }
}

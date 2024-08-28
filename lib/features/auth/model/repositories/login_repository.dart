import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/common_services/helper.dart';
import '../../../../core/utils/constants/api_url.dart';
import '../models/user_model.dart';

class LoginRepository {
  static Future<String?> loginWithUserNameAndPass(String userName,String pass) async {
    try {
      final response = await http.post((Uri.parse(ApiUrl.loginUrl)),body: {
        'UserName':userName,
        'Password':pass,
        'FCMId':'jksdf6s8df67'
      }).timeout(1.seconds);

     final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        // Fluttertoast.showToast(msg: 'OTP send to your register mobile number');
        // Fluttertoast.showToast(msg:'Welcome ${(data['data'][0]['FirstName'])??''} ${(data['data'][0]['LastName'])??''}');
        return data['data'][0]['UserId'];
      }
      Fluttertoast.showToast(msg: data['message']??'');
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Opps something went wrong $e');
      return null;
    }
  }

  static Future<String?> senOtpToMobil(String mobileNumber) async {
    try {
      final response = await http.post((Uri.parse('ApiUrl.sendOtpURL')), body: {
        "mobileNumber": mobileNumber.toString(),
      });
      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        // final UserModel userModel = UserModel.fromJson(data['data'][0]);
        Fluttertoast.showToast(
            msg: 'OTP Send To $mobileNumber');
        return 'OTP Send Successfully';
      }
      Fluttertoast.showToast(
          msg: 'Fail to Send OTP');
      return null;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: 'Opps something went wrong $e');
      return null;
    }
  }

}

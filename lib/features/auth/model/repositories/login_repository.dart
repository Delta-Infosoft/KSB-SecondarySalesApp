import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ksb_secondary_sales/core/utils/extentions/string_extentions.dart';

import '../../../../core/utils/common_services/helper.dart';
import '../../../../core/utils/common_services/local_db.dart';
import '../../../../core/utils/constants/api_url.dart';
import '../../../../core/utils/constants/app_constants.dart';
import '../../../../service/fcm_service.dart';
import '../models/user_model.dart';

class LoginRepository {

  /// Returns the logged-in user (with role flags), or null if login failed.
  static Future<UserModel?> loginWithUserNameAndPass(
      String userName,
      String pass,
      bool termsAndCondition,
      ) async {
    try {
      bool isAlreadyLoggedIn = await LocalDb.getBool(AppConstants.isLoggedInKey) ?? false;

      if (!isAlreadyLoggedIn && !termsAndCondition) {
        Fluttertoast.showToast(
          msg: "Please accept Terms and Conditions before login.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }

      // Device push token, so the server can send notifications to this user.
      final fcmId = await FCMService.getToken();

      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        body: {
          'UserName': userName,
          'Password': pass,
          'FCMId': fcmId,
          'isTermsCondition': termsAndCondition.toString() ?? '',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 500 || response.statusCode == 503) {
        Fluttertoast.showToast(
          msg: "Server is down. Please try again later.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }

      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        final user = UserModel.fromJson(
            Map<String, dynamic>.from(data['data'][0] as Map));
        debugPrint('Logged in ${user.userName}: ${user.roles}');
        return user;
      }

      Fluttertoast.showToast(msg: data['message'] ?? '');
      return null;
    } catch (e) {
      print('loginWithUserNameAndPass error : $e');
      Fluttertoast.showToast(msg: 'Oops something went wrong $e');
      return null;
    }
  }


  // static Future<String?> loginWithUserNameAndPass(
  //     String userName, String pass, bool termsAndCondition) async {
  //   try {
  //     if (!termsAndCondition) {
  //       Fluttertoast.showToast(
  //         msg: "Please accept Terms and Conditions before login.",
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //       return null;
  //     }
  //
  //     final response = await http.post(
  //       Uri.parse(ApiUrl.loginUrl),
  //       body: {
  //         'UserName': userName,
  //         'Password': pass,
  //         'FCMId': '',
  //         'isTermsCondition': termsAndCondition.toString(),
  //       },
  //     );
  //
  //     print(response.statusCode);
  //
  //     if (response.statusCode == 500 || response.statusCode == 503) {
  //       Fluttertoast.showToast(
  //         msg: "Server is down. Please try again later.",
  //         toastLength: Toast.LENGTH_LONG,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //       return null;
  //     }
  //
  //     final data = jsonDecode(response.body);
  //     if (data['isSuccessful'] == 200) {
  //       return data['data'][0]['UserId'];
  //     }
  //
  //     Fluttertoast.showToast(msg: data['message'] ?? '');
  //     return null;
  //   } catch (e) {
  //     print('loginWithUserNameAndPass error : $e');
  //     Fluttertoast.showToast(msg: 'Oops something went wrong $e');
  //     return null;
  //   }
  // }


  // static Future<String?> loginWithUserNameAndPass(
  //     String userName, String pass,bool termsAndCondition) async {
  //   try {
  //     final response = await http.post((Uri.parse(ApiUrl.loginUrl)),
  //         body: {'UserName': userName, 'Password': pass, 'FCMId': '','isTermsCondition': true});
  //     print(response.statusCode);
  //     if (response.statusCode == 500 || response.statusCode == 503) {
  //       Fluttertoast.cancel();
  //       Fluttertoast.showToast(
  //         msg: "Server is down. Please try again later.",
  //         toastLength: Toast.LENGTH_LONG,
  //         // gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 3,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //       return null;
  //     }
  //     final data = jsonDecode(response.body);
  //     if (data['isSuccessful'] == 200) {
  //       // Fluttertoast.showToast(msg: 'OTP send to your register mobile number');
  //       // Fluttertoast.showToast(msg:'Welcome ${(data['data'][0]['FirstName'])??''} ${(data['data'][0]['LastName'])??''}');
  //       return data['data'][0]['UserId'];
  //     }
  //     Fluttertoast.showToast(msg: data['message'] ?? '');
  //     return null;
  //   } catch (e) {
  //     print('loginWithUserNameAndPass error : $e');
  //
  //     Fluttertoast.showToast(msg: 'Opps something went wrong $e');
  //     return null;
  //   }
  // }

  static Future<String?> senOtpToMobil(String mobileNumber) async {
    try {
      final response = await http.post((Uri.parse('ApiUrl.sendOtpURL')), body: {
        "mobileNumber": mobileNumber.toString(),
      });
      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == 200) {
        // final UserModel userModel = UserModel.fromJson(data['data'][0]);
        Fluttertoast.showToast(msg: 'OTP Send To $mobileNumber');
        return 'OTP Send Successfully';
      }
      Fluttertoast.showToast(msg: 'Fail to Send OTP');
      return null;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'Opps something went wrong $e');
      return null;
    }
  }
}

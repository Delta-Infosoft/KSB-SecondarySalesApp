import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/common_services/helper.dart';
import '../models/user_model.dart';

class LoginRepository {
  static Future<UserModel?> loginWithUserNameAndPass(String userName,String pass) async {
    try {
      // final response = await http.post((Uri.parse(ApiUrl.loginUrl)),body: {
      //   'UserName':userName,
      //   'Password':pass
      // });

      // Wait function for two second for loading
      await Future.delayed(const Duration(seconds: 2));
      // Map<String, dynamic> data = jsonDecode(response.body);
      Map<String, dynamic> data = {
        'status': '200',
        'message': 'data get',
        'result': {'id': '123', 'name': 'Devang'}
      };
      if (data['status'] == '200') {
        final UserModel userModel = UserModel.fromJson(data['result']);
        Fluttertoast.showToast(msg: 'OTP send to your register mobile number');
        return userModel;
      }
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Opps something went wrong $e');
      //used k print because when we relase the application then normal print
      //functions are also print there value in application background.. so used  if(kDebugMode)
      kPrint(e);
      return null;
    }
  }

}

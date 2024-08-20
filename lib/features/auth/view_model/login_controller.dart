import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/features/auth/view/widgets/otp_verification_dialog.dart';
import 'package:pinput/pinput.dart';

import '../../../core/config/app_route.dart';
import '../../../core/utils/constants/app_constants.dart';
import '../model/models/user_model.dart';
import '../model/repositories/login_repository.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isObSecure = true.obs;
  RxBool isRememberMe = false.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  String otp = '';
  String actualOtp = '';

  verifyOtp(String actualOTP, String otp) {
    bool isSame = otp == actualOTP;
    if (isSame) {
      Get.offAllNamed(AppRoute.dashboard);
      Fluttertoast.showToast(msg: 'OTP Verify successfully');
    } else {
      Fluttertoast.showToast(msg: 'OTP Not Verify');
    }
  }


  Future<String> resendOtp() async {
    Fluttertoast.showToast(msg: 'Otp Resend to register mobile no');
    await LoginRepository.senOtpToMobil('9712268926');
    return '1234';
  }



  onSubmitPress(BuildContext context) async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;
      UserModel? user = await LoginRepository.loginWithUserNameAndPass(
          userNameCtrl.text, passCtrl.text);
      if (user != null) {
        LocalDb.setString(AppConstants.userIdKey, user.id);
        LocalDb.setBool(AppConstants.isLoggedInKey, true);
        LocalDb.setString(AppConstants.userNameKey, userNameCtrl.text);
        await showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) {
            return OtpVerificationDialog(
              '9712268926',
              onOtpVerifyTrigger: (value) {
                verifyOtp('1234', value);
              },
              onResendOtp: () async {
                return resendOtp();
              },
            );
          },
          barrierLabel: '',
          barrierDismissible: false,
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      }
      isLoading.value = false;
    }
  }
}

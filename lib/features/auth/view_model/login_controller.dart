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
  TextEditingController otpCtrl = TextEditingController();
  Timer? timer;
  RxDouble resendSecondTimer = 60.0.obs;
  RxBool resendEnable = false.obs;
  RxBool isOtpVerifying = false.obs;

  startTimer() {
    resendEnable.value = false;
    resendSecondTimer.value = 60.0;
    timer = Timer.periodic(
      1.seconds,
      (_) {
        if (resendSecondTimer.value > 1) {
          resendSecondTimer.value--;
        } else {
          resendEnable.value = true;
          timer?.cancel();
        }
      },
    );
  }

  stopTimer(){
    resendSecondTimer = 60.0.obs;
    resendEnable.value =true;
    timer?.cancel();
  }
  resendOtpTimer(bool isFromForgetPassword) async {
    resendSecondTimer = 60.0.obs;
    resendEnable.value = false;
    // final message = await LoginRepository.senOtpToMobil(mobileCtrl.text);
    // if (message != null) {}
    startTimer();
  }

  verifyOtp(String actualOTP){
   bool isSame = otpCtrl.text==actualOTP;
   if(isSame){
     Get.offAllNamed(AppRoute.dashboard);
     Fluttertoast.showToast(msg: 'OTP Verify successfully');
   }else{
     Fluttertoast.showToast(msg: 'OTP Not Verify');
   }
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
        startTimer();
        await showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const OtpVerificationDialog('1234');
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

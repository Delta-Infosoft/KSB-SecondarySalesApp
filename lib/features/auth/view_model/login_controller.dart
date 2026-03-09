import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/api_url.dart';
import 'package:ksb_secondary_sales/features/auth/model/models/terms_condition_model.dart';
import 'package:ksb_secondary_sales/features/auth/view/widgets/otp_verification_dialog.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_route.dart';
import '../../../core/utils/constants/app_constants.dart';
import '../model/models/user_model.dart';
import '../model/repositories/login_repository.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isObSecure = true.obs;
  RxBool isRememberMe = false.obs;
  RxBool isTermsConditionAccepted = false.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  String otp = '';
  String actualOtp = '';
  String imei = "";

  RxBool shouldShowTermsAndConditions = false.obs;

  @override
  void onInit() {
    // final hasAcceptedBefore = LocalDb.getBool(AppConstants.termsAcceptedDevicesKey) ?? false;
    // shouldShowTermsAndConditions = (!hasAcceptedBefore).obs;
    // getImeiAndCheck();
    super.onInit();
  }

  Future<void> getImeiAndCheck(String username) async {
    imei = (await UniqueIdentifier.serial)!;
    print("IMEI: $imei");

    final key = "$username|$imei";
    final acceptedList =
        LocalDb.getStringList(AppConstants.termsAcceptedDevicesKey) ?? [];
    final alreadyAccepted = acceptedList.contains(key);

    shouldShowTermsAndConditions.value = !alreadyAccepted;

    if (alreadyAccepted) {
      isTermsConditionAccepted.value = true;
    }
  }

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
    await LoginRepository.senOtpToMobil('7984637744');
    return '1234';
  }

  // onSubmitPress(BuildContext context) async {
  //   if (loginFormKey.currentState!.validate()) {
  //     isLoading.value = true;
  //
  //     String? userId = await LoginRepository.loginWithUserNameAndPass(
  //       userNameCtrl.text,
  //       passCtrl.text,
  //       isTermsConditionAccepted.value,
  //     );
  //
  //     if (userId == null) {
  //       isLoading.value = false;
  //       return;
  //     }
  //
  //     // Save login data
  //     LocalDb.setString(AppConstants.userIdKey, userId);
  //     LocalDb.setBool(AppConstants.isLoggedInKey, true);
  //     LocalDb.setString(AppConstants.userNameKey, userNameCtrl.text);
  //
  //     // Save remember me credentials
  //     if (isRememberMe.value || isTermsConditionAccepted.value) {
  //       LocalDb.setString(AppConstants.rememberUserName, userNameCtrl.text);
  //       LocalDb.setString(AppConstants.rememberPasswordKey, passCtrl.text);
  //     }
  //
  //     if (isTermsConditionAccepted.value && shouldShowTermsAndConditions.value) {
  //       final acceptedImeiList = LocalDb.getStringList(AppConstants.termsAcceptedDevicesKey) ?? [];
  //       acceptedImeiList.add(imei);
  //       await LocalDb.setStringList(AppConstants.termsAcceptedDevicesKey, acceptedImeiList);
  //       shouldShowTermsAndConditions.value = false;
  //     }
  //
  //     // Show OTP dialog
  //     await showGeneralDialog(
  //       context: context,
  //       pageBuilder: (context, animation, secondaryAnimation) {
  //         return OtpVerificationDialog(
  //           '7984637744',
  //           onOtpVerifyTrigger: (value) {
  //             verifyOtp('1234', value);
  //           },
  //           onResendOtp: () async {
  //             return resendOtp();
  //           },
  //         );
  //       },
  //       barrierLabel: '',
  //       barrierDismissible: false,
  //       transitionBuilder: (context, animation, secondaryAnimation, child) {
  //         return FadeTransition(
  //           opacity: animation,
  //           child: child,
  //         );
  //       },
  //     );
  //
  //     isLoading.value = false;
  //   }
  // }

  onSubmitPress(BuildContext context) async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;

      await getImeiAndCheck(userNameCtrl.text);

      String? userId = await LoginRepository.loginWithUserNameAndPass(
        userNameCtrl.text,
        passCtrl.text,
        isTermsConditionAccepted.value,
      );
      print('PAssword >>>>${passCtrl.text}');

      if (userId == null) {
        isLoading.value = false;
        return;
      }

      // Save login data
      LocalDb.setString(AppConstants.userIdKey, userId);
      LocalDb.setBool(AppConstants.isLoggedInKey, true);
      LocalDb.setString(AppConstants.userNameKey, userNameCtrl.text);

      // Save remember me credentials
      if (isRememberMe.value || isTermsConditionAccepted.value) {
        LocalDb.setString(AppConstants.rememberUserName, userNameCtrl.text);
        LocalDb.setString(AppConstants.rememberPasswordKey, passCtrl.text);
      }

      // Save accepted terms for user + device
      if (isTermsConditionAccepted.value &&
          shouldShowTermsAndConditions.value) {
        await saveAcceptedUserDevice(userNameCtrl.text, imei);
        shouldShowTermsAndConditions.value = false;
      }

      // Show OTP dialog
      /* await showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return OtpVerificationDialog(
            '7984637744',
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
      ); */

      // Save current app version (used to detect app updates and force re-login)
      try {
        final pkgInfo = await PackageInfo.fromPlatform();
        if (pkgInfo.version.isNotEmpty) {
          await LocalDb.setString(AppConstants.lastAppVersionKey, pkgInfo.version);
        }
      } catch (e) {
        debugPrint('Could not save app version: $e');
      }

      Get.offAllNamed(AppRoute.dashboard);

      isLoading.value = false;
    }
  }

  Future<void> saveAcceptedUserDevice(String username, String imei) async {
    final key = "$username|$imei";
    final list =
        LocalDb.getStringList(AppConstants.termsAcceptedDevicesKey) ?? [];
    if (!list.contains(key)) {
      list.add(key);
      await LocalDb.setStringList(AppConstants.termsAcceptedDevicesKey, list);
    }
  }

  bool shouldShowTerms(String username, String imei) {
    final key = "$username|$imei";
    final list =
        LocalDb.getStringList(AppConstants.termsAcceptedDevicesKey) ?? [];
    return !list.contains(key); // true means show terms
  }

  Future<void> fetchTermsAndConditionPdf() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiUrl.termsAndConditionPDF,
      );

      if (response.statusCode == 200) {
        final data = TermsAndConditionsModel.fromJson(response.data);
        final base64Data = data.data?[0].fileUrl;

        if (base64Data != null && base64Data.isNotEmpty) {
          final cleanedBase64 = base64Data.split(',').last;
          final bytes = base64Decode(cleanedBase64);

          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/terms_and_conditions.pdf');
          await file.writeAsBytes(bytes);

          final result = await OpenFile.open(file.path);
          debugPrint('Open result: ${result.message}');
        } else {
          Get.snackbar('Error', 'No PDF data found');
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching PDF: $e');
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}

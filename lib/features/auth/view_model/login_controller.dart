import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';

import '../../../core/config/app_route.dart';
import '../../../core/utils/constants/app_constants.dart';
import '../model/models/user_model.dart';
import '../model/repositories/login_repository.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isObSecure = true.obs;
  RxBool isRememberMe = true.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  onSubmitPress() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;
      UserModel? user = await LoginRepository.loginWithUserNameAndPass(
          userNameCtrl.text, passCtrl.text);
      if (user != null) {
        LocalDb.setString(AppConstants.userIdKey, user.id);
        LocalDb.setBool(AppConstants.isLoggedInKey, true);
        LocalDb.setString(AppConstants.userNameKey, userNameCtrl.text);
        Get.offAllNamed(AppRoute.dashboard);
      }
      isLoading.value = false;
    }
  }
}

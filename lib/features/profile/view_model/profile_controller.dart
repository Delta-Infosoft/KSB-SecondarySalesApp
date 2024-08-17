import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../auth/model/models/user_model.dart';
import '../model/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  UserModel? userModel;

  getProfileDetail() async {
    isLoading.value = true;
    UserModel? user = await ProfileRepository.getUserData();
    if (user != null) {
      userModel = user;
    }
    isLoading.value = false;
  }
}

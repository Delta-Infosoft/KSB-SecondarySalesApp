import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../auth/model/models/user_model.dart';
import '../model/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  Map? userData;

  getProfileDetail() async {
    isLoading.value = true;
    Map? user = await ProfileRepository.getUserData();
    if (user != null) {
  userData= user;
    }
    isLoading.value = false;
  }
}

import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';

class SplashController extends GetxController {
  init() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (LocalDb.getBool(AppConstants.isLoggedInKey)) {
          Get.offAllNamed(AppRoute.dashboard);
        } else {
          Get.offAllNamed(AppRoute.login);
        }
      }
    );
  }
}

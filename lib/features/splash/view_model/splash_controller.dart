import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  init() {
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        await _checkVersionAndRoute();
      },
    );
  }

  Future<void> _checkVersionAndRoute() async {
    final bool isLoggedIn = LocalDb.getBool(AppConstants.isLoggedInKey);

    if (isLoggedIn) {
      // Check if the app was updated since last login
      final currentVersion = await _getCurrentAppVersion();
      final savedVersion = LocalDb.getString(AppConstants.lastAppVersionKey);

      final bool isNewVersion =
          savedVersion.isNotEmpty && savedVersion != currentVersion;

      if (isNewVersion) {
        // App was updated → force logout
        await LocalDb.setBool(AppConstants.isLoggedInKey, false);
        // Keep rememberMe credentials but clear session
        print(
            '[SplashController] App updated from $savedVersion → $currentVersion. Forcing logout.');
        Get.offAllNamed(AppRoute.login);
        return;
      }

      // Same version, proceed normally
      Get.offAllNamed(AppRoute.dashboard);
    } else {
      Get.offAllNamed(AppRoute.login);
    }
  }

  Future<String> _getCurrentAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (e) {
      print('[SplashController] Could not get package version: $e');
      return '';
    }
  }
}

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_theme.dart';
import 'package:ksb_secondary_sales/core/config/initial_binding.dart';
import 'package:showcaseview/showcaseview.dart';

import 'core/config/app_route.dart';
import 'core/config/app_route_manager.dart';
import 'core/utils/common_services/local_db.dart';
import 'features/sales/view_model/sales_insert_controller.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; // Accept all certs
  }
}

Future<void> main() async {
  await initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  Get.put(SalesInsertController());
  runApp(const KSBSecondarySales());
}

class KSBSecondarySales extends StatelessWidget {
  const KSBSecondarySales({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return ShowCaseWidget(
          builder: (BuildContext context) {
            return child!;
          },
        );
      },
      defaultTransition: Transition.rightToLeftWithFade,
      initialRoute: AppRoute.splash,
      initialBinding: InitialBinding(),
      getPages: AppRouteManager.pages,
    );
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await NotificationService.initialize();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  await LocalDb.initialize();
}

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_theme.dart';
import 'package:ksb_secondary_sales/core/config/initial_binding.dart';
import 'package:ksb_secondary_sales/service/fcm_service.dart';
import 'package:ksb_secondary_sales/service/notification_service.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:showcaseview/showcaseview.dart';

import 'core/config/app_route.dart';
import 'core/config/app_route_manager.dart';
import 'core/utils/common_services/local_db.dart';
import 'features/sales/view_model/sales_insert_controller.dart';
import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Accept all certs
  }
}

Future<void> main() async {
  await initializeApp();

  HttpOverrides.global = MyHttpOverrides();
  Get.put(SalesInsertController());
  runApp(LiquidGlassWidgets.wrap(
    // Material app: follow the Material theme's brightness, not the OS one.
    brightnessResolver: Theme.maybeBrightnessOf,
    child: const KSBSecondarySales(),
  ));
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Must be registered before runApp so background/terminated messages work.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // Create the notification channel before FCM starts delivering messages.
  await LocalNotificationService.initialize();
  await LocalNotificationService.requestPermission();
  await FCMService.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Pre-warm the liquid glass shaders (bottom navigation bar).
  await LiquidGlassWidgets.initialize(enablePerformanceMonitor: false);
  // await NotificationService.initialize();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  await LocalDb.initialize();
}

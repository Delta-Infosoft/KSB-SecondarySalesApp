import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/features/analytics/view_model/analytics_controller.dart';
import 'package:ksb_secondary_sales/features/customer_approval/view/customer_approval_list.dart';
import 'package:ksb_secondary_sales/features/customer_approval/view_model/customer_approval_controller.dart';
import 'package:ksb_secondary_sales/features/auth/view_model/login_controller.dart';
import 'package:ksb_secondary_sales/features/customers/view/customer_view.dart';
import 'package:ksb_secondary_sales/features/customers/view_model/customer_view_controller.dart';
import 'package:ksb_secondary_sales/features/dashboard/view/dashboard.dart';
import 'package:ksb_secondary_sales/features/dashboard/view_model/dashboard_controller.dart';
import 'package:ksb_secondary_sales/features/documents/view/view_documents.dart';
import 'package:ksb_secondary_sales/features/documents/view_model/documents_controller.dart';
import 'package:ksb_secondary_sales/features/home/view_model/home_controller.dart';
import 'package:ksb_secondary_sales/features/profile/view_model/profile_controller.dart';
import 'package:ksb_secondary_sales/features/sales/view/sales_insert.dart';
import 'package:ksb_secondary_sales/features/sales/view/sales_view.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_view_controller.dart';
import 'package:ksb_secondary_sales/features/splash/view/splash.dart';

import '../../features/auth/view/screens/login.dart';
import '../../features/sales/view_model/sales_insert_controller.dart';
import '../../features/splash/view_model/splash_controller.dart';

class AppRouteManager {
  static List<GetPage> pages = [
    GetPage(
        name: AppRoute.splash,
        page: () => const Splash(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => SplashController());
          }
        )),
    GetPage(
        name: AppRoute.customerView,
        page: () => const CustomerListScreen(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => CustomerViewController());
          }
        )),    GetPage(
        name: AppRoute.salesView,
        page: () => const SalesListView(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => SalesViewController());
          },
        )),
    GetPage(
        name: AppRoute.viewDocuments,
        page: () => const ViewDocuments(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => DocumentsController());
          },
        )),
    GetPage(
        name: AppRoute.customerApproval,
        page: () => const CustomerApprovalList(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => CustomerApprovalController());
          },
        )),
    GetPage(
        name: AppRoute.login,
        page: () => const Login(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => LoginController());
          },
        )), GetPage(
      name: AppRoute.salesInsertRoute,
      page: () => const SalesInsert(),
      binding: BindingsBuilder(() {
        Get.create(() => SalesInsertController());
      }),
    ),
    GetPage(
        name: AppRoute.dashboard,
        page: () => const Dashboard(),
        binding: BindingsBuilder(
              () {
            Get.lazyPut(() => DashboardController());
            Get.lazyPut(() => ProfileController());
            Get.lazyPut(() => HomeController());
            Get.lazyPut(() => AnalyticsController());
          },
        )),
  ];

}



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/analytics/view/analytics_dashboard.dart';
import 'package:ksb_secondary_sales/features/auth/model/models/user_model.dart';
import 'package:ksb_secondary_sales/features/dashboard/view/widgets/dashboard_bottombar.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';
import 'package:ksb_secondary_sales/features/profile/view/screens/profile.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../view_model/dashboard_controller.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // The Dashboard tab only shows for users with the `dashboard` view right.
    final showDashboard = AppRights.current().dashboard;

    return Obx(() {
      var tab = controller.selectedTab.value;
      if (tab == DashboardTab.dashboard && !showDashboard) {
        tab = DashboardTab.home;
      }
      final bar = DashboardBottomBar(
        selected: tab,
        showDashboard: showDashboard,
        onSelected: (value) => controller.selectedTab.value = value,
      );
      final page = switch (tab) {
        DashboardTab.home => const Home(),
        DashboardTab.dashboard => const AnalyticsDashboard(),
        DashboardTab.profile => const Profile(),
      };

      // The page runs behind the floating glass bar so the glass has
      // something to refract. Tell the tabs how much of the bottom the bar
      // covers via MediaQuery padding, so their scroll views can pad for it.
      final mq = MediaQuery.of(context);
      final coveredBottom = mq.padding.bottom + bar.preferredSize.height;

      // GlassScaffold is not a Material widget, so without this the bar's
      // labels have no DefaultTextStyle and Flutter draws them with its
      // yellow double-underline "missing style" warning in a fallback font.
      return Material(
        type: MaterialType.transparency,
        child: GlassScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomBar: bar,
          body: MediaQuery(
            data: mq.copyWith(
              padding: mq.padding.copyWith(bottom: coveredBottom),
            ),
            child: page,
          ),
        ),
      );
    });
  }
}

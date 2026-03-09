import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/dashboard/view/widgets/add_Fab.dart';
import 'package:ksb_secondary_sales/features/dashboard/view/widgets/dashboard_bottombar.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';
import 'package:ksb_secondary_sales/features/profile/view/screens/profile.dart';

import '../view_model/dashboard_controller.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return [
            const Home(),
            const Profile()
          ][controller.selectedItemIndex.value];
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: AddFab(),
      bottomNavigationBar: const DashboardBottomBar(),
    );
  }
}

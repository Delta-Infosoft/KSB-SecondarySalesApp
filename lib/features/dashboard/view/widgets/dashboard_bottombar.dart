import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/features/dashboard/view_model/dashboard_controller.dart';

class DashboardBottomBar extends GetView<DashboardController> {
  const DashboardBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return NavigationBar(
          indicatorColor: context.primaryColor,
          onDestinationSelected: (value) {
            controller.selectedItemIndex.value = value;
          },
        selectedIndex: controller.selectedItemIndex.value,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
             NavigationDestination(
              icon: Icon(Icons.home_rounded,color: controller.selectedItemIndex.value==0?Colors.white:null,),
              label: 'Home',
              tooltip: 'Home',
            ),

             NavigationDestination(
                icon: Icon(Icons.person_rounded,color: controller.selectedItemIndex.value==1?Colors.white:null),
                label: 'Profile',
                tooltip: 'Profile'),
          ],
          );
    });

  }
}

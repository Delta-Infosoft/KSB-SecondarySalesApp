import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/dashboard/view_model/dashboard_controller.dart';

class DashboardBottomBar extends GetView<DashboardController> {
  const DashboardBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomAppBar(
        shape: CircularNotchedRectangle(),notchMargin: 15,

        child: Row(
          children: [
        InkWell(
          onTap: (){},
            child: Expanded(child: Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.home_filled))))),

            Expanded(child: Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.person_rounded)))),
      ],),);
    },);
    return Obx(
            () {
        return NavigationBar(
            onDestinationSelected: (value) {
              controller.selectedItemIndex.value=value;
            },
            destinations: const [
          NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.home_filled,color: Colors.transparent,), label: '',enabled: false,),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ], selectedIndex: controller.selectedItemIndex.value);
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/features/dashboard/view_model/dashboard_controller.dart';

class DashboardBottomBar extends GetView<DashboardController> {
  const DashboardBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 15,
          child: Row(
            children: [
              SizedBox(
                width: context.screenWidth * 0.3,
                height: kToolbarHeight,
                child: GestureDetector(
                  onTap: () {
                    controller.selectedItemIndex.value = 0;
                  },
                  // borderRadius: BorderRadius.circular(15),
                  child: Center(
                      child: CircleAvatar(
                    backgroundColor: controller.selectedItemIndex.value == 0
                        ? null
                        : Colors.transparent,
                    child: Icon(
                      Icons.home_filled,
                      color: controller.selectedItemIndex.value == 0
                          ? context.primaryColor
                          : context.colorScheme.secondary,
                    ),
                  )),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: context.screenWidth * 0.3,
                height: kToolbarHeight,
                child: GestureDetector(
                  onTap: () {
                    controller.selectedItemIndex.value = 1;
                  },
                  // borderRadius: BorderRadius.circular(15),
                  child: Center(
                      child: CircleAvatar(
                        backgroundColor: controller.selectedItemIndex.value == 1
                            ? null
                            : Colors.transparent,
                        child: Icon(
                          Icons.person_rounded,
                          color: controller.selectedItemIndex.value == 1
                              ? context.primaryColor
                              : context.colorScheme.secondary,
                        ),
                      )),
                ),
              )
            ],
          ),
        );
      },
    );
    return Obx(() {
      return NavigationBar(
          onDestinationSelected: (value) {
            controller.selectedItemIndex.value = value;
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
            NavigationDestination(
              icon: Icon(
                Icons.home_filled,
                color: Colors.transparent,
              ),
              label: '',
              enabled: false,
            ),
            NavigationDestination(
                icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
          selectedIndex: controller.selectedItemIndex.value);
    });
  }
}

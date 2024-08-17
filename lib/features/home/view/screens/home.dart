import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';

import '../../view_model/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MVVM'),
      ),
      body: Obx(() {
        return Column(
          children: [
            const Divider(
              height: 0,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectedTypeIndex.value = 0;
                    },
                    child: AnimatedContainer(
                      duration: 300.milliseconds,
                      height: 45,
                      alignment: Alignment.center,
                      color: controller.selectedTypeIndex.value == 0
                          ? context.colorScheme.primaryContainer
                          : null,
                      child: const Text(
                        'Insert Data',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.selectedTypeIndex.value = 1;
                      controller.getRecords();
                    },
                    child: AnimatedContainer(
                      duration: 300.milliseconds,
                      height: 45,
                      alignment: Alignment.center,
                      color: controller.selectedTypeIndex.value == 1
                          ? context.colorScheme.primaryContainer
                          : null,
                      child: const Text(
                        'Records',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 0,
            ),
            const Expanded(child: FlutterLogo())
          ],
        );
      }),
    );
  }
}

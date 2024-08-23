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
        title: const Text('KSB Sales'),

      ),
      body: Column(
        children: [
          const Divider(
            height: 0,
          ),

          const Divider(
            height: 0,
          ),

        ],
      ),
    );
  }
}

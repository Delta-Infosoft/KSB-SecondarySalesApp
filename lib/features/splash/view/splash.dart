import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';

import '../../../core/utils/constants/app_assets.dart';
import '../view_model/splash_controller.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Get.find<SplashController>().init();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),),
                clipBehavior: Clip.hardEdge,
                child: FlutterLogo(size: 150,).animate().scale().fadeIn()),
          ],
        ),
      ),
    );
  }
}

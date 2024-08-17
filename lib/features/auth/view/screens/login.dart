import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_assets.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';

import '../../../../core/utils/widgets/tap_to_remove_keyboard_widget.dart';
import '../../view_model/login_controller.dart';
import '../widgets/intro_bottomsheet.dart';
import '../widgets/login_form.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return TapToRemoveKeyboardWidget(
      child: Scaffold(
        bottomSheet:Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
          ),
          child: const OnboardContent(),) ,
        body:Container(
          height: context.screenHeight,
          width: context.screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent,
                Colors.cyanAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15)
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                    AppAssets.ksbLogo,
                    height: 90,
                    width: 90 ,
                ),
              ],
            ),
          ),
          // Y
          // our login screen content here
        )
        ,
      ),
    );
  }
}

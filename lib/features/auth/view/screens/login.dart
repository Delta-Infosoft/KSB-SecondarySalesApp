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

          decoration:  BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor ?? Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
          ),
          child: const OnboardContent(),) ,
        body:Container(
          height: context.screenHeight,
          width: context.screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2B5984), // Darker shade of primary color
                Color(0xFF4090C2)
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            )
          ),
          alignment: Alignment.topCenter,
          child: Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(top: 55,right: 25,left: 25),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Image.asset(
                AppAssets.logoImage,
                fit: BoxFit.fill,
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

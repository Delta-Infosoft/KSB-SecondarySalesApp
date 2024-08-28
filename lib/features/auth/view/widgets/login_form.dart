import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_assets.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';

import '../../../../core/utils/common_services/validator.dart';
import '../../../../core/utils/widgets/common_button.dart';
import '../../../../core/utils/widgets/common_text_input.dart';
import '../../view_model/login_controller.dart';

class LoginForm extends GetView<LoginController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              if(MediaQuery.of(context).viewInsets.bottom > 0)
              30.heightGap,
              const Text(
                'Login With Credential',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              20.heightGap,
              CommonTextInput(
                label: 'Enter Customer Code ',
                controller: controller.userNameCtrl,
                suffixIcon: const Icon(Icons.person,color: Colors.grey,),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                validator: (val) =>
                    nonEmptyValidator(val, "Please enter user name"),
              ),
              15.heightGap,
              CommonTextInput(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                obscureText: controller.isObSecure.value,
                label: 'Enter Password',
                controller: controller.passCtrl,
                validator: (val) =>
                    nonEmptyValidator(val, "Please enter your password"),
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.isObSecure.value =
                          !controller.isObSecure.value;
                    },
                    icon: Icon( Icons.visibility,color: controller.isObSecure.value?Colors.grey:context.primaryColor,)),
              ),
              20.heightGap,
              // Checkbox(value: controller.isRememberMe.value, onChanged: (value) {
              //   controller.isRememberMe.value=!controller.isRememberMe.value;
              // },),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    controller.isRememberMe.value=! controller.isRememberMe.value;
                  },
                  child: Container(
                    width: 23,height: 23,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:  controller.isRememberMe.value ? context.primaryColor : Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: FittedBox(
                      child: Text(
                        controller.isRememberMe.value ? '✓' : '', // Use check icon or empty string based on value
                        style: TextStyle(
                          fontSize: 20,
                          color: context.primaryColor// Change icon color based on value
                        ),
                      ),
                    ),
                  ),
                ),
                Text('  Remember Me',style: TextStyle(fontWeight: FontWeight.w600),)
              ],),
              if(false)
              Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: controller.isRememberMe.value?context.primaryColor:Colors.grey.withOpacity(.1),foregroundColor: controller.isRememberMe.value?Colors.white:null
                    ),
                      onPressed: () {
                        controller.isRememberMe.value=!controller.isRememberMe.value;
                      },
                      icon:  Icon(controller.isRememberMe.value?Icons.check:Icons.remember_me_rounded),
                      label:  Text(controller.isRememberMe.value?'Remembered':'Remember Me'))),
            ],
          ),
        ),
      );
    });
  }
}

class LandingContent extends StatelessWidget {
  const LandingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to KSB\nSecondary Sales App",
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Streamline your sales entry process with our intuitive app. Manage and track your sales effortlessly, all from one place.",
            style: TextStyle(fontSize: 19, color: Colors.blueGrey.shade300),
          ),
        ],
      ),
    );
  }
}

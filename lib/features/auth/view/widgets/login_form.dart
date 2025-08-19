import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_assets.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
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
    bool isLoading = false;
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if(false)
              if (MediaQuery.of(context).viewInsets.bottom > 0) 30.heightGap,
              const Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               8.heightGap,
              const Text(
                'Login credentials same as Dealer Management Portal',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),
              ),

              20.heightGap,
              Autocomplete(
                onSelected: (option) {
                  if (option.isNotEmpty) {
                    controller.userNameCtrl.text = option;
                    controller.passCtrl.text =
                        LocalDb.getString(AppConstants.rememberPasswordKey);
                  }
                },
                optionsBuilder: (textEditingValue) {
                  if (LocalDb.getString(AppConstants.rememberUserName)
                      .isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return [LocalDb.getString(AppConstants.rememberUserName)];
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return CommonTextInput(
                    label: 'Enter Customer Code',
                    controller: textEditingController,
                    focusNode: focusNode,
                    onChange: (value) {
                      controller.userNameCtrl.text = value ?? '';

                      if ((value?.length ?? 0) > 3) {
                        controller.getImeiAndCheck(value ?? '');
                      }
                    },

                    suffixIcon: const Icon(Icons.person, color: Colors.grey),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    validator: (val) =>
                        nonEmptyValidator(val, "Please enter user name"),
                  );
                },
              ),
              if (false)
                CommonTextInput(
                  label: 'Enter Customer Code ',
                  controller: controller.userNameCtrl,
                  suffixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  onTap: () {},
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  validator: (val) =>
                      nonEmptyValidator(val, "Please enter user name"),
                ),
              15.heightGap,

              CommonTextInput(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    icon: Icon(
                      Icons.visibility,
                      color: controller.isObSecure.value
                          ? Colors.grey
                          : context.primaryColor,
                    )),
              ),
              20.heightGap,
              // Checkbox(value: controller.isRememberMe.value, onChanged: (value) {
              //   controller.isRememberMe.value=!controller.isRememberMe.value;
              // },),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.isRememberMe.value =
                          !controller.isRememberMe.value;
                    },
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.isRememberMe.value
                              ? context.primaryColor
                              : Colors.grey,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: FittedBox(
                        child: Text(
                          controller.isRememberMe.value
                              ? '✓'
                              : '', // Use check icon or empty string based on value
                          style: TextStyle(
                              fontSize: 20,
                              color: context
                                  .primaryColor // Change icon color based on value
                              ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '  Remember Me',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),

              15.heightGap,


              Obx(() {
                if (controller.shouldShowTermsAndConditions.value) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.isTermsConditionAccepted.value =
                          !controller.isTermsConditionAccepted.value;
                        },
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.isTermsConditionAccepted.value
                                  ? context.primaryColor
                                  : Colors.grey,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            controller.isTermsConditionAccepted.value ? '✓' : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'I accept the',
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(width: 3),
                              isLoading
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                                  : TextButton(
                                onPressed: () async {
                                  setState(() => isLoading = true);
                                  await controller.fetchTermsAndConditionPdf();
                                  setState(() => isLoading = false);
                                },
                                child: const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )

                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),


              // GestureDetector(
              //   onTap: () {
              //     controller.isTermsConditionAccepted.value =
              //     !controller.isTermsConditionAccepted.value;
              //   },
              //   child: Row(
              //     children: [
              //       Obx(() => Container(
              //         width: 23,
              //         height: 23,
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: controller.isTermsConditionAccepted.value
              //                 ? context.primaryColor
              //                 : Colors.grey,
              //             width: 2.0,
              //           ),
              //           borderRadius: BorderRadius.circular(4.0),
              //         ),
              //         alignment: Alignment.center,
              //         child: Text(
              //           textAlign: TextAlign.center,
              //           controller.isTermsConditionAccepted.value ? '✓' : '',
              //           style: TextStyle(
              //             fontSize: 18,
              //             color: context.primaryColor,
              //           ),
              //         ),
              //       )),
              //       const SizedBox(width: 10),
              //
              //
              //       StatefulBuilder(
              //         builder: (context, setState) {
              //           return Row(
              //             children: [
              //               const Text('I accept the ', style: TextStyle(color: Colors.black)),
              //               isLoading
              //                   ? const SizedBox(
              //                 width: 16,
              //                 height: 16,
              //                 child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              //               )
              //                   : TextButton(
              //                 onPressed: () async {
              //                   setState(() => isLoading = true);
              //                   await controller.fetchTermsAndConditionPdf();
              //                   setState(() => isLoading = false);
              //                 },
              //                 child: const Text(
              //                   'Terms & Conditions',
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.w600,
              //                     decoration: TextDecoration.underline,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           );
              //         },
              //       )
              //
              //       // Flexible(
              //       //   child: RichText(
              //       //     text: TextSpan(
              //       //       children: [
              //       //         const TextSpan(
              //       //           text: 'I accept the ',
              //       //           style: TextStyle(color: Colors.black),
              //       //         ),
              //       //         TextSpan(
              //       //           text: 'Terms & Conditions',
              //       //           style: const TextStyle(
              //       //             fontWeight: FontWeight.w600,
              //       //             color: Colors.blue,
              //       //             decoration: TextDecoration.underline,
              //       //           ),
              //       //           recognizer: TapGestureRecognizer()
              //       //             ..onTap = () {
              //       //               controller.fetchTermsAndConditionPdf();
              //       //             },
              //       //         ),
              //       //       ],
              //       //     ),
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),


              if (false)
                Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: controller.isRememberMe.value
                                ? context.primaryColor
                                : Colors.grey.withOpacity(.1),
                            foregroundColor: controller.isRememberMe.value
                                ? Colors.white
                                : null),
                        onPressed: () {
                          controller.isRememberMe.value =
                              !controller.isRememberMe.value;
                        },
                        icon: Icon(controller.isRememberMe.value
                            ? Icons.check
                            : Icons.remember_me_rounded),
                        label: Text(controller.isRememberMe.value
                            ? 'Remembered'
                            : 'Remember Me'))),
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

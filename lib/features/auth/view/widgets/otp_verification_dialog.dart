import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/auth/view_model/login_controller.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationDialog extends GetView<LoginController> {
  const OtpVerificationDialog(this.actualOtp, {super.key});
  final String actualOtp;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Obx(() {
        return Container(
          // width: context.screenWidth * 0.95,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.white,
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'OTP Verification ',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              3.heightGap,
              const Text(
                'We have sent verification code to',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Text(
                '+91 9712268926',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              20.heightGap,
               Center(
                child: Pinput(
                  autofocus: true,
                  controller: controller.otpCtrl,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (value) {
                    controller.verifyOtp(actualOtp  );

                  },
                  cursor: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: VerticalDivider(),
                  ),
                  length: 4,
                ),
              ),
              10.heightGap,
              TextButton(
                  onPressed: controller.resendEnable.value
                      ? () {
                          controller.startTimer();
                        }
                      : null,
                  child: Text(
                      'Resend Code ${controller.resendEnable.value ? '' : '(${controller.resendSecondTimer.value.round()})'}')),
              16.heightGap,
              Center(
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          foregroundColor: context.colorScheme.onPrimary),
                      onPressed: () {
controller.verifyOtp(actualOtp  );
                      },
                      icon: controller.isOtpVerifying.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const SizedBox(),
                      label: Text(controller.isOtpVerifying.value
                          ? 'OTP Verifying'
                          : 'Verify OTP')))
            ],
          ),
        );
      }),
    );
  }
}

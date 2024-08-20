import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/features/auth/view_model/login_controller.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationController extends GetxController {
  Timer? timer;
  RxDouble resendSecondTimer = 60.0.obs;
  RxBool resendEnable = false.obs;
  RxBool isOtpResending = false.obs;

  startTimer() {
    resendEnable.value = false;
    resendSecondTimer.value = 60.0;
    timer = Timer.periodic(
      1.seconds,
      (_) {
        if (resendSecondTimer.value > 1) {
          resendSecondTimer.value--;
        } else {
          resendEnable.value = true;
          timer?.cancel();
        }
      },
    );
  }

  resendOtp() {}
}

class OtpVerificationDialog extends StatefulWidget {
  const OtpVerificationDialog(this.mobileNo,
      {super.key, required this.onOtpVerifyTrigger, required this.onResendOtp});
  final String mobileNo;
  final Function(String) onOtpVerifyTrigger;
  final Future<String> Function() onResendOtp;

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  late OtpVerificationController controller;
  TextEditingController otpCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = Get.put(OtpVerificationController());
    controller.startTimer();
  }

  @override
  void dispose() {
    otpCtrl.dispose();
    Get.delete<OtpVerificationController>();
    super.dispose();
  }

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
              Text(
                '${widget.mobileNo}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              20.heightGap,
              Center(
                child: Pinput(
                  autofocus: true,
                  controller: otpCtrl,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (value) {
                    widget.onOtpVerifyTrigger(value);
                  },
                  cursor: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: VerticalDivider(),
                  ),
                  length: 4,
                ),
              ),
              10.heightGap,
              TextButton.icon(
                  icon: controller.isOtpResending.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const SizedBox(),
                  onPressed: () async {
                    controller.isOtpResending.value=true;
                 String otp=  await widget.onResendOtp.call();
                 if(otp.isNotEmpty){
                    controller.startTimer();
                 }
                    controller.isOtpResending.value=false;

                  },
                  label: Text(
                      'Resend Code ${controller.resendEnable.value ? '' : '(${controller.resendSecondTimer.value.round()})'}')),
              16.heightGap,
              Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          foregroundColor: context.colorScheme.onPrimary),
                      onPressed: () {
                        widget.onOtpVerifyTrigger(otpCtrl.text);
                      },
                      child: const Text('Verify OTP')))
            ],
          ),
        );
      }),
    );
  }
}

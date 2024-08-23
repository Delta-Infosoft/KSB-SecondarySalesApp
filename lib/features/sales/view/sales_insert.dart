import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/app_date_time_controller.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_button.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_text_input.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/tap_to_remove_keyboard_widget.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';

import '../../../core/utils/common_services/validator.dart';

class SalesInsert extends GetView<SalesInsertController> {
  const SalesInsert({super.key});

  @override
  Widget build(BuildContext context) {
    return TapToRemoveKeyboardWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer Details'),
        ),
        body: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13
                    ),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    readOnly: true,
                    onTap: () async {
                      controller.salesDateCtrl.text =
                          await Get.find<AppDateTimeController>()
                              .pickDate(context, controller.salesDateCtrl.text);
                    },
                    controller: controller.salesDateCtrl,
                    lableWidget: RichText(
                      text: TextSpan(
                        text: 'Sales Date',
                        style: TextStyle(
                            color: context.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  15.heightGap,
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding:  const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                      label: RichText(
                        text: TextSpan(
                            text: 'Select Customer',
                            style: TextStyle(
                                color: context.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            children: const [
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15))
                            ]),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      fillColor: context.primaryColor.withOpacity(.1),
                    ),
                    items: [
                      const DropdownMenuItem(value: '1',child: Text('User 1'),)
                    ],
                    onChanged: (name) {
                      // final selectedAddress = controller.addressList
                      //     .firstWhere((address) => address['Name'] == name);
                      // // controller.laneCtrl.text = selectedAddress['Block'] ?? '';
                      // // controller.streetCtrl.text = selectedAddress['Division'] ?? '';
                      // // controller.landmarkCtrl.text = selectedAddress['BranchType'] ?? '';
                      // controller.cityCtrl.text = selectedAddress['District'] ?? '';
                      // controller.stateCtrl.text = selectedAddress['State'] ?? '';
                      // controller.districtCtrl.text = selectedAddress['District'] ?? '';

                    },
                  ),
                  if(false)
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.nameCtrl,
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'Name',
                          style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          children: const [
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))
                          ]),
                    ),
                    validator: (p0) =>
                        nonEmptyValidator(p0, 'Please enter customer name'),
                  ),
                  15.heightGap,
                  Form(
                    key: controller.mobileNoKey,
                    child: CommonTextInput(
                      filled: true,
                      readOnly: controller.isOtpSendToMobileIsLoading.value,
                      filledColor: context.primaryColor.withOpacity(.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                      customBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      suffixIcon: controller.isOtpSendToMobileIsLoading.value
                          ? const SizedBox(
                              height: 10,
                              width: 10,
                              child: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )))
                          : Stack(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      controller.validateMobileNo(context);
                                    },
                                    icon: const Icon(Icons.call)),
                                Positioned(
                                    top: 10,
                                    right: 10,
                                    child:
                                        controller.isMobileNumberApproved.value
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: context.primaryColor,
                                                  size: 15,
                                                ))
                                            : Icon(
                                                Icons.access_time_filled,
                                                color: context.primaryColor,
                                                size: 15,
                                              )),
                              ],
                            ),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      validator: (p0) => validateMobileNumber(p0),
                      lableWidget: RichText(
                        text: TextSpan(
                            text: 'Mobile Number',
                            style: TextStyle(
                                color: context.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            children: const [
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15))
                            ]),
                      ),
                      controller: controller.mobileNoCtrl,
                    ),
                  ),
                  15.heightGap,
                  Form(
                    key: controller.emailKey,
                    child: CommonTextInput(
                      filled: true,
                      readOnly: controller.isOtpSendToEmailIsLoading.value,
                      filledColor: context.primaryColor.withOpacity(.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                      customBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      suffixIcon: controller.isOtpSendToEmailIsLoading.value
                          ? const SizedBox(
                              height: 10,
                              width: 10,
                              child: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )))
                          : Stack(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      controller.validateEmail(context);
                                    },
                                    icon: const Icon(Icons.mail)),
                                Positioned(
                                    top: 7,
                                    right: 7,
                                    child:
                                        controller.isEmailAddressApprove.value
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: context.primaryColor,
                                                  size: 15,
                                                ))
                                            : Icon(
                                                Icons.access_time_filled,
                                                color: context.primaryColor,
                                                size: 15,
                                              )),
                              ],
                            ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (p0) => validateEmail(p0),
                      lableWidget: RichText(
                        text: TextSpan(
                            text: 'Email',
                            style: TextStyle(
                                color: context.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            children: const [
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15))
                            ]),
                      ),
                      controller: controller.emailCtrl,
                    ),
                  ),
                  15.heightGap,
                  Text(
                    'Customer Address',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: context.primaryColor),
                  ),
                  15.heightGap,
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.houseAndCityNameCtrl,
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'House Name, Building Name',
                          style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          children: const [
                            TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))
                          ]),
                    ),
                    validator: (p0) =>
                        nonEmptyValidator(p0, 'Please enter customer address'),
                  ),
                  15.heightGap,
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.areaStreetCtrl,
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'Area, Street Name',
                          style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          children: const [
                            TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))
                          ]),
                    ),
                    validator: (p0) =>
                        nonEmptyValidator(p0, 'Please enter area or street name'),
                  ),
                  15.heightGap,
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: Colors.transparent),
                    ),
                    label: "Pin Code*",
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'Pin Code',
                          style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          children: const [
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))
                          ]),
                    ),
                    maxLength: 6,
                    onChange: (p0) {
                      if (p0 != null && p0.length == 6) {
                        controller.getDataFromPinCode(p0);
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*$')),
                    ],
                    controller: controller.pinCodeCtrl,
                    suffixIcon: controller.isPinCodeDataLoading.value
                        ? SizedBox(
                      height: 10,
                      width: 10,
                      child: Stack(
                        children: [
                          const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          Center(
                              child: Icon(
                                Icons.pin_drop,
                                color: context.primaryColor,
                              )),
                        ],
                      ),
                    )
                        : Icon(
                      Icons.pin_drop,
                      color: context.primaryColor,
                    ),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Please enter pin code';
                      } else if (p0.trim().length < 6) {
                        return 'Pin code must be 6 digit long';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    labelStyle: TextStyle(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  15.heightGap,
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13
                    ),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.stateCtrl,
                    validator: (p0) =>
                        nonEmptyValidator(p0, "Please enter state"),
                    label: "State*",
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'State',
                          style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          children: const [
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))
                          ]),
                    ),
                    labelStyle: TextStyle(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  15.heightGap,
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.talukaCtrl,
                    validator: (p0) =>
                        nonEmptyValidator(p0, "Please enter taluka"),
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'Taluka',
                          style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          children: const [
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))
                          ]),
                    ),
                    labelStyle: TextStyle(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),

                  15.heightGap,
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.districtCtrl,
                    validator: (p0) =>
                        nonEmptyValidator(p0, "Please enter district"),
                    label: "District*",
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'District',
                          style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                          children: const [
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))
                          ]),
                    ),
                    labelStyle: TextStyle(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  15.heightGap,
                  CommonButton(child: Text('Submit',style: TextStyle(color: context.colorScheme.onPrimary,fontSize: 16),), onPressed: (){},borderRadius: 10,backgroundColor: context.primaryColor,)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

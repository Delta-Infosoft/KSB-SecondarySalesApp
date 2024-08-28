import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/app_date_time_controller.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_button.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_text_input.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/tap_to_remove_keyboard_widget.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';
import '../../../core/utils/common_services/validator.dart';

class SalesInsert extends StatefulWidget {
  const SalesInsert({super.key});

  @override
  State<SalesInsert> createState() => _SalesInsertState();
}

class _SalesInsertState extends State<SalesInsert> {
  final controller = Get.find<SalesInsertController>();
  @override
  void initState() {
    super.initState();
    controller.getCustomerList();
  }
  @override
  Widget build(BuildContext context) {
    return TapToRemoveKeyboardWidget(
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
              text: const TextSpan(
                  text: 'Sales Insert',
                  style: TextStyle(fontSize: 18),
                  children: [TextSpan(text: '(Customer Details)')])),
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
                        horizontal: 15, vertical: 13),
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
                  if(false)
                  DropdownButtonFormField(
                    // validator: (value) => nonEmptyValidator(value, 'Please select customer'),
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13
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
                        suffixIcon: controller.isCustomerLoading.value
                            ? const SizedBox(
                            height: 10,
                            width: 10,
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 3),
                                )))
                            :null,
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
                    items: controller.customersList.map(
                      (e) {
                        return DropdownMenuItem(
                          value: e.customerId,
                          child: Text(e.customerName),
                        );
                      },
                    ).toList(),
                    onChanged: (cId) {
                      if (cId != null && cId.isNotEmpty) {
                        Customer c = controller.customersList
                            .firstWhere((c) => c.customerId == cId);
                        controller.contactList = c.contacts.where((element) => element.name.trim().isNotEmpty,).toList();
                        controller.gstNoController.text = c.gstNo;
                        controller.nameCtrl.text = c.addressName;
                        controller.pinCodeCtrl.text = c.pinCode;
                        controller.streetCtrl.text = c.street;
                        controller.cityCtrl.text = c.city;
                        controller.districtCtrl.text = c.district;
                        controller.stateCtrl.text = c.state;
                        controller.countryCtrl.text = c.country;
                        setState(() {
                        });
                      }
                    },
                  ),
                  DropdownMenu(
                    enableFilter: true,

                    enabled: true,
                    enableSearch: true,
                    width: context.screenWidth*0.92,
                    menuHeight: 300,
                    requestFocusOnTap: true,
                    initialSelection: controller.selectedCustomerId.value.isNotEmpty?controller.selectedCustomerId.value:null,

                    trailingIcon: controller.isCustomerLoading.value
                        ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                  strokeWidth: 3),
                            )))
                        :null,
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

                    // validator: (value) => nonEmptyValidator(value, 'Please select customer'),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,

                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13
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
                    dropdownMenuEntries: controller.customersList.map(
                          (e) {
                        return DropdownMenuEntry(
                          value: e.customerId,
                          label: e.customerName,
                        );
                      },
                    ).toList(),
                    onSelected: (cId) {
                      if (cId != null && cId.isNotEmpty) {
                        Customer c = controller.customersList
                            .firstWhere((c) => c.customerId == cId);
                        // controller.contactDDKey.currentState?.reset();
                        // controller.contactList.clear();
                        // controller.  selectedContactName='';
                        // controller.mobileNoCtrl.clear();
                        // controller.emailCtrl.clear();
                        // controller.contactList = c.contacts.where((element) => element.name.trim().isNotEmpty,).toList();
                        controller.mobileNoCtrl.text = c.contacts.firstOrNull?.phone??'';
                        controller.emailCtrl.text = c.contacts.firstOrNull?.email??'';
                        controller.gstNoController.text = c.gstNo;
                        controller.nameCtrl.text = c.addressName;
                        controller.pinCodeCtrl.text = c.pinCode;
                        controller.streetCtrl.text = c.street;
                        controller.cityCtrl.text = c.city;
                        controller.districtCtrl.text = c.district;
                        controller.stateCtrl.text = c.state;
                        controller.countryCtrl.text = c.country;
                        controller.selectedLandMark.value=c.landMark;
                        controller.getDataFromPinCode(c.pinCode);
                        setState(() {
                        });
                      }
                    },
                  ),
                  15.heightGap,
                  // if(false)
                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.gstNoController,
                    maxLength: 15,
                    validator: (p0) => lengthValidator(
                        p0,
                        15,
                        'Please enter GST number',
                        'GST number must be 15-digit alphanumeric code'),
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'GST Number',
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

                  // 15.heightGap,
                  // DropdownButtonFormField(
                  //   key: controller.contactDDKey,
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //       horizontal: 15,
                  //       vertical: 13,
                  //     ),
                  //     label: RichText(
                  //       text: TextSpan(
                  //           text: 'Select Customer Contact',
                  //           style: TextStyle(
                  //               color: context.primaryColor,
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 15),
                  //           children: const [
                  //             TextSpan(
                  //                 text: '*',
                  //                 style: TextStyle(
                  //                     color: Colors.red,
                  //                     fontWeight: FontWeight.w500,
                  //                     fontSize: 15))
                  //           ]),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.transparent),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.transparent),
                  //     ),
                  //     fillColor: context.primaryColor.withOpacity(.1),
                  //   ),
                  //   items: controller.contactList
                  //       .map((e) => DropdownMenuItem(
                  //             value: e.name,
                  //             child: Text(e.name),
                  //           ))
                  //       .toList(),
                  //   onChanged: (name) {
                  //     if (name == null && (name?.isEmpty ?? false)) return;
                  //     final contact = controller.contactList.firstWhere((n) => n.name==name);
                  //   controller.  selectedContactName = name;
                  //     controller.mobileNoCtrl.text = contact.phone;
                  //     controller.emailCtrl.text = contact.email;
                  //   }
                  // ),
                  15.heightGap,
                  Form(
                    key: controller.mobileNoKey,
                    child: CommonTextInput(
                      filled: true,
                      readOnly: controller.isOtpSendToMobileIsLoading.value,
                      filledColor: context.primaryColor.withOpacity(.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13
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
                                  strokeWidth: 3),
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
                        vertical: 13
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
                                    child: controller.isEmailAddressApprove.value
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
                                                size: 15
                                    ))
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
                    'Customer Address Address',
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
                    controller: controller.nameCtrl,
                    validator: (p0) =>
                        nonEmptyValidator(p0, "Please enter name"),
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
                      borderSide: const BorderSide(color: Colors.transparent),
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
                      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
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
                  DropdownButtonFormField(
                    menuMaxHeight: 300,
                    key: controller.landMarkDdKey,
                    value: controller.selectedLandMark.value.isEmpty?null:controller.selectedLandMark.value,
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                      label: RichText(
                        text: TextSpan(
                            text: 'Select LandMark',
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
                    items: controller.addressList.map(
                      (e) {
                        return DropdownMenuItem(
                            value: e['Name'].toString(),
                            child: Text(e['Name'] ?? ''));
                      },
                    ).toList(),
                    onChanged: (name) {
                      final selectedAddress = controller.addressList
                          .firstWhereOrNull((address) => address['Name'] == name);
                      if(selectedAddress==null)return;
                      controller.selectedLandMark.value = name ?? '';
                      // controller.laneCtrl.text = selectedAddress['Block'] ?? '';
                      // controller.streetCtrl.text = selectedAddress['Division'] ?? '';
                      // controller.landmarkCtrl.text = selectedAddress['BranchType'] ?? '';
                      controller.cityCtrl.text =
                          selectedAddress['District'] ?? '';
                      controller.stateCtrl.text =
                          selectedAddress['State'] ?? '';
                      controller.districtCtrl.text =
                          selectedAddress['District'] ?? '';
                      controller.countryCtrl.text =
                          selectedAddress['Country'] ?? '';
                    },
                  ),
                  15.heightGap,
                  // 378
                  //

                  CommonTextInput(
                    filled: true,
                    filledColor: context.primaryColor.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.streetCtrl,
                    validator: (p0) =>
                        nonEmptyValidator(p0, "Please enter street"),
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'Street',
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
                  // if(false)
                  //   ...[
                  //     15.heightGap,
                  //     CommonTextInput(
                  //       filled: true,
                  //       filledColor: context.primaryColor.withOpacity(.1),
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 15, vertical: 13),
                  //       customBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: const BorderSide(color: Colors.transparent),
                  //       ),
                  //       controller: controller.landmarkCtrl,
                  //       validator: (p0) =>
                  //           nonEmptyValidator(p0, "Please enter landmark"),
                  //       lableWidget: RichText(
                  //         text: TextSpan(
                  //             text: 'Landmark',
                  //             style: TextStyle(
                  //                 color: context.primaryColor,
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 15),
                  //             children: const [
                  //               TextSpan(
                  //                   text: '*',
                  //                   style: TextStyle(
                  //                       color: Colors.red,
                  //                       fontWeight: FontWeight.w500,
                  //                       fontSize: 15))
                  //             ]),
                  //       ),
                  //       labelStyle: TextStyle(
                  //           color: context.primaryColor,
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 15),
                  //     ),
                  //   ],
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
                    controller: controller.cityCtrl,
                    validator: (p0) =>
                        nonEmptyValidator(p0, "Please enter city"),
                    lableWidget: RichText(
                      text: TextSpan(
                          text: 'City',
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
                        horizontal: 15, vertical: 13),
                    customBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    controller: controller.districtCtrl,
                    validator: (p0) =>
                        nonEmptyValidator(p0, "Please enter district"),
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
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextInput(
                          filled: true,
                          filledColor: context.primaryColor.withOpacity(.1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 13),
                          customBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          controller: controller.stateCtrl,
                          validator: (p0) =>
                              nonEmptyValidator(p0, "Please enter state"),
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
                      ),
                      15.widthGap,
                      Expanded(
                        child: CommonTextInput(
                          filled: true,
                          filledColor: context.primaryColor.withOpacity(.1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 13),
                          customBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          controller: controller.countryCtrl,
                          validator: (p0) =>
                              nonEmptyValidator(p0, "Please enter country"),
                          lableWidget: RichText(
                            text: TextSpan(
                                text: 'Country',
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
                      ),
                    ],
                  ),
                  15.heightGap,
                  15.heightGap,
                  CommonButton(
                    isLoading: controller.isSubmitLoading.value,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: context.colorScheme.onPrimary, fontSize: 16),
                    ),
                    onPressed: () {
                      controller.submitSalesEntry();
                    },
                    borderRadius: 10,
                    backgroundColor: context.primaryColor,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

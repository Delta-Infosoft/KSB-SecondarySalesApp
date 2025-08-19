import 'package:dropdown_search/dropdown_search.dart';
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
import 'package:ksb_secondary_sales/features/sales/view/widgets/filter_item_selection_bottomsheet.dart';
import 'package:ksb_secondary_sales/features/sales/view_model/sales_insert_controller.dart';
import '../../../core/utils/common_services/validator.dart';

class SalesInsert extends StatefulWidget {
  const SalesInsert({super.key});

  @override
  State<SalesInsert> createState() => _SalesInsertState();
}

class _SalesInsertState extends State<SalesInsert> {
  late final SalesInsertController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<SalesInsertController>();

    final showDropdown = Get.arguments?['showSerialDropdown'] ?? false;
    controller.setSerialDropdownVisibility(showDropdown);
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
                  if (false)
                    // DropdownButtonFormField(
                    //   // validator: (value) => nonEmptyValidator(value, 'Please select customer'),
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     contentPadding: const EdgeInsets.symmetric(
                    //         horizontal: 15, vertical: 13),
                    //     label: RichText(
                    //       text: TextSpan(
                    //           text: 'Select Customer',
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
                    //     suffixIcon: controller.isCustomerLoading.value
                    //         ? const SizedBox(
                    //             height: 10,
                    //             width: 10,
                    //             child: Center(
                    //                 child: Padding(
                    //               padding: EdgeInsets.all(8.0),
                    //               child:
                    //                   CircularProgressIndicator(strokeWidth: 3),
                    //             )))
                    //         : null,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide:
                    //           const BorderSide(color: Colors.transparent),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide:
                    //           const BorderSide(color: Colors.transparent),
                    //     ),
                    //     fillColor: context.primaryColor.withOpacity(.1),
                    //   ),
                    //   items: controller.customersList.map(
                    //     (e) {
                    //       return DropdownMenuItem(
                    //         value: e.customerId,
                    //         child: Text(e.customerName),
                    //       );
                    //     },
                    //   ).toList(),
                    //   onChanged: (cId) {
                    //     if (cId != null && cId.isNotEmpty) {
                    //       Customer c = controller.customersList
                    //           .firstWhere((c) => c.customerId == cId);
                    //       controller.contactList = c.contacts
                    //           .where(
                    //             (element) => element.name.trim().isNotEmpty,
                    //           )
                    //           .toList();
                    //       controller.gstNoController.text = c.gstNo;
                    //       controller.nameCtrl.text = c.addressName;
                    //       controller.pinCodeCtrl.text = c.pinCode;
                    //       controller.streetCtrl.text = c.street;
                    //       controller.cityCtrl.text = c.city;
                    //       controller.districtCtrl.text = c.district;
                    //       controller.stateCtrl.text = c.state;
                    //       controller.countryCtrl.text = c.country;
                    //       setState(() {});
                    //     }
                    //   },
                    // ),
                  DropdownMenu(
                    enableFilter: true,

                    enabled: true,
                    enableSearch: true,
                    width: context.screenWidth * 0.92,
                    menuHeight: 300,
                    requestFocusOnTap: true,
                    initialSelection:
                        controller.selectedCustomerId.value.isNotEmpty
                            ? controller.selectedCustomerId.value
                            : null,

                    trailingIcon: controller.isCustomerLoading.value
                        ? const SizedBox(
                            height: 10,
                            width: 10,
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )))
                        : null,
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
                          horizontal: 15, vertical: 13),
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
                    dropdownMenuEntries: controller.customersList.map((e) {
                      return DropdownMenuEntry(
                        value: e.customerId,
                        label: e.customerName,
                      );
                    }).toList(),
                    onSelected: (cId) {
                      if (cId != null && cId.isNotEmpty) {
                        controller.selectedCustomerId.value = cId;
                        Customer? c = controller.customersList
                            .firstWhereOrNull((c) => c.customerId == cId);
                        if (c == null) return;
                        // controller.contactDDKey.currentState?.reset();
                        controller.contactList.clear();
                        controller.selectedContactName = '';
                        controller.mobileNoCtrl.clear();
                        controller.emailCtrl.clear();
                        controller.contactList = c.contacts
                            .where(
                              (element) => element.name.trim().isNotEmpty,
                            )
                            .toList();
                        // controller.mobileNoCtrl.text = c.contacts.firstOrNull?.phone??'';
                        // controller.emailCtrl.text = c.contacts.firstOrNull?.email??'';
                        controller.gstNoController.text = c.gstNo;
                        controller.nameCtrl.text = c.addressName;
                        controller.pinCodeCtrl.text = c.pincode;
                        controller.streetCtrl.text = c.street;
                        controller.cityCtrl.text = c.city;
                        controller.districtCtrl.text = c.district;
                        controller.stateCtrl.text = c.state;
                        controller.countryCtrl.text = c.country;
                        controller.selectedLandMark.value = c.landMark;
                        controller.getDataFromPinCode(c.pincode);
                        setState(() {});
                      }
                    },
                  ),


                  // DropdownMenu(
                  //   enableFilter: true,
                  //
                  //   enabled: true,
                  //   enableSearch: true,
                  //   width: context.screenWidth * 0.92,
                  //   menuHeight: 300,
                  //   requestFocusOnTap: true,
                  //   initialSelection:
                  //   controller.selectedCustomerId.value.isNotEmpty
                  //       ? controller.selectedCustomerId.value
                  //       : null,
                  //
                  //   trailingIcon: controller.isCustomerLoading.value
                  //       ? const SizedBox(
                  //       height: 10,
                  //       width: 10,
                  //       child: Center(
                  //           child: Padding(
                  //             padding: EdgeInsets.all(8.0),
                  //             child: CircularProgressIndicator(strokeWidth: 3),
                  //           )))
                  //       : null,
                  //   label: RichText(
                  //     text: TextSpan(
                  //         text: 'Select Customer',
                  //         style: TextStyle(
                  //             color: context.primaryColor,
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 15),
                  //         children: const [
                  //           TextSpan(
                  //               text: '*',
                  //               style: TextStyle(
                  //                   color: Colors.red,
                  //                   fontWeight: FontWeight.w500,
                  //                   fontSize: 15))
                  //         ]),
                  //   ),
                  //
                  //   // validator: (value) => nonEmptyValidator(value, 'Please select customer'),
                  //   inputDecorationTheme: InputDecorationTheme(
                  //     filled: true,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 13),
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
                  //   dropdownMenuEntries: controller.customersList.map((e) {
                  //     return DropdownMenuEntry(
                  //       value: e.customerId,
                  //       label: e.customerName,
                  //     );
                  //   }).toList(),
                  //   onSelected: (cId) {
                  //     if (cId != null && cId.isNotEmpty) {
                  //       controller.selectedCustomerId.value = cId;
                  //       Customer? c = controller.customersList
                  //           .firstWhereOrNull((c) => c.customerId == cId);
                  //       if (c == null) return;
                  //       // controller.contactDDKey.currentState?.reset();
                  //       controller.contactList.clear();
                  //       controller.selectedContactName = '';
                  //       controller.mobileNoCtrl.clear();
                  //       controller.emailCtrl.clear();
                  //       controller.contactList = c.contacts
                  //           .where(
                  //             (element) => element.name.trim().isNotEmpty,
                  //       )
                  //           .toList();
                  //       // controller.mobileNoCtrl.text = c.contacts.firstOrNull?.phone??'';
                  //       // controller.emailCtrl.text = c.contacts.firstOrNull?.email??'';
                  //       controller.gstNoController.text = c.gstNo;
                  //       controller.nameCtrl.text = c.addressName;
                  //       controller.pinCodeCtrl.text = c.pincode;
                  //       controller.streetCtrl.text = c.street;
                  //       controller.cityCtrl.text = c.city;
                  //       controller.districtCtrl.text = c.district;
                  //       controller.stateCtrl.text = c.state;
                  //       controller.countryCtrl.text = c.country;
                  //       controller.selectedLandMark.value = c.landMark;
                  //       controller.getDataFromPinCode(c.pincode);
                  //       setState(() {});
                  //     }
                  //   },
                  // ),

                  InkWell(
                    onTap: () async {
                      final selectedCustomer = await _showCustomerSelectionSheet(context);
                      if (selectedCustomer != null) {
                        controller.selectedCustomerId.value = selectedCustomer.customerId;
                        controller.selectedContactName = selectedCustomer.customerName;

                        // Fill other fields based on selected customer
                        controller.contactList.clear();
                        controller.mobileNoCtrl.clear();
                        controller.emailCtrl.clear();
                        controller.contactList = selectedCustomer.contacts
                            .where((element) => element.name.trim().isNotEmpty)
                            .toList();

                        controller.gstNoController.text = selectedCustomer.gstNo;
                        controller.nameCtrl.text = selectedCustomer.addressName;
                        controller.pinCodeCtrl.text = selectedCustomer.pincode;
                        controller.streetCtrl.text = selectedCustomer.street;
                        controller.cityCtrl.text = selectedCustomer.city;
                        controller.districtCtrl.text = selectedCustomer.district;
                        controller.stateCtrl.text = selectedCustomer.state;
                        controller.countryCtrl.text = selectedCustomer.country;
                        controller.selectedLandMark.value = selectedCustomer.landMark;
                        controller.getDataFromPinCode(selectedCustomer.pincode);
                        setState(() {});
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Select Customer *',
                        filled: true,
                        fillColor: context.primaryColor.withOpacity(.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                      ),
                      child: Text(
                        controller.selectedCustomerId.value.isEmpty
                            ? 'Tap to select'
                            : controller.selectedContactName,
                      ),
                    ),
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
                  // DropdownButtonFormField<String>(
                  //   key: controller.contactDDKey,
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  //     label: RichText(
                  //       text: TextSpan(
                  //         text: 'Select Customer Contact',
                  //         style: TextStyle(
                  //           color: context.primaryColor,
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 15,
                  //         ),
                  //         children: const [
                  //           TextSpan(
                  //             text: '*',
                  //             style: TextStyle(
                  //               color: Colors.red,
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 15,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     fillColor: context.primaryColor.withOpacity(.1),
                  //   ),
                  //   value: controller.contactList
                  //       .any((e) => e.name == controller.selectedContactName)
                  //       ? controller.selectedContactName
                  //       : null,
                  //   items: controller.contactList
                  //       .map((e) => DropdownMenuItem<String>(
                  //     value: e.name,
                  //     child: Text(e.name),
                  //   ))
                  //       .toList(),
                  //   onChanged: (name) {
                  //     if (name == null || name.isEmpty) return;
                  //     final contact = controller.contactList
                  //         .firstWhere((n) => n.name == name, orElse: () => Contact(name: '', phone: '', email: '', department: '', designation: ''));
                  //     controller.selectedContactName = name;
                  //     controller.mobileNoCtrl.text = contact.phone;
                  //     controller.emailCtrl.text = contact.email;
                  //   },
                  // ),

                  // InkWell(
                  //   onTap: () => _showContactFilterSheet(context),
                  //   child: InputDecorator(
                  //     decoration: InputDecoration(
                  //       labelText: 'Select Customer Contact *',
                  //       filled: true,
                  //       fillColor: context.primaryColor.withOpacity(.1),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  //     ),
                  //     child: Text(controller.selectedContactName.isEmpty
                  //         ? 'Tap to select'
                  //         : controller.selectedContactName),
                  //   ),
                  // ),

                  15.heightGap,
                  // Form(
                  //   key: controller.mobileNoKey,
                  //   child: CommonTextInput(
                  //     filled: true,
                  //     readOnly: controller.isOtpSendToMobileIsLoading.value,
                  //     filledColor: context.primaryColor.withOpacity(.1),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 13),
                  //     customBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.transparent),
                  //     ),
                  //     suffixIcon: controller.isOtpSendToMobileIsLoading.value
                  //         ? const SizedBox(
                  //             height: 10,
                  //             width: 10,
                  //             child: Center(
                  //                 child: Padding(
                  //               padding: EdgeInsets.all(8.0),
                  //               child:
                  //                   CircularProgressIndicator(strokeWidth: 3),
                  //             )))
                  //         : Stack(
                  //             children: [
                  //               IconButton(
                  //                   onPressed: () {
                  //                     controller.validateMobileNo(context);
                  //                   },
                  //                   icon: const Icon(Icons.call)),
                  //               Positioned(
                  //                   top: 10,
                  //                   right: 10,
                  //                   child:
                  //                       controller.isMobileNumberApproved.value
                  //                           ? Container(
                  //                               decoration: const BoxDecoration(
                  //                                 shape: BoxShape.circle,
                  //                                 color: Colors.white,
                  //                               ),
                  //                               child: Icon(
                  //                                 Icons.check_circle,
                  //                                 color: context.primaryColor,
                  //                                 size: 15,
                  //                               ))
                  //                           : Icon(
                  //                               Icons.access_time_filled,
                  //                               color: context.primaryColor,
                  //                               size: 15,
                  //                             )),
                  //             ],
                  //           ),
                  //     keyboardType: TextInputType.number,
                  //     maxLength: 10,
                  //     validator: (p0) => validateMobileNumber(p0),
                  //     lableWidget: RichText(
                  //       text: TextSpan(
                  //           text: 'Mobile Number',
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
                  //     controller: controller.mobileNoCtrl,
                  //   ),
                  // ),
                  // 15.heightGap,
                  // Form(
                  //   key: controller.emailKey,
                  //   child: CommonTextInput(
                  //     filled: true,
                  //     readOnly: controller.isOtpSendToEmailIsLoading.value,
                  //     filledColor: context.primaryColor.withOpacity(.1),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 13),
                  //     customBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //       borderSide: const BorderSide(color: Colors.transparent),
                  //     ),
                  //     suffixIcon: controller.isOtpSendToEmailIsLoading.value
                  //         ? const SizedBox(
                  //             height: 10,
                  //             width: 10,
                  //             child: Center(
                  //                 child: Padding(
                  //               padding: EdgeInsets.all(8.0),
                  //               child: CircularProgressIndicator(
                  //                 strokeWidth: 3,
                  //               ),
                  //             )))
                  //         : Stack(
                  //             children: [
                  //               IconButton(
                  //                   onPressed: () {
                  //                     controller.validateEmail(context);
                  //                   },
                  //                   icon: const Icon(Icons.mail)),
                  //               Positioned(
                  //                   top: 7,
                  //                   right: 7,
                  //                   child:
                  //                       controller.isEmailAddressApprove.value
                  //                           ? Container(
                  //                               decoration: const BoxDecoration(
                  //                                 shape: BoxShape.circle,
                  //                                 color: Colors.white,
                  //                               ),
                  //                               child: Icon(
                  //                                 Icons.check_circle,
                  //                                 color: context.primaryColor,
                  //                                 size: 15,
                  //                               ))
                  //                           : Icon(Icons.access_time_filled,
                  //                               color: context.primaryColor,
                  //                               size: 15))
                  //             ],
                  //           ),
                  //     keyboardType: TextInputType.emailAddress,
                  //     validator: (p0) => validateEmail(p0),
                  //     lableWidget: RichText(
                  //       text: TextSpan(
                  //           text: 'Email',
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
                  //     controller: controller.emailCtrl,
                  //   ),
                  // ),
                  // 15.heightGap,
                  Text(
                    'Customer Address',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: context.primaryColor),
                  ),
                  15.heightGap,
                  IgnorePointer(
                    child: CommonTextInput(
                      filled: true,
                      readOnly: true,
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
                  ),
                  15.heightGap,
                  IgnorePointer(
                    child: CommonTextInput(
                      filled: true,
                      readOnly: true,
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
                      suffixIcon:
                          // controller.isPinCodeDataLoading.value
                          false
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
                  ),
                  if (false) ...[
                    15.heightGap,
                    DropdownButtonFormField(
                      menuMaxHeight: 300,
                      key: controller.landMarkDdKey,
                      value: controller.selectedLandMark.value.isEmpty
                          ? null
                          : controller.selectedLandMark.value,
                      validator: (val) =>
                          nonEmptyValidator(val, "Please select land mark"),
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
                                    text: '',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15))
                              ]),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
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
                            .firstWhereOrNull(
                                (address) => address['Name'] == name);
                        if (selectedAddress == null) return;
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
                  ],
                  15.heightGap,
                  // 378
                  //

                  IgnorePointer(
                    child: CommonTextInput(
                      filled: true,
                      readOnly: true,
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
                  IgnorePointer(
                    child: CommonTextInput(
                      filled: true,
                      readOnly: true,
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
                  ),
                  15.heightGap,
                  IgnorePointer(
                    child: CommonTextInput(
                      filled: true,
                      readOnly: true,
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
                  ),

                  15.heightGap,
                  Row(
                    children: [
                      Expanded(
                        child: IgnorePointer(
                          child: CommonTextInput(
                            filled: true,
                            readOnly: true,
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
                      ),
                      15.widthGap,
                      Expanded(
                        child: IgnorePointer(
                          child: CommonTextInput(
                            filled: true,
                            readOnly: true,
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
                      ),
                    ],
                  ),

                  15.heightGap,

                  // Obx(() {
                  //   if (controller.showSerialDropdown.value) {
                  //     return DropdownSearch<ProductModel>.multiSelection(
                  //       compareFn: (a, b) => a.serialNumber == b.serialNumber,
                  //       items: (String filter, LoadProps? loadProps) async {
                  //         final all = controller.products;
                  //         if (filter.isEmpty) return all;
                  //         return all
                  //             .where((i) => i.serialNumber
                  //             .toLowerCase()
                  //             .contains(filter.toLowerCase()))
                  //             .toList();
                  //       },
                  //       selectedItems: controller.products
                  //           .where((product) => controller.serialNumberList.any(
                  //               (serial) => serial.name == product.serialNumber && serial.isSelected))
                  //           .toList(),
                  //       itemAsString: (ProductModel item) => item.serialNumber,
                  //       onChanged: (List<ProductModel> selectedItems) {
                  //
                  //         controller.serialNumberList.value = controller.serialNumberList
                  //             .map((item) => item.copyWith(isSelected: false))
                  //             .toList();
                  //
                  //         for (var sel in selectedItems) {
                  //           final idx = controller.serialNumberList
                  //               .indexWhere((item) => item.name == sel.serialNumber);
                  //           if (idx != -1) {
                  //             controller.serialNumberList[idx] =
                  //                 controller.serialNumberList[idx].copyWith(isSelected: true);
                  //           }
                  //         }
                  //
                  //         // Optionally set first selected serial as contact name
                  //         if (selectedItems.isNotEmpty) {
                  //           final first = selectedItems.first;
                  //           controller.selectedContactName = first.serialNumber;
                  //
                  //           print("Serial selected: ${first.serialNumber}");
                  //           print("Note: Contact lookup skipped because serial ≠ contact name.");
                  //         }
                  //       },
                  //       decoratorProps: DropDownDecoratorProps(
                  //         decoration: InputDecoration(
                  //           filled: true,
                  //           contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  //           label: RichText(
                  //             text: TextSpan(
                  //               text: 'Select Serial No',
                  //               style: TextStyle(
                  //                 color: context.primaryColor,
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 15,
                  //               ),
                  //               children: const [
                  //                 TextSpan(
                  //                   text: '*',
                  //                   style: TextStyle(
                  //                     color: Colors.red,
                  //                     fontWeight: FontWeight.w500,
                  //                     fontSize: 15,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: BorderSide.none,
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: BorderSide.none,
                  //           ),
                  //           fillColor: context.primaryColor.withOpacity(.1),
                  //         ),
                  //       ),
                  //       popupProps: const PopupPropsMultiSelection.dialog(
                  //         showSearchBox: true,
                  //         showSelectedItems: true,
                  //         searchFieldProps: TextFieldProps(
                  //           decoration: InputDecoration(
                  //             prefixIcon: Icon(Icons.search),
                  //             hintText: 'Search..',
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   } else {
                  //     return const SizedBox();
                  //   }
                  // }),

                  Obx(() {
                    if (!controller.showSerialDropdown.value) return const SizedBox.shrink();

                    return GestureDetector(
                      onTap: () => _showSerialNumberBottomSheet(context),
                      child: Container(
                        padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Obx(() {
                          final selectedSerials = controller.serialNumberList
                              .where((s) => s.isSelected)
                              .map((s) => s.name)
                              .toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Wrap(
                                spacing: 6,
                                runSpacing: -8,
                                children: selectedSerials.isEmpty
                                    ? [
                                  Text(
                                    'Select Serial Numbers',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  )
                                ]
                                    : selectedSerials.map((serial) {
                                  return Chip(
                                    label: Text(
                                      serial,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: context.primaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    deleteIcon: const Icon(Icons.close, color: Colors.white),
                                    onDeleted: () {
                                      final idx = controller.serialNumberList.indexWhere(
                                              (s) => s.name == serial && s.isSelected);
                                      if (idx != -1) {
                                        controller.serialNumberList[idx] = controller
                                            .serialNumberList[idx]
                                            .copyWith(isSelected: false);
                                      }
                                    },
                                  );
                                }).toList(),

                              ),
                              // const Align(
                              //   alignment: Alignment.topRight,
                              //   child: Icon(Icons.arrow_drop_down),
                              // ),
                            ],
                          );
                        }),
                      ),
                    );

                  }),

                  15.heightGap,
                  CommonButton(
                    isLoading: controller.isSubmitLoading.value,
                    onPressed: () {
                      if (controller.showSerialDropdown.value == true) {
                        controller.submitOtherSalesEntry();
                      } else {
                        controller.submitSalesEntry();
                      }
                    },
                    borderRadius: 10,
                    backgroundColor: context.primaryColor,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: context.colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showSerialNumberBottomSheet(BuildContext context) {
    final products = controller.products;
    final TextEditingController searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Serial Numbers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: searchController,
                onChanged: (value) {
                  if (value.length >= 7 || value.isEmpty){
                    setState(() {
                      searchQuery.value = value;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Obx(() {
                final query = searchQuery.value;

                if (query.length < 7) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'Type at least 7 characters to search',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                final filteredProducts = products.where((product) {
                  return product.serialNumber
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }).toList();

                return SizedBox(
                  height: 300,
                  child: filteredProducts.isEmpty
                      ? const Center(
                    child: Text(
                      'No serial numbers found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return Obx(() {
                        final isChecked = controller.serialNumberList.any(
                              (s) =>
                          s.name == product.serialNumber && s.isSelected,
                        );

                        return CheckboxListTile(
                          title: Text(product.serialNumber),
                          value: isChecked,
                          onChanged: (val) {
                            final idx = controller.serialNumberList.indexWhere(
                                    (s) => s.name == product.serialNumber);
                            if (idx != -1) {
                              final updated =
                              controller.serialNumberList[idx].copyWith(
                                isSelected: val ?? false,
                              );
                              controller.serialNumberList[idx] = updated;
                            }
                          },
                        );
                      });
                    },
                  ),
                );
              }),


              const SizedBox(height: 10),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onPressed: () {
                    final firstSelected = controller.serialNumberList
                        .firstWhereOrNull((s) => s.isSelected);
                    if (firstSelected != null) {
                      controller.selectedContactName = firstSelected.name;
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              12.heightGap,
            ],
          ),
        );
      },
    );
  }

  // void _showContactFilterSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (ctx) {
  //       final searchController = TextEditingController();
  //       String searchQuery = '';
  //       String selectedFilter = 'All';
  //
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           List<Customer> filteredList = controller.customersList.where((c) {
  //             final query = searchQuery.toLowerCase();
  //             switch (selectedFilter) {
  //               case 'Name':
  //                 return c.customerName.toLowerCase().contains(query);
  //               case 'C4C ID':
  //                 return c.c4cId.toLowerCase().contains(query);
  //               case 'Pincode':
  //                 return c.pincode.toLowerCase().contains(query);
  //               case 'City':
  //                 return c.city.toLowerCase().contains(query);
  //               case 'State':
  //                 return c.state.toLowerCase().contains(query);
  //               default:
  //                 return c.customerName.toLowerCase().contains(query) ||
  //                     c.c4cId.toLowerCase().contains(query) ||
  //                     c.pincode.toLowerCase().contains(query) ||
  //                     c.city.toLowerCase().contains(query) ||
  //                     c.state.toLowerCase().contains(query);
  //             }
  //           }).toList();
  //
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               left: 16,
  //               right: 16,
  //               top: 16,
  //               bottom: MediaQuery.of(context).viewInsets.bottom + 16,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Filter Buttons
  //                 SingleChildScrollView(
  //                   scrollDirection: Axis.horizontal,
  //                   child: Row(
  //                     children: [
  //                       _buildFilterChip('All', selectedFilter, setState),
  //                       _buildFilterChip('Name', selectedFilter, setState),
  //                       _buildFilterChip('C4C ID', selectedFilter, setState),
  //                       _buildFilterChip('Pincode', selectedFilter, setState),
  //                       _buildFilterChip('City', selectedFilter, setState),
  //                       _buildFilterChip('State', selectedFilter, setState),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 // Search Field
  //                 TextField(
  //                   controller: searchController,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Search',
  //                     prefixIcon: Icon(Icons.search),
  //                     border: OutlineInputBorder(),
  //                   ),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       searchQuery = value;
  //                     });
  //                   },
  //                 ),
  //                 const SizedBox(height: 16),
  //                 // Filtered List
  //                 Expanded(
  //                   child: filteredList.isEmpty
  //                       ? const Center(child: Text('No results found'))
  //                       : ListView.builder(
  //                     itemCount: filteredList.length,
  //                     itemBuilder: (_, index) {
  //                       final contact = filteredList[index];
  //                       return ListTile(
  //                         title: Text(contact.customerName),
  //                         subtitle: Text(
  //                             '${contact.city}, ${contact.state} (${contact.pincode})'),
  //                         onTap: () {
  //                           controller.selectedContactName = contact.customerName;
  //                           controller.mobileNoCtrl.text = contact.contacts.first.phone;
  //                           controller.emailCtrl.text = contact.contacts.first.email;
  //                           Navigator.pop(context);
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showContactFilterSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxHeight: 600),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final searchController = TextEditingController();
        String searchQuery = '';
        String selectedFilter = 'C4CId';

        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = controller.customersList.where((c) {
              final query = searchQuery.toLowerCase();
              switch (selectedFilter) {
                case 'C4CId':
                  return c.c4cId.toLowerCase().contains(query);
                case 'Pincode':
                  return c.pincode.toLowerCase().contains(query);
                case 'City':
                  return c.city.toLowerCase().contains(query);
                case 'State':
                  return c.state.toLowerCase().contains(query);
                default:
                  return false;
              }
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    children: [
                      _buildFilterChip('C4CId', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                      _buildFilterChip('Pincode', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                      _buildFilterChip('City', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                      _buildFilterChip('State', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.length >= 3 || value.isEmpty) {
                        setState(() {
                          searchQuery = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (_, index) {
                        final contact = filteredList[index];
                        return ListTile(
                          title: Text(contact.customerName),
                          subtitle: Text('${contact.city}, ${contact.state} • ${contact.pincode}'),
                          onTap: () {
                            controller.selectedContactName = contact.customerName;
                            controller.gstNoController.text = contact.gstNo;
                            controller.nameCtrl.text = contact.addressName;
                            controller.pinCodeCtrl.text = contact.pincode;
                            controller.stateCtrl.text = contact.state;
                            controller.streetCtrl.text = contact.street;
                            controller.cityCtrl.text = contact.city;
                            controller.districtCtrl.text = contact.district;
                            controller.countryCtrl.text = contact.country;
                            controller.mobileNoCtrl.text = contact.contacts[index].phone;
                            controller.emailCtrl.text = contact.contacts[index].email;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



  Widget _buildFilterChip(String label, String selectedFilter, ValueChanged<String> onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == label,
        selectedColor: Colors.deepPurpleAccent.withOpacity(0.2),
        onSelected: (_) => onSelected(label),
      ),
    );
  }

  // Future<Customer?> _showCustomerSelectionSheet(BuildContext context) async {
  //   return showModalBottomSheet<Customer>(
  //     context: context,
  //     isScrollControlled: true,
  //     showDragHandle: true,
  //     constraints: BoxConstraints(
  //       maxHeight: 600
  //     ),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       final searchController = TextEditingController();
  //       String searchQuery = '';
  //       String selectedFilter = 'C4CId';
  //
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           final filteredList = controller.customersList.where((c) {
  //             final query = searchQuery.toLowerCase();
  //             switch (selectedFilter) {
  //
  //               case 'C4CId':
  //                 return c.c4cId.toLowerCase().contains(query);
  //               case 'Pincode':
  //                 return c.pincode.toLowerCase().contains(query);
  //               case 'City':
  //                 return c.city.toLowerCase().contains(query);
  //               case 'State':
  //                 return c.state.toLowerCase().contains(query);
  //               default:
  //                 return false;
  //             }
  //           }).toList();
  //
  //           return Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Wrap(
  //                   spacing: 8,
  //                   children: [
  //                     _buildFilterChip('C4CId', selectedFilter, (val) {
  //                       setState(() => selectedFilter = val);
  //                     }),
  //                     _buildFilterChip('Pincode', selectedFilter, (val) {
  //                       setState(() => selectedFilter = val);
  //                     }),
  //                     _buildFilterChip('City', selectedFilter, (val) {
  //                       setState(() => selectedFilter = val);
  //                     }),
  //                     _buildFilterChip('State', selectedFilter, (val) {
  //                       setState(() => selectedFilter = val);
  //                     }),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 16),
  //                 TextField(
  //                   controller: searchController,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Search',
  //                     prefixIcon: Icon(Icons.search),
  //                     border: OutlineInputBorder(),
  //                   ),
  //                   onChanged: (value) {
  //                     if (value.length >= 3 || value.isEmpty) {
  //                       setState(() {
  //                         searchQuery = value;
  //                       });
  //                     }
  //                   },
  //                 ),
  //                 const SizedBox(height: 16),
  //                 Expanded(
  //                   child: ListView.builder(
  //                     itemCount: filteredList.length,
  //                     itemBuilder: (context, index) {
  //                       final customer = filteredList[index];
  //                       return ListTile(
  //                         title: Text(customer.customerName),
  //                         subtitle: Text(
  //                             '${customer.city}, ${customer.state} , ${customer.pincode} '),
  //                         onTap: () => Navigator.pop(context, customer),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<Customer?> _showCustomerSelectionSheet(BuildContext context) async {

    final searchController = TextEditingController();
    String searchQuery = '';
    String selectedFilter = 'Name';

    return showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxHeight: 600),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // final searchController = TextEditingController();
        // String searchQuery = '';
        // String selectedFilter = 'Name';

        return StatefulBuilder(
          builder: (context, setState) {
            final query = searchQuery.toLowerCase();

            final filteredList = controller.customersList.where((c) {
              if (query.isEmpty) return true;

              switch (selectedFilter) {
                case 'Name':
                  return c.customerName.toLowerCase().contains(query);
                case 'C4CId':
                  return c.c4cId.toLowerCase().contains(query);
                case 'Pincode':
                  return c.pincode.toLowerCase().contains(query);
                case 'City':
                  return c.city.toLowerCase().contains(query);
                case 'State':
                  return c.state.toLowerCase().contains(query);
                case 'All':
                  return c.c4cId.toLowerCase().contains(query) ||
                      c.customerName.toLowerCase().contains(query) ||
                      c.pincode.toLowerCase().contains(query) ||
                      c.city.toLowerCase().contains(query) ||
                      c.state.toLowerCase().contains(query);


                default:
                  return false;
              }
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip('Name', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),

                      _buildFilterChip('C4CId', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                      _buildFilterChip('Pincode', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                      _buildFilterChip('City', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                      _buildFilterChip('State', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                      _buildFilterChip('All', selectedFilter, (val) {
                        setState(() => selectedFilter = val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.length >= 3 || value.isEmpty) {
                        setState(() => searchQuery = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final customer = filteredList[index];
                        return ListTile(
                          title: Text(customer.customerName),
                          subtitle: Text('${customer.city}, ${customer.state}, ${customer.pincode}'),
                          onTap: () => Navigator.pop(context, customer),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


}

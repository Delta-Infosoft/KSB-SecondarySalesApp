import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/context_extention.dart';
import 'package:ksb_secondary_sales/core/utils/extentions/number_extention.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_button.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/common_text_input.dart';
import 'package:ksb_secondary_sales/core/utils/widgets/tap_to_remove_keyboard_widget.dart';
import 'package:ksb_secondary_sales/features/customers/view_model/customer_controller.dart';

import '../../../core/utils/common_services/validator.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  @override
  void initState() {
    super.initState();
    controller = Get.put(CustomerController());
  }

  late CustomerController controller;

  @override
  void dispose() {
    Get.delete<CustomerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapToRemoveKeyboardWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer Form'),
        ),
        body: Form(
          key: controller.formKey,
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.heightGap,
                    Text(
                      'Customer Details',
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
                        horizontal: 15,
                        vertical: 13,
                      ),
                      customBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      controller: controller.customerNameController,
                      validator: (p0) =>
                          nonEmptyValidator(p0, "Please enter customer name"),
                      lableWidget: RichText(
                        text: TextSpan(
                          text: 'Customer Name',
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
                            ]
                        ),
                      ),
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
                
                    15.heightGap,
                    DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                
                      value: controller.selectedCompanyType.value.isEmpty
                          ? null
                          : controller.selectedCompanyType.value,
                      items: controller.companyTypes
                          .map((data) => DropdownMenuItem(
                        value: (data['CompanyTypeTextListId']??'').toString(),
                        child: Text(data['Text']??''),
                      ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedCompanyType.value = value??'';
                      },
                      validator: (p0) =>
                          nonEmptyValidator(p0, "Please select company type"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13,
                        ),
                        label: RichText(
                          text: TextSpan(
                              text: 'Select Company Type',
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
                          borderSide:
                          const BorderSide(color: Colors.transparent),
                        ),
                        suffixIcon: controller
                            .isCompanyTypeLoading.value
                            ? IconButton(
                            onPressed: () {},
                            icon: const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )))
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.transparent),
                        ),
                        fillColor: context.primaryColor.withOpacity(.1),
                      ),
                    ),
                    const SizedBox(height: 16),
                
                    // Customer Type Dropdown
                    DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      validator: (p0) =>
                          nonEmptyValidator(p0, "Please select customer type"),
                      value: controller.selectedCustomerType.value.isEmpty
                          ? null
                          : controller.selectedCustomerType.value,
                      items: controller.customerTypes
                          .map((data) => DropdownMenuItem(
                        value: data['CustomerTypeTextListId'].toString(),
                        child: Text(data['Text']),
                      ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedCustomerType.value = value!;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13,
                        ),
                        label: RichText(
                          text: TextSpan(
                              text: 'Select Customer Type',
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
                          borderSide:
                          const BorderSide(color: Colors.transparent),
                        ),
                          suffixIcon: controller
                              .isCustomerTypeLoading.value
                              ? IconButton(
                              onPressed: () {},
                              icon: const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )))
                              : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Colors.transparent),
                        ),
                        fillColor: context.primaryColor.withOpacity(.1),
                      ),
                    ),
                    const SizedBox(height: 16),
                
                    // Industry Type Dropdown
                    DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      value: controller.selectedIndustryType.value.isEmpty
                          ? null
                          : controller.selectedIndustryType.value,
                      items: controller.industryTypes
                          .map((data) => DropdownMenuItem(
                        value: data['IndustryTypeTextListId'].toString(),
                        child: Text(data['Text']),
                      ))
                          .toList(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (p0) =>
                          nonEmptyValidator(p0, "Please select industry type"),
                      onChanged: (value) {
                        controller.selectedIndustryType.value = value!;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 13,
                        ),
                        label: RichText(
                          text: TextSpan(
                              text: 'Industry Type',
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
                        suffixIcon: controller
                            .isIndustryTypeLoading.value
                            ? IconButton(
                            onPressed: () {},
                            icon: const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )))
                            : null,
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
                    ),
                    15.heightGap,
                    Text(
                      'Address',
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
                              value: e['Name'].toString(), child: Text(e['Name'] ?? ''));
                        },
                      ).toList(),
                      onChanged: (name) {
                        final selectedAddress = controller.addressList
                            .firstWhereOrNull((address) => address['Name'] == name);
                        if(selectedAddress==null)return;
                        controller.selectedLandMark.value=name??'';
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
                            text: 'House Name/Building Name/Street Name',
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
                    if(false)
                      ...[
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
                          controller: controller.landmarkCtrl,
                          validator: (p0) =>
                              nonEmptyValidator(p0, "Please enter landmark"),
                          lableWidget: RichText(
                            text: TextSpan(
                                text: 'Landmark',
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
                      ],
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
                              borderSide: const BorderSide(color: Colors.transparent),
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
                
                        15.widthGap,Expanded(
                          child: CommonTextInput(
                            filled: true,
                            filledColor: context.primaryColor.withOpacity(.1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 13),
                            customBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.transparent),
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
                    Text(
                      'Contact Details',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: context.primaryColor),
                    ),
                    15.heightGap,
                   ...List.generate(
                     controller.contactCount.value,
                         (index) {
                       return Padding(
                         padding: const EdgeInsets.only(bottom: 15),
                         child: ExpansionTile(
                           backgroundColor: Colors.transparent,
                           childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                           shape: RoundedRectangleBorder(
                             side: const BorderSide(color: Colors.grey),
                             borderRadius: BorderRadius.circular(15),
                           ),
                           collapsedShape: RoundedRectangleBorder(
                             side: const BorderSide(color: Colors.transparent),
                             borderRadius: BorderRadius.circular(15),
                           ),
                           collapsedBackgroundColor: context.primaryColor.withOpacity(.1),
                           title: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text('Contact ${index + 1}'),
                               if (controller.contactCount.value == index + 1 && controller.contactCount.value < 5)
                                 InkWell(
                                   onTap: () {
                                     if (controller.contactCount.value < 5) {
                                       controller.addNewContact();
                                     }
                                   },
                                   borderRadius: BorderRadius.circular(10),
                                   child: const Icon(Icons.add, color: Colors.grey,),
                                 )
                               else
                                 InkWell(
                                   onTap: () {
                                     if (controller.contactCount.value > 1) {
                                       controller.removeContact(index);
                                     }
                                   },
                                   borderRadius: BorderRadius.circular(10),
                                   child: const Icon(Icons.remove, color: Colors.grey,),
                                 )
                             ],
                           ),
                           children: [
                             Column(
                               children: [
                                 CommonTextInput(
                                   filled: true,
                                   filledColor: context.primaryColor.withOpacity(.1),
                                   validator: (p0) => nonEmptyValidator(p0,"Please enter name"),

                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                                   customBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10),
                                     borderSide: const BorderSide(color: Colors.transparent),
                                   ),
                                   controller: controller.nameControllers[index],
                                   lableWidget: RichText(
                                     text: TextSpan(
                                       text: 'Name',
                                       style: TextStyle(
                                         color: context.primaryColor,
                                         fontWeight: FontWeight.w500,
                                         fontSize: 15,
                                       ),
                                     ),
                                   ),
                                 ),
                                 const SizedBox(height: 16),
                                 CommonTextInput(
                                   filled: true,
                                   filledColor: context.primaryColor.withOpacity(.1),
                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                                   validator: (p0) => nonEmptyValidator(p0,"Please enter department"),

                                   customBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10),
                                     borderSide: const BorderSide(color: Colors.transparent),
                                   ),
                                   controller: controller.departmentControllers[index],
                                   lableWidget: RichText(
                                     text: TextSpan(
                                       text: 'Department',
                                       style: TextStyle(
                                         color: context.primaryColor,
                                         fontWeight: FontWeight.w500,
                                         fontSize: 15,
                                       ),
                                     ),
                                   ),
                                 ),
                                 const SizedBox(height: 16),
                                 CommonTextInput(
                                   filled: true,
                                   filledColor: context.primaryColor.withOpacity(.1),
                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                                   customBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10),
                                     borderSide: const BorderSide(color: Colors.transparent),
                                   ),
                                   controller: controller.designationControllers[index],
                                   validator: (p0) => nonEmptyValidator(p0,"Please enter designation"),
                                   lableWidget: RichText(
                                     text: TextSpan(
                                       text: 'Designation',
                                       style: TextStyle(
                                         color: context.primaryColor,
                                         fontWeight: FontWeight.w500,
                                         fontSize: 15,
                                       ),
                                     ),
                                   ),
                                 ),
                                 const SizedBox(height: 16),
                                 CommonTextInput(
                                   filled: true,
                                   filledColor: context.primaryColor.withOpacity(.1),
                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                                   customBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10),
                                     borderSide: const BorderSide(color: Colors.transparent),
                                   ),
                                   controller: controller.phoneControllers[index],
                                   maxLength: 10,
                                   validator:(value)=> validateMobileNumber(value),
                                   lableWidget: RichText(
                                     text: TextSpan(
                                       text: 'Phone',
                                       style: TextStyle(
                                         color: context.primaryColor,
                                         fontWeight: FontWeight.w500,
                                         fontSize: 15,
                                       ),
                                     ),
                                   ),
                                   keyboardType: TextInputType.phone,
                                 ),
                                 const SizedBox(height: 16),
                                 CommonTextInput(
                                   filled: true,
                                   filledColor: context.primaryColor.withOpacity(.1),
                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                                   customBorder: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10),
                                     borderSide: const BorderSide(color: Colors.transparent),
                                   ),
                                   validator: (value)=>validateEmail(value),
                                   controller: controller.emailControllers[index],
                                   lableWidget: RichText(
                                     text: TextSpan(
                                       text: 'Email',
                                       style: TextStyle(
                                         color: context.primaryColor,
                                         fontWeight: FontWeight.w500,
                                         fontSize: 15,
                                       ),
                                     ),
                                   ),
                                   keyboardType: TextInputType.emailAddress,
                                 ),
                               ],
                             )
                           ],
                         ),
                       );
                     },
                   ),
                
                    20.heightGap,
                    CommonButton(
                      isLoading: controller.isSubmitLoading.value,
                      onPressed: () {
                        controller.createCustomer();
                      },
                      backgroundColor: context.primaryColor,
                      borderRadius: 15,
                      child: const Text(
                        style: TextStyle(color: Colors.white),
                        'Submit',
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

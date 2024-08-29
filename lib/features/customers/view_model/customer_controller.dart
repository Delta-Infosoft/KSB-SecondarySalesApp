import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
import 'package:ksb_secondary_sales/features/customers/model/customer_model.dart';

import '../../sales/model/sales_insert_reposiotory.dart';
import '../model/customer_repository.dart';

class CustomerController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchCustomerTypes();
    fetchCompanyTypes();
    fetchIndustryTypes();
    addNewContact();
  }

  RxInt contactCount = 0.obs;
  RxBool isCustomerTypeLoading = false.obs;
  RxBool isCompanyTypeLoading = false.obs;
  RxBool isIndustryTypeLoading = false.obs;

  final GlobalKey<FormFieldState<String>> landMarkDdKey =
      GlobalKey<FormFieldState<String>>();

  RxBool isSubmitLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List addressList = [];
  // TextEditingControllers
  TextEditingController customerNameController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController pinCodeCtrl = TextEditingController();
  TextEditingController laneCtrl = TextEditingController();
  TextEditingController streetCtrl = TextEditingController();
  TextEditingController landmarkCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController countryCtrl = TextEditingController();
  TextEditingController   districtCtrl = TextEditingController();

  List<TextEditingController> nameControllers = [];
  List<TextEditingController> departmentControllers = [];
  List<TextEditingController> designationControllers = [];
  List<TextEditingController> phoneControllers = [];
  List<TextEditingController> emailControllers = [];

  RxString selectedCompanyType = ''.obs;
  RxString selectedCustomerType = ''.obs;
  RxString selectedIndustryType = ''.obs;
  RxBool isPinCodeDataLoading = false.obs;

  RxString selectedLandMark = ''.obs;

  // List of Dropdown Options
  List customerTypes = [];
  List companyTypes = [];
  List industryTypes = [];

  Future<void> fetchCustomerTypes() async {
    isCustomerTypeLoading.value = true;
    customerTypes =
        await CustomerRepository.getTestListFromGroup('CustomerType');
    isCustomerTypeLoading.value = false;
  }

  // Fetch CompanyTypes
  Future<void> fetchCompanyTypes() async {
    isCompanyTypeLoading.value = true;
    companyTypes = await CustomerRepository.getTestListFromGroup('CompanyType');
    isCompanyTypeLoading.value = false;
  }

  // Fetch IndustryTypes
  Future<void> fetchIndustryTypes() async {
    isIndustryTypeLoading.value = true;
    industryTypes =
        await CustomerRepository.getTestListFromGroup('IndustryType');
    isIndustryTypeLoading.value = false;
  }

  void addNewContact() {
    nameControllers.add(TextEditingController());
    departmentControllers.add(TextEditingController());
    designationControllers.add(TextEditingController());
    phoneControllers.add(TextEditingController());
    emailControllers.add(TextEditingController());
    contactCount.value++;
  }

  void removeContact(int index) {
    if (contactCount.value > 1) {
      // Remove controllers at specific index
      nameControllers[index].dispose();
      departmentControllers[index].dispose();
      designationControllers[index].dispose();
      phoneControllers[index].dispose();
      emailControllers[index].dispose();

      nameControllers.removeAt(index);
      departmentControllers.removeAt(index);
      designationControllers.removeAt(index);
      phoneControllers.removeAt(index);
      emailControllers.removeAt(index);
      contactCount.value--;
    }
  }

  getDataFromPinCode(String pinCode) async {
    isPinCodeDataLoading.value = true;
    selectedLandMark.value = '';
    landMarkDdKey.currentState?.reset();

    addressList = [];
    List data = await SalesInsertRepository.getAddressFromPinCode(pinCode);
    addressList = data;
    isPinCodeDataLoading.value = false;
  }

  Future<void> createCustomer() async {
    if (formKey.currentState!.validate()) {
      bool isContactValidate = true;
      for (int i = 0; i < contactCount.value; i++) {
        List<String> contactCtrl = [
          nameControllers[i].text.trim(),
          departmentControllers[i].text.trim(),
          designationControllers[i].text.trim(),
          phoneControllers[i].text.trim(),
          emailControllers[i].text.trim(),
        ];
        if (contactCtrl.any((text) => text.isEmpty)) {
          print('here');
          Fluttertoast.showToast(
              msg: 'Please fill all details of contact ${i + 1}');
                isContactValidate=false;
          break;
        }
      }
      print('isContactValidate:$isContactValidate');
      if(!isContactValidate)return;
      isSubmitLoading.value = true;

      final customer = CustomerInsertModel(
        customerName: customerNameController.text,
        gstNo: gstNoController.text,
        customerTypeId: selectedCustomerType.value,
        companyTypeId: selectedCompanyType.value,
        industryTypeId: selectedIndustryType.value,
        addressName: nameCtrl.text,
        street: streetCtrl.text,
        landMark: selectedLandMark.value,
        pincode: pinCodeCtrl.text,
        city: cityCtrl.text,
        district: districtCtrl.text,
        state: stateCtrl.text,
        country: countryCtrl.text,
        contactName1: nameControllers.isNotEmpty ? nameControllers[0].text : '',
        contactDepartment1: departmentControllers.isNotEmpty
            ? departmentControllers[0].text
            : '',
        contactPhone1:
            phoneControllers.isNotEmpty ? phoneControllers[0].text : '',
        contactDesignation1: designationControllers.isNotEmpty
            ? designationControllers[0].text
            : '',
        contactEmail1:
            emailControllers.isNotEmpty ? emailControllers[0].text : '',
        contactName2: nameControllers.length > 1 ? nameControllers[1].text : '',
        contactDepartment2: departmentControllers.length > 1
            ? departmentControllers[1].text
            : '',
        contactPhone2:
            phoneControllers.length > 1 ? phoneControllers[1].text : '',
        contactDesignation2: designationControllers.length > 1
            ? designationControllers[1].text
            : '',
        contactEmail2:
            emailControllers.length > 1 ? emailControllers[1].text : '',
        contactName3: nameControllers.length > 2 ? nameControllers[2].text : '',
        contactDepartment3: departmentControllers.length > 2
            ? departmentControllers[2].text
            : '',
        contactPhone3:
            phoneControllers.length > 2 ? phoneControllers[2].text : '',
        contactDesignation3: designationControllers.length > 2
            ? designationControllers[2].text
            : '',
        contactEmail3:
            emailControllers.length > 2 ? emailControllers[2].text : '',
        contactName4: nameControllers.length > 3 ? nameControllers[3].text : '',
        contactDepartment4: departmentControllers.length > 3
            ? departmentControllers[3].text
            : '',
        contactPhone4:
            phoneControllers.length > 3 ? phoneControllers[3].text : '',
        contactDesignation4: designationControllers.length > 3
            ? designationControllers[3].text
            : '',
        contactEmail4:
            emailControllers.length > 3 ? emailControllers[3].text : '',
        contactName5: nameControllers.length > 4 ? nameControllers[4].text : '',
        contactDepartment5: departmentControllers.length > 4
            ? departmentControllers[4].text
            : '',
        contactPhone5:
            phoneControllers.length > 4 ? phoneControllers[4].text : '',
        contactDesignation5: designationControllers.length > 4
            ? designationControllers[4].text
            : '',
        contactEmail5:
            emailControllers.length > 4 ? emailControllers[4].text : '',
        insertedOn: DateTime.now().toIso8601String(),
        lastUpdatedOn: DateTime.now().toIso8601String(),
        insertedByUserId: LocalDb.getString(
            AppConstants.userIdKey), // Replace with the actual user ID
        lastUpdatedByUserId: LocalDb.getString(
            AppConstants.userIdKey), // Replace with the actual user ID
      );
      String response = await CustomerRepository.createCustomer(customer);
      if (response == 'Successfully') {
        Get.offAllNamed(AppRoute.dashboard);
        Timer(
          100.milliseconds,
          () {
            Get.delete<CustomerController>();
          },
        );
      }
      isSubmitLoading.value = false;
    }
  }
}

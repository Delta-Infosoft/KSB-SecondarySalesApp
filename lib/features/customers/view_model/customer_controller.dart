import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../sales/model/sales_insert_reposiotory.dart';

class CustomerController extends GetxController {


  List addressList = [];
  // TextEditingControllers
  TextEditingController customerNameController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();

  TextEditingController pinCodeCtrl = TextEditingController();
  TextEditingController laneCtrl = TextEditingController();
  TextEditingController streetCtrl = TextEditingController();
  TextEditingController landmarkCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController districtCtrl = TextEditingController();

   final TextEditingController nameController = TextEditingController();
    final TextEditingController departmentController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();// Dropdown Selections
  RxString selectedCompanyType = ''.obs;
  RxString selectedCustomerType = ''.obs;
  RxString selectedIndustryType = ''.obs;
  RxBool isPinCodeDataLoading = false.obs;

  RxString selectedArea = ''.obs;


  // List of Dropdown Options
  final List<String> companyTypes = ['Pvt.', 'Ltd.', 'Non-registered'];
  final List<String> customerTypes = ['End user', 'OEM', 'Consultant'];
  final List<String> industryTypes = [
    'Food',
    'Chemical',
    'Automotive',
    'Pharma',
    'Paper',
    'Sugar',
    'Distillery',
    'Infrastructure',
    'Energy',
    'Oil & Gas',
    'Steel & Textile',
  ];
  getDataFromPinCode(String pinCode) async {
    isPinCodeDataLoading.value = true;
    addressList=[];
    List data = await SalesInsertRepository.getAddressFromPinCode(pinCode);
    addressList = data;
    isPinCodeDataLoading.value = false;
  }
}

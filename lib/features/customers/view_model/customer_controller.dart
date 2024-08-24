import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../sales/model/sales_insert_reposiotory.dart';

class CustomerController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    // Initialize the controllers with one item initially
    addNewContact();
  }
  RxInt contactCount = 0.obs;

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

  List<TextEditingController> nameControllers = [];
  List<TextEditingController> departmentControllers = [];
  List<TextEditingController> designationControllers = [];
  List<TextEditingController> phoneControllers = [];
  List<TextEditingController> emailControllers = [];

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
    addressList=[];
    List data = await SalesInsertRepository.getAddressFromPinCode(pinCode);
    addressList = data;
    isPinCodeDataLoading.value = false;
  }

  addContactDetail(){
    contactCount.value++;

  }
}

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
import 'package:ksb_secondary_sales/features/auth/model/repositories/login_repository.dart';
import 'package:ksb_secondary_sales/features/auth/view_model/login_controller.dart';
import 'package:ksb_secondary_sales/features/customers/model/customer_repository.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_data_model.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_insert_reposiotory.dart';
import 'package:ksb_secondary_sales/features/sales/view/widgets/filter_item_selection_bottomsheet.dart';

import '../../auth/view/widgets/otp_verification_dialog.dart';

class SalesInsertController extends GetxController {
  var showSerialDropdown = false.obs;

  void setSerialDropdownVisibility(bool isVisible) {
    showSerialDropdown.value = isVisible;
  }

  void enableSerialDropdown() {
    showSerialDropdown.value = true;
  }

  void disableSerialDropdown() {
    showSerialDropdown.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getProductList();
    salesDateCtrl.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    isProductListSeen = LocalDb.getBool(AppConstants.isProductListSeenKey);
    showSerialDropdown.value = Get.arguments?['showSerialDropdown'] == true;
  }

  @override
  void onClose() {
    super.onClose();
    print("SalesInsertController disposed");
  }

  bool isProductListSeen = false;

  GlobalKey materialNumberKey = GlobalKey();
  GlobalKey materialDescriptionKey = GlobalKey();
  GlobalKey serialNoKey = GlobalKey();
  RxList<Item> salesNoList = <Item>[].obs;

  RxList<Item> productGroupList = <Item>[].obs;

  RxList<Item> invoiceNumberList = <Item>[].obs;

  RxList<Item> poNumberList = <Item>[].obs;

  RxList<ProductModel> filteredList = <ProductModel>[].obs;

  final poNumberSearchCtrl = TextEditingController();

  RxList<Item> serialNumberList = <Item>[].obs;

  List addressList = [];
  RxBool isSearchEnable = true.obs;
  List<ProductModel> products = [];
  RxList<ProductModel> searchProducts = <ProductModel>[].obs;
  List<RxBool> isProductSelected = [];

  RxBool isProductLoading = false.obs;
  RxBool isPinCodeDataLoading = false.obs;
  RxBool isOtpSendToMobileIsLoading = false.obs;
  RxBool isOtpSendToEmailIsLoading = false.obs;
  RxBool isMobileNumberApproved = false.obs;
  RxBool isEmailAddressApprove = false.obs;
  RxBool isCustomerLoading = false.obs;
  FocusNode searchFocus = FocusNode();

  TextEditingController searchCtrl = TextEditingController();
  TextEditingController invoiceDateCtrl = TextEditingController();
  RxBool isSubmitLoading = false.obs;

  RxString invoiceDate = "".obs;
  TextEditingController salesDateCtrl = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileNoCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController streetCtrl = TextEditingController();
  TextEditingController pinCodeCtrl = TextEditingController();
  TextEditingController countryCtrl = TextEditingController();
  TextEditingController districtCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileNoKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  String selectedContactName = '';
  List<String> selectedSerialNos = [];

  final GlobalKey<FormFieldState<String>> landMarkDdKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> contactDDKey =
      GlobalKey<FormFieldState<String>>();

  onQuerySearch(String query) {
    if (query.isEmpty) {
      searchProducts.assignAll(products);
    } else {
      searchProducts.assignAll(products.where(
        (element) {
          return element.materialNo
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.serialNumber
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.materialDescreption
                  .toLowerCase()
                  .contains(query.toLowerCase());
        },
      ));
    }
  }

  clearFilter() {
    invoiceDateCtrl.clear();
    salesNoList.value = salesNoList.value
        .map(
          (e) => Item(name: e.name, isSelected: false),
        )
        .toList();

    invoiceNumberList.value = invoiceNumberList.value
        .map(
          (e) => Item(name: e.name, isSelected: false),
        )
        .toList();
    serialNumberList.value = serialNumberList.value
        .map(
          (e) => Item(name: e.name, isSelected: false),
        )
        .toList();

    invoiceDate.value = "";
  }

  RxString selectedLandMark = ''.obs;
  RxString selectedCustomerId = ''.obs;
  List<Customer> customersList = [];
  List<Contact> contactList = [];

  setProductListSeenTrue() {
    isProductListSeen = true;
    LocalDb.setBool(AppConstants.isProductListSeenKey, true);
  }

  Future<void> getProductList() async {
    isProductLoading.value = true;
    clearFilter();

    products = await SalesInsertRepository.getProductList();
    searchProducts.value = List.of(products);
    // products = dummyProductData;
    isProductSelected = List.generate(products.length, (index) => false.obs);

    salesNoList.value = products
        .map((e) => e.salesOrderNo)
        .toSet()
        .toList()
        .map(
          (e) => Item(name: e, isSelected: false),
        )
        .toList();

    invoiceNumberList.value = products
        .map((e) => e.invoiceNumber)
        .toSet()
        .toList()
        .map(
          (e) => Item(name: e, isSelected: false),
        )
        .toList();

    serialNumberList.value = products
        .map((e) => e.serialNumber)
        .toSet()
        .toList()
        .map(
          (e) => Item(name: e, isSelected: false),
        )
        .toList();

    isProductLoading.value = false;
  }

  void searchByPoNumber(String query) {
    if (query.isEmpty) {
      searchProducts.value = List.of(products);
    } else {
      searchProducts.value = products
          .where((element) =>
          (element.poNumber ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }


  filterProductsRecords() async {
    Get.back();
    isProductLoading.value = true;

    String selectedSerialNumberIds = serialNumberList
        .where((p0) => p0.isSelected)
        .map((e) => e.name)
        .toList()
        .join(',');

    String selectedSalesOrderIds = salesNoList
        .where((p0) => p0.isSelected)
        .map((e) => e.name)
        .toList()
        .join(',');

    String selectedInvoiceNumberIds = invoiceNumberList
        .where((p0) => p0.isSelected)
        .map((e) => e.name)
        .toList()
        .join(',');

    String poNumber = poNumberSearchCtrl.text;

    searchProducts.clear();

    final filtered = await SalesInsertRepository.getFiltersData(
      selectedSerialNumberIds,
      selectedSalesOrderIds,
      selectedInvoiceNumberIds,
      invoiceDateCtrl.text,
      poNumber,
    );

    log('Filtered response: ${filtered.length}');
    products = filtered;

    searchProducts.value = List.of(products);
    isProductSelected = List.generate(products.length, (index) => false.obs);
    isProductLoading.value = false;
  }


  // filterProductsRecords() async {
  //   Get.back();
  //   isProductLoading.value = true;
  //
  //   String selectedSerialNumberIds = serialNumberList
  //       .where((p0) => p0.isSelected)
  //       .map((e) => e.name)
  //       .toList()
  //       .join(',');
  //
  //   String selectedSalesOrderIds = salesNoList
  //       .where((p0) => p0.isSelected)
  //       .map((e) => e.name)
  //       .toList()
  //       .join(',');
  //
  //   String selectedInvoiceNumberIds = invoiceNumberList
  //       .where((p0) => p0.isSelected)
  //       .map((e) => e.name)
  //       .toList()
  //       .join(',');
  //
  //   String poNumber = poNumberSearchCtrl.text;
  //
  //   products = await SalesInsertRepository.getFiltersData(
  //     selectedSerialNumberIds,
  //     selectedSalesOrderIds,
  //     selectedInvoiceNumberIds,
  //     invoiceDateCtrl.text,
  //     poNumber,
  //   );
  //
  //   searchProducts.value = List.of(products);
  //   searchProducts.refresh();
  //   isProductSelected = List.generate(products.length, (index) => false.obs);
  //   isProductLoading.value = false;
  // }


  // filterProductsRecords() async {
  //   Get.back();
  //   isProductLoading.value = true;
  //   String selectedSerialNumberIds = serialNumberList
  //       .where((p0) => p0.isSelected)
  //       .map(
  //         (e) => e.name,
  //       )
  //       .toList()
  //       .join(',');
  //   String selectedSalesOrderIds = salesNoList
  //       .where((p0) => p0.isSelected)
  //       .map(
  //         (e) => e.name,
  //       )
  //       .toList()
  //       .join(',');
  //   String selectedInvoiceNumberIds = invoiceNumberList
  //       .where((p0) => p0.isSelected)
  //       .map(
  //         (e) => e.name,
  //       )
  //       .toList()
  //       .join(',');
  //
  //   String selectedPoNumberIds = poNumberList
  //       .where((p0) => p0.isSelected)
  //       .map((e) => e.name)
  //       .toList()
  //       .join(',');
  //
  //   products = await SalesInsertRepository.getFiltersData(
  //       selectedSerialNumberIds,
  //       selectedSalesOrderIds,
  //       selectedInvoiceNumberIds,
  //        selectedPoNumberIds,
  //       invoiceDateCtrl.text);
  //   searchProducts.value = List.of(products);
  //   // products = dummyProductData;
  //   isProductSelected = List.generate(products.length, (index) => false.obs);
  //   isProductLoading.value = false;
  // }



  Future<void> getCustomerList() async {
    isCustomerLoading.value = true;
    customersList = await CustomerRepository.getCustomerById();
    isCustomerLoading.value = false;
  }

  String get selectedProductIds {
    return products
        .asMap()
        .entries
        .where((e) => isProductSelected[e.key].value)
        .map((e) => e.value.id)
        .join(',');
  }

  String get selectedSerialsDisplayText {
    final selected = serialNumberList.where((e) => e.isSelected).map((e) => e.name).toList();
    return selected.isEmpty ? 'Select Serial No' : selected.join(', ');
  }

  Future<void> submitSalesEntry() async {
    if (formKey.currentState!.validate()) {
      isSubmitLoading.value = true;
      Map<String, dynamic> salesData = {
        "ksbSalesInvoiceId": selectedProductIds,
        "salesDate": DateTime.now().toIso8601String(),
        "customerId": selectedCustomerId.value,
        "gstNo": gstNoController.text,
        "customerContactName": selectedContactName,
        "customerMobileNo": mobileNoCtrl.text,
        "customerEmailId": emailCtrl.text,
        "customerAddress": streetCtrl.text,
        "pincode": pinCodeCtrl.text,
        "landMark": selectedLandMark.value,
        "street": streetCtrl.text,
        "city": cityCtrl.text,
        "state": stateCtrl.text,
        "country": countryCtrl.text,
        "district": districtCtrl.text,
        "insertedByUserId": LocalDb.getString(
            AppConstants.userIdKey), // Replace with actual user ID
      };

      print("Selected Serial Numbers: $selectedProductIds");
      print("Selected Product Ids: $selectedProductIds");
      print(" Final selectedProductIds for other sales: $selectedProductIds");

      print("Selected customerId $selectedCustomerId");
      print("Selected gstno.: ${gstNoController.text}");
      print("customerAddress: ${streetCtrl.text}");
      print('Streeet: ${streetCtrl.text}');
      print('City : ${cityCtrl.text}');
      print('state :${stateCtrl.text}');
      print('country : ${countryCtrl.text}');
      print(('District ${districtCtrl.text}'));
      print("insertedByUserId : ${LocalDb.getString(AppConstants.userIdKey)}");
      print("pincode ${pinCodeCtrl.text}");
      print("landMark: ${selectedLandMark.value}");
      print("Selected Serial Numbers: ${selectedProductIds}");
      print("Selected Contact Name: ${selectedContactName}");
      print("Mobile: ${mobileNoCtrl.text}, Email: ${emailCtrl.text}");

      bool isInserted =
          await SalesInsertRepository.insertSalesRecord(salesData);

      if (isInserted) {
        print('Sales Record entry inserted>>>>${salesData}');
        Fluttertoast.showToast(msg: 'Sales record inserted successfully');
        Get.offAllNamed(AppRoute.dashboard);
      } else {
        Fluttertoast.showToast(msg: 'Failed to insert sales record');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please fill all required fields');
    }
    isSubmitLoading.value = false;
  }
  /*String get selectedProductIdsFromSerials {
    return serialNumberList
        .where((item) => item.isSelected)
        .map((e) => e.productId)
        .toSet()
        .join(',');
  }
*/
  Future<void> submitOtherSalesEntry() async {
    if (formKey.currentState!.validate()) {
      isSubmitLoading.value = true;

      final selectedSerials = serialNumberList
          .where((item) => item.isSelected)
          .map((e) => e.name)
          .toList();

      final selectedProducts = products
          .where((product) => selectedSerials.contains(product.serialNumber))
          .toList();

      final selectedProductIds = selectedProducts
          .map((p) => p.id)
          .where((id) => id.trim().isNotEmpty)
          .join(',');

      // Debug print
      print("Selected Serial Numbers: $selectedProductIds");
      print("Selected Product Ids: $selectedProductIds");
      print("✅ Final selectedProductIds for other sales: $selectedProductIds");

      print("Selected customerId $selectedCustomerId");
      print("Selected gstno.: ${gstNoController}");
      print("customerAddress: ${streetCtrl.text}");
      print('Streeet: ${streetCtrl.text}');
      print('City : ${cityCtrl.text}');
      print('state :${stateCtrl.text}');
      print('country : ${countryCtrl.text}');
      print(('District ${districtCtrl.text}'));
      print("insertedByUserId : ${LocalDb.getString(AppConstants.userIdKey)}");
      print("pincode ${pinCodeCtrl.text}");
      print("landMark: ${selectedLandMark.value}");
      print("Selected Serial Numbers: ${selectedProductIds}");
      print("Selected Contact Name: ${selectedContactName}");
      print("Mobile: ${mobileNoCtrl.text}, Email: ${emailCtrl.text}");

      Map<String, dynamic> salesData = {
        "ksbSalesInvoiceId": selectedProductIds,
        "salesDate": DateTime.now().toIso8601String(),
        "customerId": selectedCustomerId.value,
        "gstNo": gstNoController.text,
        "customerContactName": selectedContactName,
        "customerMobileNo": mobileNoCtrl.text,
        "customerEmailId": emailCtrl.text,
        "customerAddress": streetCtrl.text,
        "pincode": pinCodeCtrl.text,
        "landMark": selectedLandMark.value,
        "street": streetCtrl.text,
        "city": cityCtrl.text,
        "state": stateCtrl.text,
        "country": countryCtrl.text,
        "district": districtCtrl.text,
        "insertedByUserId": LocalDb.getString(AppConstants.userIdKey),
      };

      print(" Final selectedProductIds for other sales: $selectedProductIds");

      print("Selected Serial Numbers: ${selectedSerials}");
      print("Selected Product Ids: $selectedProductIds  ");


      bool isInserted =
          await SalesInsertRepository.insertSalesRecord(salesData);

      if (isInserted) {
        print('Other sales entry inserted>>>>${salesData}');
        Fluttertoast.showToast(msg: 'Other Sales record inserted successfully');

        serialNumberList.value = serialNumberList
            .map((item) => item.copyWith(isSelected: false))
            .toList();

        selectedContactName = '';
        mobileNoCtrl.clear();
        emailCtrl.clear();


        selectedContactName = '';
        mobileNoCtrl.clear();
        emailCtrl.clear();

        await Future.delayed(Duration(milliseconds: 50));


        Get.offAllNamed(AppRoute.dashboard);
      } else {
        Fluttertoast.showToast(msg: 'Failed to insert sales record');
        Get.back();
      }

      isSubmitLoading.value = false;
    }
  }

  Future<String> resendOtp() async {
    Fluttertoast.showToast(msg: 'Otp Resend to register mobile no');
    return '1234';
  }

  verifyOtp(String actualOTP, String otp, bool isMobileNumber) {
    bool isSame = otp == actualOTP;
    if (isSame) {
      Fluttertoast.showToast(msg: 'OTP Verify successfully');
      if (isMobileNumber) {
        isMobileNumberApproved.value = true;
      } else {
        isEmailAddressApprove.value = true;
      }
      Get.back();
    } else {
      Fluttertoast.showToast(msg: 'Wrong OTP');
    }
  }

  sendOtpToMobileNo(BuildContext context) async {
    print('sendOtpToMobileNo');
    isOtpSendToMobileIsLoading.value = true;
// String? otp=await LoginRepository.senOtpToMobil(mobileNoCtrl.text);
    String otp = '1234';
    await Future.delayed(3.seconds);
    if (otp.isNotEmpty) {
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return OtpVerificationDialog(
            '+91 ${mobileNoCtrl.text}',
            onOtpVerifyTrigger: (value) {
              verifyOtp('1234', value, true);
            },
            onResendOtp: () async {
              return resendOtp();
            },
          );
        },
        barrierLabel: '',
        barrierDismissible: false,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    }

    isOtpSendToMobileIsLoading.value = false;
  }

  sendOtpToEmail(BuildContext context) async {
    print('sendOtpToEmail');
    isOtpSendToEmailIsLoading.value = true;
// String? otp=await LoginRepository.senOtpToMobil(mobileNoCtrl.text);
    String otp = '1234';
    await Future.delayed(3.seconds);
    if (otp.isNotEmpty) {
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return OtpVerificationDialog(
            emailCtrl.text,
            onOtpVerifyTrigger: (value) {
              verifyOtp('1234', value, false);
            },
            onResendOtp: () async {
              return resendOtp();
            },
          );
        },
        barrierLabel: '',
        barrierDismissible: false,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    }

    isOtpSendToEmailIsLoading.value = false;
  }

  validateMobileNo(BuildContext context) async {
    if (mobileNoKey.currentState!.validate()) {
      sendOtpToMobileNo(context);
    }
  }

  validateEmail(BuildContext context) async {
    if (emailKey.currentState!.validate()) {
      sendOtpToEmail(context);
    }
  }

  getDataFromPinCode(String pinCode) async {
    isPinCodeDataLoading.value = true;
    addressList = [];
    landMarkDdKey.currentState?.reset();
    List data = await SalesInsertRepository.getAddressFromPinCode(pinCode);
    addressList = data;
    isPinCodeDataLoading.value = false;
  }
}

class ProductModel {
  String id;
  String materialNo;
  String materialDescreption;
  String invoiceDate;
  String invoiceNumber;
  String serialNumber;
  String salesOrderNo;
  String poNumber;

  ProductModel({
    required this.id,
    required this.materialDescreption,
    required this.materialNo,
    required this.invoiceNumber,
    required this.serialNumber,
    required this.invoiceDate,
    required this.salesOrderNo,
    required this.poNumber,
  });

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
      id: json['KSBSalesInvoiceId'],
      materialDescreption: json['MaterialDescription'],
      materialNo: json['MaterialNumber'],
      salesOrderNo: json['SalesOrder'],
      invoiceNumber: json['InvoiceNumber'],
      invoiceDate: json['InvoiceDate'],
      serialNumber: json['SerialNumber'],
      poNumber: json["PONumber"] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductModel &&
              runtimeType == other.runtimeType &&
              serialNumber == other.serialNumber;

  @override
  int get hashCode => serialNumber.hashCode;
}


// class ProductModel {
//   String id;
//   String materialNo;
//   String materialDescreption;
//   String invoiceDate;
//   String invoiceNumber;
//   String serialNumber;
//   String salesOrderNo;
//
//   ProductModel({
//     required this.id,
//     required this.materialDescreption,
//     required this.materialNo,
//     required this.invoiceNumber,
//     required this.serialNumber,
//     required this.invoiceDate,
//     required this.salesOrderNo,
//   });
//
//   factory ProductModel.fromJson(dynamic json) {
//     return ProductModel(
//         id: json['KSBSalesInvoiceId'],
//         materialDescreption: json['MaterialDescription'],
//         materialNo: json['MaterialNumber'],
//         salesOrderNo: json['SalesOrder'],
//         invoiceNumber: json['InvoiceNumber'],
//         invoiceDate: json['InvoiceDate'],
//         serialNumber: json['SerialNumber']);
//   }
// }

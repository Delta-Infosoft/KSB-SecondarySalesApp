import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
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

import '../../auth/view/widgets/otp_verification_dialog.dart';

class SalesInsertController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getProductList();
    salesDateCtrl.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  List addressList = [];
RxBool isSearchEnable =false.obs;
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

  TextEditingController searchCtrl = TextEditingController();
  RxBool isSubmitLoading = false.obs;

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
  String? selectedContactName = '';

  final GlobalKey<FormFieldState<String>> landMarkDdKey =
  GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> contactDDKey =
  GlobalKey<FormFieldState<String>>();


  onQuerySearch(String query){
    if(query.isEmpty){
      searchProducts.assignAll(products);
    }else{
      searchProducts.assignAll(products.where((element) {
        return element.materialNo.toLowerCase().contains(query.toLowerCase()) ||element.serialNumber.toLowerCase().contains(query.toLowerCase())|| element.materialDescreption.toLowerCase().contains(query.toLowerCase());
      },));
    }
  }





  RxString selectedLandMark = ''.obs;
  RxString selectedCustomerId = ''.obs;
  List<Customer> customersList = [];
  List<Contact> contactList = [];

  Future<void> getProductList() async {
    isProductLoading.value = true;
    products = await SalesInsertRepository.getProductList();
    searchProducts.value=List.of(products);
    // products = dummyProductData;
    isProductSelected = List.generate(products.length, (index) => false.obs);
    isProductLoading.value = false;
  }

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

  Future<void> submitSalesEntry() async {
    if (formKey.currentState!.validate()) {
      isSubmitLoading.value=true;
      Map<String, dynamic> salesData = {
        "ksbSalesInvoiceId": selectedProductIds,
        "salesDate": DateTime.now().toIso8601String(),
        "customerId":
           selectedCustomerId.value, // Replace with actual customer ID
        "gstNo": gstNoController.text,
        "customerContactName": 'custom',
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
        "insertedByUserId":
            LocalDb.getString(AppConstants.userIdKey), // Replace with actual user ID
      };

      bool isInserted =
          await SalesInsertRepository.insertSalesRecord(salesData);

      if (isInserted) {
        Fluttertoast.showToast(msg: 'Sales record inserted successfully');
        Get.offAllNamed(AppRoute.dashboard);
      } else {
        Fluttertoast.showToast(msg: 'Failed to insert sales record');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please fill all required fields');
    }
    isSubmitLoading.value=false;

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
  String serialNumber;

  ProductModel({
    required this.id,
    required this.materialDescreption,
    required this.materialNo,
    required this.serialNumber,
  });

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
        id: json['KSBSalesInvoiceId'],
        materialDescreption: json['MaterialDescription'],
        materialNo: json['MaterialNumber'],
        serialNumber: json['SerialNumber']);
  }
}

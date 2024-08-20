import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';
import 'package:ksb_secondary_sales/features/auth/model/repositories/login_repository.dart';
import 'package:ksb_secondary_sales/features/auth/view_model/login_controller.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_insert_reposiotory.dart';

import '../../auth/view/widgets/otp_verification_dialog.dart';

class SalesInsertController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getProductList();
    salesDateCtrl.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }
  List<ProductModel> products = [];
  List<RxBool> isProductSelected = [];
  RxBool isProductLoading = false.obs;
  RxBool isPinCodeDataLoading = false.obs;
  RxBool isOtpSendToMobileIsLoading = false.obs;
  RxBool isOtpSendToEmailIsLoading = false.obs;
  RxBool isMobileNumberApproved = false.obs;
  RxBool isEmailAddressApprove = false.obs;

  Future<void> getProductList()async{
    isProductLoading.value=true;

    products.addAll([
      ProductModel(
        imgUrl: 'https://t3.ftcdn.net/jpg/00/77/77/16/360_F_77771611_BCUZR6NW73NVdiLgmOeIzzSh4RP2U3aV.jpg',
        name: 'Product 1',
        description: 'Description of Product 1',
        mrp: '₹100',
      ),
      ProductModel(
        imgUrl: 'https://acszigalen.cloudimg.io/v7/https%3A%2F%2Flive-resources-e2e-sales.ksb.com%2Fresource%2Fimage%2F2018638%2Flandscape_ratio16x9%2F3300%2F1856%2Faf4f5e56a75b209f16ea37115d15880c%2FECB4CE14572AF1A9469E970534082D9C%2Fpic-sisto-cm1300.jpg?ci_url_encoded=1&optipress=3&height=844&width=1500',
        name: 'Product 2',
        description: 'Description of Product 2',
        mrp: '₹150',
      ),
      // Add more products as needed
    ]);
    isProductSelected  = List.generate(products.length, (index) => false.obs,);
    isProductLoading.value=false;
  }
  TextEditingController salesDateCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileNoCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController houseAndCityNameCtrl = TextEditingController();
  TextEditingController areaStreetCtrl = TextEditingController();
  TextEditingController pinCodeCtrl = TextEditingController();
  TextEditingController talukaCtrl = TextEditingController();
  TextEditingController districtCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileNoKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  submitSalesEntry(){

  }


  Future<String> resendOtp()async{
    Fluttertoast.showToast(msg: 'Otp Resend to register mobile no');
    return '1234';
  }
  verifyOtp(String actualOTP,String otp,bool isMobileNumber) {
    bool isSame = otp == actualOTP;
    if (isSame) {
      Fluttertoast.showToast(msg: 'OTP Verify successfully');
      if(isMobileNumber) {
        isMobileNumberApproved.value=true;
      }else{
        isEmailAddressApprove.value=true;
      }
      Get.back();
    } else {
      Fluttertoast.showToast(msg: 'Wrong OTP');
    }
  }

  sendOtpToMobileNo(BuildContext context) async {
    print('sendOtpToMobileNo');
    isOtpSendToMobileIsLoading.value=true;
// String? otp=await LoginRepository.senOtpToMobil(mobileNoCtrl.text);
    String otp='1234';
    await Future.delayed(3.seconds);
if(otp.isNotEmpty){
   showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return OtpVerificationDialog(
        '+91 ${mobileNoCtrl.text}',
        onOtpVerifyTrigger:  (value) {
          verifyOtp('1234', value,true);
        },
        onResendOtp: ()async{
          return   resendOtp();
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

    isOtpSendToMobileIsLoading.value=false;
  }


  sendOtpToEmail(BuildContext context) async {
    print('sendOtpToEmail');
    isOtpSendToEmailIsLoading.value=true;
// String? otp=await LoginRepository.senOtpToMobil(mobileNoCtrl.text);
    String otp='1234';
    await Future.delayed(3.seconds);
    if(otp.isNotEmpty){
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return OtpVerificationDialog(
            emailCtrl.text,
            onOtpVerifyTrigger:  (value) {
              verifyOtp('1234', value,false);
            },
            onResendOtp: ()async{
              return   resendOtp();
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

    isOtpSendToEmailIsLoading.value=false;
  }

  validateMobileNo(BuildContext context) async {
    if(mobileNoKey.currentState!.validate()){
      sendOtpToMobileNo(context);
    }
  }
  validateEmail(BuildContext context) async {
    if(emailKey.currentState!.validate()){
      sendOtpToEmail(context);
    }
  }
  getDataFromPinCode(String pinCode) async {
    isPinCodeDataLoading.value = true;
    final data = await SalesInsertRepository.getAddressFromPinCode(pinCode);
    if (data.isNotEmpty) {
      Map address = data.first;
      stateCtrl.text = address['State'];
      talukaCtrl .text = address['Division'];
      districtCtrl.text = address['District'];
    } else {
      stateCtrl.clear();
      talukaCtrl.clear();
      districtCtrl.clear();
    }
    isPinCodeDataLoading.value = false;
  }
}



class ProductModel {
  String imgUrl;
  String name;
  String description;
  String mrp;

  ProductModel({
    required this.imgUrl,
    required this.name,
    required this.description,
    required this.mrp,
  });
}

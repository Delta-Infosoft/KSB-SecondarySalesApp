import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ksb_secondary_sales/core/config/app_route.dart';
import 'package:ksb_secondary_sales/core/utils/common_services/local_db.dart';
import 'package:ksb_secondary_sales/core/utils/constants/app_constants.dart';

class SalesInsertController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getProductList();
  }
  List<ProductModel> products = [];
  List<RxBool> isProductSelected = [];
  RxBool isProductLoading = false.obs;
  Future<void> getProductList()async{
    isProductLoading.value=true;

    products.addAll([
      ProductModel(
        imgUrl: 'https://t3.ftcdn.net/jpg/00/77/77/16/360_F_77771611_BCUZR6NW73NVdiLgmOeIzzSh4RP2U3aV.jpg',
        name: 'Product 1',
        description: 'Description of Product 1',
        mrp: '\$100',
      ),
      ProductModel(
        imgUrl: 'https://t3.ftcdn.net/jpg/00/77/77/16/360_F_77771611_BCUZR6NW73NVdiLgmOeIzzSh4RP2U3aV.jpg',
        name: 'Product 2',
        description: 'Description of Product 2',
        mrp: '\$150',
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

  submitSalesEntry(){

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

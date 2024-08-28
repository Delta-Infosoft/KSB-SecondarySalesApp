import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_data_model.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_view_repo.dart';

class SalesViewController extends GetxController{
  @override
  void onInit() {
    super.onInit();
    getSalesData();
  }

  RxBool isLoading = false.obs;
  List<SalesData> salesList = [];

  getSalesData() async {
    isLoading.value = true;
    salesList = await SalesViewRepo.getSalesList();
    isLoading.value = false;
  }
}
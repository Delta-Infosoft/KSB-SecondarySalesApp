import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_data_model.dart';
import 'package:ksb_secondary_sales/features/sales/model/sales_view_repo.dart';

class SalesViewController extends GetxController{

  var filterFromDate = Rxn<DateTime>();
  var filterToDate = Rxn<DateTime>();

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
    salesList.sort((a, b) => b.salesDate.compareTo(a.salesDate),);
    isLoading.value = false;
  }

  List<SalesData> get filteredSalesList {
    if (filterFromDate.value != null && filterToDate.value != null) {
      return salesList.where((sale) {
        return sale.salesDate.isAfter(filterFromDate.value!.subtract(Duration(days: 1))) &&
            sale.salesDate.isBefore(filterToDate.value!.add(Duration(days: 1)));
      }).toList();
    } else {
      return salesList;
    }
  }
}
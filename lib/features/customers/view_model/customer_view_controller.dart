import 'package:get/get.dart';
import '../../home/view/screens/home.dart';
import '../model/customer_repository.dart';

class CustomerViewController extends GetxController {
  RxString selectedFilter = 'Approved'.obs;
  RxBool isLoading = false.obs;

  var customersList = <Customer>[].obs;
  var filteredCustomers = <Customer>[].obs;
  var pendingCustomers = <Customer>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCustomerList();
  }
  void filterCustomerList() {
    final filter = selectedFilter.value.toLowerCase();

    if (filter == 'approved') {
      filteredCustomers.value = customersList
          .where((e) => e.c4cId != null && e.c4cId.isNotEmpty)
          .toList();
    } else if (filter == 'pending') {
      filteredCustomers.value = customersList
          .where((e) => e.c4cId  == null || e.c4cId.isEmpty)
          .toList();
    } else {
      filteredCustomers.value = customersList;
    }
  }

  Future<void> getCustomerList({String? approvalStatus}) async {
    isLoading.value = true;

    List<Customer> response = await CustomerRepository.getCustomerById(
      approvalStatus: approvalStatus == 'All' ? null : approvalStatus,
    );

    customersList.value = response;
    filterCustomerList();

    pendingCustomers.value =
        response.where((e) => e.c4cId.toLowerCase() == 'pending').toList();

    isLoading.value = false;
  }


// Future<void> getCustomerList() async {
  //   isLoading.value = true;
  //
  //   List<Customer> response = await CustomerRepository.getCustomerById();
  //
  //   customersList.value = response;
  //   filterCustomerList();
  //
  //   // optionally build pending list
  //   pendingCustomers.value =
  //       response.where((e) => e.c4cId.toLowerCase() == 'pending').toList();
  //
  //   isLoading.value = false;
  // }
}

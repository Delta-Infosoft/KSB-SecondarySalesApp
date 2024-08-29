import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/customers/model/customer_repository.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';

class CustomerViewController extends GetxController{

  @override
  void onInit() {
    super.onInit();

    getCustomerList();

  }

  RxBool isLoading = false.obs;
  List<Customer> customersList = [];

  Future<void> getCustomerList() async {
    isLoading.value=true;
    customersList =await  CustomerRepository.getCustomerById();
    customersList.sort((a, b) => b.insertedOn.compareTo(a.insertedOn));
    isLoading.value=false;
  }

}
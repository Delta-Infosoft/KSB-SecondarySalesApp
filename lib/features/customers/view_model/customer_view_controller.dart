import 'package:get/get.dart';
import 'package:ksb_secondary_sales/features/customers/model/customer_repository.dart';
import 'package:ksb_secondary_sales/features/home/view/screens/home.dart';

class CustomerViewController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    print('get customer list');
    fetchCustomerTypes();
    fetchCompanyTypes();
    fetchIndustryTypes();
    getCustomerList();

  }

  // List of Dropdown Options
  List customerTypes = [];
  List companyTypes = [];
  List industryTypes = [];
  RxBool isCustomerTypeLoading = false.obs;
  RxBool isCompanyTypeLoading = false.obs;
  RxBool isIndustryTypeLoading = false.obs;
  RxBool isLoading = false.obs;
  List<Customer> customersList = [];

  Future<void> getCustomerList() async {
    isLoading.value=true;
    customersList =await  CustomerRepository.getCustomerById();
    customersList.sort((a, b) => b.insertedOn.compareTo(a.insertedOn));
    isLoading.value=false;
  }

  Future<void> fetchCustomerTypes() async {
    print('fetchCustomerTypes');
    isCustomerTypeLoading.value = true;
    customerTypes = await CustomerRepository.getTestListFromGroup('CustomerType');
    print('customerTypes');
    print(customerTypes);
    isCustomerTypeLoading.value = false;
  }

  // Fetch CompanyTypes
  Future<void> fetchCompanyTypes() async {
    isCompanyTypeLoading.value = true;
    companyTypes = await CustomerRepository.getTestListFromGroup('CompanyType');
    isCompanyTypeLoading.value = false;
  }

  // Fetch IndustryTypes
  Future<void> fetchIndustryTypes() async {
    isIndustryTypeLoading.value = true;
    industryTypes = await CustomerRepository.getTestListFromGroup('IndustryType');
    isIndustryTypeLoading.value = false;
  }
}
class ApiUrl{
  //dummy URLS
  static const String baseUrl = 'http://110.227.253.77:90/ksbSecondarysalesAPI/api';
  static const String loginUrl = '$baseUrl/Login/Login';
  static const String insertCustomer = '$baseUrl/Customer/Insert';
  static const String getCustomerById = '$baseUrl/Customer/GetCustomerById';
  static const String textListApi = '$baseUrl/Common/TextList';
  static const String productionList = '$baseUrl/Common/TextList';
  static const String getProductListUrl = '$baseUrl/KSBSalesInvoice/GetAll';
  static const String insertSalesEntryUrl = '$baseUrl/SalesEntry/Insert';
  static const String salesList = '$baseUrl/SalesEntry/GetSalesEntryById';
}
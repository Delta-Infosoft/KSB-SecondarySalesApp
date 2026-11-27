class ApiUrl {
  //dummy URLS
  // static const String baseUrl = 'http://192.168.0.98:90/ksbSecondarysalesAPI/api'; // local

   // static const String baseUrl =
   //   'https://adapp.ksbindia.co.in/ksbsecondarysalesapi/api';   // Live Link

  static const String baseUrl =
      'http://galaxy.ierp.in:90/ksbSecondarysalesAPI/api';

  static const String loginUrl = '$baseUrl/Login/Login';
  static const String insertCustomer = '$baseUrl/Customer/Insert';
  static const String getCustomerById = '$baseUrl/Customer/GetApprovedCustomers';
  static const String getUserByID = '$baseUrl/User/GetUserById';
  static const String getCustomerList = '$baseUrl/Customer/GetCustomerById';

  // Customer approval (same endpoints as the web "Add Edit Customer" page)
  static const String getCustomerApprovalByStatus =
      '$baseUrl/Customer/GetCustomerApprovalByStatus';
  static const String getCustomerDetailsById =
      '$baseUrl/Customer/GetCustomerById';
  static const String updateCustomerApproval =
      '$baseUrl/Customer/UpdateCustomerApproval';
  static const String textListApi = '$baseUrl/Common/TextList';
  static const String productionList = '$baseUrl/Common/TextList';
  // static const String getProductListSerialNumber = '$baseUrl/KSBSalesInvoice/GetAll';
  static const String getProductListSerialNumber = '$baseUrl/KSBSalesInvoice/GetAllPending';
  // static const String getProductListSerialNumber = '$baseUrl/SalesEntry/GetPendingSalesInvoices';

  static const String getProductListUrl = '$baseUrl/KSBSalesInvoice/GetKSBSalesInvoiceByUsername';

  static const String getFilterProductsUrl =
      '$baseUrl/KSBSalesInvoice/GetFilteredKSBSalesInvoice';
  static const String insertSalesEntryUrl = '$baseUrl/SalesEntry/Insert';
  // Serial No not found while linking: notify Admin / HO (same as web).
  static const String reportMissingSerial =
      '$baseUrl/SalesEntry/ReportMissingSerial';
  static const String salesList = '$baseUrl/SalesEntry/GetSalesEntryById';
  static const String termsAndConditionPDF = '$baseUrl/TextLists/GetLatesFiles';

  // Dashboard (same endpoints the web dashboard uses)
  static const String getAllZone = '$baseUrl/TextLists/GetAllZone';
  static const String getAllBranch = '$baseUrl/TextLists/GetAllBranch';
  static const String dashTotalPumpIssued = '$baseUrl/Dashboard/GetTotalPumpIssued';
  static const String dashTotalPumpsLinked = '$baseUrl/Dashboard/GetTotalPumpsLinked';
  static const String dashTop10Customers = '$baseUrl/Dashboard/GetTop10Customers';
  static const String dashTop10Products = '$baseUrl/Dashboard/GetTop10Products';
  static const String dashPumpLinkedOverTime = '$baseUrl/Dashboard/GetPumpLinkedOverTime';
  static const String dashZoneWiseData = '$baseUrl/Dashboard/GetZoneWiseData';
  static const String dashBranchWiseData = '$baseUrl/Dashboard/GetBranchWiseData';

  // Policy documents (same endpoints the web "Documents" page uses)
  static const String policyGetForUser = '$baseUrl/Policy/GetForUser';
  static String policyDownload(String policyId) => '$baseUrl/Policy/Download/$policyId';

  /// API root without `/api`, e.g. http://galaxy.ierp.in:90/ksbSecondarysalesAPI
  static String get apiRoot => baseUrl.substring(0, baseUrl.length - '/api'.length);

  /// Converts the API's relative `filePath` (e.g. `PolicyDocuments/abc.pdf`)
  /// into a full http URL: `<apiRoot>/PolicyDocuments/abc.pdf`.
  static String policyFile(String filePath) {
    final path = filePath.trim().replaceAll('\\', '/');
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Uri.encodeFull(path);
    }
    final relative = path.startsWith('/') ? path.substring(1) : path;
    return Uri.encodeFull('$apiRoot/$relative');
  }
}

// aaa - 123

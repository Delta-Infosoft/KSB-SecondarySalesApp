
class SalesData {
  final String salesEntryId;
  final String materialNo;
  final String ksbSalesInvoiceId;
  final DateTime salesDate;
  final String customerId;
  final String customerName;
  final String gstNo;
  final String customerContactName;
  final String customerMobileNo;
  final String customerEmailId;
  final String customerAddress;
  final String pincode;
  final String landMark;
  final String street;
  final String city;
  final String state;
  final String country;
  final String district;
  final DateTime insertedOn;
  final DateTime lastUpdatedOn;
  final String insertedByUserId;
  final String lastUpdatedByUserId;

  SalesData({
    required this.salesEntryId,
    required this.materialNo,
    required this.ksbSalesInvoiceId,
    required this.salesDate,
    required this.customerId,
    required this.customerName,
    required this.gstNo,
    required this.customerContactName,
    required this.customerMobileNo,
    required this.customerEmailId,
    required this.customerAddress,
    required this.pincode,
    required this.landMark,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.district,
    required this.insertedOn,
    required this.lastUpdatedOn,
    required this.insertedByUserId,
    required this.lastUpdatedByUserId,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      salesEntryId: json['salesEntryId'],
      materialNo: json['MaterialNo'],
      ksbSalesInvoiceId: json['ksbSalesInvoiceId'],
      salesDate: DateTime.parse(json['salesDate']),
      customerId: json['customerId'],
      customerName: json['customerName'],
      gstNo: json['gstNo'],
      customerContactName: json['customerContactName'],
      customerMobileNo: json['customerMobileNo'],
      customerEmailId: json['customerEmailId'],
      customerAddress: json['customerAddress'],
      pincode: json['pincode'],
      landMark: json['landMark'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      district: json['district'],
      insertedOn: DateTime.parse(json['insertedOn']),
      lastUpdatedOn: DateTime.parse(json['lastUpdatedOn']),
      insertedByUserId: json['insertedByUserId'],
      lastUpdatedByUserId: json['lastUpdatedByUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesEntryId': salesEntryId,
      'ksbSalesInvoiceId': ksbSalesInvoiceId,
      'salesDate': salesDate.toIso8601String(),
      'customerId': customerId,
      'gstNo': gstNo,
      'customerContactName': customerContactName,
      'customerMobileNo': customerMobileNo,
      'customerEmailId': customerEmailId,
      'customerAddress': customerAddress,
      'pincode': pincode,
      'landMark': landMark,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'district': district,
      'insertedOn': insertedOn.toIso8601String(),
      'lastUpdatedOn': lastUpdatedOn.toIso8601String(),
      'insertedByUserId': insertedByUserId,
      'lastUpdatedByUserId': lastUpdatedByUserId,
    };
  }
}

List<SalesData> salesData = [
  SalesData(
    materialNo: 'IN156966',
    salesEntryId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    customerName: "customerName",
    ksbSalesInvoiceId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    salesDate: DateTime.now(),
    customerId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    gstNo: "1234567891",
    customerContactName: "John Doe",
    customerMobileNo: "1234567890",
    customerEmailId: "johndoe@example.com",
    customerAddress: "123 Street",
    pincode: "123456",
    landMark: "Near Park",
    street: "Main Street",
    city: "New York",
    state: "NY",
    country: "USA",
    district: "Manhattan",
    insertedOn: DateTime.now(),
    lastUpdatedOn: DateTime.now(),
    insertedByUserId: "C313B57A-5BC3-4FB9-8F23-2028343FB16F",
    lastUpdatedByUserId: "C313B57A-5BC3-4FB9-8F23-2028343FB16F",
  ),
  SalesData(
    materialNo: 'IN156585',
    customerName: "customerName",
    salesEntryId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    ksbSalesInvoiceId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    salesDate: DateTime.now(),
    customerId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    gstNo: "1234567891",
    customerContactName: "John Doe",
    customerMobileNo: "1234567890",
    customerEmailId: "johndoe@example.com",
    customerAddress: "123 Street",
    pincode: "123456",
    landMark: "Near Park",
    street: "Main Street",
    city: "New York",
    state: "NY",
    country: "USA",
    district: "Manhattan",
    insertedOn: DateTime.now(),
    lastUpdatedOn: DateTime.now(),
    insertedByUserId: "C313B57A-5BC3-4FB9-8F23-2028343FB16F",
    lastUpdatedByUserId: "C313B57A-5BC3-4FB9-8F23-2028343FB16F",
  ),
];
import 'dart:convert';
class SalesData {
  String salesEntryId;
  String ksbSalesInvoiceId;
  String salesMaterialNumbers;
  String salesMaterialDescreption;
  DateTime salesDate;
  String customerId;
  String gstNo;
  String customerContactName;
  String customerMobileNo;
  String customerEmailId;
  String customerAddress;
  String pincode;
  String landMark;
  String street;
  String city;
  String state;
  String country;
  String district;
  DateTime insertedOn;
  DateTime lastUpdatedOn;
  String insertedByUserId;
  String? lastUpdatedByUserId;
  String userName;
  String customerName;
  final List<Product> products;

  SalesData({
    required this.salesEntryId,
    required this.ksbSalesInvoiceId,
    required this.salesMaterialNumbers,
    required this.salesMaterialDescreption,
    required this.salesDate,
    required this.customerId,
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
    this.lastUpdatedByUserId,
    required this.userName,
    required this.customerName,
    required this.products,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    List<String> materialNumbers = (json['MaterialNumbers'] as String).split(',');
    List<String> materialDescriptions = (json['MaterialDescription'] as String).split(',');

    List<Product> products = List.generate(materialNumbers.length, (index) {
      return Product(
        materialNumber: materialNumbers[index],
        materialDescription: materialDescriptions[index],
        serialNumber: '198298989839839'
      );
    });
    return SalesData(
      salesEntryId: json['SalesEntryId'],
      ksbSalesInvoiceId: json['KSBSalesInvoiceId'],
      salesMaterialNumbers: json['MaterialNumbers']??'',
      salesMaterialDescreption: json['MaterialDescription']??'',
      salesDate: DateTime.parse(json['SalesDate']),
      customerId: json['CustomerId'],
      gstNo: json['GSTNo'],
      customerContactName: json['CustomerContactName'],
      customerMobileNo: json['CustomerMobileNo'],
      customerEmailId: json['CustomerEmailId'],
      customerAddress: json['CustomerAddress'],
      pincode: json['Pincode'],
      landMark: json['LandMark'],
      street: json['Street'],
      city: json['City'],
      state: json['State'],
      country: json['Country'],
      district: json['District'],
      insertedOn: DateTime.parse(json['InsertedOn']),
      lastUpdatedOn: DateTime.parse(json['LastUpdatedOn']),
      insertedByUserId: json['InsertedByUserId'],
      lastUpdatedByUserId: json['LastUpdatedByUserId'],
      userName: json['UserName'],
      customerName: json['CustomerName'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SalesEntryId': salesEntryId,
      'KSBSalesInvoiceId': ksbSalesInvoiceId,
      'SalesDate': salesDate.toIso8601String(),
      'CustomerId': customerId,
      'GSTNo': gstNo,
      'CustomerContactName': customerContactName,
      'CustomerMobileNo': customerMobileNo,
      'CustomerEmailId': customerEmailId,
      'CustomerAddress': customerAddress,
      'Pincode': pincode,
      'LandMark': landMark,
      'Street': street,
      'City': city,
      'State': state,
      'Country': country,
      'District': district,
      'InsertedOn': insertedOn.toIso8601String(),
      'LastUpdatedOn': lastUpdatedOn.toIso8601String(),
      'InsertedByUserId': insertedByUserId,
      'LastUpdatedByUserId': lastUpdatedByUserId,
      'UserName': userName,
      'CustomerName': customerName,
    };
  }
}

class Product {
  final String materialNumber;
  final String materialDescription;
  final String serialNumber;

  Product({
    required this.materialNumber,
    required this.materialDescription,
    required this.serialNumber,
  });
}

import 'dart:convert';

class SalesData {
  final String salesEntryId;
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
  final String insertedByUserId;
  final List<Product> products;

  SalesData({
    required this.salesEntryId,
    required this.ksbSalesInvoiceId,
    required this.salesDate,
    required this.customerName,
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
    required this.insertedByUserId,
    required this.products,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      salesEntryId: json['salesEntryId'],
      customerName: json['customerName'],
      ksbSalesInvoiceId: json['ksbSalesInvoiceId'].toString() ?? '',
      salesDate: DateTime.parse(json['salesDate']),
      customerId: json['customerId'],
      gstNo: json['gstNo'].toString() ?? '',
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
      insertedByUserId: json['insertedByUserId'],
      products: List<Product>.from(
          json['materialData'].map((data) => Product.fromJson(data))),
    );
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      materialNumber: json['materialNumber'],
      materialDescription: json['materialDescription'],
      serialNumber: json['serialNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materialNumber': materialNumber,
      'materialDescription': materialDescription,
      'serialNumber': serialNumber,
    };
  }
}

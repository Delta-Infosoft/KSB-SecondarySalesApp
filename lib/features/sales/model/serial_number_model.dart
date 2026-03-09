// To parse this JSON data, do
//
//     final serialNumberModel = serialNumberModelFromJson(jsonString);

import 'dart:convert';

SerialNumberModel serialNumberModelFromJson(String str) => SerialNumberModel.fromJson(json.decode(str));

String serialNumberModelToJson(SerialNumberModel data) => json.encode(data.toJson());

class SerialNumberModel {
  int? isSuccessful;
  String? message;
  List<SerialNumberData>? data;

  SerialNumberModel({
    this.isSuccessful,
    this.message,
    this.data,
  });

  factory SerialNumberModel.fromJson(Map<String, dynamic> json) => SerialNumberModel(
    isSuccessful: json["isSuccessful"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SerialNumberData>.from(json["data"]!.map((x) => SerialNumberData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccessful": isSuccessful,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SerialNumberData {
  String? ksbSalesInvoiceId;
  String? materialNumber;
  String? materialDescription;
  String? salesOrder;
  String? serialNumber;
  String? invoiceNumber;
  DateTime? invoiceDate;

  SerialNumberData({
    this.ksbSalesInvoiceId,
    this.materialNumber,
    this.materialDescription,
    this.salesOrder,
    this.serialNumber,
    this.invoiceNumber,
    this.invoiceDate,
  });

  factory SerialNumberData.fromJson(Map<String, dynamic> json) => SerialNumberData(
    ksbSalesInvoiceId: json["KSBSalesInvoiceId"],
    materialNumber: json["MaterialNumber"],
    materialDescription: json["MaterialDescription"],
    salesOrder: json["SalesOrder"],
    serialNumber: json["SerialNumber"],
    invoiceNumber: json["InvoiceNumber"],
    invoiceDate: json["InvoiceDate"] == null ? null : DateTime.parse(json["InvoiceDate"]),
  );

  Map<String, dynamic> toJson() => {
    "KSBSalesInvoiceId": ksbSalesInvoiceId,
    "MaterialNumber": materialNumber,
    "MaterialDescription": materialDescription,
    "SalesOrder": salesOrder,
    "SerialNumber": serialNumber,
    "InvoiceNumber": invoiceNumber,
    "InvoiceDate": invoiceDate?.toIso8601String(),
  };
}

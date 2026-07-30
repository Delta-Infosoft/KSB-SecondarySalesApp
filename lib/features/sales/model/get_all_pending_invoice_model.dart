// To parse this JSON data, do
//
//     final getAllPendingInvoiceSerialNumberModel = getAllPendingInvoiceSerialNumberModelFromJson(jsonString);

import 'dart:convert';

GetAllPendingInvoiceSerialNumberModel getAllPendingInvoiceSerialNumberModelFromJson(String str) => GetAllPendingInvoiceSerialNumberModel.fromJson(json.decode(str));

String getAllPendingInvoiceSerialNumberModelToJson(GetAllPendingInvoiceSerialNumberModel data) => json.encode(data.toJson());

class GetAllPendingInvoiceSerialNumberModel {
  int? isSuccessful;
  String? message;
  List<GetAllPendingInvoiceData>? data;

  GetAllPendingInvoiceSerialNumberModel({
    this.isSuccessful,
    this.message,
    this.data,
  });

  factory GetAllPendingInvoiceSerialNumberModel.fromJson(Map<String, dynamic> json) => GetAllPendingInvoiceSerialNumberModel(
    isSuccessful: json["isSuccessful"],
    message: json["message"],
    data: json["data"] == null ? [] : List<GetAllPendingInvoiceData>.from(json["data"]!.map((x) => GetAllPendingInvoiceData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccessful": isSuccessful,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GetAllPendingInvoiceData {
  dynamic ksbSalesInvoiceId;
  String? materialNumber;
  String? materialDescription;
  String? salesOrder;
  String? serialNumber;
  String? invoiceNumber;
  DateTime? invoiceDate;
  int? isLinked;

  GetAllPendingInvoiceData({
    this.ksbSalesInvoiceId,
    this.materialNumber,
    this.materialDescription,
    this.salesOrder,
    this.serialNumber,
    this.invoiceNumber,
    this.invoiceDate,
    this.isLinked,
  });

  factory GetAllPendingInvoiceData.fromJson(Map<String, dynamic> json) => GetAllPendingInvoiceData(
    ksbSalesInvoiceId: json["KSBSalesInvoiceId"],
    materialNumber: json["MaterialNumber"],
    materialDescription: json["MaterialDescription"],
    salesOrder: json["SalesOrder"],
    serialNumber: json["SerialNumber"],
    invoiceNumber: json["InvoiceNumber"],
    invoiceDate: json["InvoiceDate"] == null ? null : DateTime.parse(json["InvoiceDate"]),
    isLinked: json["IsLinked"] ?? 0
  );

  Map<String, dynamic> toJson() => {
    "KSBSalesInvoiceId": ksbSalesInvoiceId,
    "MaterialNumber": materialNumber,
    "MaterialDescription": materialDescription,
    "SalesOrder": salesOrder,
    "SerialNumber": serialNumber,
    "InvoiceNumber": invoiceNumber,
    "InvoiceDate": invoiceDate?.toIso8601String(),
    "IsLinked": isLinked,
  };
}

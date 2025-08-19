// To parse this JSON data, do
//
//     final termsAndConditionsModel = termsAndConditionsModelFromJson(jsonString);

import 'dart:convert';

TermsAndConditionsModel termsAndConditionsModelFromJson(String str) => TermsAndConditionsModel.fromJson(json.decode(str));

String termsAndConditionsModelToJson(TermsAndConditionsModel data) => json.encode(data.toJson());

class TermsAndConditionsModel {
  int? isSuccessful;
  String? message;
  List<TermsAndConditionData>? data;

  TermsAndConditionsModel({
    this.isSuccessful,
    this.message,
    this.data,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) => TermsAndConditionsModel(
    isSuccessful: json["isSuccessful"],
    message: json["message"],
    data: json["data"] == null ? [] : List<TermsAndConditionData>.from(json["data"]!.map((x) => TermsAndConditionData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccessful": isSuccessful,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TermsAndConditionData {
  String? fileId;
  String? fileName;
  String? fileUrl;
  DateTime? insertedOn;

  TermsAndConditionData({
    this.fileId,
    this.fileName,
    this.fileUrl,
    this.insertedOn,
  });

  factory TermsAndConditionData.fromJson(Map<String, dynamic> json) => TermsAndConditionData(
    fileId: json["fileId"],
    fileName: json["fileName"],
    fileUrl: json["fileURL"],
    insertedOn: json["insertedOn"] == null ? null : DateTime.parse(json["insertedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "fileId": fileId,
    "fileName": fileName,
    "fileURL": fileUrl,
    "insertedOn": insertedOn?.toIso8601String(),
  };
}

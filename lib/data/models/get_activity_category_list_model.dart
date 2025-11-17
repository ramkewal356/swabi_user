// To parse this JSON data, do
//
//     final getActivityCategoryModel = getActivityCategoryModelFromJson(jsonString);

import 'dart:convert';

GetActivityCategoryModel getActivityCategoryModelFromJson(String str) =>
    GetActivityCategoryModel.fromJson(json.decode(str));

String getActivityCategoryModelToJson(GetActivityCategoryModel data) =>
    json.encode(data.toJson());

class GetActivityCategoryModel {
  Status? status;
  List<Datum>? data;

  GetActivityCategoryModel({
    this.status,
    this.data,
  });

  factory GetActivityCategoryModel.fromJson(Map<String, dynamic> json) =>
      GetActivityCategoryModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? activityCategoryId;
  String? activityCategoryName;
  String? activityCategoryIcon;
  DateTime? createdDate;
  DateTime? modifiedDate;

  Datum({
    this.activityCategoryId,
    this.activityCategoryName,
    this.activityCategoryIcon,
    this.createdDate,
    this.modifiedDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        activityCategoryId: json["activityCategoryId"],
        activityCategoryName: json["activityCategoryName"],
        activityCategoryIcon: json["activityCategoryIcon"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "activityCategoryId": activityCategoryId,
        "activityCategoryName": activityCategoryName,
        "activityCategoryIcon": activityCategoryIcon,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
      };
}

class Status {
  String? httpCode;
  bool? success;
  String? message;

  Status({
    this.httpCode,
    this.success,
    this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        httpCode: json["httpCode"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

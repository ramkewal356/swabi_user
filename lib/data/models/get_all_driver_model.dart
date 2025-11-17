// To parse this JSON data, do
//
//     final getAllDriverModel = getAllDriverModelFromJson(jsonString);

import 'dart:convert';

GetAllDriverModel getAllDriverModelFromJson(String str) =>
    GetAllDriverModel.fromJson(json.decode(str));

String getAllDriverModelToJson(GetAllDriverModel data) =>
    json.encode(data.toJson());

class GetAllDriverModel {
  Status? status;
  Data? data;

  GetAllDriverModel({
    this.status,
    this.data,
  });

  factory GetAllDriverModel.fromJson(Map<String, dynamic> json) =>
      GetAllDriverModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? totalDriver;
  int? numberOfActiveDriver;
  int? numberOfInActiveDriver;

  Data({
    this.totalDriver,
    this.numberOfActiveDriver,
    this.numberOfInActiveDriver,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalDriver: json["totalDriver"],
        numberOfActiveDriver: json["numberOfActiveDriver"],
        numberOfInActiveDriver: json["numberOfInActiveDriver"],
      );

  Map<String, dynamic> toJson() => {
        "totalDriver": totalDriver,
        "numberOfActiveDriver": numberOfActiveDriver,
        "numberOfInActiveDriver": numberOfInActiveDriver,
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

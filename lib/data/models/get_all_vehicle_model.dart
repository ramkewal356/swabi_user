// To parse this JSON data, do
//
//     final getAllVehicleModel = getAllVehicleModelFromJson(jsonString);

import 'dart:convert';

GetAllVehicleModel getAllVehicleModelFromJson(String str) =>
    GetAllVehicleModel.fromJson(json.decode(str));

String getAllVehicleModelToJson(GetAllVehicleModel data) =>
    json.encode(data.toJson());

class GetAllVehicleModel {
  Status? status;
  Data? data;

  GetAllVehicleModel({
    this.status,
    this.data,
  });

  factory GetAllVehicleModel.fromJson(Map<String, dynamic> json) =>
      GetAllVehicleModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? totalVehicle;
  int? numberOfInActiveVehicle;
  int? numberOfActiveVehicle;

  Data({
    this.totalVehicle,
    this.numberOfInActiveVehicle,
    this.numberOfActiveVehicle,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalVehicle: json["totalVehicle"],
        numberOfInActiveVehicle: json["numberOfInActiveVehicle"],
        numberOfActiveVehicle: json["numberOfActiveVehicle"],
      );

  Map<String, dynamic> toJson() => {
        "totalVehicle": totalVehicle,
        "numberOfInActiveVehicle": numberOfInActiveVehicle,
        "numberOfActiveVehicle": numberOfActiveVehicle,
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

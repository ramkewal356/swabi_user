// To parse this JSON data, do
//
//     final getAllPackageBookingModel = getAllPackageBookingModelFromJson(jsonString);

import 'dart:convert';

GetAllPackageBookingModel getAllPackageBookingModelFromJson(String str) =>
    GetAllPackageBookingModel.fromJson(json.decode(str));

String getAllPackageBookingModelToJson(GetAllPackageBookingModel data) =>
    json.encode(data.toJson());

class GetAllPackageBookingModel {
  Status? status;
  Data? data;

  GetAllPackageBookingModel({
    this.status,
    this.data,
  });

  factory GetAllPackageBookingModel.fromJson(Map<String, dynamic> json) =>
      GetAllPackageBookingModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? numberOfUpcomingPackageBooking;
  int? numberOfCancelledPackageBooking;
  int? numberOfCompletedPackageBooking;
  int? totalPackageBooking;

  Data({
    this.numberOfUpcomingPackageBooking,
    this.numberOfCancelledPackageBooking,
    this.numberOfCompletedPackageBooking,
    this.totalPackageBooking,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        numberOfUpcomingPackageBooking: json["numberOfUpcomingPackageBooking"],
        numberOfCancelledPackageBooking:
            json["numberOfCancelledPackageBooking"],
        numberOfCompletedPackageBooking:
            json["numberOfCompletedPackageBooking"],
        totalPackageBooking: json["totalPackageBooking"],
      );

  Map<String, dynamic> toJson() => {
        "numberOfUpcomingPackageBooking": numberOfUpcomingPackageBooking,
        "numberOfCancelledPackageBooking": numberOfCancelledPackageBooking,
        "numberOfCompletedPackageBooking": numberOfCompletedPackageBooking,
        "totalPackageBooking": totalPackageBooking,
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

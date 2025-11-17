// To parse this JSON data, do
//
//     final getAllRentalBookingModel = getAllRentalBookingModelFromJson(jsonString);

import 'dart:convert';

GetAllRentalBookingModel getAllRentalBookingModelFromJson(String str) =>
    GetAllRentalBookingModel.fromJson(json.decode(str));

String getAllRentalBookingModelToJson(GetAllRentalBookingModel data) =>
    json.encode(data.toJson());

class GetAllRentalBookingModel {
  Status? status;
  Data? data;

  GetAllRentalBookingModel({
    this.status,
    this.data,
  });

  factory GetAllRentalBookingModel.fromJson(Map<String, dynamic> json) =>
      GetAllRentalBookingModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? numberOfCompletedRentalBooking;
  int? numberOfBookedRentalBooking;
  int? totalRentalBooking;
  int? numberOfCancelledRentalBooking;
  int? numberOfOnRunningRentalBooking;

  Data({
    this.numberOfCompletedRentalBooking,
    this.numberOfBookedRentalBooking,
    this.totalRentalBooking,
    this.numberOfCancelledRentalBooking,
    this.numberOfOnRunningRentalBooking,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        numberOfCompletedRentalBooking: json["numberOfCompletedRentalBooking"],
        numberOfBookedRentalBooking: json["numberOfBookedRentalBooking"],
        totalRentalBooking: json["totalRentalBooking"],
        numberOfCancelledRentalBooking: json["numberOfCancelledRentalBooking"],
        numberOfOnRunningRentalBooking: json["numberOfOnRunningRentalBooking"],
      );

  Map<String, dynamic> toJson() => {
        "numberOfCompletedRentalBooking": numberOfCompletedRentalBooking,
        "numberOfBookedRentalBooking": numberOfBookedRentalBooking,
        "totalRentalBooking": totalRentalBooking,
        "numberOfCancelledRentalBooking": numberOfCancelledRentalBooking,
        "numberOfOnRunningRentalBooking": numberOfOnRunningRentalBooking,
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

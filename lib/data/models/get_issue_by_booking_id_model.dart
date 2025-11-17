// To parse this JSON data, do
//
//     final getIssueByBookingIdModel = getIssueByBookingIdModelFromJson(jsonString);

import 'dart:convert';

GetIssueByBookingIdModel getIssueByBookingIdModelFromJson(String str) =>
    GetIssueByBookingIdModel.fromJson(json.decode(str));

String getIssueByBookingIdModelToJson(GetIssueByBookingIdModel data) =>
    json.encode(data.toJson());

class GetIssueByBookingIdModel {
  Status? status;
  List<Datum>? data;

  GetIssueByBookingIdModel({
    this.status,
    this.data,
  });

  factory GetIssueByBookingIdModel.fromJson(Map<String, dynamic> json) =>
      GetIssueByBookingIdModel(
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
  int? issueId;
  int? bookingId;
  String? bookingType;
  int? raisedById;
  String? raisedByRole;
  String? issueType;
  String? issueDescription;
  String? issueStatus;
  dynamic resolutionDescription;
  DateTime? createdDate;
  DateTime? modifiedDate;

  Datum({
    this.issueId,
    this.bookingId,
    this.bookingType,
    this.raisedById,
    this.raisedByRole,
    this.issueType,
    this.issueDescription,
    this.issueStatus,
    this.resolutionDescription,
    this.createdDate,
    this.modifiedDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        issueId: json["issueId"],
        bookingId: json["bookingId"],
        bookingType: json["bookingType"],
        raisedById: json["raisedById"],
        raisedByRole: json["raisedByRole"],
        issueType: json["issueType"],
        issueDescription: json["issueDescription"],
        issueStatus: json["issueStatus"],
        resolutionDescription: json["resolutionDescription"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "issueId": issueId,
        "bookingId": bookingId,
        "bookingType": bookingType,
        "raisedById": raisedById,
        "raisedByRole": raisedByRole,
        "issueType": issueType,
        "issueDescription": issueDescription,
        "issueStatus": issueStatus,
        "resolutionDescription": resolutionDescription,
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

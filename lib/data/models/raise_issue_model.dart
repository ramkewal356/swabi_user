// To parse this JSON data, do
//
//     final raiseIssueModel = raiseIssueModelFromJson(jsonString);

import 'dart:convert';

RaiseIssueModel raiseIssueModelFromJson(String str) =>
    RaiseIssueModel.fromJson(json.decode(str));

String raiseIssueModelToJson(RaiseIssueModel data) =>
    json.encode(data.toJson());

class RaiseIssueModel {
  Status? status;
  Data? data;

  RaiseIssueModel({
    this.status,
    this.data,
  });

  factory RaiseIssueModel.fromJson(Map<String, dynamic> json) =>
      RaiseIssueModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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

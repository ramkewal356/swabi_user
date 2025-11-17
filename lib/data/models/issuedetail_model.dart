// To parse this JSON data, do
//
//     final issueDetailsModel = issueDetailsModelFromJson(jsonString);

import 'dart:convert';

IssueDetailsModel issueDetailsModelFromJson(String str) =>
    IssueDetailsModel.fromJson(json.decode(str));

String issueDetailsModelToJson(IssueDetailsModel data) =>
    json.encode(data.toJson());

class IssueDetailsModel {
  Status? status;
  Data? data;

  IssueDetailsModel({
    this.status,
    this.data,
  });

  factory IssueDetailsModel.fromJson(Map<String, dynamic> json) =>
      IssueDetailsModel(
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
  int? raisedById;
  String? raisedByRole;
  String? issueType;
  String? issueDescription;
  String? issueStatus;
  dynamic resolutionDescription;
  int? createdDate;
  int? modifiedDate;
  int? bookingId;
  String? bookingType;
  User? user;
  dynamic driver;

  Data({
    this.issueId,
    this.raisedById,
    this.raisedByRole,
    this.issueType,
    this.issueDescription,
    this.issueStatus,
    this.resolutionDescription,
    this.createdDate,
    this.modifiedDate,
    this.bookingId,
    this.bookingType,
    this.user,
    this.driver,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        issueId: json["issueId"],
        raisedById: json["raisedById"],
        raisedByRole: json["raisedByRole"],
        issueType: json["issueType"],
        issueDescription: json["issueDescription"],
        issueStatus: json["issueStatus"],
        resolutionDescription: json["resolutionDescription"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        bookingId: json["bookingId"],
        bookingType: json["bookingType"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        driver: json["driver"],
      );

  Map<String, dynamic> toJson() => {
        "issueId": issueId,
        "raisedById": raisedById,
        "raisedByRole": raisedByRole,
        "issueType": issueType,
        "issueDescription": issueDescription,
        "issueStatus": issueStatus,
        "resolutionDescription": resolutionDescription,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "bookingId": bookingId,
        "bookingType": bookingType,
        "user": user?.toJson(),
        "driver": driver,
      };
}

class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? address;
  String? email;
  String? gender;
  DateTime? createdDate;
  DateTime? modifiedDate;
  bool? status;
  dynamic otp;
  dynamic isOtpVerified;
  String? userType;
  String? profileImageUrl;
  String? countryCode;
  dynamic notificationToken;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.address,
    this.email,
    this.gender,
    this.createdDate,
    this.modifiedDate,
    this.status,
    this.otp,
    this.isOtpVerified,
    this.userType,
    this.profileImageUrl,
    this.countryCode,
    this.notificationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        address: json["address"],
        email: json["email"],
        gender: json["gender"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        status: json["status"],
        otp: json["otp"],
        isOtpVerified: json["isOtpVerified"],
        userType: json["userType"],
        profileImageUrl: json["profileImageUrl"],
        countryCode: json["countryCode"],
        notificationToken: json["notificationToken"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
        "countryCode": countryCode,
        "notificationToken": notificationToken,
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

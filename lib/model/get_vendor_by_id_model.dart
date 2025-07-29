// To parse this JSON data, do
//
//     final getVendorByIdModel = getVendorByIdModelFromJson(jsonString);

import 'dart:convert';

GetVendorByIdModel getVendorByIdModelFromJson(String str) =>
    GetVendorByIdModel.fromJson(json.decode(str));

String getVendorByIdModelToJson(GetVendorByIdModel data) =>
    json.encode(data.toJson());

class GetVendorByIdModel {
  Status? status;
  Data? data;

  GetVendorByIdModel({
    this.status,
    this.data,
  });

  factory GetVendorByIdModel.fromJson(Map<String, dynamic> json) =>
      GetVendorByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? vendorId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? address;
  DateTime? createdDate;
  DateTime? modifiedDate;
  bool? status;
  dynamic otp;
  bool? isOtpVerified;
  String? userType;
  String? gender;
  String? countryCode;
  String? notificationToken;
  String? vendorProfileImageUrl;
  String? lastLogin;
  String? country;
  String? state;
  dynamic subscriptionStartDate;
  dynamic subscriptionEndDate;

  Data({
    this.vendorId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.createdDate,
    this.modifiedDate,
    this.status,
    this.otp,
    this.isOtpVerified,
    this.userType,
    this.gender,
    this.countryCode,
    this.notificationToken,
    this.vendorProfileImageUrl,
    this.lastLogin,
    this.country,
    this.state,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        vendorId: json["vendorId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
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
        gender: json["gender"],
        countryCode: json["countryCode"],
        notificationToken: json["notificationToken"],
        vendorProfileImageUrl: json["vendorProfileImageUrl"],
        lastLogin: json["lastLogin"],
        country: json["country"],
        state: json["state"],
        subscriptionStartDate: json["subscriptionStartDate"],
        subscriptionEndDate: json["subscriptionEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "vendorId": vendorId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "address": address,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "gender": gender,
        "countryCode": countryCode,
        "notificationToken": notificationToken,
        "vendorProfileImageUrl": vendorProfileImageUrl,
        "lastLogin": lastLogin,
        "country": country,
        "state": state,
        "subscriptionStartDate": subscriptionStartDate,
        "subscriptionEndDate": subscriptionEndDate,
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

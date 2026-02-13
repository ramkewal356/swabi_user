// To parse this JSON data, do
//
//     final getDriverByIdModel = getDriverByIdModelFromJson(jsonString);

import 'dart:convert';

GetDriverByIdModel getDriverByIdModelFromJson(String str) =>
    GetDriverByIdModel.fromJson(json.decode(str));

String getDriverByIdModelToJson(GetDriverByIdModel data) =>
    json.encode(data.toJson());

class GetDriverByIdModel {
  Status? status;
  Data? data;

  GetDriverByIdModel({
    this.status,
    this.data,
  });

  factory GetDriverByIdModel.fromJson(Map<String, dynamic> json) =>
      GetDriverByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? driverId;
  String? firstName;
  String? lastName;
  String? driverAddress;
  String? emiratesId;
  String? mobile;
  String? countryCode;
  String? email;
  String? gender;
  String? licenceNumber;
  int? createdDate;
  int? modifiedDate;
  String? profileImageUrl;
  String? licenseImageUrl;
  String? governmentIdImageUrl;
  String? userType;
  int? vendorId;
  List<UnavailableDate>? unavailableDates;
  String? driverStatus;
  dynamic lastLogin;
  String? country;
  String? state;

  Data({
    this.driverId,
    this.firstName,
    this.lastName,
    this.driverAddress,
    this.emiratesId,
    this.mobile,
    this.countryCode,
    this.email,
    this.gender,
    this.licenceNumber,
    this.createdDate,
    this.modifiedDate,
    this.profileImageUrl,
    this.licenseImageUrl,
    this.governmentIdImageUrl,
    this.userType,
    this.vendorId,
    this.unavailableDates,
    this.driverStatus,
    this.lastLogin,
    this.country,
    this.state,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        driverId: json["driverId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        driverAddress: json["driverAddress"],
        emiratesId: json["emiratesId"],
        mobile: json["mobile"],
        countryCode: json["countryCode"],
        email: json["email"],
        gender: json["gender"],
        licenceNumber: json["licenceNumber"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        profileImageUrl: json["profileImageUrl"],
        licenseImageUrl: json["licenseImageUrl"],
        governmentIdImageUrl: json["governmentIdImageUrl"],
        userType: json["userType"],
        vendorId: json["vendorId"],
        unavailableDates: json["unavailableDates"] == null
            ? []
            : List<UnavailableDate>.from(json["unavailableDates"]!
                .map((x) => UnavailableDate.fromJson(x))),
        driverStatus: json["driverStatus"],
        lastLogin: json["lastLogin"],
        country: json["country"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
        "firstName": firstName,
        "lastName": lastName,
        "driverAddress": driverAddress,
        "emiratesId": emiratesId,
        "mobile": mobile,
        "countryCode": countryCode,
        "email": email,
        "gender": gender,
        "licenceNumber": licenceNumber,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "profileImageUrl": profileImageUrl,
        "licenseImageUrl": licenseImageUrl,
        "governmentIdImageUrl": governmentIdImageUrl,
        "userType": userType,
        "vendorId": vendorId,
        "unavailableDates": unavailableDates == null
            ? []
            : List<dynamic>.from(unavailableDates!.map((x) => x.toJson())),
        "driverStatus": driverStatus,
        "lastLogin": lastLogin,
        "country": country,
        "state": state,
      };
}

class UnavailableDate {
  int? driverUnavailableId;
  // DateTime? date;
  String? date;
  String? driverUnavailableReason;
  DateTime? createdDate;
  DateTime? modifiedDate;
  bool? isCancelled;
  String? unavailableStatus;

  UnavailableDate({
    this.driverUnavailableId,
    this.date,
    this.driverUnavailableReason,
    this.createdDate,
    this.modifiedDate,
    this.isCancelled,
    this.unavailableStatus,
  });

  factory UnavailableDate.fromJson(Map<String, dynamic> json) =>
      UnavailableDate(
        driverUnavailableId: json["driverUnavailableId"],
        // date: json["date"] == null ? null : DateTime.parse(json["date"]),
        date: json["date"],
        driverUnavailableReason: json["driverUnavailableReason"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        isCancelled: json["isCancelled"],
        unavailableStatus: json["unavailableStatus"],
      );

  Map<String, dynamic> toJson() => {
        "driverUnavailableId": driverUnavailableId,
        // "date":
        //     "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "date": date,
        "driverUnavailableReason": driverUnavailableReason,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "isCancelled": isCancelled,
        "unavailableStatus": unavailableStatus,
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

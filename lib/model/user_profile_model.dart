import 'dart:convert';

class UserProfileModel {
  Status status;
  ProfileData data;

  UserProfileModel({
    required this.status,
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        status: Status.fromJson(json["status"]),
        data: ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class ProfileData {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  String createdDate;
  String modifiedDate;
  bool status;
  String otp;
  String isOtpVerified;
  String userType;
  String profileImageUrl;
  String countryCode;
  String lastLogin;
  String country;
  String state;
  ProfileData({
    this.userId = "",
    this.firstName = '',
    this.lastName = '',
    this.mobile = '',
    this.address = '',
    this.email = '',
    this.gender = '',
    this.createdDate = '',
    this.modifiedDate = '',
    this.status = false,
    this.otp = '',
    this.isOtpVerified = '',
    this.userType = '',
    this.profileImageUrl = '',
    this.countryCode = '',
    this.lastLogin = '',
    this.country = '',
    this.state = '',
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
      userId: json["userId"].toString(),
      firstName: json["firstName"] ?? '',
      lastName: json["lastName"] ?? '',
      mobile: json["mobile"] ?? '',
      address: json["address"] ?? '',
      email: json["email"] ?? '',
      gender: json["gender"] ?? '',
      createdDate: json["createdDate"] ?? '',
      modifiedDate: json["modifiedDate"] ?? '',
      status: json["status"] ?? false,
      otp: json["otp"].toString(),
      isOtpVerified: json["isOtpVerified"].toString(),
      userType: json["userType"] ?? '',
      profileImageUrl: json["profileImageUrl"] ?? '',
      countryCode: json["countryCode"] ?? '',
      lastLogin: json["lastLogin"] ?? '',
      country: json['country'] ?? '',
      state: json["state"] ?? '');

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
        "countryCode": countryCode,
        "lastLogin": lastLogin,
        "country": country,
        "state": state
      };
}

class Status {
  String httpCode;
  bool success;
  String message;

  Status({
    required this.httpCode,
    required this.success,
    required this.message,
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

///User Profile Update Model
class UserProfileUpdateModel {
  Status status;
  UserProFileUpdateData data;

  UserProfileUpdateModel({
    required this.status,
    required this.data,
  });

  factory UserProfileUpdateModel.fromJson(Map<String, dynamic> json) =>
      UserProfileUpdateModel(
        status: Status.fromJson(json["status"]),
        data: UserProFileUpdateData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class UserProFileUpdateData {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  String createdDate;
  String modifiedDate;
  bool status;
  String otp;
  String isOtpVerified;
  String userType;
  String profileImageUrl;

  UserProFileUpdateData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    required this.profileImageUrl,
  });

  factory UserProFileUpdateData.fromJson(Map<String, dynamic> json) =>
      UserProFileUpdateData(
        userId: json["userId"].toString(),
        firstName: json["firstName"] ?? '',
        lastName: json["lastName"] ?? '',
        mobile: json["mobile"] ?? '',
        address: json["address"] ?? '',
        email: json["email"] ?? '',
        gender: json["gender"] ?? '',
        createdDate: json["createdDate"] ?? '',
        modifiedDate: json["modifiedDate"] ?? '',
        status: json["status"] ?? false,
        otp: json["otp"].toString(),
        isOtpVerified: json["isOtpVerified"].toString(),
        userType: json["userType"] ?? '',
        profileImageUrl: json["profileImageUrl"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
      };
}

class UserProFileUpdateStatus {
  String httpCode;
  bool success;
  String message;

  UserProFileUpdateStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory UserProFileUpdateStatus.fromJson(Map<String, dynamic> json) =>
      UserProFileUpdateStatus(
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

///User Image Model

class UserProfileImgModel {
  ImgStatus status;
  Data data;

  UserProfileImgModel({
    required this.status,
    required this.data,
  });

  factory UserProfileImgModel.fromJson(Map<String, dynamic> json) =>
      UserProfileImgModel(
        status: ImgStatus.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Headers headers;
  String body;
  String statusCode;
  int statusCodeValue;

  Data({
    required this.headers,
    required this.body,
    required this.statusCode,
    required this.statusCodeValue,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        headers: Headers.fromJson(json["headers"]),
        body: json["body"],
        statusCode: json["statusCode"],
        statusCodeValue: json["statusCodeValue"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "body": body,
        "statusCode": statusCode,
        "statusCodeValue": statusCodeValue,
      };
}

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers();

  Map<String, dynamic> toJson() => {};
}

class ImgStatus {
  String httpCode;
  bool success;
  String message;

  ImgStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory ImgStatus.fromJson(Map<String, dynamic> json) => ImgStatus(
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

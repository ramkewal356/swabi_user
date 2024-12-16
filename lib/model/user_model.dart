// class UserModel {
//   String? data;
//
//   UserModel({this.data});
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['data'] = this.data;
//
//     return data;
//   }
// }
//
// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) =>
    UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
  Status? status;
  Data? data;

  UserLoginModel({
    this.status,
    this.data,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? userType;
  String? token;

  Data({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        userType: json["userType"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "userType": userType,
        "token": token,
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

class UserModel {
  String? token;
  String? userId;

  UserModel({this.token, this.userId});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'] ?? '';
    userId = json['userId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['userId'] = userId;

    return data;
  }
}

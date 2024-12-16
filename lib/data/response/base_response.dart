// To parse this JSON data, do
//
//     final baseResponseModel = baseResponseModelFromJson(jsonString);

import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(String str) =>
    BaseResponseModel.fromJson(json.decode(str));

String baseResponseModelToJson(BaseResponseModel data) =>
    json.encode(data.toJson());

class BaseResponseModel {
  dynamic data;
  Status? status;

  BaseResponseModel({
    this.data,
    this.status,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
      BaseResponseModel(
        data: json["data"],
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "status": status?.toJson(),
      };
}

class Status {
  String? message;
  String? httpCode;
  bool? success;

  Status({
    this.message,
    this.httpCode,
    this.success,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        message: json["message"],
        httpCode: json["httpCode"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "httpCode": httpCode,
        "success": success,
      };
}

// class BaseResponseModel {
//   int? status;
//   String? msg;
//   dynamic data;

//   BaseResponseModel({this.status, this.msg, this.data});
//   BaseResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     msg = json['msg'];
//     data = json['data'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['msg'] = msg;
//     return data;
//   }
// }

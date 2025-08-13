// To parse this JSON data, do
//
//     final bidAcceptOrRejectModel = bidAcceptOrRejectModelFromJson(jsonString);

import 'dart:convert';

BidAcceptOrRejectModel bidAcceptOrRejectModelFromJson(String str) =>
    BidAcceptOrRejectModel.fromJson(json.decode(str));

String bidAcceptOrRejectModelToJson(BidAcceptOrRejectModel data) =>
    json.encode(data.toJson());

class BidAcceptOrRejectModel {
  Status? status;
  dynamic data;

  BidAcceptOrRejectModel({
    this.status,
    this.data,
  });

  factory BidAcceptOrRejectModel.fromJson(Map<String, dynamic> json) =>
      BidAcceptOrRejectModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data,
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

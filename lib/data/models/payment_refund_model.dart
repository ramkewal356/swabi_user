// To parse this JSON data, do
//
//     final paymentRefundModel = paymentRefundModelFromJson(jsonString);

import 'dart:convert';

PaymentRefundModel paymentRefundModelFromJson(String str) =>
    PaymentRefundModel.fromJson(json.decode(str));

String paymentRefundModelToJson(PaymentRefundModel data) =>
    json.encode(data.toJson());

class PaymentRefundModel {
  Status? status;
  Data? data;

  PaymentRefundModel({
    this.status,
    this.data,
  });

  factory PaymentRefundModel.fromJson(Map<String, dynamic> json) =>
      PaymentRefundModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? refundId;
  String? paymentId;
  String? refundStatus;
  double? refundedAmount;
  int? createdAt;
  int? updatedAt;

  Data({
    this.id,
    this.refundId,
    this.paymentId,
    this.refundStatus,
    this.refundedAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        refundId: json["refundId"],
        paymentId: json["paymentId"],
        refundStatus: json["refundStatus"],
        refundedAmount: json["refundedAmount"]?.toDouble(),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refundId": refundId,
        "paymentId": paymentId,
        "refundStatus": refundStatus,
        "refundedAmount": refundedAmount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
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

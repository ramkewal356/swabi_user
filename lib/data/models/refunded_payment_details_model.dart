// To parse this JSON data, do
//
//     final refundedPaymentDetailsModel = refundedPaymentDetailsModelFromJson(jsonString);

import 'dart:convert';

RefundedPaymentDetailsModel refundedPaymentDetailsModelFromJson(String str) =>
    RefundedPaymentDetailsModel.fromJson(json.decode(str));

String refundedPaymentDetailsModelToJson(RefundedPaymentDetailsModel data) =>
    json.encode(data.toJson());

class RefundedPaymentDetailsModel {
  Status? status;
  Data? data;

  RefundedPaymentDetailsModel({
    this.status,
    this.data,
  });

  factory RefundedPaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      RefundedPaymentDetailsModel(
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
  int? vendorId;
  String? bookingType;
  String? currency;

  Data({
    this.id,
    this.refundId,
    this.paymentId,
    this.refundStatus,
    this.refundedAmount,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
    this.bookingType,
    this.currency,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        refundId: json["refundId"],
        paymentId: json["paymentId"],
        refundStatus: json["refundStatus"],
        refundedAmount: json["refundedAmount"]?.toDouble(),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        vendorId: json["vendorId"],
        bookingType: json["bookingType"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refundId": refundId,
        "paymentId": paymentId,
        "refundStatus": refundStatus,
        "refundedAmount": refundedAmount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "vendorId": vendorId,
        "bookingType": bookingType,
        "currency": currency,
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

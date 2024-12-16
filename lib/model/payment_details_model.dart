// To parse this JSON data, do
//
//     final paymentDetailsModel = paymentDetailsModelFromJson(jsonString);

import 'dart:convert';

PaymentDetailsModel paymentDetailsModelFromJson(String str) =>
    PaymentDetailsModel.fromJson(json.decode(str));

String paymentDetailsModelToJson(PaymentDetailsModel data) =>
    json.encode(data.toJson());

class PaymentDetailsModel {
  Status? status;
  PaymentData? data;

  PaymentDetailsModel({
    this.status,
    this.data,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      PaymentDetailsModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : PaymentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class PaymentData {
  String? id;
  String? entity;
  int? amount;
  String? currency;
  String? status;
  String? orderId;
  dynamic invoiceId;
  bool? international;
  String? method;
  int? amountRefunded;
  String? refundStatus;
  bool? captured;
  String? description;
  dynamic cardId;
  dynamic bank;
  dynamic wallet;
  String? vpa;
  String? email;
  String? contact;
  List<dynamic>? notes;
  int? fee;
  int? tax;
  dynamic errorCode;
  dynamic errorDescription;
  dynamic errorSource;
  dynamic errorStep;
  dynamic errorReason;
  AcquirerData? acquirerData;
  int? createdAt;
  Upi? upi;

  PaymentData({
    this.id,
    this.entity,
    this.amount,
    this.currency,
    this.status,
    this.orderId,
    this.invoiceId,
    this.international,
    this.method,
    this.amountRefunded,
    this.refundStatus,
    this.captured,
    this.description,
    this.cardId,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    this.notes,
    this.fee,
    this.tax,
    this.errorCode,
    this.errorDescription,
    this.errorSource,
    this.errorStep,
    this.errorReason,
    this.acquirerData,
    this.createdAt,
    this.upi,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
        orderId: json["order_id"],
        invoiceId: json["invoice_id"],
        international: json["international"],
        method: json["method"],
        amountRefunded: json["amount_refunded"],
        refundStatus: json["refund_status"],
        captured: json["captured"],
        description: json["description"],
        cardId: json["card_id"],
        bank: json["bank"],
        wallet: json["wallet"],
        vpa: json["vpa"],
        email: json["email"],
        contact: json["contact"],
        notes: json["notes"] == null
            ? []
            : List<dynamic>.from(json["notes"]!.map((x) => x)),
        fee: json["fee"],
        tax: json["tax"],
        errorCode: json["error_code"],
        errorDescription: json["error_description"],
        errorSource: json["error_source"],
        errorStep: json["error_step"],
        errorReason: json["error_reason"],
        acquirerData: json["acquirer_data"] == null
            ? null
            : AcquirerData.fromJson(json["acquirer_data"]),
        createdAt: json["created_at"],
        upi: json["upi"] == null ? null : Upi.fromJson(json["upi"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "currency": currency,
        "status": status,
        "order_id": orderId,
        "invoice_id": invoiceId,
        "international": international,
        "method": method,
        "amount_refunded": amountRefunded,
        "refund_status": refundStatus,
        "captured": captured,
        "description": description,
        "card_id": cardId,
        "bank": bank,
        "wallet": wallet,
        "vpa": vpa,
        "email": email,
        "contact": contact,
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
        "fee": fee,
        "tax": tax,
        "error_code": errorCode,
        "error_description": errorDescription,
        "error_source": errorSource,
        "error_step": errorStep,
        "error_reason": errorReason,
        "acquirer_data": acquirerData?.toJson(),
        "created_at": createdAt,
        "upi": upi?.toJson(),
      };
}

class AcquirerData {
  String? rrn;
  String? upiTransactionId;

  AcquirerData({
    this.rrn,
    this.upiTransactionId,
  });

  factory AcquirerData.fromJson(Map<String, dynamic> json) => AcquirerData(
        rrn: json["rrn"],
        upiTransactionId: json["upi_transaction_id"],
      );

  Map<String, dynamic> toJson() => {
        "rrn": rrn,
        "upi_transaction_id": upiTransactionId,
      };
}

class Upi {
  String? vpa;

  Upi({
    this.vpa,
  });

  factory Upi.fromJson(Map<String, dynamic> json) => Upi(
        vpa: json["vpa"],
      );

  Map<String, dynamic> toJson() => {
        "vpa": vpa,
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

// To parse this JSON data, do
//
//     final createWalletPaymentOrderModel = createWalletPaymentOrderModelFromJson(jsonString);

import 'dart:convert';

CreateWalletPaymentOrderModel createWalletPaymentOrderModelFromJson(
        String str) =>
    CreateWalletPaymentOrderModel.fromJson(json.decode(str));

String createWalletPaymentOrderModelToJson(
        CreateWalletPaymentOrderModel data) =>
    json.encode(data.toJson());

class CreateWalletPaymentOrderModel {
  String? razorpayOrderId;
  double? amount;
  String? currency;

  CreateWalletPaymentOrderModel({
    this.razorpayOrderId,
    this.amount,
    this.currency,
  });

  factory CreateWalletPaymentOrderModel.fromJson(Map<String, dynamic> json) =>
      CreateWalletPaymentOrderModel(
        razorpayOrderId: json["razorpayOrderId"],
        amount: json["amount"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "razorpayOrderId": razorpayOrderId,
        "amount": amount,
        "currency": currency,
      };
}

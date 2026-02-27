// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  int? walletId;
  int? ownerId;
  String? ownerType;
  Balance? balance;
  List<Transaction>? transactions;

  TransactionModel({
    this.walletId,
    this.ownerId,
    this.ownerType,
    this.balance,
    this.transactions,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        walletId: json["walletId"],
        ownerId: json["ownerId"],
        ownerType: json["ownerType"],
        balance:
            json["balance"] == null ? null : Balance.fromJson(json["balance"]),
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "walletId": walletId,
        "ownerId": ownerId,
        "ownerType": ownerType,
        "balance": balance?.toJson(),
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Balance {
  double? amount;
  String? currency;

  Balance({
    this.amount,
    this.currency,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        amount: json["amount"]?.toDouble(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
      };
}

class Transaction {
  int? transactionId;
  String? type;
  double? amount;
  String? currency;
  String? category;
  String? description;
  String? status;
  int? createdAt;

  Transaction({
    this.transactionId,
    this.type,
    this.amount,
    this.currency,
    this.category,
    this.description,
    this.status,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json["transactionId"],
        type: json["type"],
        amount: json["amount"],
        currency: json["currency"],
        category: json["category"],
        description: json["description"],
        status: json["status"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "type": type,
        "amount": amount,
        "currency": currency,
        "category": category,
        "description": description,
        "status": status,
        "createdAt": createdAt,
      };
}

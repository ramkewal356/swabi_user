// To parse this JSON data, do
//
//     final currencyModel = currencyModelFromJson(jsonString);

import 'dart:convert';

List<CurrencyModel> currencyModelFromJson(String str) =>
    List<CurrencyModel>.from(
        json.decode(str).map((x) => CurrencyModel.fromJson(x)));

String currencyModelToJson(List<CurrencyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CurrencyModel {
  String? code;
  String? country;

  CurrencyModel({
    this.code,
    this.country,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        code: json["code"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "country": country,
      };
}

// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

List<SubscriptionModel> subscriptionModelFromJson(String str) =>
    List<SubscriptionModel>.from(
        json.decode(str).map((x) => SubscriptionModel.fromJson(x)));

String subscriptionModelToJson(List<SubscriptionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionModel {
  int? id;
  String? subscriptionType;
  double? price;
  int? listingLimit;
  int? discountPercent;
  String? supportLevel;
  bool? premiumListingAccess;
  int? durationInMonths;
  bool? active;

  SubscriptionModel({
    this.id,
    this.subscriptionType,
    this.price,
    this.listingLimit,
    this.discountPercent,
    this.supportLevel,
    this.premiumListingAccess,
    this.durationInMonths,
    this.active,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json["id"],
        subscriptionType: json["subscriptionType"],
        price: json["price"],
        listingLimit: json["listingLimit"],
        discountPercent: json["discountPercent"],
        supportLevel: json["supportLevel"],
        premiumListingAccess: json["premiumListingAccess"],
        durationInMonths: json["durationInMonths"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscriptionType": subscriptionType,
        "price": price,
        "listingLimit": listingLimit,
        "discountPercent": discountPercent,
        "supportLevel": supportLevel,
        "premiumListingAccess": premiumListingAccess,
        "durationInMonths": durationInMonths,
        "active": active,
      };

  /// 👇 Used ONLY for SQLite
  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'],
      subscriptionType: map['subscriptionType'],
      price: (map['price'] as num?)?.toDouble(),
      listingLimit: map['listingLimit'],
      discountPercent: map['discountPercent'],
      supportLevel: map['supportLevel'],
      premiumListingAccess: map['premiumListingAccess'] == 1,
      durationInMonths: map['durationInMonths'],
      active: map['active'] == 1,
    );
  }

  /// 👇 Used ONLY for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subscriptionType': subscriptionType,
      'price': price,
      'listingLimit': listingLimit,
      'discountPercent': discountPercent,
      'supportLevel': supportLevel,
      'premiumListingAccess': premiumListingAccess == true ? 1 : 0,
      'durationInMonths': durationInMonths,
      'active': active == true ? 1 : 0,
    };
  }
}

// To parse this JSON data, do
//
//     final offerDetailByIdModel = offerDetailByIdModelFromJson(jsonString);

import 'dart:convert';

OfferDetailByIdModel offerDetailByIdModelFromJson(String str) =>
    OfferDetailByIdModel.fromJson(json.decode(str));

String offerDetailByIdModelToJson(OfferDetailByIdModel data) =>
    json.encode(data.toJson());

class OfferDetailByIdModel {
  Status? status;
  Data? data;

  OfferDetailByIdModel({
    this.status,
    this.data,
  });

  factory OfferDetailByIdModel.fromJson(Map<String, dynamic> json) =>
      OfferDetailByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? offerId;
  String? offerName;
  String? description;
  double? discountPercentage;
  String? offerCode;
  String? startDate;
  String? endDate;
  double? minimumBookingAmount;
  double? maxDiscountAmount;
  int? usageLimitPerUser;
  String? termsAndConditions;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? offerStatus;
  String? offerType;
  String? imageUrl;

  Data({
    this.offerId,
    this.offerName,
    this.description,
    this.discountPercentage,
    this.offerCode,
    this.startDate,
    this.endDate,
    this.minimumBookingAmount,
    this.maxDiscountAmount,
    this.usageLimitPerUser,
    this.termsAndConditions,
    this.createdDate,
    this.modifiedDate,
    this.offerStatus,
    this.offerType,
    this.imageUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        offerId: json["offerId"],
        offerName: json["offerName"],
        description: json["description"],
        discountPercentage: json["discountPercentage"],
        offerCode: json["offerCode"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        minimumBookingAmount: json["minimumBookingAmount"],
        maxDiscountAmount: json["maxDiscountAmount"],
        usageLimitPerUser: json["usageLimitPerUser"],
        termsAndConditions: json["termsAndConditions"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        offerStatus: json["offerStatus"],
        offerType: json["offerType"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "offerId": offerId,
        "offerName": offerName,
        "description": description,
        "discountPercentage": discountPercentage,
        "offerCode": offerCode,
        "startDate": startDate,
        "endDate": endDate,
        "minimumBookingAmount": minimumBookingAmount,
        "maxDiscountAmount": maxDiscountAmount,
        "usageLimitPerUser": usageLimitPerUser,
        "termsAndConditions": termsAndConditions,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "offerStatus": offerStatus,
        "bookingType": offerType,
        "imageUrl": imageUrl,
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

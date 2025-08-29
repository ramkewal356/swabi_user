// To parse this JSON data, do
//
//     final getActivityByIdModel = getActivityByIdModelFromJson(jsonString);

import 'dart:convert';

GetActivityByIdModel getActivityByIdModelFromJson(String str) =>
    GetActivityByIdModel.fromJson(json.decode(str));

String getActivityByIdModelToJson(GetActivityByIdModel data) =>
    json.encode(data.toJson());

class GetActivityByIdModel {
  Status? status;
  Data? data;

  GetActivityByIdModel({
    this.status,
    this.data,
  });

  factory GetActivityByIdModel.fromJson(Map<String, dynamic> json) =>
      GetActivityByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? activityId;
  String? country;
  String? state;
  String? city;
  String? address;
  String? activityName;
  String? bestTimeToVisit;
  double? activityHours;
  double? activityPrice;
  String? startTime;
  String? endTime;
  String? description;
  List<String>? participantType;
  List<String>? weeklyOff;
  List<String>? activityImageUrl;
  String? activityStatus;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<String>? activityReligiousOffDates;
  AgeGroupDiscountPercent? ageGroupDiscountPercent;
  dynamic activityOfferMapping;
  String? activityCategory;

  Data({
    this.activityId,
    this.country,
    this.state,
    this.city,
    this.address,
    this.activityName,
    this.bestTimeToVisit,
    this.activityHours,
    this.activityPrice,
    this.startTime,
    this.endTime,
    this.description,
    this.participantType,
    this.weeklyOff,
    this.activityImageUrl,
    this.activityStatus,
    this.createdDate,
    this.modifiedDate,
    this.activityReligiousOffDates,
    this.ageGroupDiscountPercent,
    this.activityOfferMapping,
    this.activityCategory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        activityId: json["activityId"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        address: json["address"],
        activityName: json["activityName"],
        bestTimeToVisit: json["bestTimeToVisit"],
        activityHours: json["activityHours"],
        activityPrice: json["activityPrice"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        description: json["description"],
        participantType: json["participantType"] == null
            ? []
            : List<String>.from(json["participantType"]!.map((x) => x)),
        weeklyOff: json["weeklyOff"] == null
            ? []
            : List<String>.from(json["weeklyOff"]!.map((x) => x)),
        activityImageUrl: json["activityImageUrl"] == null
            ? []
            : List<String>.from(json["activityImageUrl"]!.map((x) => x)),
        activityStatus: json["activityStatus"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        activityReligiousOffDates: json["activityReligiousOffDates"] == null
            ? []
            : List<String>.from(
                json["activityReligiousOffDates"]!.map((x) => x)),
        ageGroupDiscountPercent: json["ageGroupDiscountPercent"] == null
            ? null
            : AgeGroupDiscountPercent.fromJson(json["ageGroupDiscountPercent"]),
        activityOfferMapping: json["activityOfferMapping"],
        activityCategory: json["activityCategory"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": country,
        "state": state,
        "city": city,
        "address": address,
        "activityName": activityName,
        "bestTimeToVisit": bestTimeToVisit,
        "activityHours": activityHours,
        "activityPrice": activityPrice,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "participantType": participantType == null
            ? []
            : List<dynamic>.from(participantType!.map((x) => x)),
        "weeklyOff": weeklyOff == null
            ? []
            : List<dynamic>.from(weeklyOff!.map((x) => x)),
        "activityImageUrl": activityImageUrl == null
            ? []
            : List<dynamic>.from(activityImageUrl!.map((x) => x)),
        "activityStatus": activityStatus,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "activityReligiousOffDates": activityReligiousOffDates == null
            ? []
            : List<dynamic>.from(activityReligiousOffDates!.map((x) => x)),
        "ageGroupDiscountPercent": ageGroupDiscountPercent?.toJson(),
        "activityOfferMapping": activityOfferMapping,
        "activityCategory": activityCategory,
      };
}

class AgeGroupDiscountPercent {
  double? infant;
  double? child;
  double? senior;

  AgeGroupDiscountPercent({
    this.infant,
    this.child,
    this.senior,
  });

  factory AgeGroupDiscountPercent.fromJson(Map<String, dynamic> json) =>
      AgeGroupDiscountPercent(
        infant: json["INFANT"],
        child: json["CHILD"],
        senior: json["SENIOR"],
      );

  Map<String, dynamic> toJson() => {
        "INFANT": infant,
        "CHILD": child,
        "SENIOR": senior,
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

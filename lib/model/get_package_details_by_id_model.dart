// To parse this JSON data, do
//
//     final getPackageDetailByIdModel = getPackageDetailByIdModelFromJson(jsonString);

import 'dart:convert';

GetPackageDetailByIdModel getPackageDetailByIdModelFromJson(String str) =>
    GetPackageDetailByIdModel.fromJson(json.decode(str));

String getPackageDetailByIdModelToJson(GetPackageDetailByIdModel data) =>
    json.encode(data.toJson());

class GetPackageDetailByIdModel {
  Status? status;
  Data? data;

  GetPackageDetailByIdModel({
    this.status,
    this.data,
  });

  factory GetPackageDetailByIdModel.fromJson(Map<String, dynamic> json) =>
      GetPackageDetailByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? packageId;
  String? country;
  String? state;
  String? packageName;
  String? location;
  String? noOfDays;
  List<dynamic>? packageImageUrl;
  double? totalPrice;
  String? packageStatus;
  int? createdDate;
  int? modifiedDate;
  List<PackageActivity>? packageActivities;
  double? packageDiscountedAmount;

  Data({
    this.packageId,
    this.country,
    this.state,
    this.packageName,
    this.location,
    this.noOfDays,
    this.packageImageUrl,
    this.totalPrice,
    this.packageStatus,
    this.createdDate,
    this.modifiedDate,
    this.packageActivities,
    this.packageDiscountedAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        packageId: json["packageId"],
        country: json["country"],
        state: json["state"],
        packageName: json["packageName"],
        location: json["location"],
        noOfDays: json["noOfDays"],
        packageImageUrl: json["packageImageUrl"] == null
            ? []
            : List<dynamic>.from(json["packageImageUrl"]!.map((x) => x)),
        totalPrice: json["totalPrice"],
        packageStatus: json["packageStatus"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        packageActivities: json["packageActivities"] == null
            ? []
            : List<PackageActivity>.from(json["packageActivities"]!
                .map((x) => PackageActivity.fromJson(x))),
        packageDiscountedAmount: json["packageDiscountedAmount"],
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "country": country,
        "state": state,
        "packageName": packageName,
        "location": location,
        "noOfDays": noOfDays,
        "packageImageUrl": packageImageUrl == null
            ? []
            : List<dynamic>.from(packageImageUrl!.map((x) => x)),
        "totalPrice": totalPrice,
        "packageStatus": packageStatus,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "packageActivities": packageActivities == null
            ? []
            : List<dynamic>.from(packageActivities!.map((x) => x.toJson())),
        "packageDiscountedAmount": packageDiscountedAmount,
      };
}

class PackageActivity {
  int? packageActivityId;
  Activity? activity;
  dynamic day;
  dynamic startTime;

  PackageActivity({
    this.packageActivityId,
    this.activity,
    this.day,
    this.startTime,
  });

  factory PackageActivity.fromJson(Map<String, dynamic> json) =>
      PackageActivity(
        packageActivityId: json["packageActivityId"],
        activity: json["activity"] == null
            ? null
            : Activity.fromJson(json["activity"]),
        day: json["day"],
        startTime: json["startTime"],
      );

  Map<String, dynamic> toJson() => {
        "packageActivityId": packageActivityId,
        "activity": activity?.toJson(),
        "day": day,
        "startTime": startTime,
      };
}

class Activity {
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
  int? createdDate;
  int? modifiedDate;
  List<ActivityReligiousOffDate>? activityReligiousOffDates;
  AgeGroupDiscountPercent? ageGroupDiscountPercent;
  ActivityOfferMapping? activityOfferMapping;
  double? discountedAmount;

  Activity({
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
    this.discountedAmount,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
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
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        activityReligiousOffDates: json["activityReligiousOffDates"] == null
            ? []
            : List<ActivityReligiousOffDate>.from(
                json["activityReligiousOffDates"]!
                    .map((x) => ActivityReligiousOffDate.fromJson(x))),
        ageGroupDiscountPercent: json["ageGroupDiscountPercent"] == null
            ? null
            : AgeGroupDiscountPercent.fromJson(json["ageGroupDiscountPercent"]),
        activityOfferMapping: json["activityOfferMapping"] == null
            ? null
            : ActivityOfferMapping.fromJson(json["activityOfferMapping"]),
        discountedAmount: json["discountedAmount"],
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
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "activityReligiousOffDates": activityReligiousOffDates == null
            ? []
            : List<dynamic>.from(
                activityReligiousOffDates!.map((x) => x.toJson())),
        "ageGroupDiscountPercent": ageGroupDiscountPercent?.toJson(),
        "activityOfferMapping": activityOfferMapping?.toJson(),
        "discountedAmount": discountedAmount,
      };
}

class ActivityOfferMapping {
  int? activityOfferMappingId;
  int? activityId;
  String? startDate;
  String? endDate;
  bool? status;
  DateTime? createdDate;
  DateTime? modifiedDate;
  Offer? offer;

  ActivityOfferMapping({
    this.activityOfferMappingId,
    this.activityId,
    this.startDate,
    this.endDate,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.offer,
  });

  factory ActivityOfferMapping.fromJson(Map<String, dynamic> json) =>
      ActivityOfferMapping(
        activityOfferMappingId: json["activityOfferMappingId"],
        activityId: json["activityId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        status: json["status"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
      );

  Map<String, dynamic> toJson() => {
        "activityOfferMappingId": activityOfferMappingId,
        "activityId": activityId,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "offer": offer?.toJson(),
      };
}

class Offer {
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

  Offer({
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

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
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
        "offerType": offerType,
        "imageUrl": imageUrl,
      };
}

class ActivityReligiousOffDate {
  int? activityReligiousOffId;
  String? religiousOffDate;
  bool? isCancelled;
  DateTime? createdDate;
  DateTime? modifiedDate;

  ActivityReligiousOffDate({
    this.activityReligiousOffId,
    this.religiousOffDate,
    this.isCancelled,
    this.createdDate,
    this.modifiedDate,
  });

  factory ActivityReligiousOffDate.fromJson(Map<String, dynamic> json) =>
      ActivityReligiousOffDate(
        activityReligiousOffId: json["activityReligiousOffId"],
        religiousOffDate: json["religiousOffDate"],
        isCancelled: json["isCancelled"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "activityReligiousOffId": activityReligiousOffId,
        "religiousOffDate": religiousOffDate,
        "isCancelled": isCancelled,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
      };
}

class AgeGroupDiscountPercent {
  double? senior;
  double? child;
  double? infant;

  AgeGroupDiscountPercent({
    this.senior,
    this.child,
    this.infant,
  });

  factory AgeGroupDiscountPercent.fromJson(Map<String, dynamic> json) =>
      AgeGroupDiscountPercent(
        senior: json["SENIOR"],
        child: json["CHILD"],
        infant: json["INFANT"],
      );

  Map<String, dynamic> toJson() => {
        "SENIOR": senior,
        "CHILD": child,
        "INFANT": infant,
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

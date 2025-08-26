// To parse this JSON data, do
//
//     final getPackageListModel = getPackageListModelFromJson(jsonString);

import 'dart:convert';

PackageListModel getPackageListModelFromJson(String str) =>
    PackageListModel.fromJson(json.decode(str));

String getPackageListModelToJson(PackageListModel data) =>
    json.encode(data.toJson());

class PackageListModel {
  Status? status;
  Data? data;

  PackageListModel({
    this.status,
    this.data,
  });

  factory PackageListModel.fromJson(Map<String, dynamic> json) =>
      PackageListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<PackageContent>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool? last;
  int? number;
  Sort? sort;
  int? size;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.totalElements,
    this.totalPages,
    this.last,
    this.number,
    this.sort,
    this.size,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<PackageContent>.from(
                json["content"]!.map((x) => PackageContent.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        last: json["last"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        size: json["size"],
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "number": number,
        "sort": sort?.toJson(),
        "size": size,
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class PackageContent {
  int? packageId;
  String? country;
  String? state;
  String? packageName;
  String? location;
  String? noOfDays;
  List<dynamic>? packageImageUrl;
  double? totalPrice;
  String? packageStatus;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<PackageActivity>? packageActivities;
  dynamic travelTimeHour;
  dynamic travelTimeMinute;
  Vendor? vendor;

  PackageContent({
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
    this.travelTimeHour,
    this.travelTimeMinute,
    this.vendor,
  });

  factory PackageContent.fromJson(Map<String, dynamic> json) => PackageContent(
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
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        packageActivities: json["packageActivities"] == null
            ? []
            : List<PackageActivity>.from(json["packageActivities"]!
                .map((x) => PackageActivity.fromJson(x))),
        travelTimeHour: json["travelTimeHour"],
        travelTimeMinute: json["travelTimeMinute"],
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
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
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "packageActivities": packageActivities == null
            ? []
            : List<dynamic>.from(packageActivities!.map((x) => x.toJson())),
        "travelTimeHour": travelTimeHour,
        "travelTimeMinute": travelTimeMinute,
        "vendor": vendor?.toJson(),
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
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<dynamic>? activityReligiousOffDates;
  AgeGroupDiscountPercent? ageGroupDiscountPercent;
  dynamic activityOfferMapping;
  String? activityCategory;

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
    this.activityCategory,
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
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        activityReligiousOffDates: json["activityReligiousOffDates"] == null
            ? []
            : List<dynamic>.from(
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
  double? child;
  double? infant;
  double? senior;

  AgeGroupDiscountPercent({
    this.child,
    this.infant,
    this.senior,
  });

  factory AgeGroupDiscountPercent.fromJson(Map<String, dynamic> json) =>
      AgeGroupDiscountPercent(
        child: json["CHILD"],
        infant: json["INFANT"],
        senior: json["SENIOR"],
      );

  Map<String, dynamic> toJson() => {
        "CHILD": child,
        "INFANT": infant,
        "SENIOR": senior,
      };
}

class Vendor {
  int? vendorId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? address;
  DateTime? createdDate;
  DateTime? modifiedDate;
  bool? status;
  dynamic otp;
  bool? isOtpVerified;
  String? userType;
  String? gender;
  String? countryCode;
  String? notificationToken;
  String? vendorProfileImageUrl;
  String? lastLogin;
  String? country;
  String? state;
  dynamic subscriptionStartDate;
  dynamic subscriptionEndDate;

  Vendor({
    this.vendorId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.createdDate,
    this.modifiedDate,
    this.status,
    this.otp,
    this.isOtpVerified,
    this.userType,
    this.gender,
    this.countryCode,
    this.notificationToken,
    this.vendorProfileImageUrl,
    this.lastLogin,
    this.country,
    this.state,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        vendorId: json["vendorId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        status: json["status"],
        otp: json["otp"],
        isOtpVerified: json["isOtpVerified"],
        userType: json["userType"],
        gender: json["gender"],
        countryCode: json["countryCode"],
        notificationToken: json["notificationToken"],
        vendorProfileImageUrl: json["vendorProfileImageUrl"],
        lastLogin: json["lastLogin"],
        country: json["country"],
        state: json["state"],
        subscriptionStartDate: json["subscriptionStartDate"],
        subscriptionEndDate: json["subscriptionEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "vendorId": vendorId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "address": address,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "gender": gender,
        "countryCode": countryCode,
        "notificationToken": notificationToken,
        "vendorProfileImageUrl": vendorProfileImageUrl,
        "lastLogin": lastLogin,
        "country": country,
        "state": state,
        "subscriptionStartDate": subscriptionStartDate,
        "subscriptionEndDate": subscriptionEndDate,
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
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

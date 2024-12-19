// To parse this JSON data, do
//
//     final getAllActivityListModel = getAllActivityListModelFromJson(jsonString);

import 'dart:convert';

GetAllActivityListModel getAllActivityListModelFromJson(String str) =>
    GetAllActivityListModel.fromJson(json.decode(str));

String getAllActivityListModelToJson(GetAllActivityListModel data) =>
    json.encode(data.toJson());

class GetAllActivityListModel {
  Status? status;
  Data? data;

  GetAllActivityListModel({
    this.status,
    this.data,
  });

  factory GetAllActivityListModel.fromJson(Map<String, dynamic> json) =>
      GetAllActivityListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<ActivityContent>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<ActivityContent>.from(
                json["content"]!.map((x) => ActivityContent.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class ActivityContent {
  int? activityId;
  Country? country;
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
  List<ParticipantType>? participantType;
  List<String>? weeklyOff;
  List<String>? activityImageUrl;
  ActivityStatus? activityStatus;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<ActivityReligiousOffDate>? activityReligiousOffDates;
  AgeGroupDiscountPercent? ageGroupDiscountPercent;
  ActivityOfferMapping? activityOfferMapping;
  String? activityCategory;

  ActivityContent({
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

  factory ActivityContent.fromJson(Map<String, dynamic> json) =>
      ActivityContent(
        activityId: json["activityId"],
        country: countryValues.map[json["country"]]!,
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
            : List<ParticipantType>.from(json["participantType"]!
                .map((x) => participantTypeValues.map[x]!)),
        weeklyOff: json["weeklyOff"] == null
            ? []
            : List<String>.from(json["weeklyOff"]!.map((x) => x)),
        activityImageUrl: json["activityImageUrl"] == null
            ? []
            : List<String>.from(json["activityImageUrl"]!.map((x) => x)),
        activityStatus: activityStatusValues.map[json["activityStatus"]]!,
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
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
        activityCategory: json["activityCategory"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "country": countryValues.reverse[country],
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
            : List<dynamic>.from(
                participantType!.map((x) => participantTypeValues.reverse[x])),
        "weeklyOff": weeklyOff == null
            ? []
            : List<dynamic>.from(weeklyOff!.map((x) => x)),
        "activityImageUrl": activityImageUrl == null
            ? []
            : List<dynamic>.from(activityImageUrl!.map((x) => x)),
        "activityStatus": activityStatusValues.reverse[activityStatus],
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "activityReligiousOffDates": activityReligiousOffDates == null
            ? []
            : List<dynamic>.from(
                activityReligiousOffDates!.map((x) => x.toJson())),
        "ageGroupDiscountPercent": ageGroupDiscountPercent?.toJson(),
        "activityOfferMapping": activityOfferMapping?.toJson(),
        "activityCategory": activityCategory,
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

enum ActivityStatus { TRUE }

final activityStatusValues = EnumValues({"TRUE": ActivityStatus.TRUE});

class AgeGroupDiscountPercent {
  double? infant;
  double? senior;
  double? child;

  AgeGroupDiscountPercent({
    this.infant,
    this.senior,
    this.child,
  });

  factory AgeGroupDiscountPercent.fromJson(Map<String, dynamic> json) =>
      AgeGroupDiscountPercent(
        infant: json["INFANT"],
        senior: json["SENIOR"],
        child: json["CHILD"],
      );

  Map<String, dynamic> toJson() => {
        "INFANT": infant,
        "SENIOR": senior,
        "CHILD": child,
      };
}

enum Country { UNITED_ARAB_EMIRATES }

final countryValues =
    EnumValues({"United Arab Emirates": Country.UNITED_ARAB_EMIRATES});

enum ParticipantType { ADULT, CHILD, INFANT, SENIOR }

final participantTypeValues = EnumValues({
  "ADULT": ParticipantType.ADULT,
  "CHILD": ParticipantType.CHILD,
  "INFANT": ParticipantType.INFANT,
  "SENIOR": ParticipantType.SENIOR
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

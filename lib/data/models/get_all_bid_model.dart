// To parse this JSON data, do
//
//     final getAllBidModel = getAllBidModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_cab/data/models/get_all_enquiry_model.dart';

GetAllBidModel getAllBidModelFromJson(String str) =>
    GetAllBidModel.fromJson(json.decode(str));

String getAllBidModelToJson(GetAllBidModel data) => json.encode(data.toJson());

class GetAllBidModel {
  List<BidContent>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  GetAllBidModel({
    this.content,
    this.pageable,
    this.totalElements,
    this.totalPages,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory GetAllBidModel.fromJson(Map<String, dynamic> json) => GetAllBidModel(
        content: json["content"] == null
            ? []
            : List<BidContent>.from(
                json["content"]!.map((x) => BidContent.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
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
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class BidContent {
  int? id;
  String? price;
  String? accommodation;
  String? meals;
  String? itinerary;
  String? transportation;
  String? extras;
  dynamic rejectionReason;
  // TravelInquiry? travelInquiry;
  EnquiryContent? travelInquiry;
  User? vendor;
  User? user;
  int? createdAt;
  int? updatedAt;
  String? currency;
  bool? status;
  dynamic reason;
  String? shareCount;
  String? mealType;
  String? mealsPerDay;
  List<SpecialRequest>? specialRequestsResponse;
  String? region;
  dynamic subRegion;
  List<String>? countries;
  String? countryType;
  List<String>? destinations;
  String? travelDates;
  String? tentativeDays;
  String? tentativeDates;
  String? remarks;
  bool? cancelled;
  bool? accepted;
  bool? rejected;
  bool? submitted;
  bool? paid;
  bool? expired;
  bool? verified;

  BidContent({
    this.id,
    this.price,
    this.accommodation,
    this.meals,
    this.itinerary,
    this.transportation,
    this.extras,
    this.rejectionReason,
    this.travelInquiry,
    this.vendor,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.status,
    this.reason,
    this.shareCount,
    this.mealType,
    this.mealsPerDay,
    this.specialRequestsResponse,
    this.region,
    this.subRegion,
    this.countries,
    this.countryType,
    this.destinations,
    this.travelDates,
    this.tentativeDays,
    this.tentativeDates,
    this.remarks,
    this.cancelled,
    this.accepted,
    this.rejected,
    this.submitted,
    this.paid,
    this.expired,
    this.verified,
  });

  factory BidContent.fromJson(Map<String, dynamic> json) => BidContent(
        id: json["id"],
        price: json["price"],
        accommodation: json["accommodation"],
        meals: json["meals"],
        itinerary: json["itinerary"],
        transportation: json["transportation"],
        extras: json["extras"],
        rejectionReason: json["rejectionReason"],
        // travelInquiry: json["travelInquiry"] == null
        //     ? null
        //     : TravelInquiry.fromJson(json["travelInquiry"]),
        travelInquiry: json["travelInquiry"] == null
            ? null
            : EnquiryContent.fromJson(json["travelInquiry"]),
        vendor: json["vendor"] == null ? null : User.fromJson(json["vendor"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        currency: json["currency"],
        status: json["status"],
        reason: json["reason"],
        shareCount: json["shareCount"],
        mealType: json["mealType"],
        mealsPerDay: json["mealsPerDay"],
        specialRequestsResponse: json["specialRequestsResponse"] == null
            ? []
            : List<SpecialRequest>.from(json["specialRequestsResponse"]!
                .map((x) => SpecialRequest.fromJson(x))),
        region: json["region"],
        subRegion: json["subRegion"],
        countries: json["countries"] == null
            ? []
            : List<String>.from(json["countries"]!.map((x) => x)),
        countryType: json["countryType"],
        destinations: json["destinations"] == null
            ? []
            : List<String>.from(json["destinations"]!.map((x) => x)),
        travelDates: json["travelDates"],
        tentativeDays: json["tentativeDays"],
        tentativeDates: json["tentativeDates"],
        remarks: json["remarks"],
        cancelled: json["cancelled"],
        accepted: json["accepted"],
        rejected: json["rejected"],
        submitted: json["submitted"],
        paid: json["paid"],
        expired: json["expired"],
        verified: json["verified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "accommodation": accommodation,
        "meals": meals,
        "itinerary": itinerary,
        "transportation": transportation,
        "extras": extras,
        "rejectionReason": rejectionReason,
        "travelInquiry": travelInquiry?.toJson(),
        "vendor": vendor?.toJson(),
        "user": user?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "currency": currency,
        "status": status,
        "reason": reason,
        "shareCount": shareCount,
        "mealType": mealType,
        "mealsPerDay": mealsPerDay,
        "specialRequestsResponse": specialRequestsResponse == null
            ? []
            : List<dynamic>.from(
                specialRequestsResponse!.map((x) => x.toJson())),
        "region": region,
        "subRegion": subRegion,
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x)),
        "countryType": countryType,
        "destinations": destinations == null
            ? []
            : List<dynamic>.from(destinations!.map((x) => x)),
        "travelDates": travelDates,
        "tentativeDays": tentativeDays,
        "tentativeDates": tentativeDates,
        "remarks": remarks,
        "cancelled": cancelled,
        "accepted": accepted,
        "rejected": rejected,
        "submitted": submitted,
        "paid": paid,
        "expired": expired,
        "verified": verified,
      };
}

class SpecialRequest {
  int? id;
  String? request;
  String? status;
  dynamic specialRejectionReason;

  SpecialRequest({
    this.id,
    this.request,
    this.status,
    this.specialRejectionReason,
  });

  factory SpecialRequest.fromJson(Map<String, dynamic> json) => SpecialRequest(
        id: json["id"],
        request: json["request"],
        status: json["status"],
        specialRejectionReason: json["specialRejectionReason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request": request,
        "status": status,
        "specialRejectionReason": specialRejectionReason,
      };
}

class TravelInquiry {
  int? id;
  String? name;
  String? region;
  String? subRegion;
  List<String>? countries;
  List<String>? destinations;
  String? accommodationPreferences;
  dynamic meals;
  String? transportation;
  String? budget;
  String? travelDates;
  String? tentativeDays;
  String? tentativeDates;
  User? user;
  int? createdAt;
  int? updatedAt;
  String? currency;
  dynamic viewCurrency;
  dynamic viewAmount;
  dynamic paymentType;
  ParticipantType? participantType;
  String? countryType;
  String? mealType;
  String? mealsPerDay;
  dynamic mealPreferenceNotes;
  bool? status;
  String? reason;
  String? shareCount;
  double? usdAmount;
  List<SpecialRequest>? specialRequests;

  TravelInquiry({
    this.id,
    this.name,
    this.region,
    this.subRegion,
    this.countries,
    this.destinations,
    this.accommodationPreferences,
    this.meals,
    this.transportation,
    this.budget,
    this.travelDates,
    this.tentativeDays,
    this.tentativeDates,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.viewCurrency,
    this.viewAmount,
    this.paymentType,
    this.participantType,
    this.countryType,
    this.mealType,
    this.mealsPerDay,
    this.mealPreferenceNotes,
    this.status,
    this.reason,
    this.shareCount,
    this.usdAmount,
    this.specialRequests,
  });

  factory TravelInquiry.fromJson(Map<String, dynamic> json) => TravelInquiry(
        id: json["id"],
        name: json["name"],
        region: json["region"],
        subRegion: json["subRegion"],
        countries: json["countries"] == null
            ? []
            : List<String>.from(json["countries"]!.map((x) => x)),
        destinations: json["destinations"] == null
            ? []
            : List<String>.from(json["destinations"]!.map((x) => x)),
        accommodationPreferences: json["accommodationPreferences"],
        meals: json["meals"],
        transportation: json["transportation"],
        budget: json["budget"],
        travelDates: json["travelDates"],
        tentativeDays: json["tentativeDays"],
        tentativeDates: json["tentativeDates"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        currency: json["currency"],
        viewCurrency: json["viewCurrency"],
        viewAmount: json["viewAmount"],
        paymentType: json["paymentType"],
        participantType: json["participantType"] == null
            ? null
            : ParticipantType.fromJson(json["participantType"]),
        countryType: json["countryType"],
        mealType: json["mealType"],
        mealsPerDay: json["mealsPerDay"],
        mealPreferenceNotes: json["mealPreferenceNotes"],
        status: json["status"],
        reason: json["reason"],
        shareCount: json["shareCount"],
        usdAmount: json["usdAmount"]?.toDouble(),
        specialRequests: json["specialRequests"] == null
            ? []
            : List<SpecialRequest>.from(json["specialRequests"]!
                .map((x) => SpecialRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "region": region,
        "subRegion": subRegion,
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x)),
        "destinations": destinations == null
            ? []
            : List<dynamic>.from(destinations!.map((x) => x)),
        "accommodationPreferences": accommodationPreferences,
        "meals": meals,
        "transportation": transportation,
        "budget": budget,
        "travelDates": travelDates,
        "tentativeDays": tentativeDays,
        "tentativeDates": tentativeDates,
        "user": user?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "currency": currency,
        "viewCurrency": viewCurrency,
        "viewAmount": viewAmount,
        "paymentType": paymentType,
        "participantType": participantType?.toJson(),
        "countryType": countryType,
        "mealType": mealType,
        "mealsPerDay": mealsPerDay,
        "mealPreferenceNotes": mealPreferenceNotes,
        "status": status,
        "reason": reason,
        "shareCount": shareCount,
        "usdAmount": usdAmount,
        "specialRequests": specialRequests == null
            ? []
            : List<dynamic>.from(specialRequests!.map((x) => x.toJson())),
      };
}

class ParticipantType {
  int? child;
  int? guests;
  int? senior;
  int? adult;
  int? infant;

  ParticipantType({
    this.child,
    this.guests,
    this.senior,
    this.adult,
    this.infant,
  });

  factory ParticipantType.fromJson(Map<String, dynamic> json) =>
      ParticipantType(
        child: json["CHILD"],
        guests: json["GUESTS"],
        senior: json["SENIOR"],
        adult: json["ADULT"],
        infant: json["INFANT"],
      );

  Map<String, dynamic> toJson() => {
        "CHILD": child,
        "GUESTS": guests,
        "SENIOR": senior,
        "ADULT": adult,
        "INFANT": infant,
      };
}

class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? address;
  String? email;
  String? gender;
  DateTime? createdDate;
  DateTime? modifiedDate;
  bool? status;
  dynamic otp;
  dynamic isOtpVerified;
  String? userType;
  String? profileImageUrl;
  String? countryCode;
  dynamic notificationToken;
  String? lastLogin;
  String? country;
  String? state;
  String? rideOtp;
  DateTime? rideOtpExpiry;
  bool? isRideOtpVerified;
  bool? accountVerified;
  int? vendorId;
  String? vendorProfileImageUrl;
  DateTime? subscriptionStartDate;
  DateTime? subscriptionEndDate;
  String? verificationToken;
  DateTime? tokenExpiry;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.address,
    this.email,
    this.gender,
    this.createdDate,
    this.modifiedDate,
    this.status,
    this.otp,
    this.isOtpVerified,
    this.userType,
    this.profileImageUrl,
    this.countryCode,
    this.notificationToken,
    this.lastLogin,
    this.country,
    this.state,
    this.rideOtp,
    this.rideOtpExpiry,
    this.isRideOtpVerified,
    this.accountVerified,
    this.vendorId,
    this.vendorProfileImageUrl,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.verificationToken,
    this.tokenExpiry,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        address: json["address"],
        email: json["email"],
        gender: json["gender"],
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
        profileImageUrl: json["profileImageUrl"],
        countryCode: json["countryCode"],
        notificationToken: json["notificationToken"],
        lastLogin: json["lastLogin"],
        country: json["country"],
        state: json["state"],
        rideOtp: json["rideOtp"],
        rideOtpExpiry: json["rideOtpExpiry"] == null
            ? null
            : DateTime.parse(json["rideOtpExpiry"]),
        isRideOtpVerified: json["isRideOtpVerified"],
        accountVerified: json["accountVerified"],
        vendorId: json["vendorId"],
        vendorProfileImageUrl: json["vendorProfileImageUrl"],
        subscriptionStartDate: json["subscriptionStartDate"] == null
            ? null
            : DateTime.parse(json["subscriptionStartDate"]),
        subscriptionEndDate: json["subscriptionEndDate"] == null
            ? null
            : DateTime.parse(json["subscriptionEndDate"]),
        verificationToken: json["verificationToken"],
        tokenExpiry: json["tokenExpiry"] == null
            ? null
            : DateTime.parse(json["tokenExpiry"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
        "countryCode": countryCode,
        "notificationToken": notificationToken,
        "lastLogin": lastLogin,
        "country": country,
        "state": state,
        "rideOtp": rideOtp,
        "rideOtpExpiry": rideOtpExpiry?.toIso8601String(),
        "isRideOtpVerified": isRideOtpVerified,
        "accountVerified": accountVerified,
        "vendorId": vendorId,
        "vendorProfileImageUrl": vendorProfileImageUrl,
        "subscriptionStartDate": subscriptionStartDate?.toIso8601String(),
        "subscriptionEndDate": subscriptionEndDate?.toIso8601String(),
        "verificationToken": verificationToken,
        "tokenExpiry": tokenExpiry?.toIso8601String(),
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

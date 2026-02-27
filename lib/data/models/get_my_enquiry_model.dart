// To parse this JSON data, do
//
//     final getMyEnquiryModel = getMyEnquiryModelFromJson(jsonString);

import 'dart:convert';

GetMyEnquiryModel getMyEnquiryModelFromJson(String str) =>
    GetMyEnquiryModel.fromJson(json.decode(str));

String getMyEnquiryModelToJson(GetMyEnquiryModel data) =>
    json.encode(data.toJson());

class GetMyEnquiryModel {
  List<MyEnquiryContent>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? number;
  Sort? sort;
  int? size;
  int? numberOfElements;
  bool? first;
  bool? empty;

  GetMyEnquiryModel({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.number,
    this.sort,
    this.size,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory GetMyEnquiryModel.fromJson(Map<String, dynamic> json) =>
      GetMyEnquiryModel(
        content: json["content"] == null
            ? []
            : List<MyEnquiryContent>.from(
                json["content"]!.map((x) => MyEnquiryContent.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
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
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "number": number,
        "sort": sort?.toJson(),
        "size": size,
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class MyEnquiryContent {
  TravelInquiry? travelInquiry;
  List<Bid>? bids;
  String? currency;

  MyEnquiryContent({
    this.travelInquiry,
    this.bids,
    this.currency,
  });

  factory MyEnquiryContent.fromJson(Map<String, dynamic> json) =>
      MyEnquiryContent(
        travelInquiry: json["travelInquiry"] == null
            ? null
            : TravelInquiry.fromJson(json["travelInquiry"]),
        bids: json["bids"] == null
            ? []
            : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "travelInquiry": travelInquiry?.toJson(),
        "bids": bids == null
            ? []
            : List<dynamic>.from(bids!.map((x) => x.toJson())),
        "currency": currency,
      };
}

// SpecialRequest model to hold special request objects
class SpecialRequest {
  int? id;
  String? request;
  String? status;

  SpecialRequest({
    this.id,
    this.request,
    this.status,
  });

  factory SpecialRequest.fromJson(Map<String, dynamic> json) => SpecialRequest(
        id: json["id"],
        request: json["request"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request": request,
        "status": status,
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
  List<SpecialRequest>? specialRequests;
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
  String? mealPreferenceNotes;
  bool? status;
  String? reason;
  List<Bid>? bids;

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
    this.specialRequests,
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
    this.bids,
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
        // FIX: specialRequests can be a list in the API, so parse as List<SpecialRequest>
        specialRequests: json["specialRequests"] == null
            ? []
            : (json["specialRequests"] is String
                ? []
                : List<SpecialRequest>.from((json["specialRequests"] as List)
                    .map((x) => SpecialRequest.fromJson(x)))),
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
        bids: json["bids"] == null
            ? []
            : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
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
        // Serialize specialRequests as a list of maps (if available)
        "specialRequests": specialRequests == null
            ? []
            : List<dynamic>.from(specialRequests!.map((x) => x.toJson())),
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
        "bids": bids == null
            ? []
            : List<dynamic>.from(bids!.map((x) => x.toJson())),
      };
}

class Bid {
  int? id;
  String? price;
  String? accommodation;
  String? meals;
  String? itinerary;
  String? transportation;
  String? extras;
  dynamic rejectionReason;
  TravelInquiry? travelInquiry;
  User? vendor;
  User? user;
  int? createdAt;
  int? updatedAt;
  String? currency;
  bool? status;
  dynamic reason;
  bool? cancelled;
  bool? accepted;
  bool? verified;
  bool? paid;
  bool? submitted;
  bool? expired;
  bool? rejected;

  Bid({
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
    this.cancelled,
    this.accepted,
    this.verified,
    this.paid,
    this.submitted,
    this.expired,
    this.rejected,
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
        id: json["id"],
        price: json["price"],
        accommodation: json["accommodation"],
        meals: json["meals"],
        itinerary: json["itinerary"],
        transportation: json["transportation"],
        extras: json["extras"],
        rejectionReason: json["rejectionReason"],
        travelInquiry: json["travelInquiry"] == null
            ? null
            : TravelInquiry.fromJson(json["travelInquiry"]),
        vendor: json["vendor"] == null ? null : User.fromJson(json["vendor"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        currency: json["currency"],
        status: json["status"],
        reason: json["reason"],
        cancelled: json["cancelled"],
        accepted: json["accepted"],
        verified: json["verified"],
        paid: json["paid"],
        submitted: json["submitted"],
        expired: json["expired"],
        rejected: json["rejected"],
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
        "cancelled": cancelled,
        "accepted": accepted,
        "verified": verified,
        "paid": paid,
        "submitted": submitted,
        "expired": expired,
        "rejected": rejected,
      };
}

class ParticipantType {
  int? infant;
  int? guests;
  int? adult;
  int? child;
  int? senior;

  ParticipantType({
    this.infant,
    this.guests,
    this.adult,
    this.child,
    this.senior,
  });

  factory ParticipantType.fromJson(Map<String, dynamic> json) =>
      ParticipantType(
        infant: json["INFANT"],
        guests: json["GUESTS"],
        adult: json["ADULT"],
        child: json["CHILD"],
        senior: json["SENIOR"],
      );

  Map<String, dynamic> toJson() => {
        "INFANT": infant,
        "GUESTS": guests,
        "ADULT": adult,
        "CHILD": child,
        "SENIOR": senior,
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
  bool? unsorted;
  bool? sorted;

  Sort({
    this.empty,
    this.unsorted,
    this.sorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        unsorted: json["unsorted"],
        sorted: json["sorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "unsorted": unsorted,
        "sorted": sorted,
      };
}


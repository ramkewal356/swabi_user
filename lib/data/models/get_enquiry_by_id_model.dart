// To parse this JSON data, do
//
//     final getEnquiryByIdModel = getEnquiryByIdModelFromJson(jsonString);

import 'dart:convert';

GetEnquiryByIdModel getEnquiryByIdModelFromJson(String str) =>
    GetEnquiryByIdModel.fromJson(json.decode(str));

String getEnquiryByIdModelToJson(GetEnquiryByIdModel data) =>
    json.encode(data.toJson());

class GetEnquiryByIdModel {
  Status? status;
  Data? data;

  GetEnquiryByIdModel({
    this.status,
    this.data,
  });

  factory GetEnquiryByIdModel.fromJson(Map<String, dynamic> json) =>
      GetEnquiryByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
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
  Data? travelInquiry;
  User? vendor;
  User? user;
  int? createdAt;
  int? updatedAt;
  String? currency;
  bool? status;
  bool? cancelled;
  bool? accepted;
  bool? submitted;
  bool? rejected;
  bool? paid;
  bool? expired;
  bool? verified;

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
    this.cancelled,
    this.accepted,
    this.submitted,
    this.rejected,
    this.paid,
    this.expired,
    this.verified,
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
            : Data.fromJson(json["travelInquiry"]),
        vendor: json["vendor"] == null ? null : User.fromJson(json["vendor"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        currency: json["currency"],
        status: json["status"],
        cancelled: json["cancelled"],
        accepted: json["accepted"],
        submitted: json["submitted"],
        rejected: json["rejected"],
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
        "cancelled": cancelled,
        "accepted": accepted,
        "submitted": submitted,
        "rejected": rejected,
        "paid": paid,
        "expired": expired,
        "verified": verified,
      };
}

class Data {
  int? id;
  dynamic name;
  String? email;
  String? region;
  dynamic subRegion;
  List<String>? countries;
  List<String>? destinations;
  String? accommodationPreferences;
  dynamic meals;
  String? transportation;
  String? budget;
  List<SpecialRequest>? specialRequests;
  String? travelDates;
  String? tentativeDays;
  int? createdAt;
  User? user;
  List<Bid>? bids;
  String? tentativeDates;
  String? currency;
  dynamic viewCurrency;
  dynamic viewAmount;
  dynamic paymentType;
  ParticipantType? participantType;
  String? countryType;
  bool? show;
  bool? bidPlacedByVendor;
  int? updatedAt;
  String? mealType;
  String? mealsPerDay;
  dynamic mealPreferenceNotes;
  String? shareCount;
  bool? closeInquiryStatus;

  Data({
    this.id,
    this.name,
    this.email,
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
    this.createdAt,
    this.user,
    this.bids,
    this.tentativeDates,
    this.currency,
    this.viewCurrency,
    this.viewAmount,
    this.paymentType,
    this.participantType,
    this.countryType,
    this.show,
    this.bidPlacedByVendor,
    this.updatedAt,
    this.mealType,
    this.mealsPerDay,
    this.mealPreferenceNotes,
    this.shareCount,
    this.closeInquiryStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
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
        specialRequests: json["specialRequests"] == null
            ? []
            : List<SpecialRequest>.from(
                json["specialRequests"].map((x) => SpecialRequest.fromJson(x))),
        travelDates: json["travelDates"],
        tentativeDays: json["tentativeDays"],
        createdAt: json["createdAt"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        bids: json["bids"] == null
            ? []
            : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
        tentativeDates: json["tentativeDates"],
        currency: json["currency"],
        viewCurrency: json["viewCurrency"],
        viewAmount: json["viewAmount"],
        paymentType: json["paymentType"],
        participantType: json["participantType"] == null
            ? null
            : ParticipantType.fromJson(json["participantType"]),
        countryType: json["countryType"],
        show: json["show"],
        bidPlacedByVendor: json["bidPlacedByVendor"],
        updatedAt: json["updatedAt"],
        mealType: json["mealType"],
        mealsPerDay: json["mealsPerDay"],
        mealPreferenceNotes: json["mealPreferenceNotes"],
        shareCount: json["shareCount"],
        closeInquiryStatus: json["closeInquiryStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
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
        "specialRequests": specialRequests == null
            ? []
            : List<dynamic>.from(specialRequests!.map((x) => x.toJson())),
        "travelDates": travelDates,
        "tentativeDays": tentativeDays,
        "createdAt": createdAt,
        "user": user?.toJson(),
        "bids": bids == null
            ? []
            : List<dynamic>.from(bids!.map((x) => x.toJson())),
        "tentativeDates": tentativeDates,
        "currency": currency,
        "viewCurrency": viewCurrency,
        "viewAmount": viewAmount,
        "paymentType": paymentType,
        "participantType": participantType?.toJson(),
        "countryType": countryType,
        "show": show,
        "bidPlacedByVendor": bidPlacedByVendor,
        "updatedAt": updatedAt,
        "mealType": mealType,
        "mealsPerDay": mealsPerDay,
        "mealPreferenceNotes": mealPreferenceNotes,
        "shareCount": shareCount,
        "closeInquiryStatus": closeInquiryStatus,
      };
}

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

class ParticipantType {
  int? senior;
  int? adult;
  int? child;
  int? infant;
  int? guests;
  ParticipantType(
      {this.senior, this.adult, this.child, this.infant, this.guests});

  factory ParticipantType.fromJson(Map<String, dynamic> json) =>
      ParticipantType(
          senior: json["SENIOR"],
          adult: json["ADULT"],
          child: json["CHILD"],
          infant: json["INFANT"],
          guests: json["GUESTS"]);

  Map<String, dynamic> toJson() => {
        "SENIOR": senior,
        "ADULT": adult,
        "CHILD": child,
        "INFANT": infant,
        "GUESTS": guests
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

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

class Data {
  int? id;
  String? name;
  String? email;
  dynamic country;
  List<String>? destinations;
  String? accommodationPreferences;
  String? meals;
  String? transportation;
  String? budget;
  dynamic specialRequests;
  String? travelDates;
  dynamic tentativeDates;
  int? createdAt;
  User? user;
  List<Bid>? bids;
  bool? bidPlacedByVendor;

  Data({
    this.id,
    this.name,
    this.email,
    this.country,
    this.destinations,
    this.accommodationPreferences,
    this.meals,
    this.transportation,
    this.budget,
    this.specialRequests,
    this.travelDates,
    this.tentativeDates,
    this.createdAt,
    this.user,
    this.bids,
    this.bidPlacedByVendor,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        country: json["country"],
        destinations: json["destinations"] == null
            ? []
            : List<String>.from(json["destinations"]!.map((x) => x)),
        accommodationPreferences: json["accommodationPreferences"],
        meals: json["meals"],
        transportation: json["transportation"],
        budget: json["budget"],
        specialRequests: json["specialRequests"],
        travelDates: json["travelDates"],
        tentativeDates: json["tentativeDates"],
        createdAt: json["createdAt"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        bids: json["bids"] == null
            ? []
            : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
        bidPlacedByVendor: json["bidPlacedByVendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "country": country,
        "destinations": destinations == null
            ? []
            : List<dynamic>.from(destinations!.map((x) => x)),
        "accommodationPreferences": accommodationPreferences,
        "meals": meals,
        "transportation": transportation,
        "budget": budget,
        "specialRequests": specialRequests,
        "travelDates": travelDates,
        "tentativeDates": tentativeDates,
        "createdAt": createdAt,
        "user": user?.toJson(),
        "bids": bids == null
            ? []
            : List<dynamic>.from(bids!.map((x) => x.toJson())),
        "bidPlacedByVendor": bidPlacedByVendor,
      };
}

class Bid {
  int? id;
  String? price;
  String? accommodation;
  String? meals;
  dynamic itinerary;
  String? transportation;
  String? extras;
  dynamic rejectionReason;
  User? vendor;
  User? user;
  int? createdAt;
  int? updatedAt;
  bool? cancelled;
  bool? accepted;
  bool? submitted;
  bool? rejected;
  bool? paid;
  bool? verified;
  bool? expired;

  Bid({
    this.id,
    this.price,
    this.accommodation,
    this.meals,
    this.itinerary,
    this.transportation,
    this.extras,
    this.rejectionReason,
    this.vendor,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.cancelled,
    this.accepted,
    this.submitted,
    this.rejected,
    this.paid,
    this.verified,
    this.expired,
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
        vendor: json["vendor"] == null ? null : User.fromJson(json["vendor"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        cancelled: json["cancelled"],
        accepted: json["accepted"],
        submitted: json["submitted"],
        rejected: json["rejected"],
        paid: json["paid"],
        verified: json["verified"],
        expired: json["expired"],
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
        "vendor": vendor?.toJson(),
        "user": user?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "cancelled": cancelled,
        "accepted": accepted,
        "submitted": submitted,
        "rejected": rejected,
        "paid": paid,
        "verified": verified,
        "expired": expired,
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
  bool? isOtpVerified;
  String? userType;
  String? profileImageUrl;
  String? countryCode;
  String? notificationToken;
  String? lastLogin;
  String? country;
  String? state;
  int? vendorId;
  String? vendorProfileImageUrl;
  dynamic subscriptionStartDate;
  dynamic subscriptionEndDate;

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
    this.vendorId,
    this.vendorProfileImageUrl,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
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
        vendorId: json["vendorId"],
        vendorProfileImageUrl: json["vendorProfileImageUrl"],
        subscriptionStartDate: json["subscriptionStartDate"],
        subscriptionEndDate: json["subscriptionEndDate"],
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
        "vendorId": vendorId,
        "vendorProfileImageUrl": vendorProfileImageUrl,
        "subscriptionStartDate": subscriptionStartDate,
        "subscriptionEndDate": subscriptionEndDate,
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

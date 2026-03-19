// To parse this JSON data, do
//
//     final getAllEnquiryModel = getAllEnquiryModelFromJson(jsonString);

import 'dart:convert';

GetAllEnquiryModel getAllEnquiryModelFromJson(String str) =>
    GetAllEnquiryModel.fromJson(json.decode(str));

String getAllEnquiryModelToJson(GetAllEnquiryModel data) =>
    json.encode(data.toJson());

class GetAllEnquiryModel {
  StatusClass? status;
  Data? data;

  GetAllEnquiryModel({
    this.status,
    this.data,
  });

  factory GetAllEnquiryModel.fromJson(Map<String, dynamic> json) =>
      GetAllEnquiryModel(
        status: json["status"] == null
            ? null
            : StatusClass.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<EnquiryContent>? content;
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<EnquiryContent>.from(
                json["content"]!.map((x) => EnquiryContent.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalElements: _parseInt(json["totalElements"]),
        totalPages: _parseInt(json["totalPages"]),
        last: json["last"],
        size: _parseInt(json["size"]),
        number: _parseInt(json["number"]),
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: _parseInt(json["numberOfElements"]),
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

class Bid {
  int? id;
  String? price;
  String? accommodation;
  String? meals;
  String? itinerary;
  String? transportation;
  String? extras;
  dynamic rejectionReason;
  EnquiryContent? travelInquiry;
  User? vendor;
  User? user;
  int? createdAt;
  int? updatedAt;
  String? currency;
  bool? status;
  String? reason;
  bool? cancelled;
  bool? accepted;
  bool? paid;
  bool? rejected;
  bool? submitted;
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
    this.paid,
    this.rejected,
    this.submitted,
    this.verified,
    this.expired,
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
        id: _parseInt(json["id"]),
        price: json["price"],
        accommodation: json["accommodation"],
        meals: json["meals"],
        itinerary: json["itinerary"],
        transportation: json["transportation"],
        extras: json["extras"],
        rejectionReason: json["rejectionReason"],
        travelInquiry: json["travelInquiry"] == null
            ? null
            : EnquiryContent.fromJson(json["travelInquiry"]),
        vendor: json["vendor"] == null ? null : User.fromJson(json["vendor"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: _parseInt(json["createdAt"]),
        updatedAt: _parseInt(json["updatedAt"]),
        currency: json["currency"],
        status: json["status"],
        reason: json["reason"],
        cancelled: json["cancelled"],
        accepted: json["accepted"],
        paid: json["paid"],
        rejected: json["rejected"],
        submitted: json["submitted"],
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
        "paid": paid,
        "rejected": rejected,
        "submitted": submitted,
        "verified": verified,
        "expired": expired,
      };
}

class EnquiryContent {
  int? id;
  String? name;
  String? email;
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
  int? createdAt;
  User? user;
  List<Bid>? bids;
  String? tentativeDates;
  String? currency;
  String? viewCurrency;
  int? viewAmount;
  dynamic paymentType;
  ParticipantType? participantType;
  String? countryType;
  String? shareCount;
  String? mealType;
  String? mealsPerDay;
  bool? closeInquiryStatus;
  bool? bidPlacedByVendor;
  bool? show;
  int? updatedAt;
  String? mealPreferenceNotes;
  bool? status;
  dynamic reason;
  double? usdAmount;

  EnquiryContent({
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
    this.shareCount,
    this.mealType,
    this.mealsPerDay,
    this.closeInquiryStatus,
    this.bidPlacedByVendor,
    this.show,
    this.updatedAt,
    this.mealPreferenceNotes,
    this.status,
    this.reason,
    this.usdAmount,
  });

  factory EnquiryContent.fromJson(Map<String, dynamic> json) => EnquiryContent(
        id: _parseInt(json["id"]),
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
            : List<SpecialRequest>.from(json["specialRequests"]!
                .map((x) => SpecialRequest.fromJson(x))),
        travelDates: json["travelDates"],
        tentativeDays: json["tentativeDays"],
        createdAt: _parseInt(json["createdAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        bids: json["bids"] == null
            ? []
            : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
        tentativeDates: json["tentativeDates"],
        currency: json["currency"],
        viewCurrency: json["viewCurrency"],
        viewAmount: _parseInt(json["viewAmount"]),
        paymentType: json["paymentType"],
        participantType: json["participantType"] == null
            ? null
            : ParticipantType.fromJson(json["participantType"]),
        countryType: json["countryType"],
        shareCount: json["shareCount"]?.toString(),
        mealType: json["mealType"],
        mealsPerDay: json["mealsPerDay"],
        closeInquiryStatus: json["closeInquiryStatus"],
        bidPlacedByVendor: json["bidPlacedByVendor"],
        show: json["show"],
        updatedAt: _parseInt(json["updatedAt"]),
        mealPreferenceNotes: json["mealPreferenceNotes"],
        status: json["status"],
        reason: json["reason"],
        usdAmount: json["usdAmount"] != null
            ? (json["usdAmount"] is int
                ? (json["usdAmount"] as int).toDouble()
                : (json["usdAmount"] is String
                    ? double.tryParse(json["usdAmount"])
                    : json["usdAmount"]?.toDouble()))
            : null,
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
        "shareCount": shareCount,
        "mealType": mealType,
        "mealsPerDay": mealsPerDay,
        "closeInquiryStatus": closeInquiryStatus,
        "bidPlacedByVendor": bidPlacedByVendor,
        "show": show,
        "updatedAt": updatedAt,
        "mealPreferenceNotes": mealPreferenceNotes,
        "status": status,
        "reason": reason,
        "usdAmount": usdAmount,
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
        userId: _parseInt(json["userId"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        address: json["address"],
        email: json["email"],
        gender: json["gender"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.tryParse(
                json["createdDate"].toString().replaceAll('/', '-')),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.tryParse(
                json["modifiedDate"].toString().replaceAll('/', '-')),
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
            : DateTime.tryParse(
                json["rideOtpExpiry"].toString().replaceAll('/', '-')),
        isRideOtpVerified: json["isRideOtpVerified"],
        accountVerified: json["accountVerified"],
        vendorId: _parseInt(json["vendorId"]),
        vendorProfileImageUrl: json["vendorProfileImageUrl"],
        subscriptionStartDate: json["subscriptionStartDate"] == null
            ? null
            : DateTime.tryParse(
                json["subscriptionStartDate"].toString().replaceAll('/', '-')),
        subscriptionEndDate: json["subscriptionEndDate"] == null
            ? null
            : DateTime.tryParse(
                json["subscriptionEndDate"].toString().replaceAll('/', '-')),
        verificationToken: json["verificationToken"],
        tokenExpiry: json["tokenExpiry"] == null
            ? null
            : DateTime.tryParse(
                json["tokenExpiry"].toString().replaceAll('/', '-')),
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
  int? infant;
  int? adult;
  int? child;
  int? guests;

  ParticipantType({
    this.senior,
    this.infant,
    this.adult,
    this.child,
    this.guests,
  });

  factory ParticipantType.fromJson(Map<String, dynamic> json) =>
      ParticipantType(
        senior: _parseInt(json["SENIOR"]),
        infant: _parseInt(json["INFANT"]),
        adult: _parseInt(json["ADULT"]),
        child: _parseInt(json["CHILD"]),
        guests: _parseInt(json["GUESTS"]),
      );

  Map<String, dynamic> toJson() => {
        "SENIOR": senior,
        "INFANT": infant,
        "ADULT": adult,
        "CHILD": child,
        "GUESTS": guests,
      };
}

class SpecialRequest {
  int? id;
  String? request;
  String? status;
  String? specialRejectionReason;
  SpecialRequest(
      {this.id, this.request, this.status, this.specialRejectionReason});

  factory SpecialRequest.fromJson(Map<String, dynamic> json) => SpecialRequest(
      id: _parseInt(json["id"]),
      request: json["request"],
      status: json["status"],
      specialRejectionReason: json["specialRejectionReason"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "request": request,
        "status": status,
        "specialRejectionReason": specialRejectionReason
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
        offset: _parseInt(json["offset"]),
        pageNumber: _parseInt(json["pageNumber"]),
        pageSize: _parseInt(json["pageSize"]),
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

class StatusClass {
  String? httpCode;
  bool? success;
  String? message;

  StatusClass({
    this.httpCode,
    this.success,
    this.message,
  });

  factory StatusClass.fromJson(Map<String, dynamic> json) => StatusClass(
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

// Helper: Casts to int if possible, or null otherwise
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

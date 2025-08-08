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
  int? totalElements;
  int? totalPages;
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

  factory GetMyEnquiryModel.fromJson(Map<String, dynamic> json) =>
      GetMyEnquiryModel(
        content: json["content"] == null
            ? []
            : List<MyEnquiryContent>.from(
                json["content"]!.map((x) => MyEnquiryContent.fromJson(x))),
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

class MyEnquiryContent {
  TravelInquiry? travelInquiry;
  List<Bid>? bids;

  MyEnquiryContent({
    this.travelInquiry,
    this.bids,
  });

  factory MyEnquiryContent.fromJson(Map<String, dynamic> json) =>
      MyEnquiryContent(
        travelInquiry: json["travelInquiry"] == null
            ? null
            : TravelInquiry.fromJson(json["travelInquiry"]),
        bids: json["bids"] == null
            ? []
            : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "travelInquiry": travelInquiry?.toJson(),
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
            : TravelInquiry.fromJson(json["travelInquiry"]),
        vendor: json["vendor"] == null ? null : User.fromJson(json["vendor"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
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
        "cancelled": cancelled,
        "accepted": accepted,
        "submitted": submitted,
        "rejected": rejected,
        "paid": paid,
        "expired": expired,
        "verified": verified,
      };
}

class TravelInquiry {
  int? id;
  String? name;
  String? country;
  List<String>? destinations;
  String? accommodationPreferences;
  String? meals;
  String? transportation;
  String? budget;
  String? specialRequests;
  String? travelDates;
  dynamic tentativeDates;
  User? user;
  dynamic createdAt;
  dynamic updatedAt;

  TravelInquiry({
    this.id,
    this.name,
    this.country,
    this.destinations,
    this.accommodationPreferences,
    this.meals,
    this.transportation,
    this.budget,
    this.specialRequests,
    this.travelDates,
    this.tentativeDates,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory TravelInquiry.fromJson(Map<String, dynamic> json) => TravelInquiry(
        id: json["id"],
        name: json["name"],
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
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
        "user": user?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
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
  String? notificationToken;
  String? lastLogin;
  String? country;
  String? state;

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

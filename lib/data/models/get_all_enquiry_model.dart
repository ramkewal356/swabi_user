// // To parse this JSON data, do
// //
// //     final getAllEnquiryModel = getAllEnquiryModelFromJson(jsonString);

// import 'dart:convert';

// GetAllEnquiryModel getAllEnquiryModelFromJson(String str) =>
//     GetAllEnquiryModel.fromJson(json.decode(str));

// String getAllEnquiryModelToJson(GetAllEnquiryModel data) =>
//     json.encode(data.toJson());

// class GetAllEnquiryModel {
//   Status? status;
//   EnquiryData? data;

//   GetAllEnquiryModel({
//     this.status,
//     this.data,
//   });

//   factory GetAllEnquiryModel.fromJson(Map<String, dynamic> json) =>
//       GetAllEnquiryModel(
//         status: json["status"] == null ? null : Status.fromJson(json["status"]),
//         data: json["data"] == null ? null : EnquiryData.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status?.toJson(),
//         "data": data?.toJson(),
//       };
// }

// class EnquiryData {
//   List<EnquiryContent>? content;
//   Pageable? pageable;
//   int? totalElements;
//   int? totalPages;
//   bool? last;
//   int? number;
//   Sort? sort;
//   int? size;
//   int? numberOfElements;
//   bool? first;
//   bool? empty;

//   EnquiryData({
//     this.content,
//     this.pageable,
//     this.totalElements,
//     this.totalPages,
//     this.last,
//     this.number,
//     this.sort,
//     this.size,
//     this.numberOfElements,
//     this.first,
//     this.empty,
//   });

//   factory EnquiryData.fromJson(Map<String, dynamic> json) => EnquiryData(
//         content: json["content"] == null
//             ? []
//             : List<EnquiryContent>.from(
//                 json["content"]!.map((x) => EnquiryContent.fromJson(x))),
//         pageable: json["pageable"] == null
//             ? null
//             : Pageable.fromJson(json["pageable"]),
//         totalElements: json["totalElements"],
//         totalPages: json["totalPages"],
//         last: json["last"],
//         number: json["number"],
//         sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
//         size: json["size"],
//         numberOfElements: json["numberOfElements"],
//         first: json["first"],
//         empty: json["empty"],
//       );

//   Map<String, dynamic> toJson() => {
//         "content": content == null
//             ? []
//             : List<dynamic>.from(content!.map((x) => x.toJson())),
//         "pageable": pageable?.toJson(),
//         "totalElements": totalElements,
//         "totalPages": totalPages,
//         "last": last,
//         "number": number,
//         "sort": sort?.toJson(),
//         "size": size,
//         "numberOfElements": numberOfElements,
//         "first": first,
//         "empty": empty,
//       };
// }

// class EnquiryContent {
//   int? id;
//   String? name;
//   String? email;
//   String? country;
//   List<String>? destinations;
//   String? accommodationPreferences;
//   String? meals;
//   String? transportation;
//   String? budget;
//   String? currency;
//   String? specialRequests;
//   String? travelDates;
//   String? tentativeDays;
//   int? createdAt;
//   User? user;
//   bool? bidPlacedByVendor;

//   EnquiryContent({
//     this.id,
//     this.name,
//     this.email,
//     this.country,
//     this.destinations,
//     this.accommodationPreferences,
//     this.meals,
//     this.transportation,
//     this.budget,
//     this.currency,
//     this.specialRequests,
//     this.travelDates,
//     this.tentativeDays,
//     this.createdAt,
//     this.user,
//     this.bidPlacedByVendor,
//   });

//   factory EnquiryContent.fromJson(Map<String, dynamic> json) => EnquiryContent(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         country: json["country"],
//         destinations: json["destinations"] == null
//             ? []
//             : List<String>.from(json["destinations"]!.map((x) => x)),
//         accommodationPreferences: json["accommodationPreferences"],
//         meals: json["meals"],
//         transportation: json["transportation"],
//         budget: json["budget"],
//         currency: json["currency"],
//         specialRequests: json["specialRequests"],
//         travelDates: json["travelDates"],
//         tentativeDays: json["tentativeDays"],
//         createdAt: json["createdAt"],
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//         bidPlacedByVendor: json["bidPlacedByVendor"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "country": country,
//         "destinations": destinations == null
//             ? []
//             : List<dynamic>.from(destinations!.map((x) => x)),
//         "accommodationPreferences": accommodationPreferences,
//         "meals": meals,
//         "transportation": transportation,
//         "budget": budget,
//         "currency": currency,
//         "specialRequests": specialRequests,
//         "travelDates": travelDates,
//         "tentativeDays": tentativeDays,
//         "createdAt": createdAt,
//         "user": user?.toJson(),
//         "bidPlacedByVendor": bidPlacedByVendor,
//       };
// }

// class User {
//   int? userId;
//   String? firstName;
//   String? lastName;
//   String? mobile;
//   String? address;
//   String? email;
//   String? gender;
//   DateTime? createdDate;
//   DateTime? modifiedDate;
//   bool? status;
//   dynamic otp;
//   dynamic isOtpVerified;
//   String? userType;
//   String? profileImageUrl;
//   String? countryCode;
//   String? notificationToken;
//   String? lastLogin;
//   String? country;
//   String? state;

//   User({
//     this.userId,
//     this.firstName,
//     this.lastName,
//     this.mobile,
//     this.address,
//     this.email,
//     this.gender,
//     this.createdDate,
//     this.modifiedDate,
//     this.status,
//     this.otp,
//     this.isOtpVerified,
//     this.userType,
//     this.profileImageUrl,
//     this.countryCode,
//     this.notificationToken,
//     this.lastLogin,
//     this.country,
//     this.state,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         userId: json["userId"],
//         firstName: json["firstName"],
//         lastName: json["lastName"],
//         mobile: json["mobile"],
//         address: json["address"],
//         email: json["email"],
//         gender: json["gender"],
//         createdDate: json["createdDate"] == null
//             ? null
//             : DateTime.parse(json["createdDate"]),
//         modifiedDate: json["modifiedDate"] == null
//             ? null
//             : DateTime.parse(json["modifiedDate"]),
//         status: json["status"],
//         otp: json["otp"],
//         isOtpVerified: json["isOtpVerified"],
//         userType: json["userType"],
//         profileImageUrl: json["profileImageUrl"],
//         countryCode: json["countryCode"],
//         notificationToken: json["notificationToken"],
//         lastLogin: json["lastLogin"],
//         country: json["country"],
//         state: json["state"],
//       );

//   Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "firstName": firstName,
//         "lastName": lastName,
//         "mobile": mobile,
//         "address": address,
//         "email": email,
//         "gender": gender,
//         "createdDate": createdDate?.toIso8601String(),
//         "modifiedDate": modifiedDate?.toIso8601String(),
//         "status": status,
//         "otp": otp,
//         "isOtpVerified": isOtpVerified,
//         "userType": userType,
//         "profileImageUrl": profileImageUrl,
//         "countryCode": countryCode,
//         "notificationToken": notificationToken,
//         "lastLogin": lastLogin,
//         "country": country,
//         "state": state,
//       };
// }

// class Pageable {
//   Sort? sort;
//   int? offset;
//   int? pageNumber;
//   int? pageSize;
//   bool? paged;
//   bool? unpaged;

//   Pageable({
//     this.sort,
//     this.offset,
//     this.pageNumber,
//     this.pageSize,
//     this.paged,
//     this.unpaged,
//   });

//   factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
//         sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
//         offset: json["offset"],
//         pageNumber: json["pageNumber"],
//         pageSize: json["pageSize"],
//         paged: json["paged"],
//         unpaged: json["unpaged"],
//       );

//   Map<String, dynamic> toJson() => {
//         "sort": sort?.toJson(),
//         "offset": offset,
//         "pageNumber": pageNumber,
//         "pageSize": pageSize,
//         "paged": paged,
//         "unpaged": unpaged,
//       };
// }

// class Sort {
//   bool? empty;
//   bool? sorted;
//   bool? unsorted;

//   Sort({
//     this.empty,
//     this.sorted,
//     this.unsorted,
//   });

//   factory Sort.fromJson(Map<String, dynamic> json) => Sort(
//         empty: json["empty"],
//         sorted: json["sorted"],
//         unsorted: json["unsorted"],
//       );

//   Map<String, dynamic> toJson() => {
//         "empty": empty,
//         "sorted": sorted,
//         "unsorted": unsorted,
//       };
// }

// class Status {
//   String? httpCode;
//   bool? success;
//   String? message;

//   Status({
//     this.httpCode,
//     this.success,
//     this.message,
//   });

//   factory Status.fromJson(Map<String, dynamic> json) => Status(
//         httpCode: json["httpCode"],
//         success: json["success"],
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "httpCode": httpCode,
//         "success": success,
//         "message": message,
//       };
// }
// To parse this JSON data, do
//
//     final getAllEnquiryModel = getAllEnquiryModelFromJson(jsonString);

import 'dart:convert';

GetAllEnquiryModel getAllEnquiryModelFromJson(String str) =>
    GetAllEnquiryModel.fromJson(json.decode(str));

String getAllEnquiryModelToJson(GetAllEnquiryModel data) =>
    json.encode(data.toJson());

class GetAllEnquiryModel {
  Status? status;
  Data? data;

  GetAllEnquiryModel({
    this.status,
    this.data,
  });

  factory GetAllEnquiryModel.fromJson(Map<String, dynamic> json) =>
      GetAllEnquiryModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
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
            : List<EnquiryContent>.from(
                json["content"]!.map((x) => EnquiryContent.fromJson(x))),
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
  String? specialRequests;
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
  ContentParticipantType? participantType;
  String? countryType;
  bool? bidPlacedByVendor;
  bool? show;

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
    this.bidPlacedByVendor,
    this.show,
  });

  factory EnquiryContent.fromJson(Map<String, dynamic> json) => EnquiryContent(
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
        specialRequests: json["specialRequests"],
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
            : ContentParticipantType.fromJson(json["participantType"]),
        countryType: json["countryType"],
        bidPlacedByVendor: json["bidPlacedByVendor"],
        show: json["show"],
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
        "specialRequests": specialRequests,
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
        "bidPlacedByVendor": bidPlacedByVendor,
        "show": show,
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
            : TravelInquiry.fromJson(json["travelInquiry"]),
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

class TravelInquiry {
  int? id;
  dynamic name;
  String? region;
  String? subRegion;
  List<String>? countries;
  List<String>? destinations;
  String? accommodationPreferences;
  dynamic meals;
  String? transportation;
  String? budget;
  dynamic specialRequests;
  String? travelDates;
  String? tentativeDays;
  dynamic tentativeDates;
  User? user;
  int? createdAt;
  int? updatedAt;
  String? currency;
  dynamic viewCurrency;
  dynamic viewAmount;
  dynamic paymentType;
  TravelInquiryParticipantType? participantType;
  String? countryType;
  String? mealType;
  int? mealsPerDay;
  String? mealPreferenceNotes;
  bool? status;

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
        specialRequests: json["specialRequests"],
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
            : TravelInquiryParticipantType.fromJson(json["participantType"]),
        countryType: json["countryType"],
        mealType: json["mealType"],
        mealsPerDay: json["mealsPerDay"],
        mealPreferenceNotes: json["mealPreferenceNotes"],
        status: json["status"],
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
        "specialRequests": specialRequests,
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
      };
}

class TravelInquiryParticipantType {
  int? senior;

  TravelInquiryParticipantType({
    this.senior,
  });

  factory TravelInquiryParticipantType.fromJson(Map<String, dynamic> json) =>
      TravelInquiryParticipantType(
        senior: json["SENIOR"],
      );

  Map<String, dynamic> toJson() => {
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

class ContentParticipantType {
  int? infant;
  int? adult;
  int? child;
  int? senior;

  ContentParticipantType({
    this.infant,
    this.adult,
    this.child,
    this.senior,
  });

  factory ContentParticipantType.fromJson(Map<String, dynamic> json) =>
      ContentParticipantType(
        infant: json["INFANT"],
        adult: json["ADULT"],
        child: json["CHILD"],
        senior: json["SENIOR"],
      );

  Map<String, dynamic> toJson() => {
        "INFANT": infant,
        "ADULT": adult,
        "CHILD": child,
        "SENIOR": senior,
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

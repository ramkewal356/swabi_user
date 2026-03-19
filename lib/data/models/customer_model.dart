// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  List<Content>? content;
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

  CustomerModel({
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

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
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

class Content {
  User? user;
  int? totalRentalBookings;
  int? totalPackageBookings;
  int? totalInquiries;
  int? totalBids;
  int? lastBookingDate;

  Content({
    this.user,
    this.totalRentalBookings,
    this.totalPackageBookings,
    this.totalInquiries,
    this.totalBids,
    this.lastBookingDate,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        totalRentalBookings: json["totalRentalBookings"],
        totalPackageBookings: json["totalPackageBookings"],
        totalInquiries: json["totalInquiries"],
        totalBids: json["totalBids"],
        lastBookingDate: json["lastBookingDate"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "totalRentalBookings": totalRentalBookings,
        "totalPackageBookings": totalPackageBookings,
        "totalInquiries": totalInquiries,
        "totalBids": totalBids,
        "lastBookingDate": lastBookingDate,
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
  String? rideOtp;
  DateTime? rideOtpExpiry;
  bool? isRideOtpVerified;
  bool? accountVerified;

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

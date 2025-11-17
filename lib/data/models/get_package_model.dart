// To parse this JSON data, do
//
//     final packageListModel = packageListModelFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

GetPackageModel getpackageModelFromJson(String str) =>
    GetPackageModel.fromJson(json.decode(str));

String getpackageModelToJson(GetPackageModel data) =>
    json.encode(data.toJson());

class GetPackageModel {
  Status? status;
  Data? data;

  GetPackageModel({
    this.status,
    this.data,
  });

  factory GetPackageModel.fromJson(Map<String, dynamic> json) =>
      GetPackageModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<PackageListContent>? content;
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
            : List<PackageListContent>.from(
                json["content"]!.map((x) => PackageListContent.fromJson(x))),
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

class PackageListContent {
  int? packageBookingId;
  String? bookingDate;
  String? endDate;
  String? bookingStatus;
  String? cancellationReason;
  DateTime? createdDate;
  DateTime? modifiedDate;
  User? user;
  Pkg? pkg;
  int? numberOfMembers;
  List<MemberList>? memberList;
  List<AssignedVehicleOnPackageBooking>? assignedVehicleOnPackageBooking;
  List<AssignedDriverOnPackageBooking>? assignedDriverOnPackageBooking;
  PickupLocation? pickupLocation;
  String? cancelledBy;
  String? paymentStatus;
  int? transactionId;
  String? paymentId;
  String? mobile;
  String? countryCode;
  String? alternateMobile;
  String? alternateMobileCountryCode;
  String? offerCode;
  double? packagePrice;
  double? taxAmount;
  double? taxPercentage;
  double? discountAmount;
  double? totalPayableAmount;

  PackageListContent({
    this.packageBookingId,
    this.bookingDate,
    this.endDate,
    this.bookingStatus,
    this.cancellationReason,
    this.createdDate,
    this.modifiedDate,
    this.user,
    this.pkg,
    this.numberOfMembers,
    this.memberList,
    this.assignedVehicleOnPackageBooking,
    this.assignedDriverOnPackageBooking,
    this.pickupLocation,
    this.cancelledBy,
    this.paymentStatus,
    this.transactionId,
    this.paymentId,
    this.mobile,
    this.countryCode,
    this.alternateMobile,
    this.alternateMobileCountryCode,
    this.offerCode,
    this.packagePrice,
    this.taxAmount,
    this.taxPercentage,
    this.discountAmount,
    this.totalPayableAmount,
  });

  factory PackageListContent.fromJson(Map<String, dynamic> json) =>
      PackageListContent(
        packageBookingId: json["packageBookingId"],
        bookingDate: json["bookingDate"],
        endDate: json["endDate"],
        bookingStatus: json["bookingStatus"],
        cancellationReason: json["cancellationReason"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        pkg: json["pkg"] == null ? null : Pkg.fromJson(json["pkg"]),
        numberOfMembers: json["numberOfMembers"],
        memberList: json["memberList"] == null
            ? []
            : List<MemberList>.from(
                json["memberList"]!.map((x) => MemberList.fromJson(x))),
        assignedVehicleOnPackageBooking:
            json["assignedVehicleOnPackageBooking"] == null
                ? []
                : List<AssignedVehicleOnPackageBooking>.from(
                    json["assignedVehicleOnPackageBooking"]!.map(
                        (x) => AssignedVehicleOnPackageBooking.fromJson(x))),
        assignedDriverOnPackageBooking:
            json["assignedDriverOnPackageBooking"] == null
                ? []
                : List<AssignedDriverOnPackageBooking>.from(
                    json["assignedDriverOnPackageBooking"]!.map(
                        (x) => AssignedDriverOnPackageBooking.fromJson(x))),
        pickupLocation: json["pickupLocation"] == null
            ? null
            : PickupLocation.fromJson(json["pickupLocation"]),
        cancelledBy: json["cancelledBy"],
        paymentStatus: json["paymentStatus"],
        transactionId: json["transactionId"],
        paymentId: json["paymentId"],
        mobile: json["mobile"],
        countryCode: json["countryCode"],
        alternateMobile: json["alternateMobile"],
        alternateMobileCountryCode: json["alternateMobileCountryCode"],
        offerCode: json["offerCode"],
        packagePrice: json["packagePrice"]?.toDouble(),
        taxAmount: json["taxAmount"]?.toDouble(),
        taxPercentage: json["taxPercentage"],
        discountAmount: json["discountAmount"],
        totalPayableAmount: json["totalPayableAmount"],
      );

  Map<String, dynamic> toJson() => {
        "packageBookingId": packageBookingId,
        "bookingDate": bookingDate,
        "endDate": endDate,
        "bookingStatus": bookingStatus,
        "cancellationReason": cancellationReason,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "user": user?.toJson(),
        "pkg": pkg?.toJson(),
        "numberOfMembers": numberOfMembers,
        "memberList": memberList == null
            ? []
            : List<dynamic>.from(memberList!.map((x) => x.toJson())),
        "assignedVehicleOnPackageBooking":
            assignedVehicleOnPackageBooking == null
                ? []
                : List<dynamic>.from(
                    assignedVehicleOnPackageBooking!.map((x) => x.toJson())),
        "assignedDriverOnPackageBooking": assignedDriverOnPackageBooking == null
            ? []
            : List<dynamic>.from(
                assignedDriverOnPackageBooking!.map((x) => x.toJson())),
        "pickupLocation": pickupLocation?.toJson(),
        "cancelledBy": cancelledBy,
        "paymentStatus": paymentStatus,
        "transactionId": transactionId,
        "paymentId": paymentId,
        "mobile": mobile,
        "countryCode": countryCode,
        "alternateMobile": alternateMobile,
        "alternateMobileCountryCode": alternateMobileCountryCode,
        "offerCode": offerCode,
        "packagePrice": packagePrice,
        "taxAmount": taxAmount,
        "taxPercentage": taxPercentage,
        "discountAmount": discountAmount,
        "totalPayableAmount": totalPayableAmount,
      };
}

class AssignedDriverOnPackageBooking {
  int? driverAssignedId;
  String? date;
  Driver? driver;
  bool? isCancelled;

  AssignedDriverOnPackageBooking({
    this.driverAssignedId,
    this.date,
    this.driver,
    this.isCancelled,
  });

  factory AssignedDriverOnPackageBooking.fromJson(Map<String, dynamic> json) =>
      AssignedDriverOnPackageBooking(
        driverAssignedId: json["driverAssignedId"],
        date: json["date"],
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
        isCancelled: json["isCancelled"],
      );

  Map<String, dynamic> toJson() => {
        "driverAssignedId": driverAssignedId,
        "date": date,
        "driver": driver?.toJson(),
        "isCancelled": isCancelled,
      };
}

class Driver {
  int? driverId;
  String? firstName;
  String? lastName;
  String? driverAddress;
  String? emiratesId;
  String? mobile;
  String? countryCode;
  String? email;
  String? gender;
  String? licenceNumber;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? profileImageUrl;
  String? userType;
  int? vendorId;
  String? driverStatus;
  dynamic notificationToken;
  dynamic lastLogin;
  String? state;
  String? country;

  Driver({
    this.driverId,
    this.firstName,
    this.lastName,
    this.driverAddress,
    this.emiratesId,
    this.mobile,
    this.countryCode,
    this.email,
    this.gender,
    this.licenceNumber,
    this.createdDate,
    this.modifiedDate,
    this.profileImageUrl,
    this.userType,
    this.vendorId,
    this.driverStatus,
    this.notificationToken,
    this.lastLogin,
    this.state,
    this.country,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json["driverId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        driverAddress: json["driverAddress"],
        emiratesId: json["emiratesId"],
        mobile: json["mobile"],
        countryCode: json["countryCode"],
        email: json["email"],
        gender: json["gender"],
        licenceNumber: json["licenceNumber"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        profileImageUrl: json["profileImageUrl"],
        userType: json["userType"],
        vendorId: json["vendorId"],
        driverStatus: json["driverStatus"],
        notificationToken: json["notificationToken"],
        lastLogin: json["lastLogin"],
        state: json["state"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
        "firstName": firstName,
        "lastName": lastName,
        "driverAddress": driverAddress,
        "emiratesId": emiratesId,
        "mobile": mobile,
        "countryCode": countryCode,
        "email": email,
        "gender": gender,
        "licenceNumber": licenceNumber,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "profileImageUrl": profileImageUrl,
        "userType": userType,
        "vendorId": vendorId,
        "driverStatus": driverStatus,
        "notificationToken": notificationToken,
        "lastLogin": lastLogin,
        "state": state,
        "country": country,
      };
}

class AssignedVehicleOnPackageBooking {
  int? assignedId;
  String? date;
  Vehicle? vehicle;
  bool? isCancelled;

  AssignedVehicleOnPackageBooking({
    this.assignedId,
    this.date,
    this.vehicle,
    this.isCancelled,
  });

  factory AssignedVehicleOnPackageBooking.fromJson(Map<String, dynamic> json) =>
      AssignedVehicleOnPackageBooking(
        assignedId: json["assignedId"],
        date: json["date"],
        vehicle:
            json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        isCancelled: json["isCancelled"],
      );

  Map<String, dynamic> toJson() => {
        "assignedId": assignedId,
        "date": date,
        "vehicle": vehicle?.toJson(),
        "isCancelled": isCancelled,
      };
}

class Vehicle {
  int? vehicleId;
  String? carName;
  int? year;
  String? carType;
  String? brandName;
  String? fuelType;
  int? seats;
  String? color;
  String? vehicleNumber;
  String? modelNo;
  DateTime? createdDate;
  DateTime? modifiedDate;
  List<String>? images;
  String? vehicleStatus;
  String? vehicleDocUrl;

  Vehicle({
    this.vehicleId,
    this.carName,
    this.year,
    this.carType,
    this.brandName,
    this.fuelType,
    this.seats,
    this.color,
    this.vehicleNumber,
    this.modelNo,
    this.createdDate,
    this.modifiedDate,
    this.images,
    this.vehicleStatus,
    this.vehicleDocUrl,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleId: json["vehicleId"],
        carName: json["carName"],
        year: json["year"],
        carType: json["carType"],
        brandName: json["brandName"],
        fuelType: json["fuelType"],
        seats: json["seats"],
        color: json["color"],
        vehicleNumber: json["vehicleNumber"],
        modelNo: json["modelNo"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        vehicleStatus: json["vehicleStatus"],
        vehicleDocUrl: json["vehicleDocUrl"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "carName": carName,
        "year": year,
        "carType": carType,
        "brandName": brandName,
        "fuelType": fuelType,
        "seats": seats,
        "color": color,
        "vehicleNumber": vehicleNumber,
        "modelNo": modelNo,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "vehicleStatus": vehicleStatus,
        "vehicleDocUrl": vehicleDocUrl,
      };
}

class MemberList {
  int? memberId;
  String? name;
  int? age;
  String? gender;
  String? ageUnit;

  MemberList({
    this.memberId,
    this.name,
    this.age,
    this.gender,
    this.ageUnit,
  });

  factory MemberList.fromJson(Map<String, dynamic> json) => MemberList(
        memberId: json["memberId"],
        name: json["name"],
        age: json["age"],
        gender: json["gender"],
        ageUnit: json["ageUnit"],
      );

  Map<String, dynamic> toJson() => {
        "memberId": memberId,
        "name": name,
        "age": age,
        "gender": gender,
        "ageUnit": ageUnit,
      };
}

class PickupLocation {
  String? the03092025;
  String? the04092025;
  String? the23082025;
  String? the24082025;
  String? the22082025;

  PickupLocation({
    this.the03092025,
    this.the04092025,
    this.the23082025,
    this.the24082025,
    this.the22082025,
  });

  factory PickupLocation.fromJson(Map<String, dynamic> json) => PickupLocation(
        the03092025: json["03-09-2025"],
        the04092025: json["04-09-2025"],
        the23082025: json["23-08-2025"],
        the24082025: json["24-08-2025"],
        the22082025: json["22-08-2025"],
      );

  Map<String, dynamic> toJson() => {
        "03-09-2025": the03092025,
        "04-09-2025": the04092025,
        "23-08-2025": the23082025,
        "24-08-2025": the24082025,
        "22-08-2025": the22082025,
      };
}

class Pkg {
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
  User? vendor;

  Pkg({
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

  factory Pkg.fromJson(Map<String, dynamic> json) => Pkg(
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
        vendor: json["vendor"] == null ? null : User.fromJson(json["vendor"]),
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
  int? day;
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
  List<ParticipantType>? participantType;
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
            : List<ParticipantType>.from(json["participantType"]!
                .map((x) => participantTypeValues.map[x]!)),
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
            : List<dynamic>.from(
                participantType!.map((x) => participantTypeValues.reverse[x])),
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
  double? infant;
  double? child;
  double? senior;

  AgeGroupDiscountPercent({
    this.infant,
    this.child,
    this.senior,
  });

  factory AgeGroupDiscountPercent.fromJson(Map<String, dynamic> json) =>
      AgeGroupDiscountPercent(
        infant: json["INFANT"],
        child: json["CHILD"],
        senior: json["SENIOR"],
      );

  Map<String, dynamic> toJson() => {
        "INFANT": infant,
        "CHILD": child,
        "SENIOR": senior,
      };
}

class User {
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
  int? userId;
  String? profileImageUrl;

  User({
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
    this.userId,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        userId: json["userId"],
        profileImageUrl: json["profileImageUrl"],
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
        "userId": userId,
        "profileImageUrl": profileImageUrl,
      };
}

enum ParticipantType { ADULT, CHILD, INFANT, SENIOR, TEEN }

final participantTypeValues = EnumValues({
  "ADULT": ParticipantType.ADULT,
  "CHILD": ParticipantType.CHILD,
  "INFANT": ParticipantType.INFANT,
  "SENIOR": ParticipantType.SENIOR,
  "TEEN": ParticipantType.TEEN
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

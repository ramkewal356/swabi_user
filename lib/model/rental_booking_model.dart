import 'dart:convert';


class RentalCarListStatusModel {
  Status status;
  RentalCarListStatusData data;

  RentalCarListStatusModel({
    required this.status,
    required this.data,
  });

  factory RentalCarListStatusModel.fromJson(Map<String, dynamic> json) =>
      RentalCarListStatusModel(
        status: Status.fromJson(json["status"]),
        data: RentalCarListStatusData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class RentalCarListStatusData {
  RentalCarListStatusHeaders headers;
  List<Body> body;
  String errorMessage;
  String statusCode;
  String statusCodeValue;

  RentalCarListStatusData({
    required this.headers,
    required this.body,
    this.errorMessage = '',
    required this.statusCode,
    required this.statusCodeValue,
  });

  factory RentalCarListStatusData.fromJson(Map<String, dynamic> json) =>
      RentalCarListStatusData(
        headers: RentalCarListStatusHeaders.fromJson(json["headers"]),
        body: json["body"].runtimeType == List
            ? List<Body>.from(json["body"].map((x) => Body.fromJson(x)))
            : [],
        errorMessage: json["body"].runtimeType == String ? json["body"] : '',
        statusCode: json["statusCode"] ?? "",
        statusCodeValue: json["statusCodeValue"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
        "statusCode": statusCode,
        "statusCodeValue": statusCodeValue,
      };
}

class Body {
  String date;
  String pickupTime;
  String hours;
  String carType;
  String carImage;
  String totalPrice;
  String price;
  String latitude;
  String kilometers;
  String pickUpLocation;
  String seats;
  String longitude;

  Body({
    required this.date,
    required this.pickupTime,
    required this.hours,
    required this.carType,
    required this.totalPrice,
    required this.price,
    required this.carImage,
    required this.latitude,
    required this.kilometers,
    required this.pickUpLocation,
    required this.seats,
    required this.longitude,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        date: json["date"] ?? "",
        pickupTime: json["pickupTime"],
        hours: json["hours"].toString(),
        carType: json["carType"] ?? "",
        carImage: json["carImage"] ?? "",
        totalPrice: json["totalPrice"].toString(),
        price: json["price"].toString(),
        latitude: json["latitude"] ?? "",
        kilometers: json["kilometers"].toString(),
        pickUpLocation: json["pickUpLocation"] ?? "",
        seats: json["seats"].toString(),
        longitude: json["longitude"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "pickupTime": pickupTime,
        "hours": hours,
        "carType": carType,
        "carImage": carImage,
        "totalPrice": totalPrice,
        "price": price,
        "latitude": latitude,
        "kilometers": kilometers,
        "pickUpLocation": pickUpLocation,
        "seats": seats,
        "longitude": longitude,
      };
}

class RentalCarListStatusHeaders {
  RentalCarListStatusHeaders();

  factory RentalCarListStatusHeaders.fromJson(Map<String, dynamic> json) =>
      RentalCarListStatusHeaders();

  Map<String, dynamic> toJson() => {};
}

class Status {
  String httpCode;
  String success;
  String message;

  Status({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        httpCode: json["httpCode"] ?? "",
        success: json["success"].toString(),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Rental Car Booking Show Model
class RentalCarBookingModel {
  Status status;
  Data data;

  RentalCarBookingModel({
    required this.status,
    required this.data,
  });

  factory RentalCarBookingModel.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingModel(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String rentalBookingId;
  String date;
  String pickupTime;
  String locationLongitude;
  String locationLatitude;
  String bookingStatus;
  String totalRentTime;
  String kilometers;
  String paidStatus;
  String rentalCharge;
  String carType;
  String extraMinutes;
  String extraKilometers;
  String createdDate;
  String modifiedDate;
  String pickUpLocation;
  String cancellationReason;
  String rideStartTime;
  String rideEndTime;
  String bookerId;
  String bookingForId;
  String userId;

  Data({
    required this.id,
    required this.rentalBookingId,
    required this.date,
    required this.pickupTime,
    required this.locationLongitude,
    required this.locationLatitude,
    required this.bookingStatus,
    required this.totalRentTime,
    required this.kilometers,
    required this.paidStatus,
    required this.rentalCharge,
    required this.carType,
    required this.extraMinutes,
    required this.extraKilometers,
    required this.createdDate,
    required this.modifiedDate,
    required this.pickUpLocation,
    required this.cancellationReason,
    required this.rideStartTime,
    required this.rideEndTime,
    required this.bookerId,
    required this.bookingForId,
    required this.userId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"].toString(),
        rentalBookingId: json["rentalBookingId"] ?? "",
        date: json["date"] ?? "",
        pickupTime: json["pickupTime"] ?? "",
        locationLongitude: json["locationLongitude"].toString(),
        locationLatitude: json["locationLatitude"].toString(),
        bookingStatus: json["bookingStatus"] ?? "",
        totalRentTime: json["totalRentTime"].toString(),
        kilometers: json["kilometers"].toString(),
        paidStatus: json["paidStatus"].toString(),
        rentalCharge: json["rentalCharge"].toString(),
        carType: json["carType"] ?? "",
        extraMinutes: json["extraMinutes"].toString(),
        extraKilometers: json["extraKilometers"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        pickUpLocation: json["pickUpLocation"] ?? "",
        cancellationReason: json["cancellationReason"] ?? "",
        rideStartTime: json["rideStartTime"] ?? "",
        rideEndTime: json["rideEndTime"] ?? "",
        bookerId: json["bookerId"].toString(),
        bookingForId: json["bookingForId"].toString(),
        userId: json["userId"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rentalBookingId": rentalBookingId,
        "date": date,
        "pickupTime": pickupTime,
        "locationLongitude": locationLongitude,
        "locationLatitude": locationLatitude,
        "bookingStatus": bookingStatus,
        "totalRentTime": totalRentTime,
        "kilometers": kilometers,
        "paidStatus": paidStatus,
        "rentalCharge": rentalCharge,
        "carType": carType,
        "extraMinutes": extraMinutes,
        "extraKilometers": extraKilometers,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "pickUpLocation": pickUpLocation,
        "cancellationReason": cancellationReason,
        "rideStartTime": rideStartTime,
        "rideEndTime": rideEndTime,
        "bookerId": bookerId,
        "bookingForId": bookingForId,
        "userId": userId,
      };
}

class RentalCarBookingStatus {
  String httpCode;
  String success;
  String message;

  RentalCarBookingStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory RentalCarBookingStatus.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingStatus(
        httpCode: json["httpCode"] ?? "",
        success: json["success"].toString(),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

///Get Rental Range List {Hour & Kilometer}
class GetRentalRangeListModel {
  GetRentalRangeListStatus status;
  List<GetRentalRangeListDatum> data;

  GetRentalRangeListModel({
    required this.status,
    required this.data,
  });

  factory GetRentalRangeListModel.fromJson(Map<String, dynamic> json) =>
      GetRentalRangeListModel(
        status: GetRentalRangeListStatus.fromJson(json["status"]),
        data: List<GetRentalRangeListDatum>.from(
            json["data"].map((x) => GetRentalRangeListDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetRentalRangeListDatum {
  int rentalMetricId;
  int kilometer;
  int hours;
  bool status;
  DateTime createdDate;
  DateTime modifiedDate;

  GetRentalRangeListDatum({
    required this.rentalMetricId,
    required this.kilometer,
    required this.hours,
    required this.status,
    required this.createdDate,
    required this.modifiedDate,
  });

  factory GetRentalRangeListDatum.fromJson(Map<String, dynamic> json) =>
      GetRentalRangeListDatum(
        rentalMetricId: json["rentalMetricId"],
        kilometer: json["kilometer"],
        hours: json["hours"],
        status: json["status"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "rentalMetricId": rentalMetricId,
        "kilometer": kilometer,
        "hours": hours,
        "status": status,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
      };
}

class GetRentalRangeListStatus {
  String httpCode;
  bool success;
  String message;

  GetRentalRangeListStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory GetRentalRangeListStatus.fromJson(Map<String, dynamic> json) =>
      GetRentalRangeListStatus(
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

///Rental Booking Cancel Model
class RentalCarBookingCancelModel {
  Status status;
  RentalCancelData data;

  RentalCarBookingCancelModel({
    required this.status,
    required this.data,
  });

  factory RentalCarBookingCancelModel.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingCancelModel(
        status: Status.fromJson(json["status"]),
        data: RentalCancelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class RentalCancelData {
  String headers;
  String body;
  String statusCode;
  String statusCodeValue;

  RentalCancelData({
    required this.headers,
    required this.body,
    required this.statusCode,
    required this.statusCodeValue,
  });

  factory RentalCancelData.fromJson(Map<String, dynamic> json) =>
      RentalCancelData(
        headers: json["headers"].toString() ?? '',
        body: json["body"] ?? '',
        statusCode: json["statusCode"] ?? '',
        statusCodeValue: json["statusCodeValue"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "headers": headers,
        "body": body,
        "statusCode": statusCode,
        "statusCodeValue": statusCodeValue,
      };
}

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers();

  Map<String, dynamic> toJson() => {};
}

class RentalCancelStatus {
  String httpCode;
  bool success;
  String message;

  RentalCancelStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory RentalCancelStatus.fromJson(Map<String, dynamic> json) =>
      RentalCancelStatus(
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

/// RentalCarBookingList Model of Booked,Cancelled or UpComming
///=========================================================================================///
class RentalCarBookingListModel {
  Status status;
  RentalCarBookingListData data;

  RentalCarBookingListModel({
    required this.status,
    required this.data,
  });

  factory RentalCarBookingListModel.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingListModel(
        status: Status.fromJson(json["status"]),
        data: RentalCarBookingListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class RentalCarBookingListData {
  List<Content> content;
  Pageable pageable;
  int totalPages;
  int totalElements;
  bool last;
  int size;
  int number;
  Sort sort;
  int numberOfElements;
  bool first;
  bool empty;

  RentalCarBookingListData({
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory RentalCarBookingListData.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingListData(
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Content {
  String id;
  String rentalBookingId;
  String date;
  String pickupTime;
  String locationLongitude;
  String locationLatitude;
  String bookingStatus;
  String totalRentTime;
  String kilometers;
  String paidStatus;
  String userId;
  String rentalCharge;
  String carType;
  String extraMinutes;
  String extraKilometers;
  String createdDate;
  String modifiedDate;
  String rentalManagement;
  RentalDetialsSingleVehicle vehicle;
  String driver;
  String rideStartTime;
  String rideEndTime;
  String pickupLocation;
  String cancellationReason;
  String userDetails;
  String paymentId;
  String discountAmount;
  String taxAmount;
  String taxPercentage;
  String totalPayableAmount;

  Content(
      {required this.id,
      required this.rentalBookingId,
      required this.date,
      required this.pickupTime,
      required this.locationLongitude,
      required this.locationLatitude,
      required this.bookingStatus,
      required this.totalRentTime,
      required this.kilometers,
      required this.paidStatus,
      required this.userId,
      required this.rentalCharge,
      required this.carType,
      required this.extraMinutes,
      required this.extraKilometers,
      required this.createdDate,
      required this.modifiedDate,
      required this.rentalManagement,
      required this.vehicle,
      required this.driver,
      required this.rideStartTime,
      required this.rideEndTime,
      required this.pickupLocation,
      required this.cancellationReason,
      required this.userDetails,
      required this.paymentId,
      required this.discountAmount,
      required this.taxAmount,
      required this.taxPercentage,
      required this.totalPayableAmount});

  factory Content.fromJson(Map<String, dynamic> json) => Content(
      id: json["id"].toString(),
      rentalBookingId: json["rentalBookingId"].toString(),
      date: json["date"] ?? "",
      pickupTime: json["pickupTime"].toString() ?? '',
      locationLongitude: json["locationLongitude"].toString(),
      locationLatitude: json["locationLatitude"].toString(),
      bookingStatus: json["bookingStatus"] ?? '',
      totalRentTime: json["totalRentTime"].toString(),
      kilometers: json["kilometers"].toString(),
      paidStatus: json["paidStatus"].toString(),
      userId: json["userId"].toString(),
      rentalCharge: json["rentalCharge"].toString(),
      carType: json["carType"] ?? '',
      extraMinutes: json["extraMinutes"].toString(),
      extraKilometers: json["extraKilometers"] ?? '',
      createdDate: json["createdDate"].toString(),
      modifiedDate: json["modifiedDate"].toString(),
      rentalManagement: json["rentalManagement"].toString(),
      vehicle: RentalDetialsSingleVehicle.fromJson(json["vehicle"] ?? {}),
      driver: json["driver"].toString(),
      rideStartTime: json["rideStartTime"].toString(),
      rideEndTime: json["rideEndTime"].toString(),
      pickupLocation: json["pickupLocation"].toString(),
      cancellationReason: json["cancellationReason"].toString(),
      userDetails: json["userDetails"].toString(),
      paymentId: json["paymentId"]?.toString() ?? '',
      discountAmount: json["discountAmount"]?.toString() ?? '',
      taxAmount: json["taxAmount"]?.toString() ?? '',
      taxPercentage: json["taxPercentage"]?.toString() ?? '',
      totalPayableAmount: json["totalPayableAmount"]?.toString() ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "rentalBookingId": rentalBookingId,
        "date": date,
        "pickupTime": pickupTime,
        "locationLongitude": locationLongitude,
        "locationLatitude": locationLatitude,
        "bookingStatus": bookingStatusValues.reverse[bookingStatus],
        "totalRentTime": totalRentTime,
        "kilometers": kilometers,
        "paidStatus": paidStatus,
        "userId": userId,
        "rentalCharge": rentalCharge,
        "carType": carTypeValues.reverse[carType],
        "extraMinutes": extraMinutes,
        "extraKilometers": extraKilometers,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "rentalManagement": rentalManagement,
        "vehicle": vehicle?.toJson(),
        "driver": driver,
        "rideStartTime": rideStartTime,
        "rideEndTime": rideEndTime,
        "pickupLocation": pickupLocation,
        "cancellationReason": cancellationReason,
        "userDetails": userDetails,
        "paymentId": paymentId,
        "discountAmount": discountAmount,
        "taxAmount": taxAmount,
        "taxPercentage": taxPercentage,
        "totalPayableAmount": totalPayableAmount
      };
}

enum BookingStatus { BOOKED, ON_RUNNING, COMPLETED, CANCELLED }

final bookingStatusValues = EnumValues({
  "BOOKED": BookingStatus.BOOKED,
  "ON_RUNNING": BookingStatus.ON_RUNNING,
  "COMPLETED": BookingStatus.COMPLETED,
  "CANCELLED": BookingStatus.CANCELLED
});

enum CarType { FORD_FUSION, TOYOTA_CAMRY }

final carTypeValues = EnumValues(
    {"Ford Fusion": CarType.FORD_FUSION, "Toyota Camry": CarType.TOYOTA_CAMRY});

class Driver {
  int driverId;
  String firstName;
  String lastName;
  String driverAddress;
  String aadhaarNumber;
  String mobile;
  String email;
  String gender;
  String licenceNumber;
  DateTime createdDate;
  DateTime modifiedDate;
  bool status;
  dynamic profileImageUrl;
  bool bookingStatus;
  String userType;
  int vendorId;

  Driver({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.driverAddress,
    required this.aadhaarNumber,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.licenceNumber,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.profileImageUrl,
    required this.bookingStatus,
    required this.userType,
    required this.vendorId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json["driverId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        driverAddress: json["driverAddress"],
        aadhaarNumber: json["aadhaarNumber"],
        mobile: json["mobile"],
        email: json["email"],
        gender: json["gender"],
        licenceNumber: json["licenceNumber"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        status: json["status"],
        profileImageUrl: json["profileImageUrl"],
        bookingStatus: json["bookingStatus"],
        userType: json["userType"],
        vendorId: json["vendorId"],
      );

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
        "firstName": firstName,
        "lastName": lastName,
        "driverAddress": driverAddress,
        "aadhaarNumber": aadhaarNumber,
        "mobile": mobile,
        "email": email,
        "gender": gender,
        "licenceNumber": licenceNumber,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
        "status": status,
        "profileImageUrl": profileImageUrl,
        "bookingStatus": bookingStatus,
        "userType": userType,
        "vendorId": vendorId,
      };
}

class Vehicle {
  int vehicleId;
  CarType carType;
  String brandName;
  String fuelType;
  int seats;
  String color;
  String vehicleNumber;
  dynamic modelNo;
  DateTime createdDate;
  DateTime modifiedDate;
  bool status;
  bool bookingStatus;
  List<dynamic> images;
  String vehicleAvailability;

  Vehicle({
    required this.vehicleId,
    required this.carType,
    required this.brandName,
    required this.fuelType,
    required this.seats,
    required this.color,
    required this.vehicleNumber,
    required this.modelNo,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.bookingStatus,
    required this.images,
    required this.vehicleAvailability,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleId: json["vehicleId"],
        carType: carTypeValues.map[json["carType"]]!,
        brandName: json["brandName"],
        fuelType: json["fuelType"],
        seats: json["seats"],
        color: json["color"],
        vehicleNumber: json["vehicleNumber"],
        modelNo: json["modelNo"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        status: json["status"],
        bookingStatus: json["bookingStatus"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        vehicleAvailability: json["vehicleAvailability"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "carType": carTypeValues.reverse[carType],
        "brandName": brandName,
        "fuelType": fuelType,
        "seats": seats,
        "color": color,
        "vehicleNumber": vehicleNumber,
        "modelNo": modelNo,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
        "status": status,
        "bookingStatus": bookingStatus,
        "images": images,
        // "images": List<dynamic>.from(images.map((x) => x)),
        "vehicleAvailability": vehicleAvailability,
      };
}

class UserDetails {
  int userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  DateTime createdDate;
  DateTime modifiedDate;
  bool status;
  dynamic otp;
  dynamic isOtpVerified;
  String userType;
  String profileImageUrl;

  UserDetails({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    required this.profileImageUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        address: json["address"],
        email: json["email"],
        gender: json["gender"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        status: json["status"],
        otp: json["otp"],
        isOtpVerified: json["isOtpVerified"],
        userType: json["userType"],
        profileImageUrl: json["profileImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
      };
}

class Pageable {
  Sort sort;
  int pageNumber;
  int pageSize;
  int offset;
  bool paged;
  bool unpaged;

  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: Sort.fromJson(json["sort"]),
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        offset: json["offset"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort.toJson(),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "offset": offset,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool sorted;
  bool empty;
  bool unsorted;

  Sort({
    required this.sorted,
    required this.empty,
    required this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        sorted: json["sorted"],
        empty: json["empty"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "sorted": sorted,
        "empty": empty,
        "unsorted": unsorted,
      };
}

class RentalCarBookingListStatus {
  String httpCode;
  bool success;
  String message;

  RentalCarBookingListStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory RentalCarBookingListStatus.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingListStatus(
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

///Rental Details Single View Model
class RentalDetailsSingleModel {
  Status status;
  RentalDetailsSingleData data;

  RentalDetailsSingleModel({
    required this.status,
    required this.data,
  });

  factory RentalDetailsSingleModel.fromJson(Map<String, dynamic> json) =>
      RentalDetailsSingleModel(
        status: Status.fromJson(json["status"]),
        data: RentalDetailsSingleData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class RentalDetailsSingleData {
  String id;
  String rentalBookingId;
  String date;
  String pickupTime;
  String locationLongitude;
  String locationLatitude;
  String bookingStatus;
  String totalRentTime;
  String kilometers;
  String paidStatus;
  String userId;
  String rentalCharge;
  String carType;
  String extraMinutes;
  String extraKilometers;
  String createdDate;
  String modifiedDate;
  String rentalManagement;
  RentalDetialsSingleVehicle vehicle;
  RentalDetialsSingleDriver driver;
  String rideStartTime;
  String rideEndTime;
  String pickupLocation;
  String cancellationReason;
  String bookerId;
  String bookingForId;
  User user;
  Guest guest;
  String cancelledBy;
  String paymentId;
  String discountAmount;
  double taxAmount;
  String taxPercentage;
  String totalPayableAmount;

  RentalDetailsSingleData(
      {required this.id,
      required this.rentalBookingId,
      required this.date,
      required this.pickupTime,
      required this.locationLongitude,
      required this.locationLatitude,
      required this.bookingStatus,
      required this.totalRentTime,
      required this.kilometers,
      required this.paidStatus,
      required this.userId,
      required this.rentalCharge,
      required this.carType,
      required this.extraMinutes,
      required this.extraKilometers,
      required this.createdDate,
      required this.modifiedDate,
      required this.rentalManagement,
      required this.vehicle,
      required this.driver,
      required this.rideStartTime,
      required this.rideEndTime,
      required this.pickupLocation,
      required this.cancellationReason,
      required this.bookerId,
      required this.bookingForId,
      required this.user,
      required this.guest,
      required this.cancelledBy,
      required this.paymentId,
      required this.discountAmount,
      required this.taxAmount,
      required this.taxPercentage,
      required this.totalPayableAmount});

  factory RentalDetailsSingleData.fromJson(Map<String, dynamic> json) =>
      RentalDetailsSingleData(
          id: json["id"].toString(),
          rentalBookingId: json["rentalBookingId"] ?? "",
          date: json["date"] ?? "",
          pickupTime: json["pickupTime"] ?? "",
          locationLongitude: json["locationLongitude"].toString(),
          locationLatitude: json["locationLatitude"].toString(),
          bookingStatus: json["bookingStatus"] ?? "",
          totalRentTime: json["totalRentTime"].toString(),
          kilometers: json["kilometers"].toString(),
          paidStatus: json["paidStatus"].toString(),
          userId: json["userId"].toString(),
          rentalCharge: json["rentalCharge"].toString(),
          carType: json["carType"] ?? "",
          extraMinutes: json["extraMinutes"]?.toString() ?? '',
          extraKilometers: json["extraKilometers"]?.toString() ?? '',
          createdDate: json["createdDate"].toString(),
          modifiedDate: json["modifiedDate"].toString(),
          rentalManagement: json["rentalManagement"].toString(),
          vehicle: RentalDetialsSingleVehicle.fromJson(json["vehicle"] ?? {}),
          driver: RentalDetialsSingleDriver.fromJson(json["driver"] ?? {}),
          rideStartTime: json["rideStartTime"]?.toString() ?? '',
          rideEndTime: json["rideEndTime"].toString(),
          pickupLocation: json["pickupLocation"] ?? "",
          cancellationReason: json["cancellationReason"].toString(),
          bookerId: json["bookerId"].toString(),
          bookingForId: json["bookingForId"].toString(),
          user: User.fromJson(json["user"] ?? {}),
          guest: Guest.fromJson(json["guest"] ?? {}),
          cancelledBy: json["cancelledBy"].toString(),
          paymentId: json["paymentId"].toString(),
          discountAmount: json["discountAmount"]?.toString() ?? '',
          taxAmount: json["taxAmount"] ?? 0.0,
          taxPercentage: json["taxPercentage"]?.toString() ?? '',
          totalPayableAmount: json["totalPayableAmount"]?.toString() ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "rentalBookingId": rentalBookingId,
        "date": date,
        "pickupTime": pickupTime,
        "locationLongitude": locationLongitude,
        "locationLatitude": locationLatitude,
        "bookingStatus": bookingStatus,
        "totalRentTime": totalRentTime,
        "kilometers": kilometers,
        "paidStatus": paidStatus,
        "userId": userId,
        "rentalCharge": rentalCharge,
        "carType": carType,
        "extraMinutes": extraMinutes,
        "extraKilometers": extraKilometers,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "rentalManagement": rentalManagement,
        "vehicle": vehicle,
        "driver": driver,
        "rideStartTime": rideStartTime,
        "rideEndTime": rideEndTime,
        "pickupLocation": pickupLocation,
        "cancellationReason": cancellationReason,
        "bookerId": bookerId,
        "bookingForId": bookingForId,
        "user": user,
        "guest": guest,
        "cancelledBy": cancelledBy,
        "paymentId": paymentId,
        "discountAmount": discountAmount,
        "taxAmount": taxAmount,
        "taxPercentage": taxPercentage,
        "totalPayableAmount": totalPayableAmount
      };
}

class Guest {
  String? guestId;
  String? guestName;
  String? countryCode;
  String? guestMobile;
  String? gender;
  String? userId;
  String? status;
  String? createdDate;
  String? modifiedDate;

  Guest({
    this.guestId,
    this.guestName,
    this.countryCode,
    this.guestMobile,
    this.gender,
    this.userId,
    this.status,
    this.createdDate,
    this.modifiedDate,
  });

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        guestId: json["guestId"]?.toString() ?? "",
        guestName: json["guestName"]?.toString() ?? "",
        countryCode: json["countryCode"]?.toString() ?? '',
        guestMobile: json["guestMobile"]?.toString() ?? "",
        gender: json["gender"]?.toString() ?? "",
        userId: json["userId"]?.toString() ?? "",
        status: json["status"]?.toString() ?? "",
        createdDate: json["createdDate"]?.toString() ?? "",
        modifiedDate: json["modifiedDate"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "guestId": guestId,
        "guestName": guestName,
        "countryCode": countryCode,
        "guestMobile": guestMobile,
        "gender": gender,
        "userId": userId,
        "status": status,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
      };
}

class RentalDetialsSingleDriver {
  String? driverId;
  String? firstName;
  String? lastName;
  String? driverAddress;
  String? emiratesId;
  String? mobile;
  String? countryCode;
  String? email;
  String? gender;
  String? licenceNumber;
  String? createdDate;
  String? modifiedDate;
  String? profileImageUrl;
  String? userType;
  String? vendorId;
  // List<DriverUnavailableDate> unavailableDates;
  String? driverStatus;

  RentalDetialsSingleDriver({
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
    // required this.unavailableDates,
    this.driverStatus,
  });

  factory RentalDetialsSingleDriver.fromJson(Map<String, dynamic> json) =>
      RentalDetialsSingleDriver(
        driverId: json["driverId"]?.toString() ?? '',
        firstName: json["firstName"]?.toString() ?? '',
        lastName: json["lastName"]?.toString() ?? '',
        driverAddress: json["driverAddress"]?.toString() ?? '',
        emiratesId: json["emiratesId"]?.toString() ?? '',
        mobile: json["mobile"]?.toString() ?? '',
        countryCode: json["countryCode"]?.toString() ?? '',
        email: json["email"]?.toString() ?? '',
        gender: json["gender"]?.toString() ?? '',
        licenceNumber: json["licenceNumber"]?.toString() ?? '',
        createdDate: json["createdDate"]?.toString() ?? '',
        modifiedDate: json["modifiedDate"]?.toString() ?? '',
        profileImageUrl: json["profileImageUrl"]?.toString() ?? '',
        userType: json["userType"]?.toString() ?? '',
        vendorId: json["vendorId"]?.toString() ?? '',
        // unavailableDates: List<DriverUnavailableDate>.from(json["unavailableDates"].map((x) => DriverUnavailableDate.fromJson(x))),
        driverStatus: json["driverStatus"]?.toString() ?? '',
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
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "profileImageUrl": profileImageUrl,
        "userType": userType,
        "vendorId": vendorId,
        // "unavailableDates": List<dynamic>.from(unavailableDates.map((x) => x.toJson())),
        "driverStatus": driverStatus,
      };
}

class RentalDetialsSingleVehicle {
  String? vehicleId;
  String? carName;
  String? year;
  String? carType;
  String? brandName;
  String? fuelType;
  String? seats;
  String? color;
  String? vehicleNumber;
  String? modelNo;
  String? createdDate;
  String? modifiedDate;
  List<String> images;
  String? vehicleStatus;

  RentalDetialsSingleVehicle({
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
    this.images = const [],
    this.vehicleStatus,
  });

  factory RentalDetialsSingleVehicle.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RentalDetialsSingleVehicle();
    }
    return RentalDetialsSingleVehicle(
      vehicleId: json["vehicleId"]?.toString(),
      carName: json["carName"]?.toString(),
      year: json["year"]?.toString(),
      carType: json["carType"]?.toString(),
      brandName: json["brandName"]?.toString(),
      fuelType: json["fuelType"]?.toString(),
      seats: json["seats"]?.toString(),
      color: json["color"]?.toString(),
      vehicleNumber: json["vehicleNumber"]?.toString(),
      modelNo: json["modelNo"]?.toString(),
      createdDate: json["createdDate"]?.toString(),
      modifiedDate: json["modifiedDate"]?.toString(),
      images: (json["images"] as List<dynamic>?)
              ?.map((x) => x.toString())
              .toList() ??
          [],
      vehicleStatus: json["vehicleStatus"]?.toString(),
    );
  }

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
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "images": images,
        "vehicleStatus": vehicleStatus,
      };
}

class User {
  String userId;
  String firstName;
  String lastName;
  String mobile;
  String address;
  String email;
  String gender;
  String createdDate;
  String modifiedDate;
  String status;
  String otp;
  String isOtpVerified;
  String userType;
  String profileImageUrl;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.address,
    required this.email,
    required this.gender,
    required this.createdDate,
    required this.modifiedDate,
    required this.status,
    required this.otp,
    required this.isOtpVerified,
    required this.userType,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"].toString(),
        firstName: json["firstName"].toString(),
        lastName: json["lastName"].toString(),
        mobile: json["mobile"].toString(),
        address: json["address"].toString(),
        email: json["email"].toString(),
        gender: json["gender"].toString(),
        createdDate: json["createdDate"].toString(),
        modifiedDate: json["modifiedDate"].toString(),
        status: json["status"].toString(),
        otp: json["otp"].toString(),
        isOtpVerified: json["isOtpVerified"].toString(),
        userType: json["userType"].toString(),
        profileImageUrl: json["profileImageUrl"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "address": address,
        "email": email,
        "gender": gender,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "otp": otp,
        "isOtpVerified": isOtpVerified,
        "userType": userType,
        "profileImageUrl": profileImageUrl,
      };
}

class RentalDetialsSingleStatus {
  String httpCode;
  bool success;
  String message;

  RentalDetialsSingleStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory RentalDetialsSingleStatus.fromJson(Map<String, dynamic> json) =>
      RentalDetialsSingleStatus(
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
// class RentalDetialsSingleModel {
//   RentalDetialsSingleStatus status;
//   RentalDetialsSingleData data;
//
//   RentalDetialsSingleModel({
//     required this.status,
//     required this.data,
//   });
//
//   factory RentalDetialsSingleModel.fromJson(Map<String, dynamic> json) => RentalDetialsSingleModel(
//     status: RentalDetialsSingleStatus.fromJson(json["status"]),
//     data: RentalDetialsSingleData.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status.toJson(),
//     "data": data.toJson(),
//   };
// }
//
// class RentalDetialsSingleData {
//   String id;
//   String rentalBookingId;
//   String date;
//   String pickupTime;
//   String locationLongitude;
//   String locationLatitude;
//   String bookingStatus;
//   String totalRentTime;
//   String kilometers;
//   String paidStatus;
//   String userId;
//   String rentalCharge;
//   String carType;
//   String extraMinutes;
//   String extraKilometers;
//   String createdDate;
//   String modifiedDate;
//   String rentalManagement;
//   RentalDetialsSingleVehicle vehicle;
//   RentalDetialsSingleDriver driver;
//   String rideStartTime;
//   String rideEndTime;
//   String pickupLocation;
//   String cancellationReason;
//   String bookerId;
//   String bookingForId;
//   RentalDetialsSingleUser user;
//   RentalDetialsSingleGuest guest;
//
//   RentalDetialsSingleData({
//     required this.id,
//     required this.rentalBookingId,
//     required this.date,
//     required this.pickupTime,
//     required this.locationLongitude,
//     required this.locationLatitude,
//     required this.bookingStatus,
//     required this.totalRentTime,
//     required this.kilometers,
//     required this.paidStatus,
//     required this.userId,
//     required this.rentalCharge,
//     required this.carType,
//     required this.extraMinutes,
//     required this.extraKilometers,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.rentalManagement,
//     required this.vehicle,
//     required this.driver,
//     required this.rideStartTime,
//     required this.rideEndTime,
//     required this.pickupLocation,
//     required this.cancellationReason,
//     required this.bookerId,
//     required this.bookingForId,
//     required this.user,
//     required this.guest,
//   });
//
//   factory RentalDetialsSingleData.fromJson(Map<String, dynamic> json) => RentalDetialsSingleData(
//     id: json["id"].toString(),
//     rentalBookingId: json["rentalBookingId"] ?? "",
//     date: json["date"] ?? "",
//     pickupTime: json["pickupTime"] ?? "",
//     locationLongitude: json["locationLongitude"].toString(),
//     locationLatitude: json["locationLatitude"].toString(),
//     bookingStatus: json["bookingStatus"] ?? "",
//     totalRentTime: json["totalRentTime"].toString(),
//     kilometers: json["kilometers"].toString(),
//     paidStatus: json["paidStatus"].toString(),
//     userId: json["userId"] ?? "",
//     rentalCharge: json["rentalCharge"].toString(),
//     carType: json["carType"] ?? "",
//     extraMinutes: json["extraMinutes"].toString(),
//     extraKilometers: json["extraKilometers"] ?? "",
//     createdDate: json["createdDate"].toString(),
//     modifiedDate: json["modifiedDate"].toString(),
//     rentalManagement: json["rentalManagement"] ?? "",
//     vehicle: RentalDetialsSingleVehicle.fromJson(json["vehicle"]),
//     driver: RentalDetialsSingleDriver.fromJson(json["driver"]),
//     rideStartTime: json["rideStartTime"] ?? "",
//     rideEndTime: json["rideEndTime"] ?? "",
//     pickupLocation: json["pickupLocation"] ?? "",
//     cancellationReason: json["cancellationReason"] ?? "",
//     bookerId: json["bookerId"].toString(),
//     bookingForId: json["bookingForId"].toString(),
//     user: RentalDetialsSingleUser.fromJson(json["user"]),
//     guest: RentalDetialsSingleGuest.fromJson(json["guest"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "rentalBookingId": rentalBookingId,
//     "date": date,
//     "pickupTime": pickupTime,
//     "locationLongitude": locationLongitude,
//     "locationLatitude": locationLatitude,
//     "bookingStatus": bookingStatus,
//     "totalRentTime": totalRentTime,
//     "kilometers": kilometers,
//     "paidStatus": paidStatus,
//     "userId": userId,
//     "rentalCharge": rentalCharge,
//     "carType": carType,
//     "extraMinutes": extraMinutes,
//     "extraKilometers": extraKilometers,
//     "createdDate": createdDate,
//     "modifiedDate": modifiedDate,
//     "rentalManagement": rentalManagement,
//     "vehicle": vehicle.toJson(),
//     "driver": driver.toJson(),
//     "rideStartTime": rideStartTime,
//     "rideEndTime": rideEndTime,
//     "pickupLocation": pickupLocation,
//     "cancellationReason": cancellationReason,
//     "bookerId": bookerId,
//     "bookingForId": bookingForId,
//     "user": user.toJson(),
//     "guest": guest.toJson(),
//   };
// }
//
// class RentalDetialsSingleDriver {
//   String driverId;
//   String firstName;
//   String lastName;
//   String driverAddress;
//   String emiratesId;
//   String mobile;
//   String countryCode;
//   String email;
//   String gender;
//   String licenceNumber;
//   String createdDate;
//   String modifiedDate;
//   String profileImageUrl;
//   String userType;
//   String vendorId;
//   List<DriverUnavailableDate> unavailableDates;
//   String driverStatus;
//
//   RentalDetialsSingleDriver({
//     required this.driverId,
//     required this.firstName,
//     required this.lastName,
//     required this.driverAddress,
//     required this.emiratesId,
//     required this.mobile,
//     required this.countryCode,
//     required this.email,
//     required this.gender,
//     required this.licenceNumber,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.profileImageUrl,
//     required this.userType,
//     required this.vendorId,
//     required this.unavailableDates,
//     required this.driverStatus,
//   });
//
//   factory RentalDetialsSingleDriver.fromJson(Map<String, dynamic> json) => RentalDetialsSingleDriver(
//     driverId: json["driverId"].toString(),
//     firstName: json["firstName"] ?? "",
//     lastName: json["lastName"] ?? "",
//     driverAddress: json["driverAddress"] ?? "",
//     emiratesId: json["emiratesId"] ?? "",
//     mobile: json["mobile"] ?? "",
//     countryCode: json["countryCode"] ?? "",
//     email: json["email"] ?? "",
//     gender: json["gender"] ?? "",
//     licenceNumber: json["licenceNumber"] ?? "",
//     createdDate: json["createdDate"].toString(),
//     modifiedDate:json["modifiedDate"].toString(),
//     profileImageUrl: json["profileImageUrl"] ?? "",
//     userType: json["userType"] ?? "",
//     vendorId: json["vendorId"].toString(),
//     unavailableDates: List<DriverUnavailableDate>.from(json["unavailableDates"].map((x) => DriverUnavailableDate.fromJson(x))),
//     driverStatus: json["driverStatus"] ?? "",
//   );
//
//   Map<String, dynamic> toJson() => {
//     "driverId": driverId,
//     "firstName": firstName,
//     "lastName": lastName,
//     "driverAddress": driverAddress,
//     "emiratesId": emiratesId,
//     "mobile": mobile,
//     "countryCode": countryCode,
//     "email": email,
//     "gender": gender,
//     "licenceNumber": licenceNumber,
//     "createdDate": createdDate,
//     "modifiedDate": modifiedDate,
//     "profileImageUrl": profileImageUrl,
//     "userType": userType,
//     "vendorId": vendorId,
//     "unavailableDates": List<dynamic>.from(unavailableDates.map((x) => x.toJson())),
//     "driverStatus": driverStatus,
//   };
// }
//
// class DriverUnavailableDate {
//   String driverUnavailableId;
//   String date;
//   UnavailableReason driverUnavailableReason;
//   String createdDate;
//   String modifiedDate;
//   String isCancelled;
//
//   DriverUnavailableDate({
//     required this.driverUnavailableId,
//     required this.date,
//     required this.driverUnavailableReason,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.isCancelled,
//   });
//
//   factory DriverUnavailableDate.fromJson(Map<String, dynamic> json) => DriverUnavailableDate(
//     driverUnavailableId: json["driverUnavailableId"].toString(),
//     date: json["date"].toString(),
//     driverUnavailableReason: unavailableReasonValues.map[json["driverUnavailableReason"]]!,
//     createdDate: json["createdDate"].toString(),
//     modifiedDate: json["modifiedDate"].toString(),
//     isCancelled: json["isCancelled"].toString(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "driverUnavailableId": driverUnavailableId,
//     "date": date,
//     "driverUnavailableReason": unavailableReasonValues.reverse[driverUnavailableReason],
//     "createdDate": createdDate,
//     "modifiedDate": modifiedDate,
//     "isCancelled": isCancelled,
//   };
// }
//
// enum UnavailableReason {
//   LEAVE,
//   RESERVED
// }
//
// final unavailableReasonValues = EnumValues({
//   "LEAVE": UnavailableReason.LEAVE,
//   "RESERVED": UnavailableReason.RESERVED
// });
//
// class RentalDetialsSingleGuest {
//   String guestId;
//   String guestName;
//   String guestMobile;
//   String gender;
//   String userId;
//   String status;
//   String createdDate;
//   String modifiedDate;
//
//   RentalDetialsSingleGuest({
//     required this.guestId,
//     required this.guestName,
//     required this.guestMobile,
//     required this.gender,
//     required this.userId,
//     required this.status,
//     required this.createdDate,
//     required this.modifiedDate,
//   });
//
//   factory RentalDetialsSingleGuest.fromJson(Map<String, dynamic> json) => RentalDetialsSingleGuest(
//     guestId: json["guestId"].toString(),
//     guestName: json["guestName"] ?? "",
//     guestMobile: json["guestMobile"] ?? "",
//     gender: json["gender"] ?? "",
//     userId: json["userId"].toString(),
//     status: json["status"].toString(),
//     createdDate: json["createdDate"].toString(),
//     modifiedDate: json["modifiedDate"].toString(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "guestId": guestId,
//     "guestName": guestName,
//     "guestMobile": guestMobile,
//     "gender": gender,
//     "userId": userId,
//     "status": status,
//     "createdDate": createdDate,
//     "modifiedDate": modifiedDate,
//   };
// }
//
// class RentalDetialsSingleUser {
//   String userId;
//   String firstName;
//   String lastName;
//   String mobile;
//   String address;
//   String email;
//   String gender;
//   String createdDate;
//   String modifiedDate;
//   String status;
//   String otp;
//   String isOtpVerified;
//   String userType;
//   String profileImageUrl;
//
//   RentalDetialsSingleUser({
//     required this.userId,
//     required this.firstName,
//     required this.lastName,
//     required this.mobile,
//     required this.address,
//     required this.email,
//     required this.gender,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.status,
//     required this.otp,
//     required this.isOtpVerified,
//     required this.userType,
//     required this.profileImageUrl,
//   });
//
//   factory RentalDetialsSingleUser.fromJson(Map<String, dynamic> json) => RentalDetialsSingleUser(
//     userId: json["userId"].toString(),
//     firstName: json["firstName"] ?? "",
//     lastName: json["lastName"] ?? "",
//     mobile: json["mobile"] ?? "",
//     address: json["address"] ?? "",
//     email: json["email"] ?? "",
//     gender: json["gender"] ?? "",
//     createdDate: json["createdDate"].toString(),
//     modifiedDate: json["modifiedDate"].toString(),
//     status: json["status"].toString(),
//     otp: json["otp"] ?? "",
//     isOtpVerified: json["isOtpVerified"] ?? "",
//     userType: json["userType"] ?? "",
//     profileImageUrl: json["profileImageUrl"] ?? "",
//   );
//
//   Map<String, dynamic> toJson() => {
//     "userId": userId,
//     "firstName": firstName,
//     "lastName": lastName,
//     "mobile": mobile,
//     "address": address,
//     "email": email,
//     "gender": gender,
//     "createdDate": createdDate,
//     "modifiedDate": modifiedDate,
//     "status": status,
//     "otp": otp,
//     "isOtpVerified": isOtpVerified,
//     "userType": userType,
//     "profileImageUrl": profileImageUrl,
//   };
// }
//
// class RentalDetialsSingleVehicle {
//   String vehicleId;
//   String carName;
//   String year;
//   String carType;
//   String brandName;
//   String fuelType;
//   String seats;
//   String color;
//   String vehicleNumber;
//   String modelNo;
//   String createdDate;
//   String modifiedDate;
//   List<String> images;
//   String vehicleStatus;
//   List<VehicleUnavailableDate> unavailableDates;
//
//   RentalDetialsSingleVehicle({
//     required this.vehicleId,
//     required this.carName,
//     required this.year,
//     required this.carType,
//     required this.brandName,
//     required this.fuelType,
//     required this.seats,
//     required this.color,
//     required this.vehicleNumber,
//     required this.modelNo,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.images,
//     required this.vehicleStatus,
//     required this.unavailableDates,
//   });
//
//   factory RentalDetialsSingleVehicle.fromJson(Map<String, dynamic> json) => RentalDetialsSingleVehicle(
//     vehicleId: json["vehicleId"].toString(),
//     carName: json["carName"] ?? "",
//     year: json["year"].toString(),
//     carType: json["carType"] ?? "",
//     brandName: json["brandName"] ?? "",
//     fuelType: json["fuelType"] ?? "",
//     seats: json["seats"].toString(),
//     color: json["color"] ?? "",
//     vehicleNumber: json["vehicleNumber"] ?? "",
//     modelNo: json["modelNo"] ?? "",
//     createdDate: json["createdDate"].toString(),
//     modifiedDate: json["modifiedDate"].toString(),
//     images: List<String>.from(json["images"].map((x) => x)),
//     vehicleStatus: json["vehicleStatus"] ?? "",
//     unavailableDates: List<VehicleUnavailableDate>.from(json["unavailableDates"].map((x) => VehicleUnavailableDate.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "vehicleId": vehicleId,
//     "carName": carName,
//     "year": year,
//     "carType": carType,
//     "brandName": brandName,
//     "fuelType": fuelType,
//     "seats": seats,
//     "color": color,
//     "vehicleNumber": vehicleNumber,
//     "modelNo": modelNo,
//     "createdDate": createdDate,
//     "modifiedDate": modifiedDate,
//     "images": List<dynamic>.from(images.map((x) => x)),
//     "vehicleStatus": vehicleStatus,
//     "unavailableDates": List<dynamic>.from(unavailableDates.map((x) => x.toJson())),
//   };
// }

// class VehicleUnavailableDate {
//   String vehicleUnavailableId;
//   String date;
//   UnavailableReason vehicleUnavailableReason;
//   String createdDate;
//   String modifiedDate;
//   String isCancelled;
//
//   VehicleUnavailableDate({
//     required this.vehicleUnavailableId,
//     required this.date,
//     required this.vehicleUnavailableReason,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.isCancelled,
//   });
//
//   factory VehicleUnavailableDate.fromJson(Map<String, dynamic> json) => VehicleUnavailableDate(
//     vehicleUnavailableId: json["vehicleUnavailableId"].toString(),
//     date: json["date"].toString(),
//     vehicleUnavailableReason: unavailableReasonValues.map[json["vehicleUnavailableReason"]]!,
//     createdDate: json["createdDate"].toString(),
//     modifiedDate: json["modifiedDate"].toString(),
//     isCancelled: json["isCancelled"].toString(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "vehicleUnavailableId": vehicleUnavailableId,
//     "date": date,
//     "vehicleUnavailableReason": unavailableReasonValues.reverse[vehicleUnavailableReason],
//     "createdDate": createdDate,
//     "modifiedDate": modifiedDate,
//     "isCancelled": isCancelled,
//   };
// }
//
// class RentalDetialsSingleStatus {
//   String httpCode;
//   String success;
//   String message;
//
//   RentalDetialsSingleStatus({
//     required this.httpCode,
//     required this.success,
//     required this.message,
//   });
//
//   factory RentalDetialsSingleStatus.fromJson(Map<String, dynamic> json) => RentalDetialsSingleStatus(
//     httpCode: json["httpCode"] ?? "",
//     success: json["success"].toString(),
//     message: json["message"] ?? "",
//   );
//
//   Map<String, dynamic> toJson() => {
//     "httpCode": httpCode,
//     "success": success,
//     "message": message,
//   };
// }
//
// class RentalDetialsSingleEnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   RentalDetialsSingleEnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

///Rental Car Booking Validation Api Model
class RentalCarBookingValidationModel {
  Status status;
  RentalCarBookingValidationData data;

  RentalCarBookingValidationModel({
    required this.status,
    required this.data,
  });

  factory RentalCarBookingValidationModel.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingValidationModel(
        status: Status.fromJson(json["status"]),
        data: RentalCarBookingValidationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "data": data.toJson(),
      };
}

class RentalCarBookingValidationData {
  String headers;
  String body;
  String statusCode;
  String statusCodeValue;

  RentalCarBookingValidationData({
    required this.headers,
    required this.body,
    required this.statusCode,
    required this.statusCodeValue,
  });

  factory RentalCarBookingValidationData.fromJson(Map<String, dynamic> json) =>
      RentalCarBookingValidationData(
        headers: json["headers"].toString(),
        body: json["body"].toString(),
        statusCode: json["statusCode"] ?? "",
        statusCodeValue: json["statusCodeValue"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "headers": headers,
        "body": body,
        "statusCode": statusCode,
        "statusCodeValue": statusCodeValue,
      };
}

class RentalCarBookingValidationHeaders {
  RentalCarBookingValidationHeaders();

  factory RentalCarBookingValidationHeaders.fromJson(
          Map<String, dynamic> json) =>
      RentalCarBookingValidationHeaders();

  Map<String, dynamic> toJson() => {};
}

class RentalCarBookingValidationStatus {
  String httpCode;
  String success;
  String message;

  RentalCarBookingValidationStatus({
    required this.httpCode,
    required this.success,
    required this.message,
  });

  factory RentalCarBookingValidationStatus.fromJson(
          Map<String, dynamic> json) =>
      RentalCarBookingValidationStatus(
        httpCode: json["httpCode"] ?? "",
        success: json["success"].toString(),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}

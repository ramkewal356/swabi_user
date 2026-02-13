// To parse this JSON data, do
//
//     final getVehicleByIdModel = getVehicleByIdModelFromJson(jsonString);

import 'dart:convert';

GetVehicleByIdModel getVehicleByIdModelFromJson(String str) =>
    GetVehicleByIdModel.fromJson(json.decode(str));

String getVehicleByIdModelToJson(GetVehicleByIdModel data) =>
    json.encode(data.toJson());

class GetVehicleByIdModel {
  Status? status;
  Data? data;

  GetVehicleByIdModel({
    this.status,
    this.data,
  });

  factory GetVehicleByIdModel.fromJson(Map<String, dynamic> json) =>
      GetVehicleByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
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
  int? createdDate;
  int? modifiedDate;
  List<String>? images;
  String? vehicleStatus;
  List<UnavailableDate>? unavailableDates;
  String? vehicleDocUrl;
  VehicleOwnerInfo? vehicleOwnerInfo;
  VendorDetails? vendorDetails;

  Data({
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
    this.unavailableDates,
    this.vehicleDocUrl,
    this.vehicleOwnerInfo,
    this.vendorDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        vehicleStatus: json["vehicleStatus"],
        unavailableDates: json["unavailableDates"] == null
            ? []
            : List<UnavailableDate>.from(json["unavailableDates"]!
                .map((x) => UnavailableDate.fromJson(x))),
        vehicleDocUrl: json["vehicleDocUrl"],
        vehicleOwnerInfo: json["vehicleOwnerInfo"] == null
            ? null
            : VehicleOwnerInfo.fromJson(json["vehicleOwnerInfo"]),
        vendorDetails: json["vendorDetails"] == null
            ? null
            : VendorDetails.fromJson(json["vendorDetails"]),
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
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "vehicleStatus": vehicleStatus,
        "unavailableDates": unavailableDates == null
            ? []
            : List<dynamic>.from(unavailableDates!.map((x) => x.toJson())),
        "vehicleDocUrl": vehicleDocUrl,
        "vehicleOwnerInfo": vehicleOwnerInfo?.toJson(),
        "vendorDetails": vendorDetails?.toJson(),
      };
}

class UnavailableDate {
  int? vehicleUnavailableId;
  String? date;
  String? vehicleUnavailableReason;
  DateTime? createdDate;
  DateTime? modifiedDate;
  bool? isCancelled;
  String? unavailableStatus;

  UnavailableDate({
    this.vehicleUnavailableId,
    this.date,
    this.vehicleUnavailableReason,
    this.createdDate,
    this.modifiedDate,
    this.isCancelled,
    this.unavailableStatus,
  });

  factory UnavailableDate.fromJson(Map<String, dynamic> json) =>
      UnavailableDate(
        vehicleUnavailableId: json["vehicleUnavailableId"],
        // date: json["date"] == null ? null : DateTime.parse(json["date"]),
        date: json["date"],
        vehicleUnavailableReason: json["vehicleUnavailableReason"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        isCancelled: json["isCancelled"],
        unavailableStatus: json["unavailableStatus"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleUnavailableId": vehicleUnavailableId,
        // "date":
        //     "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "date": date,
        "vehicleUnavailableReason": vehicleUnavailableReason,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "isCancelled": isCancelled,
        "unavailableStatus": unavailableStatus,
      };
}

class VehicleOwnerInfo {
  int? vehicleOwnerId;
  String? firstName;
  String? lastName;
  String? address;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  String? mobile;
  String? email;
  bool? status;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? emiratesId;
  dynamic vehicleList;
  String? vehicleOwnerImageUrl;

  VehicleOwnerInfo({
    this.vehicleOwnerId,
    this.firstName,
    this.lastName,
    this.address,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    this.mobile,
    this.email,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.emiratesId,
    this.vehicleList,
    this.vehicleOwnerImageUrl,
  });

  factory VehicleOwnerInfo.fromJson(Map<String, dynamic> json) =>
      VehicleOwnerInfo(
        vehicleOwnerId: json["vehicleOwnerId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        countryCode: json["countryCode"],
        mobile: json["mobile"],
        email: json["email"],
        status: json["status"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        emiratesId: json["emiratesId"],
        vehicleList: json["vehicleList"],
        vehicleOwnerImageUrl: json["vehicleOwnerImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleOwnerId": vehicleOwnerId,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "countryCode": countryCode,
        "mobile": mobile,
        "email": email,
        "status": status,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "emiratesId": emiratesId,
        "vehicleList": vehicleList,
        "vehicleOwnerImageUrl": vehicleOwnerImageUrl,
      };
}

class VendorDetails {
  int? vendorId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? address;
  int? createdDate;
  int? modifiedDate;
  bool? status;
  String? userType;
  String? country;
  String? state;

  VendorDetails({
    this.vendorId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.createdDate,
    this.modifiedDate,
    this.status,
    this.userType,
    this.country,
    this.state,
  });

  factory VendorDetails.fromJson(Map<String, dynamic> json) => VendorDetails(
        vendorId: json["vendorId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        status: json["status"],
        userType: json["userType"],
        country: json["country"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "vendorId": vendorId,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "address": address,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
        "userType": userType,
        "country": country,
        "state": state,
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

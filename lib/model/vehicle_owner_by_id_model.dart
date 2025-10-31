// To parse this JSON data, do
//
//     final vehicleOwnerByIdModel = vehicleOwnerByIdModelFromJson(jsonString);

import 'dart:convert';

VehicleOwnerByIdModel vehicleOwnerByIdModelFromJson(String str) =>
    VehicleOwnerByIdModel.fromJson(json.decode(str));

String vehicleOwnerByIdModelToJson(VehicleOwnerByIdModel data) =>
    json.encode(data.toJson());

class VehicleOwnerByIdModel {
  Status? status;
  Data? data;

  VehicleOwnerByIdModel({
    this.status,
    this.data,
  });

  factory VehicleOwnerByIdModel.fromJson(Map<String, dynamic> json) =>
      VehicleOwnerByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
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
  List<VehicleList>? vehicleList;
  String? vehicleOwnerImageUrl;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        vehicleList: json["vehicleList"] == null
            ? []
            : List<VehicleList>.from(
                json["vehicleList"]!.map((x) => VehicleList.fromJson(x))),
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
        "vehicleList": vehicleList == null
            ? []
            : List<dynamic>.from(vehicleList!.map((x) => x.toJson())),
        "vehicleOwnerImageUrl": vehicleOwnerImageUrl,
      };
}

class VehicleList {
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

  VehicleList({
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

  factory VehicleList.fromJson(Map<String, dynamic> json) => VehicleList(
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

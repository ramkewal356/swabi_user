// To parse this JSON data, do
//
//     final vehicleOwnerModel = vehicleOwnerModelFromJson(jsonString);

import 'dart:convert';

VehicleOwnerModel vehicleOwnerModelFromJson(String str) =>
    VehicleOwnerModel.fromJson(json.decode(str));

String vehicleOwnerModelToJson(VehicleOwnerModel data) =>
    json.encode(data.toJson());

class VehicleOwnerModel {
  Status? status;
  Data? data;

  VehicleOwnerModel({
    this.status,
    this.data,
  });

  factory VehicleOwnerModel.fromJson(Map<String, dynamic> json) =>
      VehicleOwnerModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<OwnerContent>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
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
    this.totalPages,
    this.totalElements,
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
            : List<OwnerContent>.from(
                json["content"]!.map((x) => OwnerContent.fromJson(x))),
        pageable: (json["pageable"] is Map<String, dynamic>)
            ? Pageable.fromJson(json["pageable"])
            : null,
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
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
        "pageable": pageable,
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "number": number,
        "sort": sort?.toJson(),
        "size": size,
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class OwnerContent {
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

  OwnerContent({
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

  factory OwnerContent.fromJson(Map<String, dynamic> json) => OwnerContent(
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
  bool? unsorted;
  bool? sorted;

  Sort({
    this.empty,
    this.unsorted,
    this.sorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        unsorted: json["unsorted"],
        sorted: json["sorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "unsorted": unsorted,
        "sorted": sorted,
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

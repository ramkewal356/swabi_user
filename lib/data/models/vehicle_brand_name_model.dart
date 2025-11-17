// To parse this JSON data, do
//
//     final vehicleBrandNameModel = vehicleBrandNameModelFromJson(jsonString);

import 'dart:convert';

VehicleBrandNameModel vehicleBrandNameModelFromJson(String str) =>
    VehicleBrandNameModel.fromJson(json.decode(str));

String vehicleBrandNameModelToJson(VehicleBrandNameModel data) =>
    json.encode(data.toJson());

class VehicleBrandNameModel {
  Status? status;
  Data? data;

  VehicleBrandNameModel({
    this.status,
    this.data,
  });

  factory VehicleBrandNameModel.fromJson(Map<String, dynamic> json) =>
      VehicleBrandNameModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  Collection? collection;
  List<Datum>? data;

  Data({
    this.collection,
    this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        collection: json["collection"] == null
            ? null
            : Collection.fromJson(json["collection"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "collection": collection?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Collection {
  String? url;
  int? count;
  int? pages;
  int? total;
  String? next;
  String? prev;
  String? first;
  String? last;

  Collection({
    this.url,
    this.count,
    this.pages,
    this.total,
    this.next,
    this.prev,
    this.first,
    this.last,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        url: json["url"],
        count: json["count"],
        pages: json["pages"],
        total: json["total"],
        next: json["next"],
        prev: json["prev"],
        first: json["first"],
        last: json["last"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "count": count,
        "pages": pages,
        "total": total,
        "next": next,
        "prev": prev,
        "first": first,
        "last": last,
      };
}

class Datum {
  int? id;
  String? name;

  Datum({
    this.id,
    this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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

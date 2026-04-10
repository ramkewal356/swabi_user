// To parse this JSON data, do
//
//     final rentalPriceListModel = rentalPriceListModelFromJson(jsonString);

import 'dart:convert';

RentalPriceListModel rentalPriceListModelFromJson(String str) =>
    RentalPriceListModel.fromJson(json.decode(str));

String rentalPriceListModelToJson(RentalPriceListModel data) =>
    json.encode(data.toJson());

class RentalPriceListModel {
  Status? status;
  Data? data;

  RentalPriceListModel({
    this.status,
    this.data,
  });

  factory RentalPriceListModel.fromJson(Map<String, dynamic> json) =>
      RentalPriceListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<RentalPriceContent>? content;
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
            : List<RentalPriceContent>.from(
                json["content"]!.map((x) => RentalPriceContent.fromJson(x))),
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

class RentalPriceContent {
  int? id;
  int? perKilometerPrice;
  int? perHourPrice;
  String? carType;
  bool? status;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? currencyHour;
  String? currencyKm;

  RentalPriceContent({
    this.id,
    this.perKilometerPrice,
    this.perHourPrice,
    this.carType,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.currencyHour,
    this.currencyKm,
  });

  factory RentalPriceContent.fromJson(Map<String, dynamic> json) =>
      RentalPriceContent(
        id: json["id"],
        perKilometerPrice: json["perKilometerPrice"],
        perHourPrice: json["perHourPrice"],
        carType: json["carType"],
        status: json["status"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        currencyHour: json["currencyHour"],
        currencyKm: json["currencyKM"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "perKilometerPrice": perKilometerPrice,
        "perHourPrice": perHourPrice,
        "carType": carType,
        "status": status,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "currencyHour": currencyHour,
        "currencyKM": currencyKm,
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

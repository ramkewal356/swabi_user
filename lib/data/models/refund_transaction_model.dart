// To parse this JSON data, do
//
//     final refundTransactionModel = refundTransactionModelFromJson(jsonString);

import 'dart:convert';

RefundTransactionModel refundTransactionModelFromJson(String str) =>
    RefundTransactionModel.fromJson(json.decode(str));

String refundTransactionModelToJson(RefundTransactionModel data) =>
    json.encode(data.toJson());

class RefundTransactionModel {
  Status? status;
  Data? data;

  RefundTransactionModel({
    this.status,
    this.data,
  });

  factory RefundTransactionModel.fromJson(Map<String, dynamic> json) =>
      RefundTransactionModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
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
  int? id;
  String? refundId;
  String? paymentId;
  String? refundStatus;
  double? refundedAmount;
  int? createdAt;
  int? updatedAt;
  int? vendorId;
  String? bookingType;
  String? currency;

  Content({
    this.id,
    this.refundId,
    this.paymentId,
    this.refundStatus,
    this.refundedAmount,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
    this.bookingType,
    this.currency,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        refundId: json["refundId"],
        paymentId: json["paymentId"],
        refundStatus: json["refundStatus"],
        refundedAmount: json["refundedAmount"]?.toDouble(),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        vendorId: json["vendorId"],
        bookingType: json["bookingType"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refundId": refundId,
        "paymentId": paymentId,
        "refundStatus": refundStatus,
        "refundedAmount": refundedAmount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "vendorId": vendorId,
        "bookingType": bookingType,
        "currency": currency,
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

// To parse this JSON data, do
//
//     final getTransactionByIdModel = getTransactionByIdModelFromJson(jsonString);

import 'dart:convert';

GetTransactionByIdModel getTransactionByIdModelFromJson(String str) =>
    GetTransactionByIdModel.fromJson(json.decode(str));

String getTransactionByIdModelToJson(GetTransactionByIdModel data) =>
    json.encode(data.toJson());

class GetTransactionByIdModel {
  Status? status;
  Data? data;

  GetTransactionByIdModel({
    this.status,
    this.data,
  });

  factory GetTransactionByIdModel.fromJson(Map<String, dynamic> json) =>
      GetTransactionByIdModel(
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
  int? transactionId;
  String? paymentId;
  String? razorpayOrderId;
  String? razorpaySignature;
  int? orderId;
  String? bookingType;
  int? bookingId;
  int? createdDate;
  int? modifiedDate;
  String? transactionStatus;
  int? userId;
  double? amountPaid;

  Content({
    this.transactionId,
    this.paymentId,
    this.razorpayOrderId,
    this.razorpaySignature,
    this.orderId,
    this.bookingType,
    this.bookingId,
    this.createdDate,
    this.modifiedDate,
    this.transactionStatus,
    this.userId,
    this.amountPaid,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        transactionId: json["transactionId"],
        paymentId: json["paymentId"],
        razorpayOrderId: json["razorpayOrderId"],
        razorpaySignature: json["razorpaySignature"],
        orderId: json["orderId"],
        bookingType: json["bookingType"],
        bookingId: json["bookingId"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        transactionStatus: json["transactionStatus"],
        userId: json["userId"],
        amountPaid: json["amountPaid"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "paymentId": paymentId,
        "razorpayOrderId": razorpayOrderId,
        "razorpaySignature": razorpaySignature,
        "orderId": orderId,
        "bookingType": bookingType,
        "bookingId": bookingId,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "transactionStatus": transactionStatus,
        "userId": userId,
        "amountPaid": amountPaid,
      };
}

class Pageable {
  Sort? sort;
  int? pageNumber;
  int? pageSize;
  int? offset;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.pageNumber,
    this.pageSize,
    this.offset,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        offset: json["offset"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "offset": offset,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? sorted;
  bool? empty;
  bool? unsorted;

  Sort({
    this.sorted,
    this.empty,
    this.unsorted,
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

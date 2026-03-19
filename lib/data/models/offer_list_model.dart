// // To parse this JSON data, do
// //
// //     final offerListModel = offerListModelFromJson(jsonString);

// import 'dart:convert';

// OfferListModel offerListModelFromJson(String str) =>
//     OfferListModel.fromJson(json.decode(str));

// String offerListModelToJson(OfferListModel data) => json.encode(data.toJson());

// class OfferListModel {
//   Status? status;
//   List<Datum>? data;

//   OfferListModel({
//     this.status,
//     this.data,
//   });

//   factory OfferListModel.fromJson(Map<String, dynamic> json) => OfferListModel(
//         status: json["status"] == null ? null : Status.fromJson(json["status"]),
//         data: json["data"] == null
//             ? []
//             : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status?.toJson(),
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   int? offerId;
//   String? offerName;
//   String? description;
//   double? discountPercentage;
//   String? offerCode;
//   String? startDate;
//   String? endDate;
//   double? minimumBookingAmount;
//   double? maxDiscountAmount;
//   int? usageLimitPerUser;
//   String? termsAndConditions;
//   DateTime? createdDate;
//   DateTime? modifiedDate;
//   String? offerStatus;
//   String? offerType;
//   String? imageUrl;
//   String? minCurrency;
//   String? maxCurrency;
//   Datum(
//       {this.offerId,
//       this.offerName,
//       this.description,
//       this.discountPercentage,
//       this.offerCode,
//       this.startDate,
//       this.endDate,
//       this.minimumBookingAmount,
//       this.maxDiscountAmount,
//       this.usageLimitPerUser,
//       this.termsAndConditions,
//       this.createdDate,
//       this.modifiedDate,
//       this.offerStatus,
//       this.offerType,
//       this.imageUrl,
//       this.minCurrency,
//       this.maxCurrency});

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//       offerId: json["offerId"],
//       offerName: json["offerName"],
//       description: json["description"],
//       discountPercentage: json["discountPercentage"],
//       offerCode: json["offerCode"],
//       startDate: json["startDate"],
//       endDate: json["endDate"],
//       minimumBookingAmount: json["minimumBookingAmount"],
//       maxDiscountAmount: json["maxDiscountAmount"],
//       usageLimitPerUser: json["usageLimitPerUser"],
//       termsAndConditions: json["termsAndConditions"],
//       createdDate: json["createdDate"] == null
//           ? null
//           : DateTime.parse(json["createdDate"]),
//       modifiedDate: json["modifiedDate"] == null
//           ? null
//           : DateTime.parse(json["modifiedDate"]),
//       offerStatus: json["offerStatus"],
//       offerType: json["offerType"],
//       imageUrl: json["imageUrl"],
//       minCurrency: json["minCurrency"],
//       maxCurrency: json["maxCurrency"]
//       );

//   Map<String, dynamic> toJson() => {
//         "offerId": offerId,
//         "offerName": offerName,
//         "description": description,
//         "discountPercentage": discountPercentage,
//         "offerCode": offerCode,
//         "startDate": startDate,
//         "endDate": endDate,
//         "minimumBookingAmount": minimumBookingAmount,
//         "maxDiscountAmount": maxDiscountAmount,
//         "usageLimitPerUser": usageLimitPerUser,
//         "termsAndConditions": termsAndConditions,
//         "createdDate": createdDate?.toIso8601String(),
//         "modifiedDate": modifiedDate?.toIso8601String(),
//         "offerStatus": offerStatus,
//         "offerType": offerType,
//         "imageUrl": imageUrl,
//         "minCurrency": minCurrency,
//         "maxCurrency": maxCurrency
//       };
// }

// class Status {
//   String? httpCode;
//   bool? success;
//   String? message;

//   Status({
//     this.httpCode,
//     this.success,
//     this.message,
//   });

//   factory Status.fromJson(Map<String, dynamic> json) => Status(
//         httpCode: json["httpCode"],
//         success: json["success"],
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "httpCode": httpCode,
//         "success": success,
//         "message": message,
//       };
// }
// To parse this JSON data, do
//
//     final offerListModel = offerListModelFromJson(jsonString);

import 'dart:convert';

OfferListModel offerListModelFromJson(String str) =>
    OfferListModel.fromJson(json.decode(str));

String offerListModelToJson(OfferListModel data) => json.encode(data.toJson());

class OfferListModel {
  Status? status;
  Data? data;

  OfferListModel({
    this.status,
    this.data,
  });

  factory OfferListModel.fromJson(Map<String, dynamic> json) => OfferListModel(
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
  int? offerId;
  String? offerName;
  String? description;
  double? discountPercentage;
  String? offerCode;
  String? startDate;
  String? endDate;
  double? minimumBookingAmount;
  double? maxDiscountAmount;
  int? usageLimitPerUser;
  String? termsAndConditions;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? offerStatus;
  String? offerType;
  String? imageUrl;
  String? minCurrency;
  String? maxCurrency;

  Content({
    this.offerId,
    this.offerName,
    this.description,
    this.discountPercentage,
    this.offerCode,
    this.startDate,
    this.endDate,
    this.minimumBookingAmount,
    this.maxDiscountAmount,
    this.usageLimitPerUser,
    this.termsAndConditions,
    this.createdDate,
    this.modifiedDate,
    this.offerStatus,
    this.offerType,
    this.imageUrl,
    this.minCurrency,
    this.maxCurrency,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        offerId: json["offerId"],
        offerName: json["offerName"],
        description: json["description"],
        discountPercentage: json["discountPercentage"],
        offerCode: json["offerCode"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        minimumBookingAmount: json["minimumBookingAmount"],
        maxDiscountAmount: json["maxDiscountAmount"],
        usageLimitPerUser: json["usageLimitPerUser"],
        termsAndConditions: json["termsAndConditions"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        offerStatus: json["offerStatus"],
        offerType: json["offerType"],
        imageUrl: json["imageUrl"],
        minCurrency: json["minCurrency"],
        maxCurrency: json["maxCurrency"],
      );

  Map<String, dynamic> toJson() => {
        "offerId": offerId,
        "offerName": offerName,
        "description": description,
        "discountPercentage": discountPercentage,
        "offerCode": offerCode,
        "startDate": startDate,
        "endDate": endDate,
        "minimumBookingAmount": minimumBookingAmount,
        "maxDiscountAmount": maxDiscountAmount,
        "usageLimitPerUser": usageLimitPerUser,
        "termsAndConditions": termsAndConditions,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "offerStatus": offerStatus,
        "offerType": offerType,
        "imageUrl": imageUrl,
        "minCurrency": minCurrency,
        "maxCurrency": maxCurrency,
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

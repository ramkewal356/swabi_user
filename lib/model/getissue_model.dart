// To parse this JSON data, do
//
//     final getIssueModel = getIssueModelFromJson(jsonString);

import 'dart:convert';

GetIssueModel getIssueModelFromJson(String str) =>
    GetIssueModel.fromJson(json.decode(str));

String getIssueModelToJson(GetIssueModel data) => json.encode(data.toJson());

class GetIssueModel {
  Status? status;
  Data? data;

  GetIssueModel({
    this.status,
    this.data,
  });

  factory GetIssueModel.fromJson(Map<String, dynamic> json) => GetIssueModel(
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
  int? totalPages;
  int? totalElements;
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
    this.totalPages,
    this.totalElements,
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
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
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
        "totalPages": totalPages,
        "totalElements": totalElements,
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
  int? issueId;
  int? bookingId;
  String? bookingType;
  int? raisedById;
  String? raisedByRole;
  String? issueType;
  String? issueDescription;
  String? issueStatus;
  dynamic resolutionDescription;
  DateTime? createdDate;
  DateTime? modifiedDate;

  Content({
    this.issueId,
    this.bookingId,
    this.bookingType,
    this.raisedById,
    this.raisedByRole,
    this.issueType,
    this.issueDescription,
    this.issueStatus,
    this.resolutionDescription,
    this.createdDate,
    this.modifiedDate,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        issueId: json["issueId"],
        bookingId: json["bookingId"],
        bookingType: json["bookingType"],
        raisedById: json["raisedById"],
        raisedByRole: json["raisedByRole"],
        issueType: json["issueType"],
        issueDescription: json["issueDescription"],
        issueStatus: json["issueStatus"],
        resolutionDescription: json["resolutionDescription"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "issueId": issueId,
        "bookingId": bookingId,
        "bookingType": bookingType,
        "raisedById": raisedById,
        "raisedByRole": raisedByRole,
        "issueType": issueType,
        "issueDescription": issueDescription,
        "issueStatus": issueStatus,
        "resolutionDescription": resolutionDescription,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
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

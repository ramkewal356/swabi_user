import 'dart:convert';

GetAllNotificationModel getAllNotificationModelFromJson(String str) =>
    GetAllNotificationModel.fromJson(json.decode(str));

String getAllNotificationModelToJson(GetAllNotificationModel data) =>
    json.encode(data.toJson());

class GetAllNotificationModel {
  Status? status;
  Data? data;

  GetAllNotificationModel({
    this.status,
    this.data,
  });

  factory GetAllNotificationModel.fromJson(Map<String, dynamic> json) =>
      GetAllNotificationModel(
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
  int? notificationId;
  int? receiverId;
  String? receiverRole;
  String? title;
  String? message;
  int? createdDate;
  int? modifiedDate;
  String? readStatus;

  Content({
    this.notificationId,
    this.receiverId,
    this.receiverRole,
    this.title,
    this.message,
    this.createdDate,
    this.modifiedDate,
    this.readStatus,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        notificationId: json["notificationId"],
        receiverId: json["receiverId"],
        receiverRole: json["receiverRole"],
        title: json["title"],
        message: json["message"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        readStatus: json["readStatus"],
      );

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "receiverId": receiverId,
        "receiverRole": receiverRole,
        "title": title,
        "message": message,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "readStatus": readStatus,
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

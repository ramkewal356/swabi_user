import 'dart:convert';

GetLatestNotificationModel getLatestNotificationModelFromJson(String str) =>
    GetLatestNotificationModel.fromJson(json.decode(str));

String getLatestNotificationModelToJson(GetLatestNotificationModel data) =>
    json.encode(data.toJson());

class GetLatestNotificationModel {
  Status? status;
  List<Datum>? data;

  GetLatestNotificationModel({
    this.status,
    this.data,
  });

  factory GetLatestNotificationModel.fromJson(Map<String, dynamic> json) =>
      GetLatestNotificationModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? notificationId;
  int? receiverId;
  String? receiverRole;
  String? title;
  String? message;
  int? createdDate;
  int? modifiedDate;
  String? readStatus;

  Datum({
    this.notificationId,
    this.receiverId,
    this.receiverRole,
    this.title,
    this.message,
    this.createdDate,
    this.modifiedDate,
    this.readStatus,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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

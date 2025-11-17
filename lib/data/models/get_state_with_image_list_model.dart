// To parse this JSON data, do
//
//     final getStateWithImageListModel = getStateWithImageListModelFromJson(jsonString);

import 'dart:convert';

GetStateWithImageListModel getStateWithImageListModelFromJson(String str) =>
    GetStateWithImageListModel.fromJson(json.decode(str));

String getStateWithImageListModelToJson(GetStateWithImageListModel data) =>
    json.encode(data.toJson());

class GetStateWithImageListModel {
  Status? status;
  List<Datum>? data;

  GetStateWithImageListModel({
    this.status,
    this.data,
  });

  factory GetStateWithImageListModel.fromJson(Map<String, dynamic> json) =>
      GetStateWithImageListModel(
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
  int? stateId;
  String? state;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? stateImage;

  Datum({
    this.stateId,
    this.state,
    this.createdDate,
    this.modifiedDate,
    this.stateImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        stateId: json["stateId"],
        state: json["state"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null
            ? null
            : DateTime.parse(json["modifiedDate"]),
        stateImage: json["stateImage"],
      );

  Map<String, dynamic> toJson() => {
        "stateId": stateId,
        "state": state,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "stateImage": stateImage,
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

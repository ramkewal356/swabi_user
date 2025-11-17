import 'dart:convert';

CalculatePriceModel calculatePriceModelFromJson(String str) =>
    CalculatePriceModel.fromJson(json.decode(str));

String calculatePriceModelToJson(CalculatePriceModel data) =>
    json.encode(data.toJson());

class CalculatePriceModel {
  Status? status;
  Data? data;

  CalculatePriceModel({
    this.status,
    this.data,
  });

  factory CalculatePriceModel.fromJson(Map<String, dynamic> json) =>
      CalculatePriceModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<int>? activityIds;
  double? calculatedPrice;
  String? participantType;

  Data({
    this.activityIds,
    this.calculatedPrice,
    this.participantType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        activityIds: json["activityIds"] == null
            ? []
            : List<int>.from(json["activityIds"]!.map((x) => x)),
        calculatedPrice: json["calculatedPrice"]?.toDouble(),
        participantType: json["participantType"],
      );

  Map<String, dynamic> toJson() => {
        "activityIds": activityIds == null
            ? []
            : List<dynamic>.from(activityIds!.map((x) => x)),
        "calculatedPrice": calculatedPrice,
        "participantType": participantType,
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

// To parse this JSON data, do
//
//     final getStateNameModel = getStateNameModelFromJson(jsonString);

import 'dart:convert';

GetStateNameModel getStateNameModelFromJson(String str) =>
    GetStateNameModel.fromJson(json.decode(str));

String getStateNameModelToJson(GetStateNameModel data) =>
    json.encode(data.toJson());

class GetStateNameModel {
  bool? error;
  String? msg;
  List<Datum>? data;

  GetStateNameModel({
    this.error,
    this.msg,
    this.data,
  });

  factory GetStateNameModel.fromJson(Map<String, dynamic> json) =>
      GetStateNameModel(
        error: json["error"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? name;
  String? iso3;
  String? iso2;
  List<StateName>? states;

  Datum({
    this.name,
    this.iso3,
    this.iso2,
    this.states,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        iso3: json["iso3"],
        iso2: json["iso2"],
        states: json["states"] == null
            ? []
            : List<StateName>.from(
                json["states"]!.map((x) => StateName.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "iso3": iso3,
        "iso2": iso2,
        "states": states == null
            ? []
            : List<dynamic>.from(states!.map((x) => x.toJson())),
      };
}

class StateName {
  String? name;
  String? stateCode;

  StateName({
    this.name,
    this.stateCode,
  });

  factory StateName.fromJson(Map<String, dynamic> json) => StateName(
        name: json["name"],
        stateCode: json["state_code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state_code": stateCode,
      };
}

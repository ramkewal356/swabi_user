// To parse this JSON data, do
//
//     final getStateListModel = getStateListModelFromJson(jsonString);

import 'dart:convert';

List<GetStateListModel> getStateListModelFromJson(String str) =>
    List<GetStateListModel>.from(
        json.decode(str).map((x) => GetStateListModel.fromJson(x)));

String getStateListModelToJson(List<GetStateListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetStateListModel {
  String? stateName;

  GetStateListModel({
    this.stateName,
  });

  factory GetStateListModel.fromJson(Map<String, dynamic> json) =>
      GetStateListModel(
        stateName: json["state_name"],
      );

  Map<String, dynamic> toJson() => {
        "state_name": stateName,
      };
}

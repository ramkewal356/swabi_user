// To parse this JSON data, do
//
//     final getCountryListModel = getCountryListModelFromJson(jsonString);

import 'dart:convert';

List<GetCountryListModel> getCountryListModelFromJson(String str) =>
    List<GetCountryListModel>.from(
        json.decode(str).map((x) => GetCountryListModel.fromJson(x)));

String getCountryListModelToJson(List<GetCountryListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCountryListModel {
  String? countryName;
  String? countryShortName;
  int? countryPhoneCode;

  GetCountryListModel({
    this.countryName,
    this.countryShortName,
    this.countryPhoneCode,
  });

  factory GetCountryListModel.fromJson(Map<String, dynamic> json) =>
      GetCountryListModel(
        countryName: json["country_name"],
        countryShortName: json["country_short_name"],
        countryPhoneCode: json["country_phone_code"],
      );

  Map<String, dynamic> toJson() => {
        "country_name": countryName,
        "country_short_name": countryShortName,
        "country_phone_code": countryPhoneCode,
      };
}

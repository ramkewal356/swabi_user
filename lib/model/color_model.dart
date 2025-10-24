// To parse this JSON data, do
//
//     final colorModel = colorModelFromJson(jsonString);

import 'dart:convert';

ColorModel colorModelFromJson(String str) =>
    ColorModel.fromJson(json.decode(str));

String colorModelToJson(ColorModel data) => json.encode(data.toJson());

class ColorModel {
  int? status;
  String? statusText;
  String? message;
  int? count;
  List<Color>? colors;

  ColorModel({
    this.status,
    this.statusText,
    this.message,
    this.count,
    this.colors,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        count: json["count"],
        colors: json["colors"] == null
            ? []
            : List<Color>.from(json["colors"]!.map((x) => Color.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "count": count,
        "colors": colors == null
            ? []
            : List<dynamic>.from(colors!.map((x) => x.toJson())),
      };
}

class Color {
  String? name;
  String? theme;
  String? group;
  String? hex;
  String? rgb;

  Color({
    this.name,
    this.theme,
    this.group,
    this.hex,
    this.rgb,
  });

  factory Color.fromJson(Map<String, dynamic> json) => Color(
        name: json["name"],
        theme: json["theme"],
        group: json["group"],
        hex: json["hex"],
        rgb: json["rgb"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "theme": theme,
        "group": group,
        "hex": hex,
        "rgb": rgb,
      };
}

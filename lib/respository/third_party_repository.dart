import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/color_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

class ThirdPartyRepository {
  Future<ColorModel> getColorsApi() async {
    var http = HttpService(
      isAuthorizeRequest: false,
      baseURL: AppUrl.colorbaseUrl,
      endURL: AppUrl.colorUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Color Resp api success ${response?.data}");

      var resp = ColorModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Color Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

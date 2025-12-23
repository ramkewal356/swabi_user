import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/color_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';
import 'package:flutter_cab/data/models/currency_model.dart';
import 'package:flutter_cab/data/models/get_state_name_model.dart';

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
  Future<dynamic> getCountryListApi() async {
    var http = HttpService(
      isAuthorizeRequest: false,
      baseURL: AppUrl.countryStateBaseUrl,
      endURL: AppUrl.getCountryListUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("getcountry List response ${response?.data}");
      return response?.data;
    } catch (error) {
      debugPrint('error.. $error');
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<GetStateNameModel> getStateListApi({
    required Map<String, dynamic> body,
  }) async {
    var http = HttpService(
      baseURL: AppUrl.countryStateBaseUrl,
      endURL: AppUrl.getStateNameUrl,
      body: body,
      bodyType: HttpBodyType.JSON,
      isAuthorizeRequest: false,
      methodType: HttpMethodType.GET,
    );

    try {
      Response<dynamic>? response = await http.request<dynamic>();

      debugPrint("Response: ${response?.data}");
      var resp = GetStateNameModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error.. $error');
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }
Future<List<CurrencyModel>> getAllCurrencyApi() async {
    var http = HttpService(
      isAuthorizeRequest: false,
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.currencyUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Currency Resp api success ${response?.data}");

      // var resp = CurrencyModel.fromJson(response?.data);
      // return resp;
      if (response?.statusCode == 200) {
        final List<dynamic> data = response?.data;

        return data.map((e) => CurrencyModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load currency");
      }
    } catch (e) {
      debugPrint("Currency Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

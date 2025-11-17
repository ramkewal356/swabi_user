import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class ItineraryRepository {
  Future<CommonModel> addEditActivityApi(
      {required Map<String, dynamic> body, bool isEdit = false}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: isEdit ? AppUrl.updateItineraryUrl : AppUrl.addItineraryUrl,
        methodType: isEdit ? HttpMethodType.PUT : HttpMethodType.POST,
        body: body,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Create and change itinerary Repo Success ${response?.data}");
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Create and change itinerary Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

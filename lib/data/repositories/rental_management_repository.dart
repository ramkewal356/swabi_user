import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/rental_model.dart';

import 'package:flutter_cab/core/services/http_service.dart';

class RentalManagementRepository {
  Future<RentalModel> getAllRentalListRepositoryApi(
      {Map<String, dynamic>? query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllRentalListUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("get rental Matrics List Repo Success${response?.data}");

      return RentalModel.fromJson(response?.data);
    } catch (e) {
      http.handleErrorResponse(error: e);
      debugPrint('get rental Matrics List Repo Field $e');
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/available_driver_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/driver_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

class DriverRepository {
  Future<DriverModel> fetchAllDrivers(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllDriverListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Driver List Repo Success ${response?.data}");
      return DriverModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Driver List Repo Field $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<AvailableDriverModel> fetchAvailableDrivers(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAvailableDriverListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Available Driver List Repo Success ${response?.data}");
      return AvailableDriverModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Available Driver List Repo Field $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> assignDriverApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.assignDriverUrl,
        methodType: HttpMethodType.PUT,
        body: body,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Activity List Repo Success ${response?.data}");
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Activity List Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/available_driver_model.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/driver_model.dart';
import 'package:flutter_cab/data/models/get_driver_by_id_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

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

  Future<GetDriverByIdModel> getDriverByIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getDriverByIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Available Driver List Repo Success ${response?.data}");
      return GetDriverByIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Available Driver List Repo Field $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool> addEditDriverApi(
      {required Map<String, dynamic> body, bool isEdit = false}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: isEdit ? AppUrl.updateDriverUrl : AppUrl.addDriverUrl,
        methodType: isEdit ? HttpMethodType.PUT : HttpMethodType.POST,
        body: body,
        bodyType: HttpBodyType.FormData,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Add Edit Driver Repo Success ${response?.data}");
      if (response != null && response.statusCode == 200) {
        debugPrint("Add Edit Driver Success: ${response.data}");
        return true;
      } else {
        debugPrint("Add Edit Driver Failed: ${response?.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Add Edit Driver Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> activeOrDeactiveDriverApi(
      {required Map<String, dynamic> query, required bool isActive}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL:
            isActive ? AppUrl.activateDriverUrl : AppUrl.deactivateDriverUrl,
        methodType: isActive ? HttpMethodType.PATCH : HttpMethodType.DELETE,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint(
          "Active-deactive Vehicle Owner  Repo Success ${response?.data}");
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Active-deactive Vehicle Owner  Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

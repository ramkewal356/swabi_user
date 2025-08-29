import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/get_activity_by_id_model.dart';
import 'package:flutter_cab/model/get_all_activity_list_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

class ActivityManagementRepository {
  Future<GetAllActivityListModel> getAllActivityApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllActivityList,
        methodType: HttpMethodType.GET,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Activity List Repo Success ${response?.data}");
      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return GetAllActivityListModel.fromJson(
            response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return GetAllActivityListModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("Get Activity List Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetActivityByIdModel> getActivityByIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getActivityByIdUrl,
        methodType: HttpMethodType.GET,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Activity List Repo Success ${response?.data}");
      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return GetActivityByIdModel.fromJson(
            response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return GetActivityByIdModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("Get Activity List Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool> addEditActivityApi(
      {required Map<String, dynamic> body, bool isEdit = false}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: isEdit ? AppUrl.updateActivityUrl : AppUrl.addActivityUrl,
        methodType: isEdit ? HttpMethodType.PUT : HttpMethodType.POST,
        body: body,
        bodyType: HttpBodyType.FormData,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Activity List Repo Success ${response?.data}");
      if (response != null && response.statusCode == 200) {
        debugPrint("Add Package Success: ${response.data}");
        return true;
      } else {
        debugPrint("Add Package Failed: ${response?.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Get Activity List Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> activeOrDeactiveActivityApi(
      {required Map<String, dynamic> query, required bool isActive}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: isActive
            ? AppUrl.activateAcitivityUrl
            : AppUrl.deActivateAcitivityUrl,
        methodType: isActive ? HttpMethodType.PATCH : HttpMethodType.DELETE,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Active-deactive Activity  Repo Success ${response?.data}");
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Active-deactive Activity  Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

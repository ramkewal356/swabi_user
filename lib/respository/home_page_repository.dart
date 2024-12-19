import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/get_activity_category_list_model.dart';
import 'package:flutter_cab/model/get_all_activity_list_model.dart';
import 'package:flutter_cab/model/get_state_with_image_list_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

class HomePageRepository {
  Future<GetActivityCategoryModel> getActivityCategoryList({
    required BuildContext context,
  }) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getActivityCategoryList,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package List Repo Success ${response?.data}");
      var resp = GetActivityCategoryModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package List Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }

  Future<GetPackageListModel> getPackageListApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getPackageList,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package List Repo Success ${response?.data}");
      var resp = GetPackageListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package List Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }

  Future<GetAllActivityListModel> getActivityListApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllActivityList,
        methodType: HttpMethodType.GET,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package List Repo Success ${response?.data}");
      var resp = GetAllActivityListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package List Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }

  Future<GetStateWithImageListModel> getStateWithImageListApi({
    required BuildContext context,
  }) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getStateWithImageList,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package List Repo Success ${response?.data}");
      var resp = GetStateWithImageListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package List Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

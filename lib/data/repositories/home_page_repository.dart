import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/get_activity_category_list_model.dart';
import 'package:flutter_cab/data/models/get_all_activity_list_model.dart';
import 'package:flutter_cab/data/models/get_state_with_image_list_model.dart';
import 'package:flutter_cab/data/models/package_models.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class HomePageRepository {
  Future<GetActivityCategoryModel> getActivityCategoryList() async {
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
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetPackageListModel> getPackageListApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllPackageList,
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
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetAllActivityListModel> getActivityListApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllAcitivityListUrl,
        methodType: HttpMethodType.GET,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Activity List Repo Success ${response?.data}");
      var resp = GetAllActivityListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Activity List Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetStateWithImageListModel> getStateWithImageListApi() async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getStateWithImageList,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Cities List Repo Success ${response?.data}");
      var resp = GetStateWithImageListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Cities List Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

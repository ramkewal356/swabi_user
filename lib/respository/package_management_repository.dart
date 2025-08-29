
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/get_package_list_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

class PackageManagementRepository {
  Future<PackageListModel> getPackageListApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getPackageList,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response...$response');
      return PackageListModel.fromJson(response?.data);
    } catch (error) {
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  

  Future<bool> addPackageApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.addPackageUrl,
        methodType: HttpMethodType.POST,
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

  Future<bool> updatePackageApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.updatePackageUrl,
        methodType: HttpMethodType.PUT,
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

  Future<CommonModel> activeOrDeactivePackageApi(
      {required Map<String, dynamic> query, required bool isActive}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: isActive ? AppUrl.activePackageUrl : AppUrl.deactivepackageUrl,
        methodType: isActive ? HttpMethodType.PATCH : HttpMethodType.DELETE,
        queryParameters: query,
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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/vehicle_owner_by_id_model.dart';
import 'package:flutter_cab/data/models/vehicle_owner_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class VehicleOwnerRepository {
  Future<VehicleOwnerModel> getVehicleOwnerApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getVehicleOwnerListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Vehicle Owner List Repo Success ${response?.data}");
      return VehicleOwnerModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Vehicle Owner List Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<VehicleOwnerByIdModel> getVehicleOwnerByIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getVehicleOwnerByIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Vehicle Owner By Id Repo Success ${response?.data}");
      return VehicleOwnerByIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool> updateVehicleOwnerApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.updateVehicleOwnerDetails,
        methodType: HttpMethodType.PUT,
        body: body,
        bodyType: HttpBodyType.FormData,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Update Vehicle Owner Repo Success ${response?.data}");
      if (response != null && response.statusCode == 200) {
        debugPrint("Update Vehicle Owner Success: ${response.data}");
        return true;
      } else {
        debugPrint("Update Vehicle Owner Failed: ${response?.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Update Vehicle Owner Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> activeOrDeactiveVehicleOwnerApi(
      {required Map<String, dynamic> query, required bool isActive}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: isActive
            ? AppUrl.activateVehicleOwnerUrl
            : AppUrl.deactiveVehicleOwnerUrl,
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

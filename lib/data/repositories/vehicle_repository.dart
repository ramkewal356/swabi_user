import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/available_vehicle_model.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/get_all_vehicle_type_model.dart';
import 'package:flutter_cab/data/models/get_vehicle_by_id_model.dart';
import 'package:flutter_cab/data/models/vehicle_brand_name_model.dart';
import 'package:flutter_cab/data/models/vehicle_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class VehicleRepository {
  Future<VehicleModel> fetchAllVehicles(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllVehicleListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Vehicle List Repo Success ${response?.data}");
      return VehicleModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Vehicle List Repo Field $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<AvailableVehicleModel> fetchAvailableVehicles(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAvailableVehicleListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Available Vehicle List Repo Success ${response?.data}");
      return AvailableVehicleModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Available Vehicle List Repo Field $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> assignVehicleApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.assignVehicleUrl,
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

  Future<GetVehicleByIdModel> getVehicleByIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getVehicleByIdUrl,
        methodType: HttpMethodType.GET,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Vehicle By Id Repo Success ${response?.data}");
      return GetVehicleByIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Vehicle By Id Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> activeOrDeactiveVehicleApi(
      {required Map<String, dynamic> query, required bool isActive}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL:
            isActive ? AppUrl.activateVehicleUrl : AppUrl.deactiveVehicleUrl,
        methodType: isActive ? HttpMethodType.PATCH : HttpMethodType.DELETE,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Active-deactive Vehicle  Repo Success ${response?.data}");
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Active-deactive Vehicle  Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<VehicleBrandNameModel> getVehicleBrandNameApi() async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getVehicleBrandName,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Vehicle Brand Name List Repo Success ${response?.data}");
      return VehicleBrandNameModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Vehicle Brand Name List Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<VehicleTypeModel> getAllVehicleTypeApi() async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllVehicleType,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Vehicle Type List Repo Success ${response?.data}");
      return VehicleTypeModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Vehicle Type List Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool> addOrEditVehicleApi(
      {required Map<String, dynamic> body, bool isEdit = false}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: isEdit ? AppUrl.updateVehicleUrl : AppUrl.addVehicleUrl,
        methodType: isEdit ? HttpMethodType.PUT : HttpMethodType.POST,
        body: body,
        bodyType: HttpBodyType.FormData,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Add Or Edit Vehicle Repo Success ${response?.data}");
      if (response != null && response.statusCode == 200) {
        debugPrint("Add or Edit vehicle Success: ${response.data}");
        return true;
      } else {
        debugPrint("Add or Edit vehicle Failed: ${response?.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Add or Edit vehicle Repo Field $e");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

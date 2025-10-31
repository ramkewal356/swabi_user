import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/vehicle_owner_by_id_model.dart';
import 'package:flutter_cab/model/vehicle_owner_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

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
}

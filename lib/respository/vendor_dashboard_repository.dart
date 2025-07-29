import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/get_all_driver_model.dart';
import 'package:flutter_cab/model/get_all_package_booking_model.dart';
import 'package:flutter_cab/model/get_all_rental_booking_model.dart';
import 'package:flutter_cab/model/get_all_vehicle_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

class VendorDashboardRepository {
  Future<GetAllVehicleModel> getAllVehicleApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllVehicleUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get All Vehicle Resp api success ${response?.data}");

      var resp = GetAllVehicleModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Vendor Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetAllDriverModel> getAllDriverApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllDriverUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get All Vehicle Resp api success ${response?.data}");

      return GetAllDriverModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Vendor Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetAllRentalBookingModel> getAllRentalBookingApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllRentalBookingUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get All Vehicle Resp api success ${response?.data}");

      var resp = GetAllRentalBookingModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Vendor Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetAllPackageBookingModel> getAllPackageBookingApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllPackageBookingUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get All Vehicle Resp api success ${response?.data}");

      var resp = GetAllPackageBookingModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Vendor Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

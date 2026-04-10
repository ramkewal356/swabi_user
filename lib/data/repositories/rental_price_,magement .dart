import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/rental_price_list_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class RentalPriceManagementRepository {
  /// Fetches rental price list with optional query parameters.
  Future<RentalPriceListModel?> getRentalPriceList({
    Map<String, dynamic>? query,
    bool isAuthorizeRequest = false,
  }) async {
    var http = HttpService(
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.getRentalPriceListUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
      queryParameters: query,
      isAuthorizeRequest: isAuthorizeRequest,
    );

    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint(
          "RentalPriceManagementRepository - Fetch Success: ${response?.data}");
      if (response?.data != null) {
        return RentalPriceListModel.fromJson(response?.data);
      }
      return null;
    } catch (e) {
      debugPrint("RentalPriceManagementRepository - Fetch Error: $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  /// Optionally implement more CRUD methods as per your application's needs.
  /// Adds a new rental price. Returns true if successful.
  Future<bool> addEditRentalPrice({
    required Map<String, dynamic> data,
    bool isEdit = false,
  }) async {
    var http = HttpService(
      baseURL: AppUrl.baseUrl,
      endURL: isEdit
          ? AppUrl.editRentalPriceUrl
          : AppUrl.addRentalPriceUrl, // You must define in AppUrl
      methodType: isEdit ? HttpMethodType.PUT : HttpMethodType.POST,
      bodyType: HttpBodyType.JSON,
      body: data,
    );

    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint(
          "RentalPriceManagementRepository - Add Success: ${response?.data}");
      // You may want to check if response status is OK or success flag in body
      return response != null &&
          (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      debugPrint("RentalPriceManagementRepository - Add Error: $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  /// Activates a rental price entry by ID.
  Future<CommonModel> activateRentalPrice(
      {required int id, required bool isActivate}) async {
    var http = HttpService(
      baseURL: AppUrl.baseUrl,
      endURL: isActivate
          ? AppUrl.activateRentalPriceUrl
          : AppUrl
              .deactiveRentalPriceUrl, // Define in AppUrl, e.g., '/rental-price/activate'
      methodType: isActivate ? HttpMethodType.PATCH : HttpMethodType.DELETE,
      bodyType: HttpBodyType.JSON,
      queryParameters: {"id": id},
    );

    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint(
          "RentalPriceManagementRepository - Activate Success: ${response?.data}");
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("RentalPriceManagementRepository - Activate Error: $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

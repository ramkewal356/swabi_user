import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/calculate_price_model.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/get_package_details_by_id_model.dart';
import 'package:flutter_cab/data/models/package_models.dart';
import 'package:flutter_cab/core/services/http_service.dart';

///Get Package List Repo
class GetPackageListRepository {
  Future<GetPackageListModel> getPackageListRepositoryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllPackageListUrl,
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
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

///Get Package Activity By Id Repo
class GetPackageActivityByIdRepository {
  Future<GetPackageDetailByIdModel> getPackageActivityByIdRepositoryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getPackageByIdUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Activity By Id Repo Success ${response?.data}");
      var resp = GetPackageDetailByIdModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Activity By Id Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

class CalculatePriceRepository {
  Future<CalculatePriceModel> getCalculatePriceApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getCalculatePriceUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Activity By Id Repo Success ${response?.data}");
      var resp = CalculatePriceModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Activity By Id Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

///Post Package Booking By Id Repo
class GetPackageBookedByIdRepository {
  Future<BookPackageByMemberModel> getPackageBookedByIdRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.packageBookingUrl,
        body: body,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Booked By Id Repo Success ${response?.data}");
      var resp = BookPackageByMemberModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Booked By Id Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<BookPackageByMemberModel> confirmPackageBookingRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.confirmpackageBookingUrl,
        queryParameters: query,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Booked By Id Repo Success ${response?.data}");
      var resp = BookPackageByMemberModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Booked By Id Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

///Get Package History By Id Repo
class GetPackageHistoryRepository {
  Future<GetPackageHistoryModel?> getPackageHistoryRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> data}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getPackagelistUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        isAuthorizeRequest: false,
        queryParameters: data);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('Get Package History Repo Success ${response?.data}');
      var resp = GetPackageHistoryModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package History Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

///Get Package History Details By Id Repo
class GetPackageHistoryDetailByIdRepository {
  Future<GetPackageHIstoryDetailsModel?>
      getPackageHistoryDetailByIdRepositoryApi(
          {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getpackageBookingByIdUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint(
          "Get Package History Detail By Id Repo Success ${response?.data}");
      var resp = GetPackageHIstoryDetailsModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package History Detail By Id Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

///Package Cancel Repo
class PackageCancelRepository {
  Future<CommonModel?> packageCancelRepositoryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.packageCancellUrl,
        queryParameters: query,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();

      debugPrint("Package Cancel Repo Success");
      var resp = CommonModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Package Cancel Repo Field");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      debugPrint(e.toString());
      rethrow;
    }
  }
}

///Add PickUp Location Repo
class AddPickUpLocationPackageRepository {
  Future<CommonModel> addPickUpLocationPackageRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.addPickupLocation,
        queryParameters: query,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Add PickUp Location Package Repo Success ${response?.data}");

      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Add PickUp Location Package Repo Fieldb$e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);

      rethrow;
    }
  }
}

///Get Package Itinerary Repo
class GetPackageItineraryRepository {
  Future<GetPackageItineraryModel> getPackageItineraryRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getItenerypackageBookingIdUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("GetPackageItinerary Repo Success ${response?.data}");

      var resp = GetPackageItineraryModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("GetPackageItinerary Repo Field$e");
      // http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

///Get Package Itinerary Repo
class ChangeMobileRepository {
  Future<CommonModel> changeMobile({required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.changeMobileUrl,
        body: body,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response...$response');
      final parsedData = response?.data is String
          ? json.decode(response?.data)
          : response?.data;

      var resp = CommonModel.fromJson(parsedData);
      return resp;
    } catch (error) {
      debugPrint("Change Mobile Repo Field $error");
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }
}

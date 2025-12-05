import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/get_activity_offer_model.dart';
import 'package:flutter_cab/data/models/offer_detail_by_id_model.dart';
import 'package:flutter_cab/data/models/offer_list_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class OfferRepository {
  Future<OfferListModel?> offerListApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getOfferListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      var resp = OfferListModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<OfferDetailByIdModel?> offerDetailsApi(
      {
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getOfferDetailUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      var resp = OfferDetailByIdModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<OfferDetailByIdModel?> validateOfferApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.validateOfferUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      var resp = OfferDetailByIdModel.fromJson(response?.data);
      return resp;
    } catch (error) {
    
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<GetActivityOfferModel?> getActivityOfferApi() async {
    var http = HttpService(
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.activityOfferUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
      isAuthorizeRequest: false,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      return GetActivityOfferModel.fromJson(response?.data);
    } catch (error) {
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<OfferListModel> getOfferByVendorIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getOfferByVendorIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      return OfferListModel.fromJson(response?.data);
    } catch (error) {
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }
}

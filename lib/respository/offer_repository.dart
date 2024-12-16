import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/offer_detail_by_id_model.dart';
import 'package:flutter_cab/model/offer_list_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

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
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
  }

  Future<OfferDetailByIdModel?> offerDetailsApi(
      {required BuildContext context,
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
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
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
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/get_all_bid_model.dart';
import 'package:flutter_cab/data/models/get_bid_by_id_model.dart';
import 'package:flutter_cab/view_model/bid_accept_or_reject_model.dart';

import '../../core/services/http_service.dart';

class BidRepository {
  Future<GetAllBidModel> getAllBidsApi(
      {required Map<String, dynamic> query, required String? vendorId}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: '/bids/vendor/$vendorId/submitted',
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get All Bid Api success ${response?.data}");

      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return GetAllBidModel.fromJson(response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return GetAllBidModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("Get  Bid Api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetBidByIdModel> getBidByIdApi({required String? bidId}) async {
    var http = HttpService(
      isAuthorizeRequest: false,
      baseURL: AppUrl.baseUrl,
      endURL: '/bids/$bidId',
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Bid By Id Api success ${response?.data}");

      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return GetBidByIdModel.fromJson(response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return GetBidByIdModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("Get Bid By Id api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  Future<bool> createBidApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.createBidUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Create Bid Resp api success ${response?.data}");
      return true;
    } catch (e) {
      debugPrint("Create Bid Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool> updateBidApi(
      {required Map<String, dynamic> body,
      required String? vendorId,
      required int bidId}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: '${AppUrl.updateBidUrl}/$bidId/$vendorId',
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Update Bid Resp api success ${response?.data}");
      return true;
    } catch (e) {
      debugPrint("Update Bid Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool> confirmBookingBidApi({
    required Map<String, dynamic> body,
  }) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.bidBookUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("book Bid Resp api success ${response?.data}");
      return true;
    } catch (e) {
      debugPrint("book Bid Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<BidAcceptOrRejectModel> acceptOrRejectBidApi(
      {required int bidId, required bool accept}) async {
    var http = HttpService(
      isAuthorizeRequest: true,
      baseURL: AppUrl.baseUrl,
      endURL: accept
          ? '${AppUrl.bidAcceptUrl}/$bidId'
          : '${AppUrl.bidRejectUrl}/$bidId',
      methodType: HttpMethodType.POST,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Accept or Reject Bid Resp api success ${response?.data}");
      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return BidAcceptOrRejectModel.fromJson(
            response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return BidAcceptOrRejectModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("Accept or Reject Bid Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  
  Future<bool> cancelBidApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.cancelBidUrl,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Cancel Bid Resp api success ${response?.data}");
      return true;
    } catch (e) {
      debugPrint("Cancel Bid Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

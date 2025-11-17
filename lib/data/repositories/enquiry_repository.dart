import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/get_all_enquiry_model.dart';
import 'package:flutter_cab/data/models/get_enquiry_by_id_model.dart';
import 'package:flutter_cab/data/models/get_my_enquiry_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class EnquiryRepository {
  Future<GetAllEnquiryModel> getAllEnquiryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllEnquiryUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Vendor Resp api success ${response?.data}");

      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return GetAllEnquiryModel.fromJson(
            response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return GetAllEnquiryModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("Vendor Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetMyEnquiryModel> getAllMyEnquiryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllMyEnquiryUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("User Enquiry Resp api success ${response?.data}");

      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return GetMyEnquiryModel.fromJson(
            response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return GetMyEnquiryModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("User Enquiry Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetEnquiryByIdModel> getEnquiryByIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getEnquiryById,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("User Enquiry  By Id Resp api success ${response?.data}");

      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return GetEnquiryByIdModel.fromJson(
            response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return GetEnquiryByIdModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (e) {
      debugPrint("User Enquiry By Id Resp api not success");

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

  Future<bool> sendEnquiryApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.sendEnquiryUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Send Enquiry Resp api success ${response?.data}");
      return true;
    } catch (e) {
      debugPrint("Send Enquiry Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

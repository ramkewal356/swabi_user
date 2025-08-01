import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/get_all_enquiry_model.dart';

import '../view_model/services/http_service.dart';

class BidRepository {
  Future<GetAllEnquiryModel> getAllBidsApi(
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
}

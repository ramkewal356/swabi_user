import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/core/services/http_service.dart';
import 'package:flutter_cab/data/models/create_wallet_payment_order_model.dart';
import 'package:flutter_cab/data/models/transaction_model.dart';

class WalletRepository {
  Future<bool> viewBidPaymentApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.payfoviewbidUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Bid payment Resp api success ${response?.data}");

      return response?.data != null ? true : false;
    } catch (e) {
      debugPrint("Bid payment Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<TransactionModel> getTranasactionApi() async {
    var http = HttpService(
      isAuthorizeRequest: true,
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.getTransactionUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Wallet Transaction Resp api success ${response?.data}");
      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return TransactionModel.fromJson(
            response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return TransactionModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
      // return TransactionModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Wallet Transaction api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CreateWalletPaymentOrderModel?> createPaymentOrderApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.createWalletPaymentOrderUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Create Payment Order API response: ${response?.data}");
      if (response?.data != null) {
        return CreateWalletPaymentOrderModel.fromJson(response?.data);
      }
      return null;
    } catch (e) {
      debugPrint("Create Payment Order API call failed: $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool?> verifyPaymentApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
      isAuthorizeRequest: true,
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.verifyPaymentUrl,
      methodType: HttpMethodType.POST,
      bodyType: HttpBodyType.FormData,
      body: body,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Verify Payment API response: ${response?.data}");
      if (response?.data != null) {
        return true;
      }
      return null;
    } catch (e) {
      debugPrint("Verify Payment API call failed: $e");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

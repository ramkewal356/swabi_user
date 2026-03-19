import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/core/services/http_service.dart';
import 'package:flutter_cab/data/models/payment_details_model.dart';
import 'package:flutter_cab/data/models/payment_transaction_model.dart';
import 'package:flutter_cab/data/models/refund_transaction_model.dart';
import 'package:flutter_cab/data/models/refunded_payment_details_model.dart';

class PaymentManagementRepository {
  Future<PaymentTransactionModel> getPaymentTransactionListApi({
    required Map<String, dynamic> query,
  }) async {
    var http = HttpService(
      isAuthorizeRequest: false,
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.getPaymentTransactionListUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
      queryParameters: query,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("PaymentDetailsResponse ${response?.data}");
      return PaymentTransactionModel.fromJson(response?.data);
    } catch (error) {
      debugPrint('error $error');
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<RefundTransactionModel> getRefundListApi({
    required Map<String, dynamic> query,
  }) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getRefundTransactionListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Refund TransactionResponse ${response?.data}");
      return RefundTransactionModel.fromJson(response?.data);
    } catch (error) {
      debugPrint('error $error');
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<RefundedPaymentDetailsModel> getRefundPaymentDetailsApi({
    required Map<String, dynamic> query,
  }) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getRefundByIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("RefundedPaymentDetailsResponse ${response?.data}");
      return RefundedPaymentDetailsModel.fromJson(response?.data);
    } catch (error) {
      debugPrint('error $error');
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<PaymentDetailsModel> getPaymentDetailsApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getPaymentByIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("PaymentDetailsResponse ${response?.data}");
      return PaymentDetailsModel.fromJson(response?.data);
    } catch (error) {
      debugPrint('error $error');
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/get_trasactionbyid_model.dart';
import 'package:flutter_cab/data/models/payment_getway_model.dart';
import 'package:flutter_cab/data/models/payment_refund_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

///Payment Create OrderID Repo
class PaymentCreateOrderIDRepository {
  Future<PaymentCreateOderIdModel?> paymentCreateOrderIdApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.createPaymentOrder,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        // queryParameters: query,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("CreatePaymentOrderresponse ${response?.data}");
      var resp = PaymentCreateOderIdModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }
}

///Payment Verify Repo
class PaymentVerifyRepository {
  Future<PaymentVerifyModel?> paymentVerifyApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.verifyPayment,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("paymentVerifyresponse ${response?.data}");
      var resp = PaymentVerifyModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      http.handleErrorResponse(
        // ignore: use_build_context_synchronously

        error: error,
      );
    }
    return null;
  }
}

class PaymentTrasactionRespository {
  Future<GetTransactionByIdModel?> getTrasactionByIdApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getTransactionByIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("GetTrasactionresponse ${response?.data}");
      var resp = GetTransactionByIdModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<GetTransactionByIdModel?> getRefundTrasactionByIdApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getRefundTransactionByIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("GetTrasactionresponse ${response?.data}");
      var resp = GetTransactionByIdModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }
}

class PaymentRefundRespository {
  Future<PaymentRefundModel?> getRefundPaymentApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getRefundPaymentUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Refunde details.... ${response?.data}");
      var resp = PaymentRefundModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }
}

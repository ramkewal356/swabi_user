import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/core/services/http_service.dart';

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
}

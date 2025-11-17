import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/get_vendor_by_id_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class VendorRepository {
  Future<GetVendorByIdModel> getVendorByIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getVendorByIdUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Vendor Resp api success ${response?.data}");

      var resp = GetVendorByIdModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Vendor Resp api not success");

      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

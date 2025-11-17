import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/registration_model.dart';
import 'package:flutter_cab/data/models/user_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class AuthRepository {
  Future<UserLoginModel?> userloginApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.loginUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("user login response ${response?.data}");
      var resp = UserLoginModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<SignUpModel?> fetchRegistrationListApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.signupUrl,
        body: body,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response...$response');
      var resp = SignUpModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<CommonModel> changePasswordApi(
      {required Map<String, dynamic> query, required String userType}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: userType == 'USER'
            ? AppUrl.changepasswordUrl
            : AppUrl.vendorChangePasswordUrl,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("password change resp  ${response?.data}");
      var resp = CommonModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<CommonModel> sendOtpApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.sendOtpsUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("send otp response ${response?.data}");
      if (response?.data is Map<String, dynamic>) {
        // Already JSON decoded
        return CommonModel.fromJson(response?.data as Map<String, dynamic>);
      } else if (response?.data is String) {
        // Need to decode
        final decoded = jsonDecode(response?.data as String);
        return CommonModel.fromJson(decoded);
      } else {
        throw Exception("Unexpected response format: ${response?.data}");
      }
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<CommonModel> verifyOtpApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.verifyOtpUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("passord change response ${response?.data}");
      var resp = CommonModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<CommonModel> resetPasswordApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.resetPassordUrl,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("passord change response  ${response?.data}");
      var resp = CommonModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/getall_notification_model.dart';
import 'package:flutter_cab/data/models/getlatest_notification_model.dart';
import 'package:flutter_cab/data/models/update_notification_status_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

class NotificationRepository {
  Future<GetLatestNotificationModel?> getLatestNotificationApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getLatestNotificationUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      var resp = GetLatestNotificationModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<UpdateNotificationStatusModel?> updateNotificationStatusApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.updateNotificationStatusUrl,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      var resp = UpdateNotificationStatusModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<GetAllNotificationModel?> getAllNotificationApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllNotificationUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      var resp = GetAllNotificationModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      // ignore: use_build_context_synchronously
      // http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }
}

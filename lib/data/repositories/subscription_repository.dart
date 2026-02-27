import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/core/database/database_helper.dart';
import 'package:flutter_cab/core/services/http_service.dart';
import 'package:flutter_cab/data/models/subscription_model.dart';

class SubscriptionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Future<List<SubscriptionModel>> getSubscriptionApi() async {
    var http = HttpService(
      isAuthorizeRequest: true,
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.getSubscriptionUrl,
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Create Bid Resp api success ${response?.data}");
      if (response?.data is List) {
        return (response?.data as List)
            .map((e) => SubscriptionModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Unexpected response type for subscriptions list");
      }
    } catch (e) {
      debugPrint("Create Bid Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<SubscriptionModel> getSubscriptionByVendorIdApi(
      {required String vendorId}) async {
    var http = HttpService(
      isAuthorizeRequest: true,
      baseURL: AppUrl.baseUrl,
      endURL: "${AppUrl.getSubscriptionByVendorId}/$vendorId",
      methodType: HttpMethodType.GET,
      bodyType: HttpBodyType.JSON,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint(
          "Get Subscription by vendor Id Resp api success ${response?.data}");
      return SubscriptionModel.fromJson(response?.data);
    } catch (e) {
      debugPrint("Get Subscription by vendor Id Resp api not success");
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final apiData = await getSubscriptionApi();

      // Clear old cache
      await _dbHelper.clearSubscriptions();

      // Save new data in batch
      await _dbHelper.insertAllSubscriptions(apiData);

      return apiData;
    } catch (e) {
      // If API fails, return cached data
      return await _dbHelper.getAllSubscriptions();
    }
  }

  Future<int> updateSubscription(SubscriptionModel subscription) async {
    try {
      return await _dbHelper.updateSubscription(subscription);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteSubscription(int id) async {
    try {
      return await _dbHelper.deleteSubscription(id);
    } catch (e) {
      rethrow;
    }
  }

  Future close() async {
    return await _dbHelper.close();
  }
}

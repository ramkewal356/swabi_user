import 'dart:convert';

import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/core/services/http_service.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/offer_list_model.dart';

class OfferManagementRepository {
  Future<OfferListModel> getOfferListApi(
      {required Map<String, dynamic> query}) async {
    final http = HttpService(
        isAuthorizeRequest: true,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllOfferListUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      final response = await http.request<dynamic>();
      if (response?.data != null) {
        // The response may be directly a Map or a JSON string
        if (response!.data is Map<String, dynamic>) {
          return OfferListModel.fromJson(response.data);
        }
        if (response.data is String) {
          final decoded = jsonDecode(response.data);
          return OfferListModel.fromJson(decoded);
        }
        throw Exception("Unexpected response format: ${response.data}");
      } else {
        throw Exception("No data found in response");
      }
    } catch (e) {
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<bool> addOrEditOfferApi(
      {required Map<String, dynamic> data, required bool isEdit}) async {
    final http = HttpService(
      isAuthorizeRequest: true,
      baseURL: AppUrl.baseUrl,
      endURL: isEdit
          ? AppUrl.updateOfferUrl
          : AppUrl.addOfferUrl, // define this in AppUrl
      methodType: isEdit ? HttpMethodType.PUT : HttpMethodType.POST,
      bodyType: HttpBodyType.FormData,
      body: data,
    );
    try {
      final response = await http.request<dynamic>();
      if (response?.data != null) {
        // throw Exception("No data found in response");
        return true;
      } else {
        return false;
      }
      // Optionally, you may want to parse/return response as needed
    } catch (e) {
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> activateAndDeactivateOfferApi(
      {required String offerId, required bool isActivate}) async {
    final http = HttpService(
      isAuthorizeRequest: true,
      baseURL: AppUrl.baseUrl,
      endURL: isActivate ? AppUrl.activateOfferUrl : AppUrl.deactivateOfferUrl,
      methodType: HttpMethodType.DELETE,
      bodyType: HttpBodyType.JSON,
      queryParameters: {"offerId": offerId},
    );
    try {
      final response = await http.request<dynamic>();
      return CommonModel.fromJson(response?.data);
      // Optionally, handle any response parsing or success confirmation
    } catch (e) {
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

//   Future<List<String>> fetchCurrenciesFromApi() async {
//      final http = HttpService(
//       isAuthorizeRequest: true,
//       baseURL: AppUrl.baseUrl,
//       endURL:
//           "${AppUrl.updateOfferUrl}/deactivate/$offerId", // Deactivate endpoint pattern (adjust if needed)
//       methodType: HttpMethodType.PUT,
//       bodyType: HttpBodyType.JSON,
//       body: {},
//     );
//   final response = await http.get(Uri.parse(currencyApiUrl));
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = json.decode(response.body);
//     return data.keys.toList();
//   } else {
//     throw Exception('Failed to load currencies');
//   }
// }
}

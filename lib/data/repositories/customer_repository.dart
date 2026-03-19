import 'package:dio/dio.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/core/services/http_service.dart';
import 'package:flutter_cab/data/models/customer_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class CustomerRepository {
  Future<CustomerModel> getAllCustomer(
      {required Map<String, dynamic> query}) async {
    String? vendorId = await UserViewModel().getUserId();
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: "/vendor/$vendorId/users",
        isAuthorizeRequest: true,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      return CustomerModel.fromJson(response?.data);
    } catch (e) {
      http.handleErrorResponse(error: e.toString());
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/user_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';


class UserRepository {
  
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
      debugPrint("passord change response ${response?.data}");
      var resp = UserLoginModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }
}

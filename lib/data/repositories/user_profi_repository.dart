import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/app_url.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/get_state_name_model.dart';
import 'package:flutter_cab/data/models/user_profile_model.dart';
import 'package:flutter_cab/core/services/http_service.dart';

///Rental View Single Detail Repo
class UserProfileRepository {
  // final BaseApiServices _apiServices = NetworkApiService();

  Future<UserProfileModel> userProfileRepositoryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getProfileUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("UserProfile Repo api success ${response?.data}");

      var resp = UserProfileModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("UserProfile Repo api not success");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

class ProfileImageRepository {
  Future<CommonModel> fetchProfileImageApi(
      {required Map<String, dynamic> body, required String userType}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: userType == 'USER'
            ? AppUrl.updateProfilePicUrl
            : AppUrl.updateVendorProfilePicUrl,
        methodType:
            userType == 'USER' ? HttpMethodType.PUT : HttpMethodType.PATCH,
        bodyType: HttpBodyType.FormData,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("passord change response ${response?.data}");
      var resp = CommonModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("UserProfile Update Repo api not success");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}

class UserProfileUpdateRepository {
  Future<bool> userProfileUpdateRepositoryApi(
      {required Map<String, dynamic> body, required String userType}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: userType == 'USER'
            ? AppUrl.updateProfileUrl
            : AppUrl.vendorUpdateProfileUrl,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("passord change response ${response?.data}");
      // var resp = UserProfileUpdateModel.fromJson(response?.data);
      return true;
    } catch (e) {
      debugPrint("UserProfile Update Repo api not success");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<dynamic> getCountryListApi(
      {required BuildContext context,
      required Map<String, String> header}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.locationBaseUrl,
        endURL: AppUrl.getCountryList,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        headers: header);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("getcountry List response ${response?.data}");
      // var resp = GetCountryListModel.fromJson(jsonDecode(response?.data));

      // Convert to a list of GetCountryListModel
      return response?.data;

      // return resp;
    } catch (error) {
      debugPrint('error.. $error');
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(error: error);
      rethrow;
    }
  }

  Future<GetStateNameModel> getStateListApi({
    required BuildContext context,
    required Map<String, dynamic> body,
  }) async {
    var http = HttpService(
      baseURL: AppUrl.stateBaseUrl,
      endURL: AppUrl.getStateNameUrl,
      body: body,
      bodyType: HttpBodyType.JSON,
      isAuthorizeRequest: false,
      methodType: HttpMethodType.GET,
    );

    try {
      Response<dynamic>? response = await http.request<dynamic>();

      debugPrint("Response: ${response?.data}");
      var resp = GetStateNameModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error.. $error');
      // http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }

  Future<dynamic> getAccessTokentApi({
    required BuildContext context,
    required Map<String, String> header,
  }) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.locationBaseUrl,
        endURL: AppUrl.getAccessTokenUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        headers: header);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("getcountry List response ${response?.data}");
      // var resp = GetStateListModel.fromJson(response?.data);
      if (response?.data != null) {
        return response?.data;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('error.. $error');
      // http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }
}

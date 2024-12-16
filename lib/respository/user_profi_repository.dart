import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/data/network/base_apiservices.dart';
import 'package:flutter_cab/data/network/network_apiservice.dart';
import 'package:flutter_cab/data/response/base_response.dart';
import 'package:flutter_cab/model/changepassword_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/get_country_list_model.dart';
import 'package:flutter_cab/model/get_state_list_model.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

///Rental View Single Detail Repo
class UserProfileRepository {
  // final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> userProfileRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
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
      // dynamic response = await _apiServices
      //     .getGetApiResponse("http://swabi.ap-south-1.elasticbeanstalk.com"
      //         "/user/get_user_by_userId?userId=${data["userId"]}");
      // print("UserProfile Repo api success $data");
      var resp = UserProfileModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("UserProfile Repo api not success");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

class ProfileImageRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchProfileImageApi(data) async {
    try {
      /// for image
      dynamic response = await _apiServices.uploadImageHTTP2(
          // "http://swabi.ap-south-1.elasticbeanstalk.com/"
          "${AppUrl.baseUrl}"
          "/user/upload_profile",
          data["image"],
          data['userId']);

      return response["data"]["body"];
    } catch (e) {
      if (kDebugMode) {
        // print("$e profile image field");
      }
      rethrow;
    }
  }
}

class UserProfileUpdateRepository {
  Future<dynamic> userProfileUpdateRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.updateProfileUrl,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("passord change response ${response?.data}");
      var resp = UserProfileUpdateModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("UserProfile Update Repo api not success");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }

  Future<ChangePasswordModel?> changePasswordApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.changepasswordUrl,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("passord change response ${response?.data}");
      var resp = ChangePasswordModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      debugPrint('error $error');
      http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }

  Future<CommonModel?> sendOtpApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.sendOtpsUrl,
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
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
  }

  Future<CommonModel?> verifyOtpApi(
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
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
  }

  Future<CommonModel?> resetPasswordApi(
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
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
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
      http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }

  Future<dynamic> getStateListApi(
      {required BuildContext context,
      required Map<String, String> header,
      required String country}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.locationBaseUrl,
        endURL: AppUrl.getStateList + country,
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
      // return response?.data;
    } catch (error) {
      debugPrint('error.. $error');
      http.handleErrorResponse(context: context, error: error);
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
      return response?.data;
    } catch (error) {
      debugPrint('error.. $error');
      http.handleErrorResponse(context: context, error: error);
      rethrow;
    }
  }
}

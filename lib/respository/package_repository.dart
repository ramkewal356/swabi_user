import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/calculate_price_model.dart';
import 'package:flutter_cab/model/change_mobile_model.dart';
import 'package:flutter_cab/model/get_package_details_by_id_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';

///Get Package List Repo
class GetPackageListRepository {
  Future<GetPackageListModel> getPackageListRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getAllPackageListUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package List Repo Success ${response?.data}");
      var resp = GetPackageListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package List Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

///Get Package Activity By Id Repo
class GetPackageActivityByIdRepository {
  Future<GetPackageDetailByIdModel> getPackageActivityByIdRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getPackageByIdUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Activity By Id Repo Success ${response?.data}");
      var resp = GetPackageDetailByIdModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Activity By Id Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}
class CalculatePriceRepository {
  Future<CalculatePriceModel> getCalculatePriceApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getCalculatePriceUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Activity By Id Repo Success ${response?.data}");
      var resp = CalculatePriceModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Activity By Id Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}
///Post Package Booking By Id Repo
class GetPackageBookedByIdRepository {
  Future<BookPackageByMemberModel> getPackageBookedByIdRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.packageBookingUrl,
        body: body,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
    
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Booked By Id Repo Success ${response?.data}");
      var resp = BookPackageByMemberModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Booked By Id Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }

  Future<BookPackageByMemberModel> confirmPackageBookingRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.confirmpackageBookingUrl,
        queryParameters: query,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
     
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Package Booked By Id Repo Success ${response?.data}");
      var resp = BookPackageByMemberModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package Booked By Id Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

///Get Package History By Id Repo
class GetPackageHistoryRepository {
  Future<GetPackageHistoryModel?> getPackageHistoryRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> data}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getPackagelistUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        isAuthorizeRequest: false,
        queryParameters: data);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('Get Package History Repo Success ${response?.data}');
      var resp = GetPackageHistoryModel.fromJson(response?.data);
      return resp;
    
    } catch (e) {
      debugPrint("Get Package History Repo Field $e");
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

///Get Package History Details By Id Repo
class GetPackageHistoryDetailByIdRepository {
  Future<GetPackageHIstoryDetailsModel?>
      getPackageHistoryDetailByIdRepositoryApi(
          {required BuildContext context,
          required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getpackageBookingByIdUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint(
          "Get Package History Detail By Id Repo Success ${response?.data}");
      // dynamic response = await _apiServices.getGetApiResponse(AppUrl.getPackageList);
      // dynamic response = await _apiServices.getGetApiResponse(
      //     "http://swabi.ap-south-1.elasticbeanstalk.com"
      //     "/package_booking/get_package_booking_by_id?packageBookingId=${data["packageBookingId"]}");
      // print("Get Package History Detail By Id Repo Success");
      var resp = GetPackageHIstoryDetailsModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Package History Detail By Id Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

///Package Cancel Repo
class PackageCancelRepository {
  Future<PackageCancelModel?> packageCancelRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.packageCancellUrl,
        queryParameters: query,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();

      debugPrint("Package Cancel Repo Success");
      var resp = PackageCancelModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Package Cancel Repo Field");
      http.handleErrorResponse(context: context, error: e);
      debugPrint(e.toString());
      rethrow;
    }
  }
}

///Add PickUp Location Repo
class AddPickUpLocationPackageRepository {
  Future<dynamic> addPickUpLocationPackageRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.addPickupLocation,
        queryParameters: query,
        methodType: HttpMethodType.PATCH,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      // dynamic response = await _apiServices.getGetApiResponse(AppUrl.getPackageList);
      // dynamic response = await _apiServices.patchApiResponseWithData(
      //     "http://swabi.ap-south-1.elasticbeanstalk.com"
      //     "/package_booking/add_pickup_location?packageBookingId=${data["packageBookingId"]}&pickupLocation=${data["pickupLocation"]}",
      //     data);
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Add PickUp Location Package Repo Success ${response?.data}");
      return response;
      // return response = AddPickUpLocationModel.fromJson(response);
    } catch (e) {
      debugPrint("Add PickUp Location Package Repo Fieldb$e");
      http.handleErrorResponse(context: context, error: e);

      rethrow;
    }
  }
}

///Get Package Itinerary Repo
class GetPackageItineraryRepository {
  Future<GetPackageItineraryModel> getPackageItineraryRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getItenerypackageBookingIdUrl,
        queryParameters: query,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("GetPackageItinerary Repo Success ${response?.data}");

      var resp = GetPackageItineraryModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("GetPackageItinerary Repo Field$e");
      // http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

///Get Package Itinerary Repo
class ChangeMobileRepository {
  Future<ChangeMobileModel?> changeMobile(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.changeMobileUrl,
        body: body,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response...$response');
      var resp = ChangeMobileModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
  }
}

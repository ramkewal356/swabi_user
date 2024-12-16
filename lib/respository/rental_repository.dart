import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_url.dart';
import 'package:flutter_cab/model/payment_details_model.dart';
import 'package:flutter_cab/model/rentalbooking_model.dart';
import 'package:flutter_cab/view_model/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/base_apiservices.dart';
import '../data/network/network_apiservice.dart';

class RentalRepository {
  Future<RentalCarListStatusModel> rentalRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.rentalCarSearchUrl,
        methodType: HttpMethodType.GET,
        bodyType: HttpBodyType.JSON,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("rentalBooking search Repo api success${response?.data}");
      var resp = RentalCarListStatusModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      // print("rental api not successful error");
      // print(e);
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
}

///Rental Booking Repo
class RentalBookingRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  Future<RentalCarBookingModel?> rentalBookingApi(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    var prefsToken = await SharedPreferences.getInstance();
    dynamic token = prefsToken.getString('token');
    Map<String, String> headerData = {
      "Content-Type": "application/json",
      "token": token,
    };
    var http = HttpService(
        isAuthorizeRequest: false,
        headers: headerData,
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.rentalCarBookingUrl,
        methodType: HttpMethodType.POST,
        bodyType: HttpBodyType.JSON,
        body: body);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("rentalBooking Repo api success${response?.data}");
      var resp = RentalCarBookingModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      print({'error..': error});
      http.handleErrorResponse(context: context, error: error);
    }
    return null;
  }

  Future<RentalCarBookingModel> confirmRentalBookingRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.confirmRentalBookingUrl,
        queryParameters: query,
        methodType: HttpMethodType.PUT,
        bodyType: HttpBodyType.JSON,
        isAuthorizeRequest: false);
    try {
      
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("Get Rental Booked By Id Repo Success ${response?.data}");
      var resp = RentalCarBookingModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      debugPrint("Get Rental Booked By Id Repo Field $e");
      http.handleErrorResponse(context: context, error: e);
      rethrow;
    }
  }
  
}

///Rental Booking Cancel Repo
class RentalBookingCancelRepository {
  Future<RentalCarBookingCancelModel> rentalBookingCancelRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.rentalCancellUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();

      debugPrint("rentalBooking cancel Repo api success ${response?.data}");
      var resp = RentalCarBookingCancelModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      // ignore: use_build_context_synchronously
      http.handleErrorResponse(context: context, error: e);
      debugPrint('cancel bookingbooking $e');
      rethrow;
    }
  }
}

///Rental Booking List Repo
class RentalBookingListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<RentalCarBookingListModel> rentalBookingListRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getRentalByUserIdUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("rentalBooking Repo api success${response?.data}");
     
      var resp = RentalCarBookingListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      http.handleErrorResponse(context: context, error: e);
      debugPrint('rentalBooking Repo api not successful error $e');
      rethrow;
    }
  }
}

///Rental View Single Detail Repo
class RentalViewDetailsRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<RentalDetailsSingleModel> rentalViewDetailsRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.getRentalByIdUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("rental View Detail Repo api success${response?.data}");
      // dynamic response = await _apiServices
      //     .getGetApiResponse("http://swabi.ap-south-1.elasticbeanstalk.com"
      //         "/rental/get_rental_booking_by_id?id=${data["id"]}");
      // print("rental View Detail Repo api success");
      var resp = RentalDetailsSingleModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      http.handleErrorResponse(context: context, error: e);
      debugPrint('rental View Detail api not successful error $e');
      rethrow;
    }
  }
}

///Rental View Single payment Detail Repo
class RentalViewPaymentDetailsRepository {
  Future<PaymentDetailsModel?> paymentDetailsApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.paymentDetailUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        isAuthorizeRequest: false);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      print('response..${response?.data}');
      var resp = PaymentDetailsModel.fromJson(response?.data);
      return resp;
    } catch (error) {
      print({'error..': error});
      http.handleErrorResponse(
        context: context,
        error: error,
      );
    }

    return null;
  }
}

///Rental Validation  Repo
class RentalValidationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> rentalValidationRepositoryApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    var http = HttpService(
        baseURL: AppUrl.baseUrl,
        endURL: AppUrl.checkRentalBookingByDateUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET,
        isAuthorizeRequest: false,
        queryParameters: query);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("rental Validation Repo Success${response?.data}");

      var resp = RentalCarBookingValidationModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      // http.handleErrorResponse(context: context, error: e);
      debugPrint('rental Validation Repo Field $e');
      rethrow;
    }
  }
}

///Get Rental Range List  Repo
class GetRentalRangeListRepository {
  // final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getRentalRangeListRepositoryApi({
    required BuildContext context,
  }) async {
    var http = HttpService(
      baseURL: AppUrl.baseUrl,
      endURL: AppUrl.getRentalmatricsListUrl,
      bodyType: HttpBodyType.JSON,
      methodType: HttpMethodType.GET,
      isAuthorizeRequest: false,
    );
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint("get rental Matrics List Repo Success${response?.data}");

      var resp = GetRentalRangeListModel.fromJson(response?.data);
      return resp;
    } catch (e) {
      http.handleErrorResponse(context: context, error: e);
      debugPrint('get rental Matrics List Repo Field $e');
      rethrow;
    }
  }
}

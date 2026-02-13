import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/get_trasactionbyid_model.dart';
import 'package:flutter_cab/data/models/payment_getway_model.dart';
import 'package:flutter_cab/data/models/payment_refund_model.dart';
import 'package:flutter_cab/data/repositories/payment_gateway_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

/// Rental Booking View Model
class PaymentCreateOrderIdViewModel with ChangeNotifier {
  final _myRepo = PaymentCreateOrderIDRepository();
  ApiResponse<PaymentCreateOderIdModel> paymentOrderID = ApiResponse.initial();
  void setDataList(ApiResponse<PaymentCreateOderIdModel> response) {
    paymentOrderID = response;
    notifyListeners();
  }

  Future<PaymentCreateOderIdModel?> paymentCreateOrderIdViewModelApi(
      {required double amount,
      required double taxAmount,
      required double taxPercentage,
      required double discountAmount,
      required double totalPayableAmount,
      required String currency}) async {
    String? userId = await UserViewModel().getUserId();
    Map<String, dynamic> body = {
      "price": amount,
      "taxAmount": taxAmount.toStringAsFixed(2),
      "userId": userId,
      "taxPercentage": taxPercentage.toInt(),
      "discountAmount": discountAmount.toStringAsFixed(2),
      "totalPayableAmount": totalPayableAmount.round(),
      "currency": currency
    };
    try {
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.paymentCreateOrderIdApi(body: body);
      setDataList(ApiResponse.completed(resp));
      return resp;
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
      debugPrint('$e');
    } finally {
      setDataList(ApiResponse.error(''));
    }
    return null;
  }
}

/// Rental Booking View Model
class PaymentVerifyViewModel with ChangeNotifier {
  final _myRepo = PaymentVerifyRepository();
  ApiResponse<PaymentVerifyModel> paymentVerify = ApiResponse.initial();
  void setDataList(ApiResponse<PaymentVerifyModel> response) {
    paymentVerify = response;
    notifyListeners();
  }

  Future<PaymentVerifyModel?> paymentVerifyViewModelApi(
      {required BuildContext context,
      required String userId,
      required String venderId,
      required String? paymentId,
      required String? razorpayOrderId,
      required String? razorpaySignature}) async {
    Map<String, dynamic> body = {
      "userId": userId,
      "paymentId": paymentId,
      "vendorId": venderId,
      "razorpayOrderId": razorpayOrderId,
      "razorpaySignature": razorpaySignature
    };
    try {
      debugPrint('bodyofpaymentverification..$body');
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.paymentVerifyApi(context: context, body: body);
      setDataList(ApiResponse.completed(resp));

      // Utils.flushBarSuccessMessage("Payment paymentVerify Success", context);
      return resp;
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }
}

class GetTranactionViewModel with ChangeNotifier {
  final _myRepo = PaymentTrasactionRespository();
  ApiResponse<GetTransactionByIdModel> getTrasaction = ApiResponse.initial();
  void setDataList(ApiResponse<GetTransactionByIdModel> response) {
    getTrasaction = response;
    notifyListeners();
  }

  Future<GetTransactionByIdModel?> getTranactionApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    try {
      debugPrint('bodyofpaymentverification..$query');
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.getTrasactionByIdApi(context: context, query: query);
      setDataList(ApiResponse.completed(resp));
      // Utils.flushBarSuccessMessage("Payment paymentVerify Success", context);
      return resp;
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }

  Future<GetTransactionByIdModel?> getRefundTranactionApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    try {
      debugPrint('bodyofpaymentverification..$query');
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.getRefundTrasactionByIdApi(
          context: context, query: query);
      setDataList(ApiResponse.completed(resp));
      // Utils.flushBarSuccessMessage("Payment paymentVerify Success", context);
      return resp;
    } catch (e) {
      debugPrint('$e');
    }
    return null;
  }
}

class GetPaymentRefundViewModel with ChangeNotifier {
  final _myRepo = PaymentRefundRespository();
  ApiResponse<PaymentRefundModel> getPaymentRefund = ApiResponse.initial();
  void setDataList(ApiResponse<PaymentRefundModel> response) {
    getPaymentRefund = response;
    notifyListeners();
  }

  Future<PaymentRefundModel?> getPaymentRefundApi(
      {required BuildContext context, required String paymentId}) async {
    Map<String, dynamic> query = {"paymentId": paymentId};
    try {
      debugPrint('refundQuery..$query');
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.getRefundPaymentApi(context: context, query: query);
      setDataList(ApiResponse.completed(resp));
      // Utils.flushBarSuccessMessage("Payment paymentVerify Success", context);
      return resp;
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
      debugPrint('$e');
    }
    return null;
  }
}

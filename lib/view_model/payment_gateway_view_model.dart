import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/get_trasactionbyid_model.dart';
import 'package:flutter_cab/model/payment_getway_model.dart';
import 'package:flutter_cab/model/payment_refund_model.dart';
import 'package:flutter_cab/respository/payment_gateway_repository.dart';


/// Rental Booking View Model
class PaymentCreateOrderIdViewModel with ChangeNotifier {
  final _myRepo = PaymentCreateOrderIDRepository();
  ApiResponse<PaymentCreateOderIdModel> paymentOrderID = ApiResponse.loading();
  setDataList(ApiResponse<PaymentCreateOderIdModel> response) {
    paymentOrderID = response;
    notifyListeners();
  }

  Future<PaymentCreateOderIdModel?> paymentCreateOrderIdViewModelApi(
      {required BuildContext context,
      required double amount,
      required String userId,
      required double taxAmount,
      required double taxPercentage,
      required double discountAmount,
      required double totalPayableAmount}) async {
    Map<String, dynamic> body = {
      "price": amount,
      "taxAmount": taxAmount.toStringAsFixed(2),
      "userId": userId,
      "taxPercentage": taxPercentage,
      "discountAmount": discountAmount.toStringAsFixed(2),
      "totalPayableAmount": totalPayableAmount.ceil()
    };
    try {
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.paymentCreateOrderIdApi(context: context, body: body);
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
  ApiResponse<PaymentVerifyModel> paymentVerify = ApiResponse.loading();
  setDataList(ApiResponse<PaymentVerifyModel> response) {
    paymentVerify = response;
    notifyListeners();
  }

  Future<PaymentVerifyModel?> paymentVerifyViewModelApi(
      {required BuildContext context,
      required String userId,
      required String? paymentId,
      required String? razorpayOrderId,
      required String? razorpaySignature}) async {
    Map<String, dynamic> body = {
      "userId": userId,
      "paymentId": paymentId,
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
  ApiResponse<GetTransactionByIdModel> getTrasaction = ApiResponse.loading();
  setDataList(ApiResponse<GetTransactionByIdModel> response) {
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
  ApiResponse<PaymentRefundModel> getPaymentRefund = ApiResponse.loading();
  setDataList(ApiResponse<PaymentRefundModel> response) {
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

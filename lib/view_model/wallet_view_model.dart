import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/create_wallet_payment_order_model.dart';
import 'package:flutter_cab/data/models/transaction_model.dart';
import 'package:flutter_cab/data/repositories/wallet_repository.dart';
import 'package:flutter_cab/data/response/api_response.dart';

class WalletViewModel with ChangeNotifier {
  final _myRepo = WalletRepository();
  ApiResponse<bool> viewBidPaymentData = ApiResponse.initial();
  void setViewBidPaymentData(ApiResponse<bool> response) {
    viewBidPaymentData = response;
    notifyListeners();
  }
  ApiResponse<TransactionModel> getTransactionResponse = ApiResponse.initial();
  void setTransactionData(ApiResponse<TransactionModel> response) {
    getTransactionResponse = response;
    notifyListeners();
  }
  Future<bool> viewBidPaymentApi({required Map<String, dynamic> body}) async {
    try {
      setViewBidPaymentData(ApiResponse.loading());
      var resp = await _myRepo.viewBidPaymentApi(body: body);
      setViewBidPaymentData(ApiResponse.completed(resp));
      return resp;
    } catch (e) {
      debugPrint('error $e');
      setViewBidPaymentData(ApiResponse.error(e.toString()));
      return false;
    }
  }

  Future<void> getTransactionApi() async {
    try {
      setTransactionData(ApiResponse.loading());
      var resp = await _myRepo.getTranasactionApi();
      setTransactionData(ApiResponse.completed(resp));
    } catch (e) {
      debugPrint('error $e');
      setTransactionData(ApiResponse.error(e.toString()));
    }
  }

  ApiResponse<CreateWalletPaymentOrderModel?> createPaymentOrderResponse =
      ApiResponse.initial();
  void setCreatePaymentOrderResponse(
      ApiResponse<CreateWalletPaymentOrderModel?> response) {
    createPaymentOrderResponse = response;
    notifyListeners();
  }

  Future<CreateWalletPaymentOrderModel?> createWalletPaymentOrderApi(
      {required Map<String, dynamic> query}) async {
    try {
      setCreatePaymentOrderResponse(ApiResponse.loading());
      final result = await _myRepo.createPaymentOrderApi(query: query);
      setCreatePaymentOrderResponse(ApiResponse.completed(result));
      return result;
    } catch (e) {
      debugPrint('Create Wallet Payment Order Error: $e');
      setCreatePaymentOrderResponse(ApiResponse.error(e.toString()));
      return null;
    }
  }

  ApiResponse<bool?> verifyPaymentResponse = ApiResponse.initial();
  void setVerifyPaymentResponse(ApiResponse<bool?> response) {
    verifyPaymentResponse = response;
    notifyListeners();
  }

  Future<bool?> verifyPaymentApi({required Map<String, dynamic> body}) async {
    try {
      setVerifyPaymentResponse(ApiResponse.loading());
      final result = await _myRepo.verifyPaymentApi(body: body);
      setVerifyPaymentResponse(ApiResponse.completed(result));
      return result;
    } catch (e) {
      debugPrint('Verify Payment Error: $e');
      setVerifyPaymentResponse(ApiResponse.error(e.toString()));
      return null;
    }
  }
}

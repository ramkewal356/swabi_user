import 'package:flutter/material.dart';
import 'package:flutter_cab/data/repositories/wallet_repository.dart';
import 'package:flutter_cab/data/response/api_response.dart';

class WalletViewModel with ChangeNotifier {
  final _myRepo = WalletRepository();
  ApiResponse<bool> viewBidPaymentData = ApiResponse.initial();
  void setViewBidPaymentData(ApiResponse<bool> response) {
    viewBidPaymentData = response;
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
}

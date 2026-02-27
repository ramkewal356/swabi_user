import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/subscription_model.dart';
import 'package:flutter_cab/data/repositories/subscription_repository.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class SubscriptionViewModel with ChangeNotifier {
  // Dependencies
  // import 'package:flutter_cab/data/repositories/subscription_repository.dart';
  // import 'package:flutter_cab/data/models/subscription_model.dart';
  // import 'package:flutter_cab/core/api_response.dart';

  // Add your repository and response variables
  final SubscriptionRepository _subscriptionRepository =
      SubscriptionRepository();

  ApiResponse<List<SubscriptionModel>>? _subscriptionResponse;
  ApiResponse<List<SubscriptionModel>>? get subscriptionResponse =>
      _subscriptionResponse;

  ApiResponse<SubscriptionModel>? _subscriptionByVendorResponse;
  ApiResponse<SubscriptionModel>? get subscriptionByVendorResponse =>
      _subscriptionByVendorResponse;

  void _setSubscriptionResponse(ApiResponse<List<SubscriptionModel>> response) {
    _subscriptionResponse = response;
    notifyListeners();
  }

  void _setSubscriptionByVendorResponse(
      ApiResponse<SubscriptionModel> response) {
    _subscriptionByVendorResponse = response;
    notifyListeners();
  }

  Future<void> fetchSubscriptions() async {
    _setSubscriptionResponse(ApiResponse.loading());
    try {
      // final subscription = await _subscriptionRepository.getSubscriptionApi();
      final subscription = await _subscriptionRepository.getSubscriptions();

      _setSubscriptionResponse(ApiResponse.completed(subscription));
    } catch (e) {
      _setSubscriptionResponse(ApiResponse.error(e.toString()));
    }
  }

  Future<void> fetchSubscriptionByVendorId() async {
    String? vendorId = await UserViewModel().getUserId();
    _setSubscriptionByVendorResponse(ApiResponse.loading());
    try {
      final subscription =
          await _subscriptionRepository.getSubscriptionByVendorIdApi(
        vendorId: vendorId ?? '',
      );
      _setSubscriptionByVendorResponse(ApiResponse.completed(subscription));
    } catch (e) {
      _setSubscriptionByVendorResponse(ApiResponse.error(e.toString()));
    }
  }
}

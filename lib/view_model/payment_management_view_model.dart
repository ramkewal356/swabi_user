import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/payment_details_model.dart';
import 'package:flutter_cab/data/models/payment_transaction_model.dart' as pt;
import 'package:flutter_cab/data/models/refunded_payment_details_model.dart';
import 'package:flutter_cab/data/repositories/payment_management_repository.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:flutter_cab/data/models/refund_transaction_model.dart' as rt;

class PaymentManagementViewModel with ChangeNotifier {
  final _myRepo = PaymentManagementRepository();
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;

  // Payment Transaction List
  ApiResponse<List<pt.Content>> getTransactionList = ApiResponse.initial();
  List<pt.Content> _allTransactionItems = []; // For paginated accumulation

  void setTransaction(
    ApiResponse<List<pt.Content>> response,
  ) {
    getTransactionList = response;
    notifyListeners();
  }

  Future<void> getTransactionListApi({
    required bool isFilter,
    required bool isSearch,
    required bool isPagination,
    String? bookingType,
    String? status,
    String? searchQuery,
    int? page,
    int? size,
  }) async {
    if (isLoadingMore) return;
    bool isNewSort = (isSearch || isFilter);
    if (isNewSort && !isPagination) {
      pageNumber = 0;
      _allTransactionItems.clear();
      isLastPage = false;
      notifyListeners();
      setTransaction(ApiResponse.loading());
    }
    if (isLastPage) return;
    isLoadingMore = true;
    notifyListeners();

    String? vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'bookingType': bookingType,
      'transactionStatus': status,
      'search': searchQuery,
      "vendorId": vendorId
    };

    try {
      var resp = await _myRepo.getPaymentTransactionListApi(query: query);

      final List<pt.Content> newItems = resp.data?.content ?? [];
      final List<pt.Content> allItems =
          (pageNumber == 0) ? newItems : [..._allTransactionItems, ...newItems];
      _allTransactionItems = allItems;
      final bool lastPage = resp.data?.last ?? false;

      isLastPage = lastPage;
      setTransaction(
          ApiResponse.completed(List<pt.Content>.from(_allTransactionItems)));
      pageNumber++;
    } catch (e) {
      setTransaction(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // Refund Transaction List
  ApiResponse<List<rt.Content>> getRefundList = ApiResponse.initial();
  List<rt.Content> _allRefundItems = []; // For paginated accumulation

  void setRefundTransaction(ApiResponse<List<rt.Content>> response,
      {bool notify = true}) {
    getRefundList = response;
    if (notify) notifyListeners();
  }

  Future<void> getRefundListApi({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
    String? bookingType,
    String? status,
    String? searchQuery,
    int? page,
    int? size,
  }) async {
    if (isLoadingMore) return;
    // Set up pagination, filtering, and search values
    bool isNewSort = (isSearch || isFilter);
    if (isNewSort && !isPagination) {
      setRefundTransaction(ApiResponse.loading());
      pageNumber = 0;
      _allRefundItems.clear();
      isLastPage = false;
      notifyListeners();
    }
    if (isLastPage) return;
    isLoadingMore = true;
    notifyListeners();

    String? vendorId = await UserViewModel().getUserId() ?? '';

    Map<String, dynamic> query = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'bookingType': bookingType,
      'refundStatus': status,
      'search': searchQuery,
      "vendorId": vendorId
    };

    try {
      final refundTransactionModel = await _myRepo.getRefundListApi(
        query: query,
      );
      final List<rt.Content> newItems =
          refundTransactionModel.data?.content ?? [];
      final List<rt.Content> allItems =
          (pageNumber == 0) ? newItems : [..._allRefundItems, ...newItems];
      final bool lastPage = refundTransactionModel.data?.last ?? false;
      _allRefundItems = allItems;
      isLastPage = lastPage;
      setRefundTransaction(
          ApiResponse.completed(List<rt.Content>.from(_allRefundItems)));
      pageNumber++;
    } catch (e) {
      setRefundTransaction(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // Get Payment Details by Payment ID
  ApiResponse<PaymentDetailsModel> _paymentDetails = ApiResponse.initial();
  ApiResponse<PaymentDetailsModel> get paymentDetails => _paymentDetails;

  void setPaymentDetails(ApiResponse<PaymentDetailsModel> response) {
    _paymentDetails = response;
    notifyListeners();
  }

  Future<void> fetchPaymentDetails({
    required String paymentId,
  }) async {
    setPaymentDetails(ApiResponse.loading());
    try {
      Map<String, dynamic> query = {
        'paymentId': paymentId,
      };
      final paymentDetailsModel =
          await _myRepo.getPaymentDetailsApi(query: query);
      setPaymentDetails(ApiResponse.completed(paymentDetailsModel));
    } catch (e) {
      setPaymentDetails(ApiResponse.error(e.toString()));
    }
  }

  // Get Refund Payment Details by Refund ID
  ApiResponse<RefundedPaymentDetailsModel> _refundPaymentDetails =
      ApiResponse.initial();
  ApiResponse<RefundedPaymentDetailsModel> get refundPaymentDetails =>
      _refundPaymentDetails;

  void setRefundPaymentDetails(
      ApiResponse<RefundedPaymentDetailsModel> response) {
    _refundPaymentDetails = response;
    notifyListeners();
  }

  Future<void> fetchRefundPaymentDetails({
    required String paymentId,
  }) async {
    setRefundPaymentDetails(ApiResponse.loading());
    try {
      Map<String, dynamic> query = {
        'paymentId': paymentId,
      };
      final refundPaymentDetailsModel =
          await _myRepo.getRefundPaymentDetailsApi(query: query);
      setRefundPaymentDetails(ApiResponse.completed(refundPaymentDetailsModel));
    } catch (e) {
      setRefundPaymentDetails(ApiResponse.error(e.toString()));
    }
  }
}

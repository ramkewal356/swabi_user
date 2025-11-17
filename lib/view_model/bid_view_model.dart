import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/get_all_bid_model.dart';
import 'package:flutter_cab/data/models/get_bid_by_id_model.dart';
import 'package:flutter_cab/data/repositories/bid_repository.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/view_model/bid_accept_or_reject_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class BidViewModel with ChangeNotifier {
  int page = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false; 

  final _myRepo = BidRepository();
  ApiResponse<List<BidContent>> bidData = ApiResponse.initial();
  void setBidData(ApiResponse<List<BidContent>> response) {
    bidData = response;
    notifyListeners();
  }

  ApiResponse<GetBidByIdModel> bidByIdData = ApiResponse.initial();
  void setBidByIdData(ApiResponse<GetBidByIdModel> response) {
    bidByIdData = response;
    notifyListeners();
  }

  ApiResponse<bool> updateBid = ApiResponse.initial();
  void updateBidData(ApiResponse<bool> response) {
    updateBid = response;
    notifyListeners();
  }

  ApiResponse<bool> confirmBookingBid = ApiResponse.initial();
  void bookBid(ApiResponse<bool> response) {
    confirmBookingBid = response;
    notifyListeners();
  }

  ApiResponse<BidAcceptOrRejectModel> acceptOrRejectBid = ApiResponse.initial();
  void acceptOrRejectBids(ApiResponse<BidAcceptOrRejectModel> response) {
    acceptOrRejectBid = response;
    notifyListeners();
  }

  Future<void> getAllBidsApi(
      {required bool isFilter,
      required bool isSearch,
      required bool isPagination,
      required String searchText,
      required String filterText}) async {
    if (isLoadingMore) return; // Prevent multiple calls
    bool newSearch = (isFilter || isSearch);
    if (!isPagination && newSearch) {
      page = 0;
      isLastPage = false; 
    
      setBidData(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "page": page,
      "query": searchText,
      "bidStatus": filterText
    };

    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getAllBidsApi(query: query, vendorId: vendorId);
      List<BidContent> newBids = resp.content ?? [];
      List<BidContent> allBids =
          (page == 0) ? newBids : [...bidData.data ?? [], ...newBids];

      isLastPage = resp.last ?? false; // Check if it's the last page
      page++; // Increment page for next request
      setBidData(ApiResponse.completed(allBids));

      // debugPrint("Bid Resp api success ${resp.content}");
    } catch (e) {
      debugPrint('error $e');
      setBidData(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false; // Reset loading state after request
    }
  }

  Future<void> getBidByIdApi({required String? bidId}) async {
    if (bidId == null || bidId.isEmpty) {
      setBidByIdData(ApiResponse.error("Bid ID cannot be null or empty"));
      return;
    }
    try {
      setBidByIdData(ApiResponse.loading());
      var resp = await _myRepo.getBidByIdApi(bidId: bidId);
      setBidByIdData(ApiResponse.completed(resp));
      debugPrint("Get Bid By Id Api success ${resp.toJson()}");
    } catch (e) {
      debugPrint('error $e');
      setBidByIdData(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateBidApi(
      {required String price,
      required String accommodation,
      required String meals,
      required String transportation,
      required String extra,
      required String itinerary,
      required int bidId}) async {
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> body = {
      "price": price,
      "accommodation": accommodation,
      "meals": meals,
      "transportation": transportation,
      "extras": extra,
      "itinerary": itinerary,
      "bidId": bidId,
      "vendorId": vendorId
    };
    updateBidData(ApiResponse.loading());
    try {
      var resp = await _myRepo.updateBidApi(
          body: body, vendorId: vendorId, bidId: bidId);
      if (resp == true) {
        updateBidData(ApiResponse.completed(resp));
        debugPrint("Update Bid Api success");
        Utils.toastSuccessMessage(
          "Bid updated successfully",
        );
      } else {
        updateBidData(ApiResponse.error(resp.toString()));
      }
    } catch (e) {
      debugPrint('error $e');
      updateBidData(ApiResponse.error(e.toString()));
    }
  }

  Future<bool?> confirmBookingBidApi(
      {required int bidId,
      required String paymentId,
      required String orderId,
      required String signature,
      required String transactionStatus,
      required int vendorId}) async {
    Map<String, dynamic> body = {
      "bidId": bidId,
      "paymentId": paymentId,
      "razorpayOrderId": orderId,
      "razorpaySignature": signature,
      "transactionStatus": transactionStatus,
      "vendorId": vendorId
    };
    try {
      bookBid(ApiResponse.loading());
      var resp = await _myRepo.confirmBookingBidApi(body: body);
      bookBid(ApiResponse.completed(resp));
      return resp;
    } catch (e) {
      bookBid(ApiResponse.error(e.toString()));
    }
    return null;
  }

  Future<void> acceptOrRejectBidApi(
      {required int bidId, required bool accept}) async {
    try {
      acceptOrRejectBids(ApiResponse.loading());
      var resp =
          await _myRepo.acceptOrRejectBidApi(bidId: bidId, accept: accept);
      acceptOrRejectBids(ApiResponse.completed(resp));
      if (resp.status?.message == 'Bid Accepted') {
        Utils.toastSuccessMessage(resp.status?.message ?? '');
      } else {
        Utils.toastMessage(resp.status?.message ?? '');
      }
    } catch (e) {
      acceptOrRejectBids(ApiResponse.error(e.toString()));
    }
  }
}

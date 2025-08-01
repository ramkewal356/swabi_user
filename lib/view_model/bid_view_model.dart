import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';

import 'package:flutter_cab/model/get_all_enquiry_model.dart';
import 'package:flutter_cab/respository/bid_repository.dart';

class BidViewModel with ChangeNotifier {
  int page = 0; // Track the current page
  int pageSize = 10; // Number of items per page
  bool isLastPage = false; // Track if the last page has been reached
  bool isLoadingMore = false; // Track if more data is being loaded

  final _myRepo = BidRepository();
  ApiResponse<List<EnquiryContent>> bidData = ApiResponse.initial();
  setBidData(ApiResponse<List<EnquiryContent>> response) {
    bidData = response;
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
      page = 0; // Reset page if not paginating
      isLastPage = false; // Reset last page status
      bidData.data?.clear(); // Clear existing data
      setBidData(ApiResponse.loading());
    }
    Map<String, dynamic> query = {
      "page": page,
      "query": searchText,
      "status": filterText
    };

    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getAllBidsApi(query: query);
      List<EnquiryContent> newBids = resp.data?.content ?? [];
      List<EnquiryContent> allBids =
          (page == 0) ? newBids : [...bidData.data ?? [], ...newBids];

      isLastPage = resp.data?.last ?? false; // Check if it's the last page
      page++; // Increment page for next request
      setBidData(ApiResponse.completed(allBids));

      debugPrint("Bid Resp api success ${resp.data}");
    } catch (e) {
      debugPrint('error $e');
      setBidData(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false; // Reset loading state after request
    }
  }
}

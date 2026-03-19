import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
// import 'package:flutter_cab/model/rental_booking_model.dart';
import 'package:flutter_cab/data/repositories/rental_management_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

import '../data/models/rental_model.dart';

class RentalManagementViewModel with ChangeNotifier {
  int page = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  final _myRepo = RentalManagementRepository();
  ApiResponse<List<RentalContent>> getRentalData = ApiResponse.initial();
  void setRentalData(ApiResponse<List<RentalContent>> response) {
    getRentalData = response;
    notifyListeners();
  }

  Future<void> getAllRentalApi(
      {required bool isFilter,
      required bool isSearch,
      required bool isPagination,
      required String searchText,
      required String sortDirection,
      required String bookingStatus,
      required bool isSort,
      required String userId}) async {
    if (isLoadingMore) return; // Prevent multiple calls
    bool newSearch = (isFilter || isSearch || isSort);
    if (!isPagination && newSearch) {
      page = 0; // Reset page if not paginating
      isLastPage = false; // Reset last page status

      setRentalData(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "vendorId": vendorId,
      "pageNumber": page,
      "pageSize": pageSize,
      "search": searchText,
      "sortBy": "id",
      "sortDirection": sortDirection,
      "bookingStatus": bookingStatus,
      if (userId.isNotEmpty) "userId": userId
    };

    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getAllRentalListRepositoryApi(query: query);
      List<RentalContent> newBids = resp.data?.content ?? [];
      List<RentalContent> allBids =
          (page == 0) ? newBids : [...getRentalData.data ?? [], ...newBids];

      isLastPage = resp.data?.last ?? false; // Check if it's the last page
      page++; // Increment page for next request
      setRentalData(ApiResponse.completed(allBids));

      debugPrint("Bid Resp api success ${resp.data}");
    } catch (e) {
      debugPrint('error $e');
      setRentalData(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false; // Reset loading state after request
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/rental_price_list_model.dart';
import 'package:flutter_cab/data/repositories/rental_price_,magement .dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class RentalPriceManagementViewModel with ChangeNotifier {
  int page = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  final _priceRepo = RentalPriceManagementRepository();
  ApiResponse<List<RentalPriceContent>> rentalPriceData = ApiResponse.initial();

  void setRentalPriceData(ApiResponse<List<RentalPriceContent>> response) {
    rentalPriceData = response;
    notifyListeners();
  }

  ApiResponse<bool> addEditRentalPrice = ApiResponse.initial();

  void setAddEditRentalPrice(ApiResponse<bool> response) {
    addEditRentalPrice = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> activateDeactivateRentalPrice =
      ApiResponse.initial();

  void setActivateDeactivateRentalPrice(ApiResponse<CommonModel> response) {
    activateDeactivateRentalPrice = response;
    notifyListeners();
  }

  /// Fetch rental price list with search, filter, and pagination
  Future<void> getRentalPriceListApi({
    required bool isFilter,
    required bool isSearch,
    required bool isPagination,
    required String searchText,
    required String statusText,
  }) async {
    if (isLoadingMore) return;
    bool newSearch = (isFilter || isSearch);
    if (!isPagination && newSearch) {
      page = 0;
      isLastPage = false;
      setRentalPriceData(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "vendorId": vendorId,
      "pageNumber": page,
      "pageSize": pageSize,
      "search": searchText,
      "status": statusText,
    };
    if (isLastPage) return;
    isLoadingMore = true;
    try {
      final resp = await _priceRepo.getRentalPriceList(query: query);
      List<RentalPriceContent> newList = resp?.data?.content ?? [];
      List<RentalPriceContent> allList =
          (page == 0) ? newList : [...rentalPriceData.data ?? [], ...newList];

      isLastPage = resp?.data?.last ?? false;
      page++;
      setRentalPriceData(ApiResponse.completed(allList));
      debugPrint("Rental price list fetch api success ${resp?.data}");
    } catch (e) {
      debugPrint('RentalPriceList Fetch Error $e');
      setRentalPriceData(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Add or Edit rental price using the repository API and handle loader state.
  Future<void> addEditRentalPriceApi({
    required Map<String, dynamic> data,
    bool isEdit = false,
    required Function(bool success, String? errorMsg) onComplete,
  }) async {
    String? vendorId = await UserViewModel().getUserId();
    if (!isEdit) {
      data["vendorId"] = vendorId;
    }
    setAddEditRentalPrice(ApiResponse.loading());
    try {
      final result = await _priceRepo.addEditRentalPrice(
        data: data,
        isEdit: isEdit,
      );
      if (result) {
        setAddEditRentalPrice(ApiResponse.completed(true));
        onComplete(true, null);
      } else {
        setAddEditRentalPrice(ApiResponse.error(
            "Failed to ${isEdit ? 'edit' : 'add'} rental price."));
        onComplete(false, "Failed to ${isEdit ? 'edit' : 'add'} rental price.");
      }
    } catch (e) {
      setAddEditRentalPrice(ApiResponse.error(e.toString()));
      onComplete(false, e.toString());
    }
  }

  /// Activate or Deactivate a rental price entry using the repository API.
  Future<void> activateDeactivateRentalPriceApi({
    required int id,
    required bool isActivate,
    required Function(bool success, String? errorMsg) onComplete,
  }) async {
    setActivateDeactivateRentalPrice(ApiResponse.loading());
    try {
      final resp =
          await _priceRepo.activateRentalPrice(id: id, isActivate: isActivate);
      if (resp.data?.statusCode == "200") {
        setActivateDeactivateRentalPrice(ApiResponse.completed(resp));
        onComplete(true, null);
      } else {
        setActivateDeactivateRentalPrice(
            ApiResponse.error(resp.status?.message ?? 'Operation failed'));
        onComplete(false, resp.status?.message ?? 'Operation failed');
      }
    } catch (e) {
      setActivateDeactivateRentalPrice(ApiResponse.error(e.toString()));
      onComplete(false, e.toString());
    }
  }
}

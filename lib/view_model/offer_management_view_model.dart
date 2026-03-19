import 'package:flutter/material.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/offer_list_model.dart';
import 'package:flutter_cab/data/repositories/offer_management_repository.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class OfferManagementViewModel with ChangeNotifier {
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  final _offerRepository = OfferManagementRepository();

  ApiResponse<List<Content>> offerListResponse = ApiResponse.initial();
  List<Content> _offerList = [];
  // Setter method to update the offer list response and notify listeners
  void setOfferListResponse(ApiResponse<List<Content>> response) {
    offerListResponse = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> activeDeactiveResponse = ApiResponse.initial();
  void setOfferResponse(ApiResponse<CommonModel> response) {
    activeDeactiveResponse = response;
    notifyListeners();
  }

  ApiResponse<bool> addOrEditOfferResponse = ApiResponse.initial();
  void setAddOrEditOfferResponse(ApiResponse<bool> response) {
    addOrEditOfferResponse = response;
    notifyListeners();
  }

  // Method to call the get offer list API and handle the response
  Future<void> getOfferListApi(
      {required bool isSearch,
      required bool isFilter,
      required bool isPagination,
      required String offerStatus,
      required String search}) async {
    if (isLoadingMore) return;
    bool newSearch = (isSearch || isFilter);
    if (newSearch && !isPagination) {
      pageNumber = 0;
      _offerList.clear();
      isLastPage = false;
      notifyListeners();
      setOfferListResponse(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "offerStatus": offerStatus,
      "vendorId": vendorId,
      "search": search,
    };
    if (isLastPage) return;
    isLoadingMore = true;
    notifyListeners();
    try {
      final result = await _offerRepository.getOfferListApi(query: query);
      final List<Content> newData = result.data?.content ?? [];
      final List<Content> allData =
          (pageNumber == 0) ? newData : [..._offerList, ...newData];
      _offerList = allData;
      isLastPage = result.data?.last ?? false;
      setOfferListResponse(ApiResponse.completed(allData));
      pageNumber++;
    } catch (error) {
      setOfferListResponse(ApiResponse.error(error.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  // Method to add a new offer
  Future<bool> addOrEditOffer(
      {required Map<String, dynamic> offerData, required bool isEdit}) async {
    try {
      setAddOrEditOfferResponse(ApiResponse.loading());
      var resp = await _offerRepository.addOrEditOfferApi(
          data: offerData, isEdit: isEdit);
      setAddOrEditOfferResponse(ApiResponse.completed(resp));
      return resp;
    } catch (error) {
      setAddOrEditOfferResponse(ApiResponse.error(error.toString()));
      rethrow;
    }
  }

  // Method to activate or deactivate an offer, and set offer response with API result
  Future<void> activateOrDeactivateOffer(
      {required String offerId, bool isActivate = false}) async {
    setOfferResponse(ApiResponse.loading());
    try {
      var resp = await _offerRepository.activateAndDeactivateOfferApi(
          offerId: offerId, isActivate: isActivate);
      setOfferResponse(ApiResponse.completed(resp));
      if (resp.data?.statusCodeValue == 200) {
        Utils.toastSuccessMessage(resp.data?.body ?? '');
      }
    } catch (error) {
      setOfferResponse(ApiResponse.error(error.toString()));
      rethrow;
    }
  }
}

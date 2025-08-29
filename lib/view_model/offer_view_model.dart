// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/model/get_activity_offer_model.dart';
import 'package:flutter_cab/model/offer_detail_by_id_model.dart';
import 'package:flutter_cab/model/offer_list_model.dart';
import 'package:flutter_cab/respository/offer_repository.dart';
import 'package:go_router/go_router.dart';

import '../data/response/api_response.dart';

class OfferViewModel with ChangeNotifier {
  final _myRepo = OfferRepository();
  OfferListModel? offerListModel;
  OfferDetailByIdModel? offerDetailByIdModel;
  bool isLoading = false;
  bool isLoading1 = false;
  ApiResponse<GetActivityOfferModel> getActivityOffer = ApiResponse.initial();

  void setActivityOffer(ApiResponse<GetActivityOfferModel> response) {
    getActivityOffer = response;
    notifyListeners();
  }

  Future<void> getOfferList(
      {required BuildContext context,
      required String date,
      required String bookingType}) async {
    Map<String, dynamic> query = {"date": date, "offerType": bookingType};
    try {
      isLoading1 = true;
      notifyListeners();
      await _myRepo
          .offerListApi(context: context, query: query)
          .then((onValue) {
        if (onValue?.status?.httpCode == '200') {
          offerListModel = onValue;
          isLoading1 = false;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('error..$e');
      isLoading1 = false;
      notifyListeners();
    } finally {
      isLoading1 = false;
      notifyListeners();
    }
  }

  Future<void> getOfferDetails(
      {required BuildContext context, required int offerId}) async {
    Map<String, dynamic> query = {"offerId": offerId};
    try {
      isLoading = true;
      notifyListeners();
      await _myRepo
          .offerDetailsApi(context: context, query: query)
          .then((onValue) {
        if (onValue?.status?.httpCode == '200') {
          offerDetailByIdModel = onValue;
          isLoading = false;
          notifyListeners();
          context.push('/offerDetails');
        }
      });
    } catch (e) {
      debugPrint('error..$e');
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<OfferDetailByIdModel?> validateOffer(
      {required BuildContext context,
      required String offerCode,
      required String bookingType,
      required double bookigAmount}) async {
    Map<String, dynamic> query = {
      "offerCode": offerCode,
      "offerType": bookingType,
      "bookingAmount": bookigAmount
    };
    try {
      isLoading = true;
      notifyListeners();
      var resp = await _myRepo.validateOfferApi(context: context, query: query);
      return resp;
    } catch (e) {
      debugPrint('error..$e');
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> getActivityOfferApi() async {
    try {
      setActivityOffer(ApiResponse.loading());
      var resp = await _myRepo.getActivityOfferApi();
      setActivityOffer(ApiResponse.completed(resp));
    } catch (e) {
      setActivityOffer(ApiResponse.error(e.toString()));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/repositories/itinerary_repository.dart';
import 'package:flutter_cab/core/utils/utils.dart';

class ItineraryViewModel with ChangeNotifier {
  final _myRepo = ItineraryRepository();
  ApiResponse<CommonModel> addOrEditItinerary = ApiResponse.initial();

  void setData(ApiResponse<CommonModel> response) {
    addOrEditItinerary = response;
    notifyListeners();
  }

  Future<void> addEditItineraryApi({
    // required BuildContext context,
    required Map<String, dynamic> body,
    bool isEdit = false,
    Function()? onSuccess,
  }) async {
    setData(ApiResponse.loading());
    try {
      var response =
          await _myRepo.addEditActivityApi(body: body, isEdit: isEdit);
      debugPrint("Create and change itinerary View Model Success $response");
      setData(ApiResponse.completed(response));
      if (response.status?.httpCode == '200') {
        Utils.toastSuccessMessage(
            response.data?.body ?? "Itinerary saved successfully");

        if (onSuccess != null) onSuccess();
      } else {
        setData(ApiResponse.error('error'));
      }
    } catch (e) {
      debugPrint("Create and change itinerary View Model Field $e");
      setData(ApiResponse.error(e.toString()));
    }
  }
}

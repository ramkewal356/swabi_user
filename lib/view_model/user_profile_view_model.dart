// Rental Booking View Model

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/user_profile_model.dart';
import 'package:flutter_cab/data/repositories/user_profi_repository.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';


class UserProfileViewModel with ChangeNotifier {
  final _myRepo = UserProfileRepository();
  ApiResponse<UserProfileModel> dataList = ApiResponse.initial();

  void setDataList(ApiResponse<UserProfileModel> response) {
    dataList = response;
    notifyListeners();
  }

  String userStateName = '';
  Future<UserProfileModel?> fetchUserProfileViewModelApi() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {"userId": vendorId};
    try {
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.userProfileRepositoryApi(query: query);
      if (resp.status.httpCode == '200') {
        setDataList(ApiResponse.completed(resp));
        userStateName = resp.data.state;
        notifyListeners();
      }

      return resp;
    } catch (error) {
      setDataList(ApiResponse.error(error.toString()));
    }
    return null;
  }
}

// ///Profile Image View Model
class ProfileImageViewModel with ChangeNotifier {
  final _myRepo = ProfileImageRepository();
  ApiResponse<CommonModel> dataList = ApiResponse.initial();

  void setDataList(ApiResponse<CommonModel> response) {
    dataList = response;
    notifyListeners();
  }

  Future<void> postProfileImageApi(
      Map<String, dynamic> body, String userType) async {
    try {
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.fetchProfileImageApi(body: body, userType: userType);
      setDataList(ApiResponse.completed(resp));
      Utils.toastSuccessMessage(resp.data?.body ?? '');
    } catch (e) {
      debugPrint('error $e');
      setDataList(ApiResponse.error(e.toString()));
    }
  }
}

///User Profile Update View Model
class UserProfileUpdateViewModel with ChangeNotifier {
  final _myRepo = UserProfileUpdateRepository();
  ApiResponse<bool> dataList = ApiResponse.initial();
  bool isLoading = false;
  void setDataList(ApiResponse<bool> response) {
    dataList = response;
    notifyListeners();
  }

  Future<bool> profileUpdateViewModelApi(
      {required Map<String, dynamic> body, required String userType}) async {
    try {
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.userProfileUpdateRepositoryApi(
          body: body, userType: userType);

      if (resp) {
        setDataList(ApiResponse.completed(true));
        return true;
      } else {
        setDataList(ApiResponse.error("Update failed"));
        return false;
      }
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
      return false;
    }
  }
}

class GetCountryStateListViewModel with ChangeNotifier {
  final _myRepo = UserProfileUpdateRepository();
  List<dynamic> getCountryListModel = [];
  // List<dynamic> getStateListModel = [];
  List<String>? getStateNameModel;
  bool isLoading = false;
  Future<dynamic> getAccessToken({
    required BuildContext context,
  }) async {
    Map<String, String> headers = {
      'api-token':
          'ky36oc3IK7cBvBSMi9wkMQsvyf2kLTHLg83JuA8pYL5tLotwdV_401qVFkMHMunj8nM',
      'user-email': 'saurabhm@shilshatech.com',
    };
    try {
      var resp =
          await _myRepo.getAccessTokentApi(context: context, header: headers);
      return resp;
    } catch (e) {
      debugPrint('error$e');
    }
    return null;
  }

  Future<dynamic> getCountryList({
    required BuildContext context,
    required String token,
  }) async {
    Map<String, String> header = {
      "Authorization": 'Bearer $token',
    };
    try {
      _myRepo
          .getCountryListApi(context: context, header: header)
          .then((onValue) {
        getCountryListModel = onValue;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error$e');
    }
    return null;
  }

  Future<void> getStateList({
    required BuildContext context,
    required String country,
  }) async {
    Map<String, dynamic> body = {"country": country};
    try {
      isLoading = true;
      notifyListeners();
      _myRepo
          .getStateListApi(
        context: context,
        body: body,
      )
          .then((onValue) {
        if (onValue.data != null) {
          // Filter the data to get the country-specific states
          var countryData = onValue.data?.firstWhere(
            (item) => item.name == country,
            // orElse: () => null,
          );

          if (countryData != null) {
            var states = countryData.states;
            getStateNameModel = states
                ?.map((state) => state.name
                    ?.replaceFirst(RegExp(r' Emirate$'), '') as String)
                .toList();
            debugPrint('vcnbxcnbxcn,,,,,,,,....???????? $getStateNameModel');
          } else {
            // If country is not found in the data, handle accordingly
            getStateNameModel = [];
          }

          isLoading = false;
          notifyListeners(); // Notify listeners after update
        } else {
          // Handle case when the response is null
          isLoading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('error$e');
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    // return null;
  }
}

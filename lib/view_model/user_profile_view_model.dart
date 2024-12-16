// Rental Booking View Model

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/changepassword_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/respository/user_profi_repository.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProfileViewModel with ChangeNotifier {
  final _myRepo = UserProfileRepository();
  ApiResponse<UserProfileModel> DataList = ApiResponse.loading();

  setDataList(ApiResponse<UserProfileModel> response) {
    DataList = response;
    notifyListeners();
  }

  Future<void> fetchUserProfileViewModelApi(
    BuildContext context,
    data,
    /*String uid */
  ) async {
    setDataList(ApiResponse.loading());
    _myRepo
        .userProfileRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
      // context.push("/profilePage",extra: {"userId":uid});
    }).onError((error, stackTrace) {
      // debugPrint("data nhi chla");
      Utils.toastMessage(error.toString());
      setDataList(ApiResponse.error(error.toString()));
    });
  }
}

// ///Profile Image View Model
class ProfileImageViewModel with ChangeNotifier {
  final _myRepo = ProfileImageRepository();
  ApiResponse<String> DataList = ApiResponse.loading();

  setDataList(ApiResponse<String> response) {
    DataList = response;
    notifyListeners();
  }

  Future<void> postProfileImageApi(BuildContext context, dynamic data) async {
    _myRepo.fetchProfileImageApi(data).then((value) async {
      setDataList(ApiResponse.completed(value));
      // context.pop();
      Utils.toastSuccessMessage(
        DataList.data ?? "Profile Uploaded Successfully",
      );
      // print('Profile Upload Completed');
    }).onError((error, stackTrace) {
      setDataList(ApiResponse.error(error.toString()));
      // print('Profile Failed');
      print(error.toString());
      // Utils.flushBarErrorMessage(error.toString(), context);
    });
  }
}

///User Profile Update View Model
class UserProfileUpdateViewModel with ChangeNotifier {
  final _myRepo = UserProfileUpdateRepository();
  ApiResponse<UserProfileUpdateModel> dataList = ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<UserProfileUpdateModel> response) {
    dataList = response;
    notifyListeners();
  }

  Future<void> fetchUserProfileUpdateViewModelApi(
      BuildContext context, data, String uid) async {
    setDataList(ApiResponse.loading());
    isLoading = true;
    notifyListeners();

    _myRepo
        .userProfileUpdateRepositoryApi(context: context, body: data)
        .then((value) async {
      Provider.of<UserProfileViewModel>(context, listen: false)
          .fetchUserProfileViewModelApi(
              context, {"userId": uid}).then((value) => debugPrint("k"));

      setDataList(ApiResponse.completed(value));
      context.pop();

      Utils.toastSuccessMessage(
        "Profile Updated Successfully",
      );
      isLoading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      // debugPrint(error.toString());
      // print("api failed");
      setDataList(ApiResponse.error(error.toString()));
      isLoading = false;
      notifyListeners();
    });
  }
}

class ChangePasswordViewModel with ChangeNotifier {
  final _myRepo = UserProfileUpdateRepository();
  ApiResponse<ChangePasswordModel> dataList = ApiResponse.loading();

  setDataList(ApiResponse<ChangePasswordModel> response) {
    dataList = response;
    notifyListeners();
  }

  Future<ChangePasswordModel?> changePasswordViewModelApi(
      {required BuildContext context,
      required Map<String, dynamic> query}) async {
    try {
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.changePasswordApi(context: context, query: query);
      setDataList(ApiResponse.completed(resp));
      // Utils.flushBarSuccessMessage("Changed password Successfully", context);
      return resp;
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
      debugPrint('error $e');
    }
    return null;
  }
}

class ResetPasswordViewModel with ChangeNotifier {
  final _myRepo = UserProfileUpdateRepository();
  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = false;

  Future<CommonModel?> sendOtp(
      {required BuildContext context, required String email}) async {
    Map<String, dynamic> query = {"email": email};
    try {
      isLoading = true;
      notifyListeners();
      var resp = await _myRepo.sendOtpApi(context: context, query: query);
      if (resp?.status?.httpCode == '200') {
        Utils.toastSuccessMessage(resp?.data?.body ?? '');
        isLoading = false;
        notifyListeners();
      }

      return resp;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('error$e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> verifyOtp(
      {required BuildContext context,
      required String email,
      required String otp}) async {
    Map<String, dynamic> query = {"email": email, "otp": otp};
    try {
      isLoading1 = true;
      notifyListeners();
      await _myRepo.verifyOtpApi(context: context, query: query).then((resp) {
        if (resp?.status?.httpCode == '200') {
          Utils.toastSuccessMessage(resp?.data?.body ?? '');
          context.push('/resetPassword', extra: {"email": email});
          isLoading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      isLoading1 = false;
      notifyListeners();
      debugPrint('error$e');
    } finally {
      isLoading1 = false;
      notifyListeners();
    }
  }

  Future<CommonModel?> resetPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    Map<String, dynamic> query = {"email": email, "password": password};
    try {
      isLoading2 = true;
      notifyListeners();
      var resp = await _myRepo.resetPasswordApi(context: context, query: query);
      if (resp?.status?.httpCode == '200') {
        Utils.toastSuccessMessage(resp?.data?.body ?? '');
        context.push('/login');
        isLoading2 = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading2 = false;
      notifyListeners();
      debugPrint('error$e');
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
    return null;
  }
}

class GetCountryStateListViewModel with ChangeNotifier {
  final _myRepo = UserProfileUpdateRepository();
  List<dynamic> getCountryListModel = [];
  List<dynamic> getStateListModel = [];
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

  Future<dynamic> getStateList({
    required BuildContext context,
    required String token,
    required String country,
  }) async {
    Map<String, String> header = {
      "Authorization": 'Bearer $token',
    };
    try {
      isLoading = true;
      notifyListeners();
      _myRepo
          .getStateListApi(context: context, header: header, country: country)
          .then((onValue) {
        if (onValue != null) {
          getStateListModel = onValue;
          isLoading = false;
          notifyListeners(); // Returns a List
        } else {
          isLoading = false;
          notifyListeners();
          return []; // Return an empty List if the response is null
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
    return null;
  }
}

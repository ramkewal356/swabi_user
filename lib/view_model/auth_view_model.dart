// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/registration_model.dart';
import 'package:flutter_cab/data/models/user_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/response/api_response.dart';
import '../data/repositories/auth_repository.dart';
import '../core/utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();
  late bool setupFinish = false;

  bool check = true;
  ApiResponse<SignUpModel> signUpResponse = ApiResponse.initial();
  void setOnSignUpUser(ApiResponse<SignUpModel> response) {
    signUpResponse = response;
    notifyListeners();
  }

  ApiResponse<UserLoginModel> loginResponse = ApiResponse.initial();
  void setOnLoginUser(ApiResponse<UserLoginModel> response) {
    loginResponse = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> sendOtpResponse = ApiResponse.initial();

  void setOnSendOtp(ApiResponse<CommonModel> response) {
    sendOtpResponse = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> verifyOtpResponse = ApiResponse.initial();

  void setOnVerifyOtp(ApiResponse<CommonModel> response) {
    verifyOtpResponse = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> resetPassResponse = ApiResponse.initial();

  void setOnResetPassword(ApiResponse<CommonModel> response) {
    resetPassResponse = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> changePassResponse = ApiResponse.initial();

  void setOnChangePassword(ApiResponse<CommonModel> response) {
    changePassResponse = response;
    notifyListeners();
  }

  Future<void> userLoginApi({
    required BuildContext context,
    required String email,
    required String password,
    required bool rememberMe,
    required String userType,
  }) async {
    Map<String, String> body = {
      'email': email,
      'password': password,
      'userType': userType
    };
    try {
      setOnLoginUser(ApiResponse.loading());
      _myRepo.userloginApi(context: context, body: body).then((value) {
        if (value?.status?.httpCode == '200') {
          final userPreference =
              context.read<UserViewModel>();

          // userPreference.saveEmail(value['user']);

          userPreference.saveUser(
              userId: value?.data?.userId.toString() ?? '',
              token: value?.data?.token ?? '',
              userType: value?.data?.userType ?? "");
          rememberMe
              ? userPreference.saveRememberMe(email, password, rememberMe)
              : userPreference.clearRememberMe();
          debugPrint('token: ${value?.data?.token}');
          debugPrint('usertype: ${value?.data?.userType ?? ''}');
          if (value?.data?.accountVerified == false) {
            context.push('/verifyOtp',
                extra: {"email": value?.data?.email ?? '', "forVerify": true});
          } else {
            if (value?.data?.userType == 'USER') {
            context.pushReplacement('/user_dashboard');
          } else if (value?.data?.userType == 'VENDOR') {
            context.pushReplacement('/vendor_dashboard');
          }
          Utils.toastSuccessMessage("Login Successfully");

          }
          setOnLoginUser(ApiResponse.completed(value));
        }
      }).onError((error, stackTrace) {
        FocusScope.of(context).unfocus();

        setOnLoginUser(ApiResponse.error('error'));
      });
    } catch (e) {
      setOnLoginUser(ApiResponse.error(e.toString()));
      debugPrint('error $e');
    }
  }

  Future<SignUpModel?> fetchPostSingUp(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    try {
      setOnSignUpUser(ApiResponse.loading());
      var resp =
          await _myRepo.fetchRegistrationListApi(context: context, body: body);
      setOnSignUpUser(ApiResponse.completed(resp));
      return resp;
    } catch (e) {
      debugPrint('errrrrrrrrrrrrrrrrrrrr$e');

      setOnSignUpUser(ApiResponse.error(e.toString()));
    }
    return null;
  }

  Future<void> changePasswordViewModelApi(
      {required BuildContext context,
      required Map<String, dynamic> query,
      required String userType}) async {
    try {
      setOnChangePassword(ApiResponse.loading());
      var resp =
          await _myRepo.changePasswordApi(query: query, userType: userType);
      if (resp.status?.httpCode == '200') {
        Utils.toastSuccessMessage(resp.data?.body ?? '');
        context.pop();
      }
      setOnChangePassword(ApiResponse.completed(resp));
    } catch (e) {
      setOnChangePassword(ApiResponse.error(e.toString()));
      debugPrint('error $e');
    }
  }

  Future<CommonModel?> sendOtp(
      {required BuildContext context, required String emailId}) async {
    Map<String, dynamic> query = {"email": emailId};
    try {
      setOnSendOtp(ApiResponse.loading());
      var resp = await _myRepo.sendOtpApi(context: context, query: query);
      if (resp.status?.httpCode == '200') {
        Utils.toastSuccessMessage(resp.data?.body ?? '');
        setOnSendOtp(ApiResponse.completed(resp));
      }

      return resp;
    } catch (e) {
      setOnSendOtp(ApiResponse.error(e.toString()));
      debugPrint('error$e');
    }
    return null;
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
    required bool forUserVerification,
  }) async {
    Map<String, dynamic> query = {"email": email, "otp": otp};
    try {
      setOnVerifyOtp(ApiResponse.loading());
      await _myRepo.verifyOtpApi(context: context, query: query).then((resp) {
        if (resp.status?.httpCode == '200') {
          Utils.toastSuccessMessage(resp.data?.body ?? '');
          if (forUserVerification) {
            context.push('/login');
          } else {
            context.push('/resetPassword', extra: {"email": email});
          }
          setOnVerifyOtp(ApiResponse.completed(resp));
        }
      });
    } catch (e) {
      setOnVerifyOtp(ApiResponse.error(e.toString()));
      debugPrint('error$e');
    }
  }

  Future<CommonModel?> resetPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    Map<String, dynamic> query = {"email": email, "password": password};
    try {
      setOnResetPassword(ApiResponse.loading());
      var resp = await _myRepo.resetPasswordApi(context: context, query: query);
      if (resp.status?.httpCode == '200') {
        Utils.toastSuccessMessage(resp.data?.body ?? '');

        context.push('/login');
        setOnResetPassword(ApiResponse.completed(resp));
        return resp;
      }
    } catch (e) {
      setOnResetPassword(ApiResponse.error(e.toString()));
      debugPrint('error$e');
    }
    return null;
  }
}

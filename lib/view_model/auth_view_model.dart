import 'package:flutter/material.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../respository/user.dart';
import '/utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = UserRepository();
  late bool setupFinish = false;

  bool check = true;
  bool _loading = false;
  bool get loading => _loading;

  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setSignUpLoading(bool value) {
    _signUpLoading = value;
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
      setLoading(true);
      _myRepo.userloginApi(context: context, body: body).then((value) {
        if (value?.status?.httpCode == '200') {
          final userPreference =
              Provider.of<UserViewModel>(context, listen: false);

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
          if (value?.data?.userType == 'USER') {
            context.pushReplacement('/user_dashboard');
          } else if (value?.data?.userType == 'VENDOR') {
            context.pushReplacement('/vendor_dashboard');
          }
          Utils.toastSuccessMessage("Login Successfully");

          setLoading(false);
        }
      }).onError((error, stackTrace) {
        FocusScope.of(context).unfocus();

        setLoading(false);
      });
    } catch (e) {
      setLoading(false);
      debugPrint('error $e');
    }
  }
}

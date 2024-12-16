import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class SplashServices {
  // Future<UserModel> getUserData ()=> UserViewModel().getUser();

  UserViewModel userViewModel = UserViewModel();

  void login(BuildContext context) {
    userViewModel.getUser().then((value) async {
      if (value.token == null || value.token == '') {
        await Future.delayed(const Duration(seconds: 4));
        print('Token ${value.token}');
        context.push('/login');
      } else {
        await Future.delayed(const Duration(seconds: 4));
        // context.push('/');
        print('Token ${value.token}');
        context.push('/');
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }


}

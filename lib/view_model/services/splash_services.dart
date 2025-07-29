import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class SplashServices {

  UserViewModel userViewModel = UserViewModel();

  void login(BuildContext context) async {
    String? token = await userViewModel.getToken();
    String userTpe = await userViewModel.getUserType() ?? '';
    try {
      
      if (token != null || (token ?? '').isNotEmpty) {
        if (userTpe == 'USER') {
          // ignore: use_build_context_synchronously
          context.pushReplacement('/user_dashboard');
        } else if (userTpe == 'VENDOR') {
          // ignore: use_build_context_synchronously
          context.pushReplacement('/vendor_dashboard');
        }
      } else {
        // ignore: use_build_context_synchronously
        context.push('/landing_screen');
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }
}

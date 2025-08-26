// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class SplashServices {

  UserViewModel userViewModel = UserViewModel();

  void login(BuildContext context) async {
    String? token = await userViewModel.getToken();
    String? userTpe = await userViewModel.getUserType();
    try {
      
      if (token != null && token.isNotEmpty) {
        if (userTpe == 'USER') {
      
          context.pushReplacement('/user_dashboard');
        } else if (userTpe == 'VENDOR') {
        
          context.pushReplacement('/vendor_dashboard');
        } else {
          context.push('/landing_screen');
        }
      } else {
      
        context.push('/landing_screen');
      }
    } catch (e) {
      debugPrint('error $e');
      context.push('/landing_screen');
    }
  }
}

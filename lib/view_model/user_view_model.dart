import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '/model/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {

  bool _loading = false;
  bool get loading => _loading;
  String filename = '';
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> saveToken(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', user.token.toString());
    notifyListeners();
    return true;
  }

  Future<bool> saveRememberMe(
      String email, String pass, bool rememberMe) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('email', email);
    await sp.setString('password', pass);
    await sp.setBool('remember', rememberMe);

    notifyListeners();
    return true;
  }

  Future<void> clearRememberMe() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('email');
    await sp.remove('password');
    await sp.remove('remember');
    notifyListeners();
  }

  Future<bool> saveUserId(UserModel userID) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userId', userID.userId.toString());
    notifyListeners();
    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('token');
    return UserModel(token: token);
  }

  Future<UserModel> getUserId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? userId = sp.getString('userId');
    return UserModel(userId: userId);
  }

  Future<String> getEmail() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String email = sp.getString('email') ?? "";
    return email;
  }

  Future<String> getPass() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String pass = sp.getString('password') ?? '';
    return pass;
  }

  Future<bool> getRememberMe() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final bool remember = sp.getBool('remember') ?? false;
    return remember;
  }
 

  Future<dynamic> remove(context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('token');
    sp.remove('userId');
    sp.remove('baseUrl');
    // sp.clear();
    Utils.toastSuccessMessage("Logout Successfully");
  }

  Future<dynamic> allClear(context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.clear();
  }
}

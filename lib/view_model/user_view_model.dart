import 'package:flutter/material.dart';
import '../utils/utils.dart';

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

  Future<void> saveUser(
      {required String userId,
      required String token,
      required String userType}) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('userId', userId);
    await sp.setString('userType', userType);
    await sp.setString('token', token);
  
   
  }

  void setSate(String state) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('stateName', state);
    notifyListeners();
  }

  Future<String> getState() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String state = sp.getString('stateName') ?? "";
    return state;
  }

  Future<String?> getToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token');
   
  }

  Future<String?> getUserId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userId');
  }

  Future<String?> getUserType() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userType');
    
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
    sp.remove('userType');
    sp.remove('baseUrl');
    sp.remove('stateName');

    // sp.clear();
    Utils.toastSuccessMessage("Logout Successfully");
  }

  Future<dynamic> allClear(context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.clear();
  }
}

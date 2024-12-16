import 'package:flutter/cupertino.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/registration_model.dart';
import 'package:flutter_cab/respository/registration_repository.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostSignUpViewModel with ChangeNotifier {
  final _myRepo = RegistrationRepository();
  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<SignUpModel> DataList = ApiResponse.loading();
  setDataList(ApiResponse<SignUpModel> response) {
    DataList = response;
    notifyListeners();
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<SignUpModel?> fetchPostSingUp(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    try {
      setLoading(true);
      setDataList(ApiResponse.loading());
      _myRepo
          .fetchRegistrationListApi(context: context, body: body)
          .then((onValue) {
        if (onValue?.status.httpCode == '200') {
          final userPreference =
              Provider.of<UserViewModel>(context, listen: false);
          setLoading(false);
          setDataList(ApiResponse.completed(onValue));
          // print("Signup Success");
          userPreference.clearRememberMe();
          userPreference.allClear(context);
          Utils.toastSuccessMessage("SignUp Successfully");
          context.push("/login");
        }
      }).onError((error, stactrace) {
        setLoading(false);
        setDataList(ApiResponse.error(error.toString()));
      });
    } catch (e) {
      debugPrint('errrrrrrrrrrrrrrrrrrrr$e');
      setLoading(false);
      setDataList(ApiResponse.error(e.toString()));
    }
    return null;
  }
 
}

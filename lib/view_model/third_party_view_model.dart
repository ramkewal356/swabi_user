import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/color_model.dart';
import 'package:flutter_cab/data/repositories/third_party_repository.dart';

class ThirdPartyViewModel with ChangeNotifier {
  final _myRepo = ThirdPartyRepository();
  ApiResponse<ColorModel> colors = ApiResponse.initial();

  void setColors(ApiResponse<ColorModel> response) {
    colors = response;
    notifyListeners();
  }

  Future<void> getColors() async {
    try {
      setColors(ApiResponse.loading());
      var colors = await _myRepo.getColorsApi();
      setColors(ApiResponse.completed(colors));
    } catch (e) {
      setColors(ApiResponse.error(e.toString()));
    }
  }
}

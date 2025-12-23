import 'package:flutter/material.dart';
// import 'package:flutter_cab/data/models/currency_model.dart';
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

  ApiResponse<List<String>> getCountryListResponse = ApiResponse.initial();

  void setOnCountryList(ApiResponse<List<String>> response) {
    getCountryListResponse = response;
    notifyListeners();
  }

  ApiResponse<List<String>> stateList = ApiResponse.initial();

  void setOnStateList(ApiResponse<List<String>> response) {
    stateList = response;
    notifyListeners();
  }

  ApiResponse<String> currencyList = ApiResponse.initial();

  void setOnCurrencyList(ApiResponse<String> response) {
    currencyList = response;
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

  Future<void> getCountryList() async {
    try {
      setOnCountryList(ApiResponse.loading());
      var resp = await _myRepo.getCountryListApi();
      final List data = resp["data"];

      List<String> countryList =
          data.map((e) => e["country"].toString()).toList();
      debugPrint('countryList$countryList');
      setOnCountryList(ApiResponse.completed(countryList));
    } catch (e) {
      debugPrint('error$e');
      setOnCountryList(ApiResponse.error(e.toString()));
    }
  }
void clearStateList() {
    stateList = ApiResponse.completed([]);
    notifyListeners();
  }

  Future<void> getStateList({
    required String country,
  }) async {
    Map<String, dynamic> body = {
      "country": country,
    };
    try {
      setOnStateList(ApiResponse.loading());
      var resp = await _myRepo.getStateListApi(body: body);
      if (resp.data != null) {
          // Filter the data to get the country-specific states
        var countryData = resp.data?.firstWhere(
            (item) => item.name == country,
          );

          if (countryData != null) {
            var states = countryData.states;
            var getStateListModel = states
                ?.map((state) => state.name
                    ?.replaceFirst(RegExp(r' Emirate$'), '') as String)
                .toList();
            setOnStateList(ApiResponse.completed(getStateListModel));
          }
      }
    } catch (e) {
      debugPrint('error$e');
      setOnStateList(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getAllCurrency({required String countryName}) async {
    try {
      setOnCurrencyList(ApiResponse.loading());
      var resp = await _myRepo.getAllCurrencyApi();

      var currencyCode =
          resp.firstWhere((element) => element.country == countryName).code;
      debugPrint('currencyList$currencyCode');
      setOnCurrencyList(ApiResponse.completed(currencyCode));
    } catch (e) {
      debugPrint('error$e');
      setOnCurrencyList(ApiResponse.error(e.toString()));
    }
  }
}

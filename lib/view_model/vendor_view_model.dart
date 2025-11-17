import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/get_vendor_by_id_model.dart';
import 'package:flutter_cab/data/repositories/vendor_repository.dart';

import 'package:flutter_cab/view_model/user_view_model.dart';

class VendorViewModel with ChangeNotifier {
  final _myRepo = VendorRepository();

  ApiResponse<GetVendorByIdModel> vendorData = ApiResponse.initial();
  void setVendorData(ApiResponse<GetVendorByIdModel> response) {
    vendorData = response;
    notifyListeners();
  }

  Future<void> getVendorByIdApi() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {"vendorId": vendorId};

    try {
      setVendorData(ApiResponse.loading());
      var resp = await _myRepo.getVendorByIdApi(query: query);
      setVendorData(ApiResponse.completed(resp));
    } catch (e) {
      debugPrint('error $e');
      setVendorData(ApiResponse.error(e.toString()));
    }
  }
}

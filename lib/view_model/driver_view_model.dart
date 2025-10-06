import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/available_driver_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/driver_model.dart';
import 'package:flutter_cab/respository/driver_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class DriverViewModel extends ChangeNotifier {
  final _myRepo = DriverRepository();
  ApiResponse<DriverModel> driverList = ApiResponse.initial();
  ApiResponse<AvailableDriverModel> availableDriverList = ApiResponse.initial();
  ApiResponse<CommonModel> assignDriver = ApiResponse.initial();

  void setDriverList(ApiResponse<DriverModel> response) {
    driverList = response;
    notifyListeners();
  }

  void setAvailableDriverList(ApiResponse<AvailableDriverModel> response) {
    availableDriverList = response;
    notifyListeners();
  }

  void setAssignDriver(ApiResponse<CommonModel> response) {
    assignDriver = response;
    notifyListeners();
  }

  Future<void> fetchAllDrivers() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {
      "pageNumber": -1,
      "pageSize": -1,
      "search": "",
      "driverStatus": "TRUE",
      "vendorId": vendorId,
    };
    setDriverList(ApiResponse.loading());
    try {
      var response = await _myRepo.fetchAllDrivers(query: query);
      debugPrint("Get Driver List View Model Success $response");
      setDriverList(ApiResponse.completed(response));
    } catch (e) {
      debugPrint("Get Driver List View Model Field $e");
      setDriverList(ApiResponse.error(e.toString()));
    }
  }

  Future<void> fetchAvailableDrivers({required String bookingId}) async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {
      "packageBookingId": bookingId,
      "vendorId": vendorId,
    };
    setAvailableDriverList(ApiResponse.loading());
    try {
      var response = await _myRepo.fetchAvailableDrivers(query: query);
      debugPrint("Get Available Driver List View Model Success $response");
      setAvailableDriverList(ApiResponse.completed(response));
    } catch (e) {
      debugPrint("Get Available Driver List View Model Field $e");
      setAvailableDriverList(ApiResponse.error(e.toString()));
    }
  }

  Future<CommonModel> assignDriverApi(
      {required Map<String, dynamic> body}) async {
    setAssignDriver(ApiResponse.loading());
    try {
      var response = await _myRepo.assignDriverApi(body: body);
      debugPrint("Assign Driver Api View Model Success $response");
      setAssignDriver(ApiResponse.completed(response));
      // Utils.toastSuccessMessage('Driver assigned successfully');
      return response;
    } catch (e) {
      debugPrint("Assign Driver Api View Model Field $e");
      setAssignDriver(ApiResponse.error(e.toString()));
      rethrow;
    }
  }
}

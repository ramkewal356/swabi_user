import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/available_vehicle_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/vehicle_model.dart';
import 'package:flutter_cab/respository/vehicle_repository.dart';
// import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class VehicleViewModel extends ChangeNotifier {
  final _myRepo = VehicleRepository();
  ApiResponse<VehicleModel> vehicleList = ApiResponse.initial();
  ApiResponse<AvailableVehicleModel> availableVehicleList =
      ApiResponse.initial();
  ApiResponse<CommonModel> assignVehicle = ApiResponse.initial();

  void setVehicleList(ApiResponse<VehicleModel> response) {
    vehicleList = response;
    notifyListeners();
  }

  void setAvailableVehicleList(ApiResponse<AvailableVehicleModel> response) {
    availableVehicleList = response;
    notifyListeners();
  }

  void setAssignVehicle(ApiResponse<CommonModel> response) {
    assignVehicle = response;
    notifyListeners();
  }

  Future<void> fetchAllVehicles() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {
      "pageNumber": -1,
      "pageSize": -1,
      "search": "",
      "vehicleStatus": "TRUE",
      "vendorId": vendorId,
    };
    setVehicleList(ApiResponse.loading());
    try {
      var response = await _myRepo.fetchAllVehicles(query: query);
      debugPrint("Get Vehicle List View Model Success $response");
      setVehicleList(ApiResponse.completed(response));
    } catch (e) {
      debugPrint("Get Vehicle List View Model Field $e");
      setVehicleList(ApiResponse.error(e.toString()));
    }
  }

  Future<void> fetchAvailableVehicles({required String bookingId}) async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {
      "packageBookingId": bookingId,
      "vendorId": vendorId,
    };
    setAvailableVehicleList(ApiResponse.loading());
    try {
      var response = await _myRepo.fetchAvailableVehicles(query: query);
      debugPrint("Get Available Vehicle List View Model Success $response");
      setAvailableVehicleList(ApiResponse.completed(response));
    } catch (e) {
      debugPrint("Get Available Vehicle List View Model Field $e");
      setAvailableVehicleList(ApiResponse.error(e.toString()));
    }
  }

  Future<CommonModel> assignVehicleApi(
      {required Map<String, dynamic> body}) async {
    setAssignVehicle(ApiResponse.loading());
    try {
      var response = await _myRepo.assignVehicleApi(body: body);
      debugPrint("Assign Vehicle Api View Model Success $response");
      setAssignVehicle(ApiResponse.completed(response));
      // Utils.toastSuccessMessage('Vehicle assigned successfully');
      return response;
    } catch (e) {
      debugPrint("Assign Vehicle Api View Model Field $e");
      setAssignVehicle(ApiResponse.error(e.toString()));
      rethrow;
    }
  }
}

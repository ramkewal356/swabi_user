import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/get_all_driver_model.dart';
import 'package:flutter_cab/data/models/get_all_package_booking_model.dart';
import 'package:flutter_cab/data/models/get_all_rental_booking_model.dart';
import 'package:flutter_cab/data/models/get_all_vehicle_model.dart';
import 'package:flutter_cab/data/repositories/vendor_dashboard_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

import '../data/response/api_response.dart';

class VendorDashboardViewModel with ChangeNotifier {
  final _myRepo = VendorDashboardRepository();

  ApiResponse<GetAllVehicleModel> allVehicleData = ApiResponse.initial();
  void setVendorData(ApiResponse<GetAllVehicleModel> response) {
    allVehicleData = response;
    notifyListeners();
  }

  ApiResponse<GetAllDriverModel> allDriverData = ApiResponse.initial();
  void setDriverData(ApiResponse<GetAllDriverModel> response) {
    allDriverData = response;
    notifyListeners();
  }

  ApiResponse<GetAllRentalBookingModel> allRentalBookingData =
      ApiResponse.initial();
  void setAllRentalBookingData(ApiResponse<GetAllRentalBookingModel> response) {
    allRentalBookingData = response;
    notifyListeners();
  }

  ApiResponse<GetAllPackageBookingModel> allPackageBookingData =
      ApiResponse.initial();
  void setAllPackageBookingData(
      ApiResponse<GetAllPackageBookingModel> response) {
    allPackageBookingData = response;
    notifyListeners();
  }

  Future<void> getAllVehicleApi() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {"vendorId": vendorId};

    try {
      setVendorData(ApiResponse.loading());
      var resp = await _myRepo.getAllVehicleApi(query: query);
      setVendorData(ApiResponse.completed(resp));
    } catch (e) {
      debugPrint('error $e');
      setVendorData(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getAllDriverApi() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {"vendorId": vendorId};

    try {
      setDriverData(ApiResponse.loading());
      var resp = await _myRepo.getAllDriverApi(query: query);
      setDriverData(ApiResponse.completed(resp));
    } catch (e) {
      debugPrint('error $e');
      setDriverData(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getAllRentalBookingApi() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {"vendorId": vendorId};

    try {
      setAllRentalBookingData(ApiResponse.loading());
      var resp = await _myRepo.getAllRentalBookingApi(query: query);
      setAllRentalBookingData(ApiResponse.completed(resp));
    } catch (e) {
      debugPrint('error $e');
      setAllRentalBookingData(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getAllPackageBookingApi() async {
    String vendorId = await UserViewModel().getUserId() ?? '';
    Map<String, dynamic> query = {"vendorId": vendorId};

    try {
      setAllPackageBookingData(ApiResponse.loading());
      var resp = await _myRepo.getAllPackageBookingApi(query: query);
      setAllPackageBookingData(ApiResponse.completed(resp));
    } catch (e) {
      debugPrint('error $e');
      setAllPackageBookingData(ApiResponse.error(e.toString()));
    }
  }
}

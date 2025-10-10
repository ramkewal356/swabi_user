import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/available_vehicle_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/vehicle_model.dart';
import 'package:flutter_cab/respository/vehicle_repository.dart';
// import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class VehicleViewModel extends ChangeNotifier {
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  final _myRepo = VehicleRepository();
  ApiResponse<List<Content>> getVehicleList = ApiResponse.initial();
  ApiResponse<VehicleModel> vehicleList = ApiResponse.initial();
  ApiResponse<AvailableVehicleModel> availableVehicleList =
      ApiResponse.initial();
  ApiResponse<CommonModel> assignVehicle = ApiResponse.initial();

  void setVehicleList(ApiResponse<VehicleModel> response) {
    vehicleList = response;
    notifyListeners();
  }
  void setAllVehicleList(ApiResponse<List<Content>> response) {
    getVehicleList = response;
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
  Future<void> getAllVehicleListApi(
      {required bool isFilter,
      required bool isSearch,
      required bool isPagination,
      required String searchText,
      required String filterText}) async {
    if (isLoadingMore) return; // Prevent multiple calls
    bool newSearch = (isFilter || isSearch);
    if (!isPagination && newSearch) {
      pageNumber = 0;
      isLastPage = false;

      setAllVehicleList(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": searchText,
      "vehicleStatus": filterText,
      "vendorId": vendorId,
    };
    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.fetchAllVehicles(query: query);
      List<Content> newVehicle = resp.data?.content ?? [];
      List<Content> allVehicle = (pageNumber == 0)
          ? newVehicle
          : [...getVehicleList.data ?? [], ...newVehicle];

      isLastPage = resp.data?.last ?? false; // Check if it's the last page
      pageNumber++; // Increment page for next request
      setAllVehicleList(ApiResponse.completed(allVehicle));

      // debugPrint("Bid Resp api success ${resp.content}");
    } catch (e) {
      debugPrint('error $e');
      setAllVehicleList(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false; // Reset loading state after request
    }
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

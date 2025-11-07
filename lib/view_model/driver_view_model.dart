import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/available_driver_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/driver_model.dart';
import 'package:flutter_cab/respository/driver_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class DriverViewModel extends ChangeNotifier {
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  final _myRepo = DriverRepository();
  ApiResponse<List<Content>> driverList = ApiResponse.initial();
  ApiResponse<AvailableDriverModel> availableDriverList = ApiResponse.initial();
  ApiResponse<CommonModel> assignDriver = ApiResponse.initial();

  void setDriverList(ApiResponse<List<Content>> response) {
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

  Future<void> fetchAllDrivers(
      {required bool isSearch,
      required bool isFilter,
      required bool isPagination,
      required String filterText,
      required String searchText,
      int? pageNumber1,
      int? pageSize1}) async {
    if (isLoadingMore) return;
    bool newSearch = (isSearch || isFilter);
    if (!isPagination && newSearch) {
      pageNumber = 0;
      isLastPage = false;
      setDriverList(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": pageNumber1 ?? pageNumber,
      "pageSize": pageSize1 ?? pageSize,
      "search": searchText,
      "driverStatus": filterText,
      "vendorId": vendorId
    };
    if (isLastPage) return;
    isLoadingMore = true;
 
  
    try {
      var resp = await _myRepo.fetchAllDrivers(query: query);
      debugPrint("Get Driver List View Model Success $resp");
      List<Content> newData = resp.data?.content ?? [];
      List<Content> allData =
          (pageNumber == 0) ? newData : [...driverList.data ?? [], ...newData];

      isLastPage = resp.data?.last ?? false;
      pageNumber++;
      setDriverList(ApiResponse.completed(allData));
    } catch (e) {
      debugPrint("Get Driver List View Model Field $e");
      setDriverList(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
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

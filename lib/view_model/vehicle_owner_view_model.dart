import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/vehicle_owner_by_id_model.dart';
import 'package:flutter_cab/model/vehicle_owner_model.dart';
import 'package:flutter_cab/respository/vehicle_owner_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class VehicleOwnerViewModel with ChangeNotifier {
  final _myRepo = VehicleOwnerRepository();
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;

  ApiResponse<List<OwnerContent>> getVehicleOwnerList = ApiResponse.initial();

  void setVehicleOwner(ApiResponse<List<OwnerContent>> response) {
    getVehicleOwnerList = response;
    notifyListeners();
  }

  ApiResponse<VehicleOwnerByIdModel> vehicleOwnerById = ApiResponse.initial();
  void setVehicleOwnerById(ApiResponse<VehicleOwnerByIdModel> response) {
    vehicleOwnerById = response;
    notifyListeners();
  }

  Future<void> getVehicleOwnerListApi(
      {required bool isFilter,
      required String filterText,
      required bool isSearch,
      required String searchText,
      required bool isPagination,
      int? pageNumber1,
      int? pageSize1}) async {
    if (isLoadingMore) return;
    bool newSearch = (isSearch || isFilter);
    if (!isPagination && newSearch) {
      pageNumber = 0;
      isLastPage = false;
      setVehicleOwner(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": pageNumber1 ?? pageNumber,
      "pageSize": pageSize1 ?? pageSize,
      "search": searchText,
      "filter": filterText,
      "vendorId": vendorId
    };
    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getVehicleOwnerApi(query: query);
      List<OwnerContent> newData = resp.data?.content ?? [];
      List<OwnerContent> allData = (pageNumber == 0)
          ? newData
          : [...getVehicleOwnerList.data ?? [], ...newData];

      isLastPage = resp.data?.last ?? false;
      pageNumber++;
      setVehicleOwner(ApiResponse.completed(allData));
    } catch (e) {
      setVehicleOwner(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> getVehicleOwnerByIdApi({required String ownerId}) async {
    Map<String, dynamic> query = {
      "vehicleOwnerId": ownerId,
    };
    try {
      setVehicleOwnerById(ApiResponse.loading());
      var resp = await _myRepo.getVehicleOwnerByIdApi(query: query);
      setVehicleOwnerById(ApiResponse.completed(resp));
    } catch (e) {
      setVehicleOwnerById(ApiResponse.error(e.toString()));
    }
  }
}

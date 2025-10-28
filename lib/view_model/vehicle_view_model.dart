import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/available_vehicle_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/get_all_vehicle_type_model.dart';
import 'package:flutter_cab/model/get_vehicle_by_id_model.dart';
import 'package:flutter_cab/model/vehicle_brand_name_model.dart';
import 'package:flutter_cab/model/vehicle_model.dart';
import 'package:flutter_cab/respository/vehicle_repository.dart';
import 'package:flutter_cab/utils/utils.dart';
// import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';

class VehicleViewModel extends ChangeNotifier {
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  final _myRepo = VehicleRepository();
  ApiResponse<List<Content>> getVehicleList = ApiResponse.initial();
  ApiResponse<VehicleModel> vehicleList = ApiResponse.initial();
  ApiResponse<GetVehicleByIdModel> getVehicleDetails = ApiResponse.initial();

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

  void setVehicleDetails(ApiResponse<GetVehicleByIdModel> response) {
    getVehicleDetails = response;
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

  ApiResponse<CommonModel> activeOrDeactive = ApiResponse.initial();

  void activeDeactive(ApiResponse<CommonModel> response) {
    activeOrDeactive = response;
    notifyListeners();
  }

  ApiResponse<VehicleTypeModel> getAllVehicleType = ApiResponse.initial();

  void setVehicleType(ApiResponse<VehicleTypeModel> response) {
    getAllVehicleType = response;
    notifyListeners();
  }

  ApiResponse<VehicleBrandNameModel> getVehicleBrandName =
      ApiResponse.initial();

  void setVehicleBrandName(ApiResponse<VehicleBrandNameModel> response) {
    getVehicleBrandName = response;
    notifyListeners();
  }

  ApiResponse<bool> addOrUpdateVehicle = ApiResponse.initial();

  void setAddOrUpdateVehicle(ApiResponse<bool> response) {
    addOrUpdateVehicle = response;
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

  Future<void> getVehicleByIdApi({required String vehicleId}) async {
    if (vehicleId.isEmpty) {
      setVehicleDetails(
          ApiResponse.error("Vehicle ID cannot be null or empty"));
      return;
    }
    Map<String, dynamic> query = {
      "vehicleId": vehicleId,
    };
    try {
      setVehicleDetails(ApiResponse.loading());
      var resp = await _myRepo.getVehicleByIdApi(query: query);
      setVehicleDetails(ApiResponse.completed(resp));
      debugPrint("Get Vehicle By Id Api success ${resp.toJson()}");
    } catch (e) {
      debugPrint('error $e');
      setVehicleDetails(ApiResponse.error(e.toString()));
    }
  }

  Future<void> activeDeactiveVehicleApi(
      {required String vehicleId, bool isActive = false}) async {
   
    Map<String, dynamic> query = {
      "vehicleId": vehicleId,
    };
    try {
      activeDeactive(ApiResponse.loading());
      var resp = await _myRepo.activeOrDeactiveVehicleApi(
          query: query, isActive: isActive);
      activeDeactive(ApiResponse.completed(resp));
      Utils.toastSuccessMessage(resp.data?.body ?? '');
    } catch (e) {
      activeDeactive(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getVehicleBrandNameApi() async {
    try {
      setVehicleBrandName(ApiResponse.loading());
      var resp = await _myRepo.getVehicleBrandNameApi();
      setVehicleBrandName(ApiResponse.completed(resp));
    } catch (e) {
      setVehicleBrandName(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getVehicleTypeApi() async {
    try {
      setVehicleType(ApiResponse.loading());
      var resp = await _myRepo.getAllVehicleTypeApi();
      setVehicleType(ApiResponse.completed(resp));
    } catch (e) {
      setVehicleType(ApiResponse.error(e.toString()));
    }
  }

  Future<void> addOrUpdateVehicleApi(
      {required BuildContext context,
      required Map<String, dynamic> body,
      required bool isEdit}) async {
    try {
      setAddOrUpdateVehicle(ApiResponse.loading());
      var resp = await _myRepo.addOrEditVehicleApi(body: body, isEdit: isEdit);
      setAddOrUpdateVehicle(ApiResponse.completed(resp));
      if (isEdit) {
        Utils.toastSuccessMessage('Updated Vehicle Successfully');
      } else {
        Utils.toastSuccessMessage('Added Vehicle Successfully');
      }
      // ignore: use_build_context_synchronously
      context.pop();
    } catch (e) {
      setAddOrUpdateVehicle(ApiResponse.error(e.toString()));
    }
  }
}

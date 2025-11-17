// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/common_model.dart';
import 'package:flutter_cab/data/models/get_package_list_model.dart';
import 'package:flutter_cab/data/models/get_package_model.dart';
import 'package:flutter_cab/data/repositories/package_management_repository.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';

import '../data/response/api_response.dart';

class PackageManagementViewModel with ChangeNotifier {
  final _myRepo = PackageManagementRepository();
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  ApiResponse<List<PackageContent>> getPackageLists = ApiResponse.initial();

  void setDataList(ApiResponse<List<PackageContent>> response) {
    getPackageLists = response;
    notifyListeners();
  }
  ApiResponse<List<PackageListContent>> getPackageDataLists =
      ApiResponse.initial();

  void setPackageDataList(ApiResponse<List<PackageListContent>> response) {
    getPackageDataLists = response;
    notifyListeners();
  }
  ApiResponse<bool> addedPackage = ApiResponse.initial();

  void addPackage(ApiResponse<bool> response) {
    addedPackage = response;
    notifyListeners();
  }

  ApiResponse<bool> updatedPackage = ApiResponse.initial();

  void updatepackage(ApiResponse<bool> response) {
    updatedPackage = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> activeOrDeactive = ApiResponse.initial();

  void activeDeactive(ApiResponse<CommonModel> response) {
    activeOrDeactive = response;
    notifyListeners();
  }

  Future<void> getPackageListApi(
      {required bool isFilter,
      required bool isSearch,
      required bool isPagination,
      required String packageStatus,
      required String searchText}) async {
    if (isLoadingMore) return;
    bool newSearch = (isFilter || isSearch);
    if (!isPagination && newSearch) {
      pageNumber = 0;
      isLastPage = false;
      setDataList(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "packageStatus": packageStatus,
      "search": searchText,
      "vendorId": vendorId
    };
    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getPackageListApi(query: query);
      List<PackageContent> newData = resp.data?.content ?? [];
      List<PackageContent> allData = (pageNumber == 0)
          ? newData
          : [...getPackageLists.data ?? [], ...newData];

      isLastPage = resp.data?.last ?? false;
      pageNumber++;
      setDataList(ApiResponse.completed(allData));
    } catch (e) {
      debugPrint('Get Package pice Booking By Id ViewModel Failed $e');
      setDataList(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
      // notifyListeners();
    }
  }

  Future<void> getAllPackageListApi(
      {required bool isFilter,
      required bool isSearch,
      required bool isPagination,
      required String packageStatus,
      required bool isSort,
      required String sortDirection,
      required String searchText}) async {
    if (isLoadingMore) return;
    bool newSearch = (isFilter || isSearch || isSort);
    if (!isPagination && newSearch) {
      pageNumber = 0;
      isLastPage = false;
      setPackageDataList(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "bookingStatus": packageStatus,
      "sortBy": "bookingId",
      "sortDirection": sortDirection,
      "search": searchText,
      "vendorId": vendorId
    };
    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getAllPackageListApi(query: query);
      List<PackageListContent> newData = resp.data?.content ?? [];
      List<PackageListContent> allData = (pageNumber == 0)
          ? newData
          : [...getPackageDataLists.data ?? [], ...newData];

      isLastPage = resp.data?.last ?? false;
      pageNumber++;
      setPackageDataList(ApiResponse.completed(allData));
    } catch (e) {
      debugPrint('Get Package pice Booking By Id ViewModel Failed $e');
      setPackageDataList(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
      // notifyListeners();
    }
  }

  Future<void> addPackageApi(
      {required BuildContext context,
      required Map<String, dynamic> packageRequest}) async {
    String? vendorId = await UserViewModel().getUserId();
    String packageRequestJson = jsonEncode(packageRequest);
    Map<String, dynamic> body = {
      "packageRequest": packageRequestJson,
      // ...packageRequest,
      "vendorId": vendorId
    };
    debugPrint('bodydata   :$body');
    try {
      addPackage(ApiResponse.loading());
      var resp = await _myRepo.addPackageApi(body: body);
      addPackage(ApiResponse.completed(resp));
      Utils.toastSuccessMessage('Package added successfully');
      context.pop();
    } catch (e) {
      debugPrint('error $e');
      addPackage(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updatePackageApi(
      {required BuildContext context,
      required Map<String, dynamic> packageRequest}) async {
    // String? vendorId = await UserViewModel().getUserId();
    String packageRequestJson = jsonEncode(packageRequest);
    Map<String, dynamic> body = {
      "packageRequest": packageRequestJson,
      // "vendorId": vendorId
    };
    debugPrint('bodydata   :$body');
    try {
      updatepackage(ApiResponse.loading());
      var resp = await _myRepo.updatePackageApi(body: body);
      updatepackage(ApiResponse.completed(resp));
      Utils.toastSuccessMessage('Package updated successfully');
      context.pop();
    } catch (e) {
      debugPrint('error $e');
      updatepackage(ApiResponse.error(e.toString()));
    }
  }

  Future<void> activeDeactiveApi(
      {required String packageId, bool isActive = false}) async {
    Map<String, dynamic> query = {"packageId": packageId};
    try {
      activeDeactive(ApiResponse.loading());
      var resp = await _myRepo.activeOrDeactivePackageApi(
          query: query, isActive: isActive);
      activeDeactive(ApiResponse.completed(resp));
      Utils.toastSuccessMessage(resp.data?.body ?? '');
    } catch (e) {
      activeDeactive(ApiResponse.error(e.toString()));
    }
  }
}

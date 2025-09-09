import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/get_activity_by_id_model.dart';
import 'package:flutter_cab/model/get_all_activity_list_model.dart';
import 'package:flutter_cab/respository/activity_management_repository.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';

class ActivityManagementViewModel with ChangeNotifier {
  final _myRepo = ActivityManagementRepository();
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  ApiResponse<List<ActivityContent>> getAllActivityListData =
      ApiResponse.initial();

  void setAllActivityList(ApiResponse<List<ActivityContent>> response) {
    getAllActivityListData = response;
    notifyListeners();
  }

  ApiResponse<GetAllActivityListModel> getAllActivityList =
      ApiResponse.initial();

  void setActivityList(ApiResponse<GetAllActivityListModel> response) {
    getAllActivityList = response;
    notifyListeners();
  }

  ApiResponse<GetActivityByIdModel> getActivityById = ApiResponse.initial();

  void setActivityById(ApiResponse<GetActivityByIdModel> response) {
    getActivityById = response;
    notifyListeners();
  }

  ApiResponse<bool> addEditActivity = ApiResponse.initial();

  void setAddEditActivity(ApiResponse<bool> response) {
    addEditActivity = response;
    notifyListeners();
  }

  ApiResponse<CommonModel> activeOrDeactive = ApiResponse.initial();

  void activeDeactive(ApiResponse<CommonModel> response) {
    activeOrDeactive = response;
    notifyListeners();
  }

  Future<void> getAllActivityListApi(
      {required bool isFilter,
      required bool isSearch,
      required bool isPagination,
      required String activityStatus,
      required String searchText}) async {
    if (isLoadingMore) return;
    bool newSearch = (isFilter || isSearch);
    if (!isPagination && newSearch) {
      pageNumber = 0;
      isLastPage = false;
      setAllActivityList(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "activityStatus": activityStatus,
      "vendorId": vendorId,
      "search": searchText
    };
    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getAllActivityApi(query: query);
      List<ActivityContent> newData = resp.data?.content ?? [];
      List<ActivityContent> allData = (pageNumber == 0)
          ? newData
          : [...getAllActivityListData.data ?? [], ...newData];

      isLastPage = resp.data?.last ?? false;
      pageNumber++;
      setAllActivityList(ApiResponse.completed(allData));
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get Activity List Api Failed');
      setAllActivityList(ApiResponse.error(error.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> getActivityByIdApi({required String activityId}) async {
    Map<String, dynamic> query = {"activityId": activityId};
    try {
      setActivityById(ApiResponse.loading());
      var resp = await _myRepo.getActivityByIdApi(query: query);
      setActivityById(ApiResponse.completed(resp));
    } catch (e) {
      setActivityById(ApiResponse.error(e.toString()));
    }
  }

  Future<GetAllActivityListModel?> getAllActivityApi() async {
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "pageNumber": -1,
      "pageSize": -1,
      "activityStatus": "TRUE",
      "vendorId": vendorId,
      "search": ""
    };
    try {
      setActivityList(ApiResponse.loading());
      var resp = await _myRepo.getAllActivityApi(query: query);
      setActivityList(ApiResponse.completed(resp));
      debugPrint('Get Activity List Api Success');
      return resp;
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get Activity List Api Failed');
      setActivityList(ApiResponse.error(error.toString()));
    }
    return null;
  }

  Future<void> addEditActivityApi(
      {required BuildContext context,
      required Map<String, dynamic> activityRequest,
      required List<File> images,
      required bool isEdit}) async {
    // String? vendorId = await UserViewModel().getUserId();
    String activityRequestJson = jsonEncode(activityRequest);
    List<MultipartFile> multipartImages = [];
    for (File file in images) {
      multipartImages.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }
    Map<String, dynamic> body = {
      "activityRequest": activityRequestJson,
      "images": multipartImages,
    };
    debugPrint('bodydata   :$body');
    try {
      setAddEditActivity(ApiResponse.loading());
      var resp = await _myRepo.addEditActivityApi(body: body, isEdit: isEdit);
      setAddEditActivity(ApiResponse.completed(resp));
      if (isEdit) {
        Utils.toastSuccessMessage('Activity updated successfully');
      } else {
        Utils.toastSuccessMessage('Activity added successfully');
      }
      // ignore: use_build_context_synchronously
      context.pop();
    } catch (e) {
      debugPrint('error $e');
      setAddEditActivity(ApiResponse.error(e.toString()));
    }
  }

  Future<void> activeDeactiveActivityApi(
      {required String activityId, bool isActive = false}) async {
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "activityId": activityId,
      "vendorId": vendorId
    };
    try {
      activeDeactive(ApiResponse.loading());
      var resp = await _myRepo.activeOrDeactiveActivityApi(
          query: query, isActive: isActive);
      activeDeactive(ApiResponse.completed(resp));
      Utils.toastSuccessMessage(resp.data?.body ?? '');
    } catch (e) {
      activeDeactive(ApiResponse.error(e.toString()));
    }
  }
}

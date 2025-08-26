import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/get_activity_category_list_model.dart';
import 'package:flutter_cab/model/get_all_activity_list_model.dart';
import 'package:flutter_cab/model/get_state_with_image_list_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/respository/home_page_repository.dart';

class GetActivityCategoryListViewModel with ChangeNotifier {
  final _myRepo = HomePageRepository();
  ApiResponse<GetActivityCategoryModel> getActivityList = ApiResponse.initial();

  void setDataList(ApiResponse<GetActivityCategoryModel> response) {
    getActivityList = response;
    notifyListeners();
  }

  Future<GetActivityCategoryModel?> getActivityCategoryListApi(
  ) async {
    try {
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.getActivityCategoryList();
      setDataList(ApiResponse.completed(resp));
      debugPrint('Get Package List Api Success');
      return resp;
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get Package List Api Failed');
      setDataList(ApiResponse.error(error.toString()));
    }
    return null;
  }
}

class GetAllPackageListViewModel with ChangeNotifier {
  final _myRepo = HomePageRepository();
  ApiResponse<GetPackageListModel> getAllPackageList = ApiResponse.initial();

  void setDataList(ApiResponse<GetPackageListModel> response) {
    getAllPackageList = response;
    notifyListeners();
  }

  Future<GetPackageListModel?> getAllPackageListApi(
      Map<String, dynamic> data) async {
    try {
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.getPackageListApi(query: data);
      setDataList(ApiResponse.completed(resp));
      debugPrint('Get All Package List Api Success');
      return resp;
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get All Package List Api Failed');
      setDataList(ApiResponse.error(error.toString()));
    }
    return null;
  }
}

class GetAllActivityViewModel with ChangeNotifier {
  final _myRepo = HomePageRepository();
  ApiResponse<GetAllActivityListModel> getAllActivityList =
      ApiResponse.loading();

  void setDataList(ApiResponse<GetAllActivityListModel> response) {
    getAllActivityList = response;
    notifyListeners();
  }

  Future<GetAllActivityListModel?> getAllActivityApi(
      BuildContext context, data) async {
    try {
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.getActivityListApi(context: context, query: data);
      setDataList(ApiResponse.completed(resp));
      debugPrint('Get Package List Api Success');
      return resp;
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get Package List Api Failed');
      setDataList(ApiResponse.error(error.toString()));
    }
    return null;
  }
}

class GetStateWithImageListViewModel with ChangeNotifier {
  final _myRepo = HomePageRepository();
  ApiResponse<GetStateWithImageListModel> getStateWithImageList =
      ApiResponse.loading();

  void setDataList(ApiResponse<GetStateWithImageListModel> response) {
    getStateWithImageList = response;
    notifyListeners();
  }

  Future<GetStateWithImageListModel?> getStateWithImageApi(
   ) async {
    try {
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.getStateWithImageListApi();
      setDataList(ApiResponse.completed(resp));
      debugPrint('Get Cities List Api Success');
      return resp;
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get Cities List Api Failed');
      setDataList(ApiResponse.error(error.toString()));
    }
    return null;
  }
}

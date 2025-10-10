// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/calculate_price_model.dart';
import 'package:flutter_cab/model/common_model.dart';
import 'package:flutter_cab/model/get_package_details_by_id_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/respository/package_repository.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Get Package List View Model
class GetPackageListViewModel with ChangeNotifier {
  int currentPage = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  List<Content> _packageList = [];
  final _myRepo = GetPackageListRepository();
  ApiResponse<List<Content>> getPackageList = ApiResponse.initial();
  List<Content> get items => _packageList;
  void setDataList(ApiResponse<List<Content>> response) {
    getPackageList = response;
    notifyListeners();
  }

  void resetPagination() {
    _packageList.clear();
    currentPage = 0;
    isLastPage = false;
    notifyListeners();
  }

  Future<void> fetchGetPackageListViewModelApi(
      {required String date,
      required String country,
      required String state,
      required bool isPagination,
      required bool isSearch}) async {
    if (isLoadingMore) return;
    if (!isPagination || isSearch) {
      resetPagination();
      setDataList(ApiResponse.loading());
    }
    if (isLastPage) return;

    isLoadingMore = true;
    notifyListeners();
    Map<String, dynamic> query = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      "date": date,
      "search": "",
      "days": "",
      "price": "",
      "country": country,
      "state": state
    };
    try {
      // if (currentPage == 0) setDataList(ApiResponse.loading());
      var resp = await _myRepo.getPackageListRepositoryApi(query: query);
      List<Content> newData = resp.data.content;
      List<Content> allData =
          (currentPage == 0) ? newData : [..._packageList, ...newData];
      isLastPage = newData.length < pageSize;
      _packageList = allData;
      setDataList(ApiResponse.completed(List<Content>.from(_packageList)));
      currentPage++;
      debugPrint('Get Package List Api Success');
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get Package List Api Failed');
      setDataList(ApiResponse.error(error.toString()));
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}

// Get Package Activity By Id View Model
class GetPackageActivityByIdViewModel with ChangeNotifier {
  final _myRepo = GetPackageActivityByIdRepository();
  ApiResponse<GetPackageDetailByIdModel> getPackageActivityById =
      ApiResponse.initial();

  void setDataList(ApiResponse<GetPackageDetailByIdModel> response) {
    getPackageActivityById = response;
    notifyListeners();
  }

  Future<void> getPackageByIdApi({required String packageId}) async {
    Map<String, dynamic> query = {"packageId": packageId};
    try {
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.getPackageActivityByIdRepositoryApi(query: query);
      setDataList(ApiResponse.completed(resp));
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
    }
  }
}

// Get Package BOOKING By Id View Model
class GetPackageBookingByIdViewModel with ChangeNotifier {
  final _myRepo = GetPackageBookedByIdRepository();
  ApiResponse<BookPackageByMemberModel> getPackageBookingById =
      ApiResponse.initial();

  void setDataList(ApiResponse<BookPackageByMemberModel> response) {
    getPackageBookingById = response;
    notifyListeners();
  }

  Future<BookPackageByMemberModel?> fetchGetPackageBookingByIdViewModelApi(
      BuildContext context, data, String urId) async {
    try {
      setDataList(ApiResponse.loading());

      var rsep = await _myRepo.getPackageBookedByIdRepositoryApi(
          context: context, body: data);
      setDataList(ApiResponse.completed(rsep));

      return rsep;
    } catch (e) {
      debugPrint(e.toString());

      debugPrint('Get Package Booking By Id ViewModel Failed');
      setDataList(ApiResponse.error(e.toString()));
    }

    return null;
  }
}

class GetCalculatePackagePriceViewModel with ChangeNotifier {
  final _myRepo = CalculatePriceRepository();
  ApiResponse<CalculatePriceModel> getCalculatePrice = ApiResponse.initial();
  bool isLoading = false;
  void setDataList(ApiResponse<CalculatePriceModel> response) {
    getCalculatePrice = response;
    notifyListeners();
  }

  Future<CalculatePriceModel?> getPackageCalculateBookingPrice(
      {required BuildContext context,
      required String packageId,
      required String participantType}) async {
    Map<String, dynamic> query = {
      "packageId": packageId,
      "participantType": participantType
    };
    try {
      setDataList(ApiResponse.loading());
      var rsep =
          await _myRepo.getCalculatePriceApi(context: context, query: query);
      setDataList(ApiResponse.completed(rsep));
      return rsep;
    } catch (e) {
      debugPrint('Get Package pice Booking By Id ViewModel Failed $e');
      setDataList(ApiResponse.error(e.toString()));
    }
    return null;
  }
}

// ignore: camel_case_types
class ConfirmPackageBookingViewModel with ChangeNotifier {
  final _myRepo = GetPackageBookedByIdRepository();
  ApiResponse<BookPackageByMemberModel> getConfirmPackageBooking =
      ApiResponse.initial();
  // bool isLoading = false;
  void setDataList(ApiResponse<BookPackageByMemberModel> response) {
    getConfirmPackageBooking = response;
    notifyListeners();
  }

  Future<void> confirmBooking({
    required BuildContext context,
    required String packageBookingId,
    required String transactionId,
    required String userId,
  }) async {
    Map<String, dynamic> query = {
      'packageBookingId': packageBookingId,
      'transactionId': transactionId
    };
    try {
      setDataList(ApiResponse.loading());

      await _myRepo
          .confirmPackageBookingRepositoryApi(context: context, query: query)
          .then((onValue) {
        if (onValue.status.httpCode == '200') {
          setDataList(ApiResponse.completed(onValue));
          Utils.toastSuccessMessage("Your Package Booked successfully");
          context.pushReplacement("/package/packageHistoryManagement",
              extra: {"userID": userId});

          debugPrint('Get Package Booking By Id ViewModel Success');
          Provider.of<NotificationViewModel>(context, listen: false)
              .getAllNotificationList(
                  context: context,
                  pageNumber: 0,
                  pageSize: 100,
                  readStatus: 'FALSE');
        }
      });
    } catch (e) {
      debugPrint(e.toString());

      debugPrint('Get Package Booking By Id ViewModel Failed');
      setDataList(ApiResponse.error(e.toString()));
    }
  }
}

// Get Package History View Model
class GetPackageHistoryViewModel with ChangeNotifier {
  int currentPage = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  List<PackageHistoryContent> _packageList = [];
  final _myRepo = GetPackageHistoryRepository();
  ApiResponse<List<PackageHistoryContent>> getBookedHistory =
      ApiResponse.initial();
  void setDataList(ApiResponse<List<PackageHistoryContent>> response) {
    getBookedHistory = response;
    notifyListeners();
  }

  List<PackageHistoryContent> get items => _packageList;
  void updateDayStatus({required String newStatus, required String bookingId}) {
    if (getBookedHistory.data != null) {
      var booking = getBookedHistory.data
          ?.firstWhere((e) => e.packageBookingId == bookingId);

      if (booking != null) {
        booking.bookingStatus = newStatus;
        notifyListeners(); // Notify listeners after the change
      }
    }
  }

// Asynchronous function to fetch data from the repository
  Future<void> fetchGetPackageHistoryBookedViewModelApi(
      {required BuildContext context,
      required bool isPagination,
      required bool isFilter,
      required bool isSort,
      required String userId,
      required String filterText,
      required String sortText}) async {
    if (isLoadingMore) return;
    bool isNewSort = (isSort || isFilter);
    if (isNewSort && !isPagination) {
      currentPage = 0;
      _packageList.clear();
      isLastPage = false;
      setDataList(ApiResponse.loading());
    }
    if (isLastPage) return;
    isLoadingMore = true;
    notifyListeners();
    Map<String, dynamic> query = {
      "userId": userId,
      "bookingStatus": filterText,
      "pageNumber": currentPage,
      "pageSize": pageSize,
      "search": '',
      "sortBy": 'bookingId',
      "sortDirection": sortText
    };
    try {
      // if (currentPage == 0) setDataList(ApiResponse.loading());
      var resp = await _myRepo.getPackageHistoryRepositoryApi(
          context: context, data: query);
      List<PackageHistoryContent> newData = resp?.data.content ?? [];
      List<PackageHistoryContent> allData =
          (currentPage == 0) ? newData : [..._packageList, ...newData];
      isLastPage = newData.length < pageSize;
      _packageList = allData;
      setDataList(ApiResponse.completed(
          List<PackageHistoryContent>.from(_packageList)));
      currentPage++;
      debugPrint('Get Package List Api Success');
    } catch (error) {
      debugPrint(error.toString());
      debugPrint('Get Package List Api Failed');
      setDataList(ApiResponse.error(error.toString()));
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}

// Get Package History Detail By Id View Model
class GetPackageHistoryDetailByIdViewModel with ChangeNotifier {
  final _myRepo = GetPackageHistoryDetailByIdRepository();
  ApiResponse<GetPackageHIstoryDetailsModel> getPackageHistoryDetailById =
      ApiResponse.initial();

  void setDataList(ApiResponse<GetPackageHIstoryDetailsModel> response) {
    getPackageHistoryDetailById = response;
    notifyListeners();
  }

  Future<void> fetchGetPackageHistoryDetailByIdViewModelApi(
      {required String bookingId}) async {
    Map<String, dynamic> query = {"packageBookingId": bookingId};
    try {
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.getPackageHistoryDetailByIdRepositoryApi(query: query);
      setDataList(ApiResponse.completed(resp));
      // return resp;
    } catch (error) {
      setDataList(ApiResponse.error(error.toString()));
    }
    // return null;
  }
}

/// Get Package List View Model
class PackageCancelViewModel with ChangeNotifier {
  final _myRepo = PackageCancelRepository();
  ApiResponse<CommonModel> packageCancel = ApiResponse.initial();
  // bool isLoading = false;
  void setDataList(ApiResponse<CommonModel> response) {
    packageCancel = response;
    notifyListeners();
  }

  Future<CommonModel?> fetchPackageCancelViewModelApi({
    required Map<String, dynamic> query,
  }) async {
    try {
      setDataList(ApiResponse.loading());

      var resp = await _myRepo.packageCancelRepositoryApi(query: query);
      setDataList(ApiResponse.completed(resp));
      return resp;
    } catch (e) {
      debugPrint(e.toString());
      debugPrint('Get Package Cancel Api Failed');
      // isLoading = false;
      // notifyListeners();
      setDataList(ApiResponse.error(e.toString()));
    }
    return null;
  }
}

// Add PickUp Location Package View Model
class AddPickUpLocationPackageViewModel with ChangeNotifier {
  final _myRepo = AddPickUpLocationPackageRepository();
  ApiResponse<CommonModel> addPickUpLocationPackage = ApiResponse.initial();
  // bool isLoading = false;
  void setDataList(ApiResponse<CommonModel> response) {
    addPickUpLocationPackage = response;
    notifyListeners();
  }

  Future<CommonModel?> fetchAddPickUpLocationPackageViewModelApi(
      BuildContext context, data) async {
    try {
      setDataList(ApiResponse.loading());
     
      var resp = await _myRepo.addPickUpLocationPackageRepositoryApi(
          context: context, query: data);
      setDataList(ApiResponse.completed(resp));
      return resp;
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
    }
    return null;
  }
}

// GetPackageItinerary View Model
class GetPackageItineraryViewModel with ChangeNotifier {
  final _myRepo = GetPackageItineraryRepository();
  ApiResponse<GetPackageItineraryModel> getPackageItineraryList =
      ApiResponse.initial();

  void setDataList(ApiResponse<GetPackageItineraryModel> response) {
    getPackageItineraryList = response;
    notifyListeners();
  }

  Future<void> fetchGetPackageItineraryViewModelApi(
      BuildContext context, data) async {
    setDataList(ApiResponse.loading());
    _myRepo
        .getPackageItineraryRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
      debugPrint('GetPackageItinerary ViewModel Success');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrint('GetPackageItinerary ViewModel Failed');
      setDataList(ApiResponse.error(error.toString()));
    });
  }
}

class ChangeMobileViewModel with ChangeNotifier {
  final _myRepo = ChangeMobileRepository();
  ApiResponse<CommonModel> changeMobile = ApiResponse.initial();
  // bool isLoading = false;
  void setDataList(ApiResponse<CommonModel> response) {
    changeMobile = response;
    notifyListeners();
  }

  Future<CommonModel?> changeMobileApi({
    required Map<String, dynamic> body,
  }) async {
    try {
      setDataList(ApiResponse.loading());

      var rsep = await _myRepo.changeMobile(body: body);
      setDataList(ApiResponse.completed(rsep));
      Utils.toastSuccessMessage(rsep.data?.body ?? '');
      return rsep;
    } catch (e) {
      debugPrint('Change Mobile Api Failed $e');
      setDataList(ApiResponse.error(e.toString()));
    }
    return null;
  }
}

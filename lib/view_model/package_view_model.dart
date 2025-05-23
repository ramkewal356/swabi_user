import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/calculate_price_model.dart';
import 'package:flutter_cab/model/change_mobile_model.dart';
import 'package:flutter_cab/model/get_package_details_by_id_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/respository/package_repository.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
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
  ApiResponse<List<Content>> getPackageList = ApiResponse.loading();
  List<Content> get items => _packageList;
  setDataList(ApiResponse<List<Content>> response) {
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
      {required BuildContext context,
      required String date,
      required String country,
      required String state,
      required bool isPagination}) async {
    if (isLoadingMore || isLastPage) return;
    if (!isPagination) {
      resetPagination();
      setDataList(ApiResponse.loading());
    }
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
      var resp = await _myRepo.getPackageListRepositoryApi(
          context: context, query: query);
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
      ApiResponse.loading();

  setDataList(ApiResponse<GetPackageDetailByIdModel> response) {
    getPackageActivityById = response;
    notifyListeners();
  }

  Future<void> fetchGetPackageActivityByIdViewModelApi(BuildContext context,
      data, String packID, String uId, String dateBooking) async {
    setDataList(ApiResponse.loading());
    _myRepo
        .getPackageActivityByIdRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
      context.push("/package/packageDetails", extra: {
        "packageID": packID,
        "userId": uId,
        "bookDate": dateBooking,
        "venderId": value.data?.vendor?.vendorId.toString()
      });
      debugPrint('Get Package Activity By Id ViewModel Success');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrint('Get Package Activity By Id ViewModel Failed');
      setDataList(ApiResponse.error(error.toString()));
    });
  }
}

// Get Package BOOKING By Id View Model
class GetPackageBookingByIdViewModel with ChangeNotifier {
  final _myRepo = GetPackageBookedByIdRepository();
  ApiResponse<BookPackageByMemberModel> getPackageBookingById =
      ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<BookPackageByMemberModel> response) {
    getPackageBookingById = response;
    notifyListeners();
  }

  Future<BookPackageByMemberModel?> fetchGetPackageBookingByIdViewModelApi(
      BuildContext context, data, String urId) async {
    try {
      setDataList(ApiResponse.loading());
      isLoading = true;
      notifyListeners();
      var rsep = await _myRepo.getPackageBookedByIdRepositoryApi(
          context: context, body: data);
      setDataList(ApiResponse.completed(rsep));
      isLoading = false;
      notifyListeners();
      return rsep;
    } catch (e) {
      debugPrint(e.toString());

      debugPrint('Get Package Booking By Id ViewModel Failed');
      setDataList(ApiResponse.error(e.toString()));
      isLoading = false;
      notifyListeners();
    }

    return null;
  }
}

class GetCalculatePackagePriceViewModel with ChangeNotifier {
  final _myRepo = CalculatePriceRepository();
  ApiResponse<CalculatePriceModel> getCalculatePrice = ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<CalculatePriceModel> response) {
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
      ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<BookPackageByMemberModel> response) {
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
      isLoading = true;
      notifyListeners();
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
                  userId: userId,
                  pageNumber: 0,
                  pageSize: 100,
                  readStatus: 'FALSE');
          isLoading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
      debugPrint('Get Package Booking By Id ViewModel Failed');
      setDataList(ApiResponse.error(e.toString()));
    } finally {
      isLoading = false;
      notifyListeners();
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
  ApiResponse<GetPackageHistoryModel> getBookedHistory = ApiResponse.loading();
  setDataList(ApiResponse<GetPackageHistoryModel> response) {
    getBookedHistory = response;
    notifyListeners();
  }

  List<PackageHistoryContent> get items => _packageList;
  void updateDayStatus({required String newStatus, required String bookingId}) {
    if (getBookedHistory.data != null) {
      var booking = getBookedHistory.data?.data.content
          .firstWhere((e) => e.packageBookingId == bookingId);

      if (booking != null) {
        booking.bookingStatus = newStatus;
        notifyListeners(); // Notify listeners after the change
      }
    }
  }

// Asynchronous function to fetch data from the repository
  Future<GetPackageHistoryModel?> fetchGetPackageHistoryBookedViewModelApi(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      // Set state to loading before starting the API call
      setDataList(ApiResponse.loading());

      // Await the API call
      final value = await _myRepo.getPackageHistoryRepositoryApi(
          context: context, data: data);

      // Set the state to completed when the API call is successful
      setDataList(ApiResponse.completed(value));

      debugPrint('Get Package History ViewModel Success');
      return value;
    } catch (error) {
      // If there's an error, set the state to error
      debugPrint('Get Package History ViewModel Failed: $error');
      setDataList(ApiResponse.error(error.toString()));
    }
    return null;
  }
}

// Get Package History Detail By Id View Model
class GetPackageHistoryDetailByIdViewModel with ChangeNotifier {
  final _myRepo = GetPackageHistoryDetailByIdRepository();
  ApiResponse<GetPackageHIstoryDetailsModel> getPackageHistoryDetailById =
      ApiResponse.loading();

  setDataList(ApiResponse<GetPackageHIstoryDetailsModel> response) {
    getPackageHistoryDetailById = response;
    notifyListeners();
  }

  Future<void> fetchGetPackageHistoryDetailByIdViewModelApi(
      BuildContext context, data, String userID, String bookingID) async {
    setDataList(ApiResponse.loading());
    _myRepo
        .getPackageHistoryDetailByIdRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
      // context.push("/package/packageDetails",extra: {"packageID":packID,"userId":uId,"bookDate":dateBooking});
      context.push("/package/packageDetailsPageView", extra: {
        "user": userID,
        "book": bookingID,
        "paymentId": value?.data.paymentId
      });
      debugPrint('Get Package History Detail By Id ViewModel Success');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrint('Get Package History Detail By Id ViewModel Failed');
      setDataList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchPackageHistoryDetailByIdViewModelApi(
      BuildContext context, data, String bookingID) async {
    setDataList(ApiResponse.loading());
    _myRepo
        .getPackageHistoryDetailByIdRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
      // context.push("/package/packageDetails",extra: {"packageID":packID,"userId":uId,"bookDate":dateBooking});

      debugPrint('Get Package History Detail By Id ViewModel Success');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrint('Get Package History Detail By Id ViewModel Failed');
      setDataList(ApiResponse.error(error.toString()));
    });
  }
}

/// Get Package List View Model
class PackageCancelViewModel with ChangeNotifier {
  final _myRepo = PackageCancelRepository();
  ApiResponse<PackageCancelModel> packageCancel = ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<PackageCancelModel> response) {
    packageCancel = response;
    notifyListeners();
  }

  Future<PackageCancelModel?> fetchPackageCancelViewModelApi(
      BuildContext context,
      data,
      String urId,
      String bookingId,
      String paymentId) async {
    try {
      setDataList(ApiResponse.loading());
      // setDataList(ApiResponse.error(''));
      isLoading = true;
      notifyListeners();
      // return null;
      await _myRepo
          .packageCancelRepositoryApi(context: context, query: data)
          .then((onValue) {
        if (onValue?.status.httpCode == '200') {
          Provider.of<GetPackageItineraryViewModel>(context, listen: false)
              .fetchGetPackageItineraryViewModelApi(
                  context, {"packageBookingId": bookingId});

          Provider.of<GetPaymentRefundViewModel>(context, listen: false)
              .getPaymentRefundApi(context: context, paymentId: paymentId);
          Provider.of<GetPackageHistoryDetailByIdViewModel>(context,
                  listen: false)
              .fetchPackageHistoryDetailByIdViewModelApi(
                  context, {"packageBookingId": bookingId}, bookingId);
          Provider.of<GetPackageHistoryViewModel>(context, listen: false)
              .updateDayStatus(newStatus: "CANCELLED", bookingId: bookingId);
          setDataList(ApiResponse.completed(onValue));

          // context.pop();
          Navigator.pop(context);
          Utils.toastSuccessMessage(packageCancel.data?.data.body ?? '');
          isLoading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      debugPrint('Get Package Cancel Api Failed');
      isLoading = false;
      notifyListeners();
      setDataList(ApiResponse.error(e.toString()));
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}

// Add PickUp Location Package View Model
class AddPickUpLocationPackageViewModel with ChangeNotifier {
  final _myRepo = AddPickUpLocationPackageRepository();
  ApiResponse<AddPickUpLocationModel> addPickUpLocationPackage =
      ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<AddPickUpLocationModel> response) {
    addPickUpLocationPackage = response;
    notifyListeners();
  }

  Future<void> fetchAddPickUpLocationPackageViewModelApi(
      BuildContext context, data, String bookingId) async {
    setDataList(ApiResponse.loading());
    // setDataList(ApiResponse.error(''));
    // return null;
    isLoading = true;
    notifyListeners();
    _myRepo
        .addPickUpLocationPackageRepositoryApi(context: context, query: data)
        .then((value) async {
      Provider.of<GetPackageHistoryDetailByIdViewModel>(context, listen: false)
          .fetchPackageHistoryDetailByIdViewModelApi(
              context, {"packageBookingId": bookingId}, bookingId);
      // setDataList(ApiResponse.completed(value));
      setDataList(ApiResponse.error(''));
      context.pop(context);
      // context.pop(context);
      Utils.toastSuccessMessage(
        "Pickup location added successfully",
      );
      isLoading = false;
      notifyListeners();
      debugPrint('Get Package Activity By Id ViewModel Success');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrint('Get Package Activity By Id ViewModel Failed');
      setDataList(ApiResponse.error(error.toString()));
      isLoading = false;
      notifyListeners();
    });
  }
}

// GetPackageItinerary View Model
class GetPackageItineraryViewModel with ChangeNotifier {
  final _myRepo = GetPackageItineraryRepository();
  ApiResponse<GetPackageItineraryModel> getPackageItineraryList =
      ApiResponse.loading();

  setDataList(ApiResponse<GetPackageItineraryModel> response) {
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
  ApiResponse<ChangeMobileModel> changeMobile = ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<ChangeMobileModel> response) {
    changeMobile = response;
    notifyListeners();
  }

  Future<ChangeMobileModel?> changeMobileApi(
      {required BuildContext context,
      required Map<String, dynamic> body,
      required String bookingId}) async {
    try {
      setDataList(ApiResponse.loading());
      isLoading = true;
      notifyListeners();
      _myRepo.changeMobile(context: context, body: body).then((onValue) {
        if (onValue?.status?.httpCode == '200') {
          setDataList(ApiResponse.completed(onValue));

          Provider.of<GetPackageHistoryDetailByIdViewModel>(context,
                  listen: false)
              .fetchPackageHistoryDetailByIdViewModelApi(
                  context, {"packageBookingId": bookingId}, bookingId);
          // print("Signup Success");
          Utils.toastSuccessMessage("Contact Changed  Successfully");
          isLoading = false;
          notifyListeners();
        }
        context.pop();
      }).onError((error, stactrace) {
        setDataList(ApiResponse.error(error.toString()));
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      print('errrrrrrrrrrrrrrrrrrrr$e');
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}

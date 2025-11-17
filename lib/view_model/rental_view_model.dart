// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/payment_details_model.dart';
import 'package:flutter_cab/data/models/rental_booking_model.dart';
import 'package:flutter_cab/data/models/rental_model.dart';
import 'package:flutter_cab/data/repositories/rental_repository.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/utils/utils.dart';
// ignore: depend_on_referenced_packages

// Rental View Model
class RentalViewModel with ChangeNotifier {
  final _myRepo = RentalRepository();
  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<RentalCarListStatusModel> dataList = ApiResponse.initial();

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setDataList(ApiResponse<RentalCarListStatusModel> response) {
    dataList = response;
    notifyListeners();
  }

  Future<void> fetchRentalViewModelApi(
      BuildContext context, data, double lati, double logi) async {
    String? userId = await UserViewModel().getUserId();
    setLoading(true);
    setDataList(ApiResponse.loading());
    _myRepo
        .rentalRepositoryApi(context: context, query: data)
        .then((value) async {
      setLoading(false);
      setDataList(ApiResponse.completed(value));
      // debugPrint('Rental Api Success');
      (dataList.data?.data.body ?? []).isEmpty
          ? Utils.toastMessage(
              dataList.data?.data.errorMessage ?? "Something went wrong")
          : null;
      (dataList.data?.data.body ?? []).isNotEmpty
          ? context.push('/rentalForm/carsDetails',
              extra: {'id': userId, 'logitude': logi, "latitude": lati})
          : null;
      // (DataList.data?.data.body ?? []).isEmpty ? Utils.flushBarErrorMessage(DataList.data?.data.errorMessage ?? "Something went wrong", context, redColor) : null;
    }).onError((error, stackTrace) {
      setLoading(false);
      setDataList(ApiResponse.error(error.toString()));
    });
  }
}

// Get Rental Range List View Model
class GetRentalRangeListViewModel with ChangeNotifier {
  final _myRepo = GetRentalRangeListRepository();
  ApiResponse<GetRentalRangeListModel> getRentalRangeList =
      ApiResponse.loading();

  void setDataList(ApiResponse<GetRentalRangeListModel> response) {
    getRentalRangeList = response;
    notifyListeners();
  }

  Future<void> fetchGetRentalRangeListViewModelApi(BuildContext context) async {
    setDataList(ApiResponse.loading());
    _myRepo
        .getRentalRangeListRepositoryApi(context: context)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      // debugPrint(error.toString());
      if (error.toString() == "Null check operator used on a null value") {
        // Utils.flushBarErrorMessage("", context);
      }
      setDataList(ApiResponse.error(error.toString()));
    });
  }
}

/// Rental Booking View Model
class RentalBookingViewModel with ChangeNotifier {
  final _myRepo = RentalBookingRepository();
  ApiResponse<RentalCarBookingModel> dataList = ApiResponse.initial();
  bool isLoading = false;
  void setDataList(ApiResponse<RentalCarBookingModel> response) {
    dataList = response;
    notifyListeners();
  }

  Future<RentalCarBookingModel?> rentalBookingViewModel(
      {required BuildContext context,
      required Map<String, dynamic> body,
      required String userId}) async {
    try {
      isLoading == true;
      notifyListeners();
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.rentalBookingApi(context: context, body: body);

      setDataList(ApiResponse.completed(resp));
      isLoading == false;
      notifyListeners();

      return resp;
    } catch (e) {
      debugPrint('$e');
      isLoading == false;
      notifyListeners();
      setDataList(ApiResponse.error(e.toString()));
    } finally {
      isLoading == false;
      notifyListeners();
    }
    return null;
  }
}

class ConfirmRentalBookingViewModel with ChangeNotifier {
  final _myRepo = RentalBookingRepository();
  ApiResponse<RentalCarBookingModel> rentalDataList = ApiResponse.initial();
  bool isLoading = false;
  void setDataList(ApiResponse<RentalCarBookingModel> response) {
    rentalDataList = response;
    notifyListeners();
  }

  Future<RentalCarBookingModel?> confirmBookingViewModel(
      {required BuildContext context,
      required String rentalId,
      required String transactionId,
      required String userId}) async {
    Map<String, dynamic> query = {
      "rentalId": rentalId,
      "transactionId": transactionId
    };
    try {
      setDataList(ApiResponse.loading());
      isLoading = true;
      notifyListeners();
      await _myRepo
          .confirmRentalBookingRepositoryApi(context: context, query: query)
          .then((onValue) {
        if (onValue.status.httpCode == '200') {
          setDataList(ApiResponse.completed(onValue));
          Utils.toastSuccessMessage("Ride Booked Successfully");
          Provider.of<NotificationViewModel>(context, listen: false)
              .getAllNotificationList(
                  context: context,
                  pageNumber: 0,
                  pageSize: 100,
                  readStatus: 'FALSE');
          isLoading = false;
          notifyListeners();
          //         context.pushReplacement("/package/packageHistoryManagement",
          // extra: {"userID": userId});
          context
              .replace("/rentalForm/rentalHistory", extra: {"myIdNo": userId});
          context.pop();
        }
      });
    } catch (e) {
      debugPrint('error $e');
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

// Rental Booking View Model
class RentalBookingCancelViewModel with ChangeNotifier {
  final _myRepo = RentalBookingCancelRepository();
  ApiResponse<RentalCarBookingCancelModel> cancelldataList =
      ApiResponse.initial();

  void setDataList(ApiResponse<RentalCarBookingCancelModel> response) {
    cancelldataList = response;
    notifyListeners();
  }

  Future<RentalCarBookingCancelModel?> fetchRentalBookingCancelViewModelApi(
      BuildContext context,
      data,
      String userId,
      String bookingId,
      String paymentId) async {
    try {
      setDataList(ApiResponse.loading());

      await _myRepo
          .rentalBookingCancelRepositoryApi(context: context, query: data)
          .then((onValue) {
        if (onValue.status.httpCode == '200') {
          Provider.of<RentalViewDetailViewModel>(context, listen: false)
              .fetchRentalBookedViewDetialViewModelApi(context, {
            "id": bookingId,
          });

          Provider.of<GetPaymentRefundViewModel>(context, listen: false)
              .getPaymentRefundApi(context: context, paymentId: paymentId);

          Provider.of<RentalBookingListViewModel>(context, listen: false)
              .updateDayStatus(newStatus: "CANCELLED", bookingId: bookingId);

          setDataList(ApiResponse.completed(onValue));
          // context.pop();
          Navigator.pop(context);
          Utils.toastSuccessMessage(cancelldataList.data?.data.body ?? '');
        }
      });
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
    }
    return null;
  }
}

// Rental Booking List FilterWise View Model
class RentalBookingListViewModel with ChangeNotifier {
  int currentPage = 0;
  bool isLoadingMore = false;

  bool isLastPage = false; // Assuming true at the start
  int pageSize = 10;
  final _myRepo = RentalBookingListRepository();
  // List<Content> _rentalBookingData = [];
  ApiResponse<List<RentalContent>> rentalBookingList = ApiResponse.initial();
  // List<Content> get items => _rentalBookingData;
  void setDataList(ApiResponse<List<RentalContent>> response) {
    rentalBookingList = response;
    notifyListeners();
  }

  void updateDayStatus({required String newStatus, required String bookingId}) {
    if (rentalBookingList.data != null) {
      var booking =
          rentalBookingList.data?.firstWhere((e) => e.id.toString() == bookingId);
      debugPrint('bookingStatus>>>>>>>>>2222 ${booking?.bookingStatus}');
      if (booking != null) {
        booking.bookingStatus = newStatus;
        debugPrint('bookingStatus>>>>>>>>> ${booking.bookingStatus}');
        notifyListeners(); // Notify listeners after the change
      }
    } else {
      debugPrint('object.....>>>...');
    }
  }

  Future<void> fetchRentalBookingListBookedViewModelApi(
      {required BuildContext context,
      required String userId,
      required bool isPagination,
      required bool isFilter,
      required String filterText,
      required bool isSort,
      required String sortText}) async {
    if (isLoadingMore) return;
    bool isNewSort = (isSort || isFilter);
    if (isNewSort && !isPagination) {
      currentPage = 0;
      // _rentalBookingData.clear();
      isLastPage = false;
      setDataList(ApiResponse.loading());
    }
    if (isLastPage) return;
    isLoadingMore = true;
    notifyListeners();
    Map<String, dynamic> query = {
      'userId': userId,
      'pageNumber': currentPage,
      'pageSize': pageSize,
      'bookingStatus': filterText,
      "search": '',
      "sortBy": 'id',
      "sortDirection": sortText
    };
    try {
      // setDataList(ApiResponse.loading());
      var resp = await _myRepo.rentalBookingListRepositoryApi(
          context: context, query: query);
      List<RentalContent> newData = resp.data?.content ?? [];
      List<RentalContent> allData = (currentPage == 0)
          ? newData
          : [...rentalBookingList.data ?? [], ...newData];

      isLastPage = newData.length < pageSize;
      rentalBookingList.data = allData;
      currentPage++;
      setDataList(ApiResponse.completed(allData));
    } catch (error) {
      setDataList(ApiResponse.error(error.toString()));
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}

// Rental View Detail View Model
class RentalViewDetailViewModel with ChangeNotifier {
  final _myRepo = RentalViewDetailsRepository();
  ApiResponse<RentalDetailsSingleModel> dataList = ApiResponse.initial();
  ApiResponse<RentalDetailsSingleModel> dataList1 = ApiResponse.initial();

  void setDataList(ApiResponse<RentalDetailsSingleModel> response) {
    dataList = response;
    notifyListeners();
  }

  void setDataList1(ApiResponse<RentalDetailsSingleModel> response) {
    dataList1 = response;
    notifyListeners();
  }

  // Future<RentalDetailsSingleModel?> fetchRentalBookedViewDetialViewModelApi(
  //   BuildContext context,
  //   data,
  // ) async {
  //   try {
  //     setDataList(ApiResponse.loading());
  //     // debugPrint(bookid);
  //     var resp = await _myRepo.rentalViewDetailsRepositoryApi(
  //         context: context, query: data);
  //     setDataList(ApiResponse.completed(resp));
  //     return resp;
  //   } catch (error) {
  //     setDataList(ApiResponse.error(error.toString()));
  //   }

  //   return null;
  // }

  Future<void> fetchRentalBookedViewDetialViewModelApi(
      BuildContext context, Map<String, dynamic> query) async {
    try {
      setDataList(ApiResponse.loading());
      debugPrint('bookingId,,,,$query');
      var resp = await _myRepo.rentalViewDetailsRepositoryApi(
           query: query);
      setDataList(ApiResponse.completed(resp));
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
    }
  }

  // Future<void> fetchRentalCancelledViewDetialViewModelApi(
  //     BuildContext context, data, String cancelId) async {
  //   setDataList1(ApiResponse.loading());
  //   _myRepo
  //       .rentalViewDetailsRepositoryApi( query: data)
  //       .then((value) async {
  //     setDataList1(ApiResponse.completed(value));
  //     context.push('/rentalForm/rentalCancelledPageView',
  //         extra: {"cancelledId": cancelId});
  //     // Utils.toastMessage("Rental Car View Detail Booking");
  //   }).onError((error, stackTrace) {
  //     debugPrint(error.toString());
  //     // Utils.flushBarErrorMessage(error.toString(), context);
  //     setDataList1(ApiResponse.error(error.toString()));
  //   });
  // }
}

///Rental booking payment  detail view model
class RentalPaymentDetailsViewModel with ChangeNotifier {
  final _myRepo = RentalViewPaymentDetailsRepository();
  ApiResponse<PaymentDetailsModel> rentalPaymentDetails = ApiResponse.initial();

  void setDataList(ApiResponse<PaymentDetailsModel> response) {
    rentalPaymentDetails = response;
    notifyListeners();
  }

  Future<void> rentalPaymentDetail({required String paymentId}) async {
    Map<String, dynamic> query = {"paymentId": paymentId};
    try {
      setDataList(ApiResponse.loading());
      var resp = await _myRepo.paymentDetailsApi(query: query);
      setDataList(ApiResponse.completed(resp));
      debugPrint('Rental payment Api ViewModel Success');
    } catch (e) {
      debugPrint('error $e');
      setDataList(ApiResponse.error(e.toString()));
    }
  }
}

/// Rental Validation View Model
class RentalValidationViewModel with ChangeNotifier {
  final _myRepo = RentalValidationRepository();
  ApiResponse<RentalCarBookingValidationModel> dataList = ApiResponse.initial();

  void setDataList(ApiResponse<RentalCarBookingValidationModel> response) {
    dataList = response;
    notifyListeners();
  }

  Future<void> fetchRentalValidationModelApi(BuildContext context, data) async {
    setDataList(ApiResponse.loading());
    _myRepo
        .rentalValidationRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
      debugPrint('Rental Validation Api ViewModel Success');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrint('Rental Validation Api ViewModel Failed');
      setDataList(ApiResponse.error(error.toString()));
    });
  }
}

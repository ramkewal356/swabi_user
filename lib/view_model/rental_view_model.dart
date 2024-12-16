import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/model/payment_details_model.dart';
import 'package:flutter_cab/model/rentalbooking_model.dart';
import 'package:flutter_cab/respository/rental_repository.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
// ignore: depend_on_referenced_packages

// Rental View Model
class RentalViewModel with ChangeNotifier {
  final _myRepo = RentalRepository();
  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<RentalCarListStatusModel> DataList = ApiResponse.loading();

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setDataList(ApiResponse<RentalCarListStatusModel> response) {
    DataList = response;
    notifyListeners();
  }

  Future<void> fetchRentalViewModelApi(BuildContext context, data,
      String myUserId, double lati, double logi) async {
    setLoading(true);
    setDataList(ApiResponse.loading());
    _myRepo
        .rentalRepositoryApi(context: context, query: data)
        .then((value) async {
      setLoading(false);
      setDataList(ApiResponse.completed(value));
      // debugPrint('Rental Api Success');
      (DataList.data?.data.body ?? []).isEmpty
          ? Utils.toastMessage(
              DataList.data?.data.errorMessage ?? "Something went wrong")
          : null;
      (DataList.data?.data.body ?? []).isNotEmpty
          ? context.push('/rentalForm/carsDetails',
              extra: {'id': myUserId, 'logitude': logi, "latitude": lati})
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

  setDataList(ApiResponse<GetRentalRangeListModel> response) {
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
  ApiResponse<RentalCarBookingModel> DataList = ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<RentalCarBookingModel> response) {
    DataList = response;
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
  ApiResponse<RentalCarBookingModel> rentalDataList = ApiResponse.loading();
  bool isLoading = false;
  setDataList(ApiResponse<RentalCarBookingModel> response) {
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
                  userId: userId,
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
      ApiResponse.loading();

  setDataList(ApiResponse<RentalCarBookingCancelModel> response) {
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
      // // debugPrint('bncnvccnbcbncbc,,......,,,,,,,,,,');
      // setDataList(ApiResponse.error(''));
      // // context.pop();
      // return null;
      await _myRepo
          .rentalBookingCancelRepositoryApi(context: context, query: data)
          .then((onValue) {
        if (onValue.status.httpCode == '200') {
          Provider.of<RentalViewDetailViewModel>(context, listen: false)
              .fetchRentalBookedViewDetialViewModelApi1(context, {
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
  final _myRepo = RentalBookingListRepository();
  ApiResponse<RentalCarBookingListModel> rentalBookingList =
      ApiResponse.loading();
 

  setDataList(ApiResponse<RentalCarBookingListModel> response) {
    rentalBookingList = response;
    notifyListeners();
  }

  void updateDayStatus({required String newStatus, required String bookingId}) {
    if (rentalBookingList.data != null) {
      var booking = rentalBookingList.data?.data.content
          .firstWhere((e) => e.id == bookingId);
      debugPrint('bookingStatus>>>>>>>>>2222 ${booking?.bookingStatus}');
      if (booking != null) {
        booking.bookingStatus = newStatus;
        debugPrint('bookingStatus>>>>>>>>> ${booking.bookingStatus}');
        notifyListeners(); // Notify listeners after the change
      }
    } else {
      print('object.....>>>...');
    }
  }

  
  Future<RentalCarBookingListModel?> fetchRentalBookingListBookedViewModelApi(
      BuildContext context, data) async {
    try {
      setDataList(ApiResponse.loading());
      final resp = await _myRepo.rentalBookingListRepositoryApi(
          context: context, query: data);
      setDataList(ApiResponse.completed(resp));
      return resp;
    } catch (error) {
      setDataList(ApiResponse.error(error.toString()));
    }
    return null;
  }

  
}

// Rental View Detail View Model
class RentalViewDetailViewModel with ChangeNotifier {
  final _myRepo = RentalViewDetailsRepository();
  ApiResponse<RentalDetailsSingleModel> dataList = ApiResponse.loading();
  ApiResponse<RentalDetailsSingleModel> dataList1 = ApiResponse.loading();

  setDataList(ApiResponse<RentalDetailsSingleModel> response) {
    dataList = response;
    notifyListeners();
  }

  setDataList1(ApiResponse<RentalDetailsSingleModel> response) {
    dataList1 = response;
    notifyListeners();
  }

  Future<void> fetchRentalBookedViewDetialViewModelApi(
      BuildContext context, data, String bookid, String uid) async {
    setDataList(ApiResponse.loading());
    debugPrint(bookid);
    _myRepo
        .rentalViewDetailsRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));
      context.push('/rentalForm/rentalBookedPageView', extra: {
        "bookedId": bookid,
        "useriD": uid,
        "paymentId": value.data.paymentId
      }).then((onValue) {
        debugPrint('then.apicalling,.,.,.,.,.,.,../,,.,.,/..,./.,///,/,/,//');
        Provider.of<RentalBookingListViewModel>(context, listen: false)
            .fetchRentalBookingListBookedViewModelApi(context, {
          'userId': uid,
          'pageNumber': '0',
          'pageSize': '100',
          'bookingStatus': 'ALL',
          "search": '',
          "sortBy": 'date',
          "sortDirection": 'desc'
        });
      });
      // Utils.toastMessage("Rental Car View Detail Booking");
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      // Utils.flushBarErrorMessage(error.toString(), context);
      setDataList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchRentalBookedViewDetialViewModelApi1(
      BuildContext context, data) async {
    setDataList(ApiResponse.loading());
    debugPrint('bookingId,,,,$data');
    _myRepo
        .rentalViewDetailsRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList(ApiResponse.completed(value));

      // Utils.toastMessage("Rental Car View Detail Booking");
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      // Utils.flushBarErrorMessage(error.toString(), context);
      setDataList(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchRentalCancelledViewDetialViewModelApi(
      BuildContext context, data, String cancelId) async {
    setDataList1(ApiResponse.loading());
    _myRepo
        .rentalViewDetailsRepositoryApi(context: context, query: data)
        .then((value) async {
      setDataList1(ApiResponse.completed(value));
      context.push('/rentalForm/rentalCancelledPageView',
          extra: {"cancelledId": cancelId});
      // Utils.toastMessage("Rental Car View Detail Booking");
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      // Utils.flushBarErrorMessage(error.toString(), context);
      setDataList1(ApiResponse.error(error.toString()));
    });
  }
}

///Rental booking payment  detail view model
class RentalPaymentDetailsViewModel with ChangeNotifier {
  final _myRepo = RentalViewPaymentDetailsRepository();
  ApiResponse<PaymentDetailsModel> RentalPaymentDetail = ApiResponse.loading();

  setDataList(ApiResponse<PaymentDetailsModel> response) {
    RentalPaymentDetail = response;
    notifyListeners();
  }

  Future<PaymentDetailsModel?> rentalPaymentDetail(
      {required BuildContext context, required String paymentId}) async {
    Map<String, dynamic> query = {"paymentId": paymentId};
    try {
      setDataList(ApiResponse.loading());
      var resp =
          await _myRepo.paymentDetailsApi(context: context, query: query);
      if (resp?.status?.httpCode == '200') {
        setDataList(ApiResponse.completed(resp));
        debugPrint('Rental payment Api ViewModel Success');
      }
      return resp;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

/// Rental Validation View Model
class RentalValidationViewModel with ChangeNotifier {
  final _myRepo = RentalValidationRepository();
  ApiResponse<RentalCarBookingValidationModel> DataList = ApiResponse.loading();

  setDataList(ApiResponse<RentalCarBookingValidationModel> response) {
    DataList = response;
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

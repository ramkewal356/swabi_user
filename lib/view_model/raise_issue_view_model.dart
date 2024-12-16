import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/response/error_handler.dart';
import 'package:flutter_cab/model/getissue_model.dart';
import 'package:flutter_cab/model/issuedetail_model.dart';
import 'package:flutter_cab/model/raise_issue_model.dart';
import 'package:flutter_cab/model/get_issue_by_booking_id_model.dart';
import 'package:flutter_cab/model/user_model.dart';
import 'package:flutter_cab/respository/raise_issue_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';

class RaiseissueViewModel with ChangeNotifier {
  final _myRepo = RaiseissueRepository();
  RaiseIssueModel? _raiseIssueModel;
  RaiseIssueModel? get raiseIssueModel => _raiseIssueModel;
  bool isloading = false;
  bool isloading1 = false;
  bool raisedloading = false;

  GetIssueModel? _getIssueModel;
  GetIssueModel? get getIssue => _getIssueModel;

  ApiResponse<IssueDetailsModel> issueDetail = ApiResponse.loading();

  setDataList(ApiResponse<IssueDetailsModel> response) {
    issueDetail = response;
    notifyListeners();
  }

  ApiResponse<GetIssueByBookingIdModel> getIssueBybookingId =
      ApiResponse.loading();

  setDataList1(ApiResponse<GetIssueByBookingIdModel> response) {
    getIssueBybookingId = response;
    notifyListeners();
  }

  Future<void> requestRaiseIssue(
      {required BuildContext context,
      required String bookingId,
      required String bookingType,
      required String raisedById,
      required String issueDescription}) async {
    Map<String, dynamic> body = {
      "bookingId": bookingId,
      "bookingType": bookingType,
      "raisedById": raisedById,
      "raisedByRole": "USER",
      "issueType": "Service Issue",
      "issueDescription": issueDescription
    };
    try {
      raisedloading = true;
      notifyListeners();
      await _myRepo
          .requestRaiseIssueApi(context: context, body: body)
          .then((onValue) {
        if (onValue?.status?.httpCode == '200') {
          getIssueByBookingId(
              context: context,
              bookingId: bookingId,
              userId: raisedById,
              bookingType: bookingType);
          _raiseIssueModel = onValue;
          raisedloading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      raisedloading = false;
      notifyListeners();
      ErrorHandler.handleError(e);
    }
  }

  Future<GetIssueModel?> getRaiseIssue({
    required BuildContext context,
    required String issueStatus,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      isloading = true;
      notifyListeners();
      UserViewModel userViewModel = UserViewModel();
      UserModel? usermodel = await userViewModel.getUserId();
      Map<String, dynamic> query = {
        "raisedById": usermodel.userId,
        "userType": "USER",
        "search": "",
        "issueStatus": issueStatus,
        "pageNumber": pageNumber.toString(),
        "pageSize": pageSize.toString()
      };
      GetIssueModel? issueModel =
          await _myRepo.getRaiseIssueApi(context: context, query: query);
      _getIssueModel = issueModel;
      notifyListeners();
      return issueModel;
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      isloading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> getRaiseIssueDetails({
    required BuildContext context,
    required String issueId,
  }) async {
    try {
      isloading1 = true;
      notifyListeners();
      setDataList(ApiResponse.loading());
      Map<String, dynamic> query = {
        "issueId": issueId,
      };
      debugPrint('loder1223333$isloading1');
      await _myRepo
          .getRaiseIssueDetailsApi(context: context, query: query)
          .then((onValue) {
        if (onValue?.status?.httpCode == '200') {
          setDataList(ApiResponse.completed(onValue));
          context.push('/issueDetailsbyId');
          isloading1 = false;
          notifyListeners();
        }
      });
    } catch (e) {
      setDataList(ApiResponse.error(e.toString()));
      ErrorHandler.handleError(e);
    } finally {
      isloading1 = false;
      notifyListeners();
    }
  }

  Future<void> getIssueByBookingId(
      {required BuildContext context,
      required String bookingId,
      required String userId,
      required String bookingType}) async {
    Map<String, dynamic> query = {
      "bookingId": bookingId,
      "userId": userId,
      "userType": "USER",
      "bookingType": bookingType
    };
    try {
      setDataList1(ApiResponse.loading());

      await _myRepo
          .getRaiseIssueByBookingIdApi(context: context, query: query)
          .then((onValue) {
        if (onValue?.status?.httpCode == '200') {
          setDataList1(ApiResponse.completed(onValue));
        }
      });
    } catch (e) {
      setDataList1(ApiResponse.error(e.toString()));
    }
  }
}

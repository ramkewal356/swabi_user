import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';
import 'package:flutter_cab/data/models/get_all_enquiry_model.dart';
import 'package:flutter_cab/data/models/get_enquiry_by_id_model.dart';
import 'package:flutter_cab/data/models/get_my_enquiry_model.dart';
import 'package:flutter_cab/data/repositories/enquiry_repository.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

class EnquiryViewModel with ChangeNotifier {
  int page = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;

  final _myRepo = EnquiryRepository();
  ApiResponse<List<EnquiryContent>> bidData = ApiResponse.initial();
  void setBidData(ApiResponse<List<EnquiryContent>> response) {
    bidData = response;
    notifyListeners();
  }

 

  ApiResponse<bool> sendEnquiryResponse = ApiResponse.initial();
  void sendEnquiry(ApiResponse<bool> response) {
    sendEnquiryResponse = response;
    notifyListeners();
  }

  ApiResponse<bool> updateEnquiryResponse = ApiResponse.initial();
  void updateEnquiry(ApiResponse<bool> response) {
    updateEnquiryResponse = response;
    notifyListeners();
  }

  ApiResponse<List<MyEnquiryContent>> myEnquiryResponse = ApiResponse.initial();
  void setEnquiry(ApiResponse<List<MyEnquiryContent>> response) {
    myEnquiryResponse = response;
    notifyListeners();
  }

  ApiResponse<GetEnquiryByIdModel> getEnquiryById = ApiResponse.initial();
  void setEnquiryById(ApiResponse<GetEnquiryByIdModel> response) {
    getEnquiryById = response;
    notifyListeners();
  }

  Future<void> getAllEnquiryApi(
      {required bool isFilter,
      required bool isSearch,
      required bool isPagination,
      required String searchText,
      required String filterText}) async {
    if (isLoadingMore) return; // Prevent multiple calls
    bool newSearch = (isFilter || isSearch);
    if (!isPagination && newSearch) {
      page = 0; // Reset page if not paginating
      isLastPage = false; // Reset last page status
      bidData.data?.clear(); // Clear existing data
      setBidData(ApiResponse.loading());
    }
    String? vendorId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "vendorId": vendorId,
      "page": page,
      "query": searchText,
      "status": filterText
    };

    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getAllEnquiryApi(query: query);
      List<EnquiryContent> newBids = resp.data?.content ?? [];
      List<EnquiryContent> allBids =
          (page == 0) ? newBids : [...bidData.data ?? [], ...newBids];

      isLastPage = resp.data?.last ?? false; // Check if it's the last page
      page++; // Increment page for next request
      setBidData(ApiResponse.completed(allBids));

      debugPrint("Bid Resp api success ${resp.data}");
    } catch (e) {
      debugPrint('error $e');
      setBidData(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false; // Reset loading state after request
    }
  }

  Future<void> getMyEnquiryApi({
    required bool isPagination,
    int? pageNumber,
    int? pageSize1,
  }) async {
    if (isLoadingMore) return; // Prevent multiple calls

    if (!isPagination) {
      page = 0; // Reset page if not paginating
      isLastPage = false; // Reset last page status
      bidData.data?.clear(); // Clear existing data
      setEnquiry(ApiResponse.loading());
    }
    String? userId = await UserViewModel().getUserId();
    Map<String, dynamic> query = {
      "userId": userId,
      "page": pageNumber ?? page,
      "size": pageSize1 ?? pageSize,
    };

    if (isLastPage) return;
    isLoadingMore = true;
    try {
      var resp = await _myRepo.getAllMyEnquiryApi(query: query);
      List<MyEnquiryContent> newEnquiry = resp.content ?? [];
      List<MyEnquiryContent> allEnquiry = (page == 0)
          ? newEnquiry
          : [...myEnquiryResponse.data ?? [], ...newEnquiry];

      isLastPage = resp.last ?? false; // Check if it's the last page
      page++; // Increment page for next request
      setEnquiry(ApiResponse.completed(allEnquiry));

      debugPrint("Bid Resp api success ${resp.content}");
    } catch (e) {
      debugPrint('error $e');
      setEnquiry(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false; // Reset loading state after request
    }
  }



  Future<void> getEnquiryByIdApi({required int enquiryId}) async {
    Map<String, dynamic> query = {"inquiryId": enquiryId};
    try {
      setEnquiryById(ApiResponse.loading());
      var resp = await _myRepo.getEnquiryByIdApi(query: query);
      setEnquiryById(ApiResponse.completed(resp));
    } catch (e) {
      setEnquiryById(ApiResponse.error(e.toString()));
    }
  }

  Future<bool> sendEnquiryApi({required Map<String, dynamic> body}) async {
    String? userId = await UserViewModel().getUserId();
    // Map<String, dynamic> body = {
    //   "accommodationPreferences": accommodation,
    //   "currency": currency,
    //   "budget": budget,
    //   "country": country,
    //   "destinations": destination,
    //   "meals": meals,
    //   "name": fullName,
    //   "specialRequests": specialRequest,
    //   "tentativeDates": tentativeDates,
    //   "tentativeDays": tentativeDays,
    //   "transportation": transportation,
    //   "travelDates": travelDate,
    //   "userId": userId
    // };
    if (userId != null) {
      body["userId"] = userId;
    }
    sendEnquiry(ApiResponse.loading());
    try {
      var resp = await _myRepo.sendEnquiryApi(body: body);
      if (resp == true) {
        sendEnquiry(ApiResponse.completed(resp));
        debugPrint("Send Enquiry Api success");
        // Utils.toastSuccessMessage(
        //   "Send Enquiry Successfully",
        // );
        return resp;
      } else {
        sendEnquiry(ApiResponse.error(resp.toString()));
        return resp;
      }
    } catch (e) {
      debugPrint('error $e');
      sendEnquiry(ApiResponse.error(e.toString()));
      return false;
    }
  }

  Future<bool> updateEnquiryApi({required Map<String, dynamic> body}) async {
    String? userId = await UserViewModel().getUserId();
    if (userId != null) {
      body["userId"] = userId;
    }
    updateEnquiry(ApiResponse.loading());
    try {
      var resp = await _myRepo.updateEnquiryApi(body: body);
      if (resp == true) {
        updateEnquiry(ApiResponse.completed(resp));
        debugPrint("Update Enquiry Api success");
        return resp;
      } else {
        updateEnquiry(ApiResponse.error(resp.toString()));
        return resp;
      }
    } catch (e) {
      debugPrint('error $e');
      updateEnquiry(ApiResponse.error(e.toString()));
      return false;
    }
  }

  Future<bool> closeEnquiryApi({required Map<String, dynamic> body}) async {
    // Optionally: You could introduce an ApiResponse for closeEnquiry if you want
    try {
      var resp = await _myRepo.closeEnquiryApi(body: body);
      if (resp == true) {
        debugPrint("Close Enquiry Api success");
        return resp;
      } else {
        debugPrint("Close Enquiry Api error: $resp");
        return false;
      }
    } catch (e) {
      debugPrint('Close Enquiry Api exception: $e');
      return false;
    }
  }

}

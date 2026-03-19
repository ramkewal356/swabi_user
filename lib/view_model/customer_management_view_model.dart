import 'package:flutter/material.dart';
import 'package:flutter_cab/data/repositories/customer_repository.dart';
import 'package:flutter_cab/data/response/api_response.dart';

import '../data/models/customer_model.dart';

class CustomerManagementViewModel with ChangeNotifier {
  int pageNumber = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  ApiResponse<List<Content>> customerList = ApiResponse.initial();
  void setCustomerList(ApiResponse<List<Content>> response) {
    customerList = response;
    notifyListeners();
  }

  List<Content> _customerList = [];
  final _myRepo = CustomerRepository();
  Future<void> getAllCustomerApi(
      {required bool isFilter,
      required bool isPagination,
      required bool isSearch,
      required String searhText,
      required String filterText}) async {
    if (isLoadingMore) return;
    bool newSearch = (isSearch || isFilter);
    if (newSearch && !isPagination) {
      pageNumber = 0;
      isLastPage = false;
      _customerList.clear();
      notifyListeners();
      setCustomerList(ApiResponse.loading());
    }
    Map<String, dynamic> query = {
      "search": searhText,
      "status": filterText,
      "page": pageNumber,
      "size": pageSize
    };
    if (isLastPage) return;
    isLoadingMore = true;
    notifyListeners();
    try {
      var resp = await _myRepo.getAllCustomer(query: query);
      List<Content> newData = resp.content ?? [];
      List<Content> allData =
          (pageNumber == 0) ? newData : [..._customerList, ...newData];
      _customerList = allData;
      isLastPage = resp.last ?? false;
      setCustomerList(ApiResponse.completed(List<Content>.from(_customerList)));
      pageNumber++;
    } catch (e) {
      setCustomerList(ApiResponse.error(e.toString()));
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}

// base_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/api_response.dart';

import '../data/response/status.dart';

class BaseViewModel<T> with ChangeNotifier {
  ApiResponse<T> _response = ApiResponse.loading();
  ApiResponse<T> get response => _response;

  void setLoading() {
    _response = ApiResponse.loading();
    notifyListeners();
  }

  void setCompleted(T data) {
    _response = ApiResponse.completed(data);
    notifyListeners();
  }

  void setError(String message) {
    _response = ApiResponse.error(message);
    notifyListeners();
  }

  void reset() {
    _response = ApiResponse(Status.loading, null, '');
    notifyListeners();
  }
}

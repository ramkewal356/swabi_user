import 'package:flutter/material.dart';
import 'package:flutter_cab/data/app_excaptions.dart';

class ErrorHandler {
  static void handleError(e) {
    if (e is NetworkException) {
      // Handle network issues
      debugPrint("Network error: ${e.message}");
    } else if (e is ApiException) {
      // Handle API errors
      debugPrint("API error: ${e.message}");
    } else if (e is TimeoutException) {
      // Handle timeouts
      debugPrint("Timeout error: ${e.message}");
    } else {
      // Handle unknown or general errors
      debugPrint("Unknown error: ${e.toString()}");
    }
  }
}

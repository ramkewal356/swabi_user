

import 'package:flutter/material.dart';

class ApiCalls {
  ApiCalls._(); // Private constructor to prevent instantiation
  Map<String, dynamic> data = {"start": 0, "page_length": 20};

  static Future<void> initializeApiData(BuildContext context) async {
    // await fetchDashboardData(context);
    // await fetchProfileData(context);

  }

  // Dashboard data initialisation
  // static Future<void> fetchDashboardData(BuildContext context) async {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Provider.of<>(context, listen: false)
  //         .(context);
  //     Provider.of<>(context, listen: false)
  //         .fetchOfficeLocationApi(context);
  //   });
  // }

// Daily data initialisation
//   static Future<void> fetchAttendanceData(BuildContext context) async {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Provider.of<CheckInViewViewModel>(context, listen: false)
//           .fetchAttendanceApi(context, DateTime.now().month.toString(), DateTime.now().year.toString());
//     });
//   }

}

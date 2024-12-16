import 'package:flutter/material.dart';
import 'package:flutter_cab/model/getall_notification_model.dart';
import 'package:flutter_cab/model/getlatest_notification_model.dart';
import 'package:flutter_cab/model/update_notification_status_model.dart';
import 'package:flutter_cab/respository/notification_repository.dart';

class NotificationViewModel with ChangeNotifier {
  final _myRepo = NotificationRepository();
  GetLatestNotificationModel? getLatestNotificationModel;
  // GetAllNotificationModel? getAllNotificationModel;
  int? totalUnreadNotification;
  bool isLoading = false;
  Future<void> getLatestNotification({
    required BuildContext context,
    required String userId,
  }) async {
    Map<String, dynamic> query = {"receiverId": userId, "receiverRole": 'USER'};
    try {
      await _myRepo
          .getLatestNotificationApi(context: context, query: query)
          .then((onValue) {
        if (onValue?.status?.httpCode == '200') {
          getLatestNotificationModel = onValue;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future<UpdateNotificationStatusModel?> updateNotification({
    required BuildContext context,
    required String userId,
  }) async {
    Map<String, dynamic> query = {"receiverId": userId};
    try {
      var resp = await _myRepo.updateNotificationStatusApi(
          context: context, query: query);
      return resp;
    } catch (e) {
      debugPrint('error $e');
    }
    return null;
  }

  Future<GetAllNotificationModel?> getAllNotificationList(
      {required BuildContext context,
      required String userId,
      required int pageNumber,
      required int pageSize,
      required String readStatus}) async {
    Map<String, dynamic> query = {
      "receiverId": userId,
      "readStatus": readStatus,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'receiverRole': 'USER'
    };
    try {
      isLoading = true;
      notifyListeners();
      if (readStatus == 'FALSE') {
        await _myRepo
            .getAllNotificationApi(context: context, query: query)
            .then((onValue) {
          if (onValue?.status?.httpCode == '200') {
            totalUnreadNotification = onValue?.data?.totalElements;
          }
        });
      } else {
        
        var resp =
            await _myRepo.getAllNotificationApi(context: context, query: query);

        return resp;
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('error $e');
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static double averageRating(List<int> rating) {
    var avgRating = 0;
    for (int i = 0; i < rating.length; i++) {
      avgRating = avgRating + rating[i];
    }
    return double.parse((avgRating / rating.length).toStringAsFixed(1));
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void toastMessage(String message, {bool isSuccess = false}) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM_LEFT,
        backgroundColor: isSuccess ? btnColor : Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT, // or LENGTH_LONG
        webPosition: 'Left');
  }

  static void toastSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color(0xff23974B),
      textColor: Colors.white,
    );
  }

  static void flushBarSuccessMessage(String? message, BuildContext? context) {
    if (message != null && context != null) {
      DelightToastBar(
        position: DelightSnackbarPosition.top,
        animationDuration: const Duration(milliseconds: 200),
        builder: (context) => ToastCard(
          color: const Color(0xff23974B),
          leading: const Icon(
            Icons.done,
            size: 28,
            color: Colors.white,
          ),
          title: Text(
            message,
            style: utilsTextStyle,
          ),
          trailing: const IconButton(
              onPressed: DelightToastBar.removeAll,
              icon: Icon(
                Icons.close,
                size: 28,
                color: Colors.white,
              )),
        ),
      ).show(context);
      // Automatically close the popup after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        DelightToastBar.removeAll();
      });
    }
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    DelightToastBar(
      position: DelightSnackbarPosition.bottom,
      builder: (context) => ToastCard(
        color: btnColor,
        leading: const Icon(
          Icons.warning_amber,
          size: 28,
          color: Colors.white,
        ),
        title: Text(
          message,
          style: utilsTextStyle,
        ),
        trailing: const IconButton(
          onPressed: DelightToastBar.removeAll,
          icon: Icon(
            Icons.close,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    ).show(context);

    // Automatically close the popup after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      DelightToastBar.removeAll();
    });
  }

  static void flushBarInfoMessage(String message, BuildContext context) {
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      builder: (context) => ToastCard(
        color: const Color.fromRGBO(42, 98, 184, 1),
        leading: Container(
          height: 28,
          width: 28,
          alignment: Alignment.center,
          child: Text(
            "!",
            style: utilsTextStyle,
          ),
        ),
        title: Text(
          message,
          style: utilsTextStyle,
        ),
        trailing: const IconButton(
            onPressed: DelightToastBar.removeAll,
            icon: Icon(
              Icons.close,
              size: 28,
              color: Colors.white,
            )),
      ),
    ).show(context);
    // Automatically close the popup after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      DelightToastBar.removeAll();
    });
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: btnColor, content: Text(message)));
  }
}

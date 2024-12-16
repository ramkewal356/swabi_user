import 'package:flutter/widgets.dart';

class AppDimension {
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

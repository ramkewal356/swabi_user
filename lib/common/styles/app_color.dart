// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

const bgGreyColor = Color(0xFFf0f0f0);
const headingTextColor = Colors.black;
const naturalTextColor = Color(0xff39404A);
const naturalGreyColor = Color(0xff99A0AB);
const curvePageColor = Color(0xffEAE9E2);
const lightBrownColor = Color(0xffBAA78E);
const blueTextColor = Colors.blueAccent;
const btnColor = Color(0xff7B1E34);
const background = Color(0xFFFFFFFF);
const greyColor = Color(0xff130F26);
const greyColor1 = Colors.grey;
const blackColor = Colors.black;
const textColor = Color(0xff130F26);
const cancelButtonTextColor = Color(0xFF7A7A7A);
const greenColor = Color(0xff03A900);
const redColor = Color(0xffE22C2C);
const bglightGreyColor = Color(0xffEAE9E2);

// AppColor class for wallet_screen.dart color scheme usage.
class AppColor {
  // Main dark shade for wallet card gradient (primaryDark)
  static const Color primaryDark = Color(0xFF263159);

  // Primary color for wallet card gradient
  static const Color primary = Color(0xFF4262B8);

  // Accent color for wallet card gradient
  static const Color accent = Color(0xFF56CCF2);

  // Success shade for wallet card gradient and tags
  static const Color success = Color(0xFF1B8637);

  // Light success (e.g., ACTIVE badge background)
  static const Color successLight = Color(0xFFA3EDCC);

  // Wallet balance label color
  static const Color walletBalanceLabel = Color(0xFFECEEFB);

  // App background color for wallet screen
  static const Color bgColor = Color(0xFFF5F7FB);

  // Add this for card background on wallet_screen.dart add money section
  static const Color cardColor = Color(0xfff8fafc);

  // Text color for heading in add money section
  static const Color textPrimary = Color(0xFF163565);

  // Text color for secondary labels in add money section (Quick Add etc)
  static const Color textSecondary = Color(0xFF6B7280);

  // Divider/border color for unselected quick add buttons, etc.
  static const Color divider = Color(0xFFD6DFEA);

  // Old color constants
  static const bgGreyColor = Color(0xFFf0f0f0);
  static const headingTextColor = Colors.black;
  static const naturalTextColor = Color(0xff39404A);
  static const naturalGreyColor = Color(0xff99A0AB);
  static const curvePageColor = Color(0xffEAE9E2);
  static const lightBrownColor = Color(0xffBAA78E);
  static const blueTextColor = Colors.blueAccent;
  static const btnColor = Color(0xff7B1E34);
  static const background = Color(0xFFFFFFFF);
  static const greyColor = Color(0xff130F26);
  static const greyColor1 = Colors.grey;
  static const blackColor = Colors.black;
  static const textColor = Color(0xff130F26);
  static const cancelButtonTextColor = Color(0xFF7A7A7A);
  static const greenColor = Color(0xff03A900);
  static const redColor = Color(0xffE22C2C);

  static const secondaryColor = Color.fromRGBO(253, 104, 93, 1);
  static const textPrimaryColor = Color.fromRGBO(34, 80, 150, 1);
  static const lightGreyColor = Color(0xffDFE1E4);
  static const textgreyColor = Color(0xff626D7E);
  static const bglightGreyColor = Color(0xffFBFBFC);

  static const allStatusColor = Color(0xffEAEFF8);
  static const darkBlueColor = Color(0xff2A62B8);
  static final lightBlueColor = const Color(0xff9BBAE8).withOpacity(0.3);

  static const naturalGreyColor1 = Color(0xff23282E);
  static const weightchartLineColor = Color(0xff2A62B8);
  static const bmichartLineColor = Color(0xff47C088);
  static const unSelectedBackRoundColor = Color.fromRGBO(251, 251, 252, 1);

  static const closedStatusColor = Color.fromRGBO(255, 232, 231, 1);
  static const cancelStatusColor = Color.fromRGBO(255, 249, 238, 1);
  static const scheduledStatusColor = Color.fromRGBO(237, 249, 243, 1);
  static const closedTextColor = Color.fromRGBO(253, 29, 13, 1);
  static const aTextBackGroundColor = Color(0xffF15E53);
  static const aBackGroundColor = Color(0xffFEEFEE);

  static const scheduledTextColor = Color.fromRGBO(71, 192, 136, 1);
  static const cancelTextColor = Color.fromRGBO(180, 138, 63, 1);

  ///SettingPage
  static const inCompleteBoxColor = Color.fromRGBO(255, 249, 238, 1);
}

// Light and Dark ThemeData for the app (unchanged, can be refactored based on new AppColor above)
final ThemeData themeDataLight = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  primaryColor: AppColor.primary,
  primaryColorDark: Colors.black,
  primaryColorLight: Colors.orangeAccent,
  secondaryHeaderColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(13, 30, 57, 1),
        fontFamily: 'poppin'),
    titleMedium: TextStyle(
        fontSize: 19.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(13, 30, 57, 1),
        fontFamily: 'poppin'),
    bodyLarge: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(57, 64, 74, 1),
        fontFamily: 'Loto-Regular'),
    bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(57, 64, 74, 1),
        fontFamily: 'Loto-Regular'),
    bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(57, 64, 74, 1),
        fontFamily: 'Loto-Regular'),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
);

final ThemeData themeDataDark = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 28, 27, 27),
  primaryColorDark: Colors.teal,
  primaryColorLight: const Color.fromARGB(255, 157, 156, 156),
  scaffoldBackgroundColor: Colors.black,
  secondaryHeaderColor: Colors.white,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'poppin'),
    titleMedium: TextStyle(
        fontSize: 19.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'poppin'),
    bodyLarge: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'Loto-Regular'),
    bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'Loto-Regular'),
    bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'Loto-Regular'),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
);

import 'package:flutter/material.dart';
//color themes for light and dark model

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













//rgba()
const secondaryColor = Color.fromRGBO(253, 104, 93, 1);
const successColor = Color.fromRGBO(27, 134, 55, 1);
const primaryColor = Color.fromRGBO(42, 98, 184, 1);
const textPrimaryColor = Color.fromRGBO(34, 80, 150, 1);
const lightGreyColor = Color(0xffDFE1E4);
const textgreyColor = Color(0xff626D7E);
const bglightGreyColor = Color(0xffFBFBFC);
// const LinearGradient screenGradient = LinearGradient(
//   begin: Alignment(0.00, -1.00),
//   end: Alignment(0, 1),
//   colors: [Color(0xFFEC642A), Color(0xFF391F84)],
// );
//



//background: linear-gradient(0deg, #EAEFF8, #EAEFF8),
// linear-gradient(0deg, #2A62B8, #2A62B8);
const allStatusColor = Color(0xffEAEFF8);
const darkBlueColor = Color(0xff2A62B8);
Color lightBlueColor = const Color(0xff9BBAE8).withOpacity(0.3);

const naturalGreyColor1 = Color(0xff23282E);
const weightchartLineColor = Color(0xff2A62B8);
const bmichartLineColor = Color(0xff47C088);
const unSelectedBackRoundColor = Color.fromRGBO(251, 251, 252, 1);

const closedStatusColor = Color.fromRGBO(255, 232, 231, 1);
const cancelStatusColor = Color.fromRGBO(255, 249, 238, 1);
const scheduledStatusColor = Color.fromRGBO(237, 249, 243, 1);
const closedTextColor = Color.fromRGBO(253, 29, 13, 1);
const aTextBackGroundColor = Color(0xffF15E53);
const aBackGroundColor = Color(0xffFEEFEE);

//#

const scheduledTextColor = Color.fromRGBO(71, 192, 136, 1);
const cancelTextColor = Color.fromRGBO(180, 138, 63, 1);

///SettingPage
const inCompleteBoxColor = Color.fromRGBO(255, 249, 238, 1);

//

final ThemeData themeDataLight = ThemeData(

  useMaterial3: false,
  brightness: Brightness.light,
  primaryColor: const Color.fromRGBO(42, 98, 184, 1),
  primaryColorDark: const Color.fromARGB(255, 0, 0, 0),
  primaryColorLight: Colors.orangeAccent,
  secondaryHeaderColor: const Color.fromARGB(255, 0, 0, 0),
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
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 28, 27, 27),
  primaryColorDark: Colors.teal,
  primaryColorLight: const Color.fromARGB(255, 157, 156, 156),
  scaffoldBackgroundColor: Colors.black,
  secondaryHeaderColor: const Color.fromARGB(255, 255, 255, 255),
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

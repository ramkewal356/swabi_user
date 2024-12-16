import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/utils/routes/route.dart';
import 'package:flutter_cab/view_model/auth_view_model.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
import 'package:flutter_cab/view_model/registration_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => PostSignUpViewModel()),
        ChangeNotifierProvider(create: (context) => RentalViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetRentalRangeListViewModel()),
        ChangeNotifierProvider(create: (context) => RentalBookingViewModel()),
        ChangeNotifierProvider(
            create: (context) => RentalBookingCancelViewModel()),
        ChangeNotifierProvider(
            create: (context) => RentalBookingListViewModel()),
        ChangeNotifierProvider(
            create: (context) => RentalViewDetailViewModel()),
        ChangeNotifierProvider(create: (context) => UserProfileViewModel()),
        ChangeNotifierProvider(
            create: (context) => UserProfileUpdateViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileImageViewModel()),
        ChangeNotifierProvider(
            create: (context) => RentalValidationViewModel()),
        ChangeNotifierProvider(create: (context) => GetPackageListViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetPackageActivityByIdViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetPackageBookingByIdViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetPackageHistoryViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetPackageHistoryDetailByIdViewModel()),
        ChangeNotifierProvider(create: (context) => PackageCancelViewModel()),
        ChangeNotifierProvider(
            create: (context) => AddPickUpLocationPackageViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetPackageItineraryViewModel()),
        ChangeNotifierProvider(
            create: (context) => PaymentCreateOrderIdViewModel()),
        ChangeNotifierProvider(create: (context) => PaymentVerifyViewModel()),
        ChangeNotifierProvider(create: (context) => ChangePasswordViewModel()),
        ChangeNotifierProvider(
            create: (context) => RentalPaymentDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => ChangeMobileViewModel()),
        ChangeNotifierProvider(create: (context) => RaiseissueViewModel()),
        ChangeNotifierProvider(create: (context) => ResetPasswordViewModel()),
        ChangeNotifierProvider(create: (context) => OfferViewModel()),
        ChangeNotifierProvider(create: (context) => GetTranactionViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetPaymentRefundViewModel()),
        ChangeNotifierProvider(create: (context) => NotificationViewModel()),
        ChangeNotifierProvider(
            create: (context) => ConfirmPackageBookingViewModel()),
        ChangeNotifierProvider(
            create: (context) => ConfirmRentalBookingViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetCalculatePackagePriceViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetCountryStateListViewModel()),
      ],
      child: const MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: myRouter,
      // home: VendorProfileScreen(),
      // const SplashSreen(),
    );
  }
}

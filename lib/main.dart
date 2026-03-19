import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/app/routes.dart';
import 'package:flutter_cab/core/services/notification_service.dart';
import 'package:flutter_cab/view_model/activity_management_view_model.dart';
import 'package:flutter_cab/view_model/auth_view_model.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';
import 'package:flutter_cab/view_model/customer_management_view_model.dart';
import 'package:flutter_cab/view_model/driver_view_model.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/view_model/home_page_view_model.dart';
import 'package:flutter_cab/view_model/itinerary_view_model.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/offer_management_view_model.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/package_management_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/payment_management_view_model.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
import 'package:flutter_cab/view_model/rental_management_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:flutter_cab/view_model/subscription_view_model.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:flutter_cab/view_model/vehicle_owner_view_model.dart';
import 'package:flutter_cab/view_model/vehicle_view_model.dart';
import 'package:flutter_cab/view_model/vendor_dashboard_view_model.dart';
import 'package:flutter_cab/view_model/vendor_view_model.dart';
import 'package:flutter_cab/view_model/wallet_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background Message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();
  await NotificationService.initialize(navigatorKey);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
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
       
        ChangeNotifierProvider(
            create: (context) => RentalPaymentDetailsViewModel()),
        ChangeNotifierProvider(create: (context) => ChangeMobileViewModel()),
        ChangeNotifierProvider(create: (context) => RaiseissueViewModel()),
      
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
        // ChangeNotifierProvider(
        //     create: (context) => GetCountryStateListViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetActivityCategoryListViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetAllPackageListViewModel()),
        ChangeNotifierProvider(create: (context) => GetAllActivityViewModel()),
        ChangeNotifierProvider(
            create: (context) => GetStateWithImageListViewModel()),
        ChangeNotifierProvider(create: (create) => VendorViewModel()),
        ChangeNotifierProvider(create: (create) => VendorDashboardViewModel()),
        ChangeNotifierProvider(create: (create) => BidViewModel()),
        ChangeNotifierProvider(create: (create) => EnquiryViewModel()),
        ChangeNotifierProvider(
            create: (create) => PackageManagementViewModel()),
        ChangeNotifierProvider(
            create: (create) => ActivityManagementViewModel()),
        ChangeNotifierProvider(create: (create) => RentalManagementViewModel()),
        ChangeNotifierProvider(create: (create) => ItineraryViewModel()),
        ChangeNotifierProvider(create: (create) => VehicleViewModel()),
        ChangeNotifierProvider(create: (create) => DriverViewModel()),
        ChangeNotifierProvider(create: (create) => ThirdPartyViewModel()),
        ChangeNotifierProvider(create: (create) => VehicleOwnerViewModel()),
        ChangeNotifierProvider(create: (create) => WalletViewModel()),
        ChangeNotifierProvider(create: (create) => SubscriptionViewModel()),
        ChangeNotifierProvider(
            create: (create) => PaymentManagementViewModel()),
        ChangeNotifierProvider(create: (create) => OfferManagementViewModel()),
        ChangeNotifierProvider(
            create: (create) => CustomerManagementViewModel()),
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
    
    );
  }
}

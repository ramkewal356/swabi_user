// routes.dart

import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/change_password.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/contact.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/faq_page_screen.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/help&support_screen.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/notification.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/profile_page_screen.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/raiseissue_details_screen.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/term_condition_screen.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/transaction.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/verify_password_screen.dart';
import 'package:flutter_cab/view/dashboard/home_screen.dart';
import 'package:flutter_cab/view/dashboard/account_screen.dart';
import 'package:flutter_cab/view/dashboard/offers_pages/all_offers_screen.dart';
import 'package:flutter_cab/view/dashboard/offers_pages/offer_details_screen.dart';
import 'package:flutter_cab/view/dashboard/raiseIssue_pages/issue_view_details_screen.dart';
import 'package:flutter_cab/view/dashboard/rental/book_your_ride_screen_.dart';
import 'package:flutter_cab/view/dashboard/rental/cancel_booking.dart';
import 'package:flutter_cab/view/dashboard/rental/cars_available_screen.dart';
import 'package:flutter_cab/view/dashboard/rental/history/rental_bookedpage_view.dart';
import 'package:flutter_cab/view/dashboard/rental/history/rental_cancel_page_view.dart';
import 'package:flutter_cab/view/dashboard/rental/history/rental_history_managment_screen.dart';
import 'package:flutter_cab/view/dashboard/rental/rental_form.dart';
// import 'package:flutter_cab/view/dashboard/tourPackage/addMemberDesign.dart';
import 'package:flutter_cab/view/dashboard/tourPackage/package_screen.dart';
import 'package:flutter_cab/view/dashboard/tourPackage/package_booking_member_screen.dart';
import 'package:flutter_cab/view/dashboard/tourPackage/package_viewdetails_screen.dart';
import 'package:flutter_cab/view/dashboard/tourPackage/packageHistory/mypackage_history_screen.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/edit_profile_screen.dart';
import 'package:flutter_cab/view/dashboard/wallet_pages/wallet_history_screen.dart';
import 'package:flutter_cab/view/dashboard/wallet_pages/wallet_screen.dart';
import 'package:flutter_cab/view/registration/forgot_screen.dart';
import 'package:flutter_cab/view/registration/login_screen.dart';
import 'package:flutter_cab/view/registration/otp_verification_screen.dart';
import 'package:flutter_cab/view/registration/registration_screen.dart';
import 'package:flutter_cab/view/registration/splash_screen.dart';
import 'package:flutter_cab/view/reset_password_screen.dart';
import 'package:go_router/go_router.dart';

import '../../view/dashboard/tourPackage/packageHistory/package_booking_details.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter myRouter = GoRouter(
  // initialLocation: '/profilePage/editProfilePage',
  initialLocation: '/splash',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    
    GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashSreen();
        }),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const registration_screen();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // var data = state.extra as Map<String, dynamic>;
        return const home_screen();
      },
    ),
  
    GoRoute(
      path: '/notification',
      builder: (BuildContext context, GoRouterState state) {
        var data = state.extra as Map<String, dynamic>;
        return NotificationPage(
          userId: data['userId'],
        );
      },
    ),
    
    GoRoute(
        path: '/profilePage',
        builder: (BuildContext context, GoRouterState state) {
          var data = state.extra as Map<String, dynamic>;
          // return ProfilePage(user:'1001',);
          return ProfilePage(
            user: data['userId'],
          );
        },
        routes: [
          GoRoute(
            path: 'editProfilePage',
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;
              return EditProfiePage(
                usrId: data['uId'],
              );
            },
          ),
        ]),
  
    GoRoute(
      path: '/changePassword',
      // parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var data = state.extra as Map<String, dynamic>;
        return ChangePassword(
          userId: data['userId'],
        );
      },
    ),
    GoRoute(
      path: '/verifyPassword',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const VerifyPassword();
      },
    ),
    GoRoute(
      path: '/forgotPassword',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPassword();
      },
    ),
    GoRoute(
      path: '/verifyOtp',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var data = state.extra as Map<String, dynamic>;
        return OtpVerificationScreen(
          email: data["email"],
        );
      },
    ),
    GoRoute(
      path: '/resetPassword',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var data = state.extra as Map<String, dynamic>;

        return ResetPasswordScreen(
          email: data["email"],
        );
      },
    ),
    GoRoute(
      path: '/faqPage',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const FAQPage();
      },
    ),
    GoRoute(
      path: '/termCondition',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const TermCondition();
      },
    ),
    GoRoute(
      path: '/contact',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const ContactPage();
      },
    ),
    GoRoute(
      path: '/help&support',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const HelpAndSupport();
      },
    ),
    GoRoute(
      path: '/raiseIssueDetail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const Raiseissuedetails();
      },
    ),
    GoRoute(
      path: '/issueDetailsbyId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const Issueviewdetails();
      },
    ),
   
    GoRoute(
      path: '/allOffer',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var data = state.extra as Map<String, dynamic>;
        return AlloffersScreen(
          initialIndex: data["initialIndex"],
        );
      },
    ),
    GoRoute(
      path: '/OfferDetails',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const OfferdetailsScreen();
      },
    ),
    GoRoute(
      path: '/myTransaction',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var userId = state.extra as Map<String, dynamic>;

        return MyTransaction(
          userId: userId["userId"],
        );
      },
    ),
    GoRoute(
      path: '/myWallet',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var userId = state.extra as Map<String, dynamic>;

        return WalletScreen(
          userId: userId["userId"],
        );
      },
    ),
    GoRoute(
      path: '/walletHistory',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var userId = state.extra as Map<String, dynamic>;

        return WalletHistoryScreen(
          userId: userId["userId"],
        );
      },
    ),
    GoRoute(
      path: '/setting',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold(
          body: PageLayout_Page(
            appHeading: "Setting Page",
            child: Center(
              child: Text("Setting Page"),
            ),
          ),
        );
      },
    ),
    GoRoute(
        path: '/package',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final uid = state.extra as Map<String, dynamic>;
          return Packages(
            ursID: uid['user'],
          );
        },
        routes: [
       
          GoRoute(
            path: 'packageDetails',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              final pkgId = state.extra as Map<String, dynamic>;
              final usrId = state.extra as Map<String, dynamic>;
              final bookingDate = state.extra as Map<String, dynamic>;
              // return  const PackageDetailsOld();
              return PackageDetails(
                packageId: pkgId['packageID'],
                userId: usrId['userId'],
                bookDate: bookingDate['bookDate'],
              );
            },
          ),
          GoRoute(
            path: 'packageBookingMember',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              final pkgId = state.extra as Map<String, dynamic>;
              final usrId = state.extra as Map<String, dynamic>;
              final amt = state.extra as Map<String, dynamic>;
              final bookingDate = state.extra as Map<String, dynamic>;
              final participantTypes = state.extra as Map<String, dynamic>;
              final activityList = state.extra as Map<String, dynamic>;
              return PackageBookingMemberPage(
                packageID: pkgId["pkgID"],
                userID: usrId['usrID'],
                amt: amt['amt'],
                bookingDate: bookingDate['bookDate'],
                participantTypes: participantTypes['participantTypes'],
                packageActivityList: activityList['activityList'],
              );
            },
          ),
        
          ///History Pages
          GoRoute(
            path: 'packageHistoryManagement',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              final data = state.extra as Map<String, dynamic>;
              return PackageHistoryManagement(userID: data['userID']);
            },
          ),
          GoRoute(
            path: 'packageDetailsPageView',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              final userID = state.extra as Map<String, dynamic>;
              final bookID = state.extra as Map<String, dynamic>;
              final paymentId = state.extra as Map<String, dynamic>;
              return PackagePageViewDetails(
                userId: userID['user'],
                packageBookID: bookID['book'],
                paymentId: paymentId['paymentId'],
              );
            },
          ),
        ]),
    GoRoute(
        path: '/rentalForm',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          return RentalForm(userId: data['userId']);
        },
        routes: [
       
          GoRoute(
            path: 'carsDetails',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;
              var logi = state.extra as Map<String, dynamic>;
              var lati = state.extra as Map<String, dynamic>;
              return CarsDetailsAvailable(
                id: data['id'],
                longitude: logi['logitude'],
                latitude: lati['latitude'],
              );
            },
          ),
          GoRoute(
            path: 'bookYourCab',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;
              var userId = state.extra as Map<String, dynamic>;
              var bookDate = state.extra as Map<String, dynamic>;
              var logi = state.extra as Map<String, dynamic>;
              var lati = state.extra as Map<String, dynamic>;
              var totalAmt = state.extra as Map<String, dynamic>;
              return BookYourCab(
                carType: data['carType'],
                userId: userId['userId'],
                bookingDate: bookDate['bookdate'],
                totalAmt: totalAmt['totalAmt'],
                latitude: logi['longitude'],
                logitude: lati['latitude'],
              );
            },
          ),
        
          GoRoute(
            path: 'rentalCarBooking',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;
              // var longitude = state.extra as Map<String, dynamic>;
              // var latitude = state.extra as Map<String, dynamic>;
              return RentalCarBooking(
                data: data['myId'],
                // lati: latitude['lati'],logi: longitude['logi'],
              );
            },
          ),
          GoRoute(
            path: 'rentalHistory',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;
              return RentalHistoryManagment(
                myId: data['myIdNo'],
              );
            },
          ),
          GoRoute(
            path: 'rentalBookedPageView',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;
              var uid = state.extra as Map<String, dynamic>;
              var paymentId = state.extra as Map<String, dynamic>;
              return RentalBookedPageView(
                bookedId: data["bookedId"].toString(),
                useriD: uid['useriD'],
                paymentId: paymentId['paymentId'],
              );
            },
          ),
          GoRoute(
            path: 'rentalCancelledPageView',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;
              return RentalCancelledPageView(
                cancelledId: data["cancelledId"].toString(),
              );
            },
          ),
        ]),

 
  ],
);


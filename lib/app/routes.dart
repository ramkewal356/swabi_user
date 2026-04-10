// routes.dart

import 'package:flutter/material.dart';

import 'package:flutter_cab/view/customer/enquiry/enquiry_form_screen.dart';
import 'package:flutter_cab/view/customer/my_package/booking_payment_screen.dart';
import 'package:flutter_cab/view/vendor/customer_management/customer_management.dart';
import 'package:flutter_cab/view/vendor/customer_management/view_customer_screen.dart';
import 'package:flutter_cab/view/vendor/offer_management/add_edit_offer_screen.dart';
import 'package:flutter_cab/view/vendor/offer_management/offer_management_screen.dart';
import 'package:flutter_cab/view/vendor/offer_management/view_offer_screen.dart';
import 'package:flutter_cab/view/vendor/payment_management/payment_details_screen.dart';
import 'package:flutter_cab/view/vendor/payment_management/payment_management_screen.dart';
import 'package:flutter_cab/view/vendor/rental_price_management/add_and_edit_rental_price_screen.dart';
import 'package:flutter_cab/view/vendor/rental_price_management/rental_price_management.dart';
import 'package:flutter_cab/view/vendor/subscription_management/subscription_screen.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/view/auth_screens/change_password.dart';
import 'package:flutter_cab/view/customer/enquiry/my_enquiry_screen.dart';
import 'package:flutter_cab/view/customer/enquiry/view_bid_screen.dart';
import 'package:flutter_cab/view/customer/my_package/package_view_screen.dart';
import 'package:flutter_cab/view/help_and_support/contact.dart';
import 'package:flutter_cab/view/help_and_support/help_and_support_screen.dart';
import 'package:flutter_cab/view/notification/notification.dart';
import 'package:flutter_cab/view/profile/profile_page_screen.dart';
import 'package:flutter_cab/view/help_and_support/raiseissue_details_screen.dart';
import 'package:flutter_cab/view/help_and_support/term_condition_screen.dart';
import 'package:flutter_cab/view/customer/my_tranaction/transaction.dart';
import 'package:flutter_cab/view/customer/bottom_navigation_bar_screen.dart';
import 'package:flutter_cab/view/customer/offers_pages/all_offers_screen.dart';
import 'package:flutter_cab/view/customer/raiseIssue_pages/issue_view_details_screen.dart';
import 'package:flutter_cab/view/customer/my_rental/book_your_ride_screen_.dart';
import 'package:flutter_cab/view/customer/my_rental/cancel_booking.dart';
import 'package:flutter_cab/view/customer/my_rental/cars_available_screen.dart';
import 'package:flutter_cab/view/customer/my_rental/history/rental_bookedpage_view.dart';
import 'package:flutter_cab/view/customer/my_rental/history/rental_cancel_page_view.dart';
import 'package:flutter_cab/view/customer/my_rental/history/rental_history_managment_screen.dart';
import 'package:flutter_cab/view/customer/my_rental/rental_form.dart';
import 'package:flutter_cab/view/customer/my_package/package_screen.dart';
import 'package:flutter_cab/view/customer/my_package/package_booking_member_screen.dart';
import 'package:flutter_cab/view/customer/my_package/package_viewdetails_screen.dart';
import 'package:flutter_cab/view/customer/my_package/packageHistory/mypackage_history_screen.dart';
import 'package:flutter_cab/view/vendor/wallet_pages/wallet_history_screen.dart';
import 'package:flutter_cab/view/vendor/wallet_pages/wallet_screen.dart';
import 'package:flutter_cab/view/auth_screens/forgot_screen.dart';
import 'package:flutter_cab/view/auth_screens/login_screen.dart';
import 'package:flutter_cab/view/auth_screens/otp_verification_screen.dart';
import 'package:flutter_cab/view/auth_screens/registration_screen.dart';
import 'package:flutter_cab/view/starting_screen/landing_screen.dart';
import 'package:flutter_cab/view/starting_screen/splash_screen.dart';
import 'package:flutter_cab/view/auth_screens/reset_password_screen.dart';
import 'package:flutter_cab/view/vendor/activity_management_screen/activity_management_screen.dart';
import 'package:flutter_cab/view/vendor/activity_management_screen/add_and_edit_activity_screen.dart';
import 'package:flutter_cab/view/vendor/activity_management_screen/view_activity_screen.dart';
import 'package:flutter_cab/view/vendor/driver_management_screen/add_and_edit_driver_screen.dart';
import 'package:flutter_cab/view/vendor/driver_management_screen/driver_management_screen.dart';
import 'package:flutter_cab/view/vendor/driver_management_screen/view_driver_details_screen.dart';
import 'package:flutter_cab/view/vendor/enquiry_management/bid_now_screen.dart';
import 'package:flutter_cab/view/vendor/enquiry_management/enquiry_management_screen.dart';
import 'package:flutter_cab/view/vendor/package_booking_management.dart/package_booking_management.dart';
import 'package:flutter_cab/view/vendor/package_management/add_and_edit_package_screen.dart';
import 'package:flutter_cab/view/vendor/package_management/package_management_screen.dart';
import 'package:flutter_cab/view/vendor/rental_booking_management_screen/rental_booking_details_screen.dart';
import 'package:flutter_cab/view/vendor/rental_booking_management_screen/rental_booking_management_screen.dart';
import 'package:flutter_cab/view/vendor/vehicle_management_screen/add_and_edit_vehicle_screen.dart';
import 'package:flutter_cab/view/vendor/vehicle_management_screen/vehicle_management_screen.dart';
import 'package:flutter_cab/view/vendor/vehicle_management_screen/view_vehicle_details_screen.dart';
import 'package:flutter_cab/view/vendor/vehicle_owner_management/vehicle_owner_management_screen.dart';
import 'package:flutter_cab/view/vendor/vehicle_owner_management/view_vehicle_owner_details_screen.dart';
import 'package:flutter_cab/view/vendor/vendor_dashboard_screen.dart';
import 'package:go_router/go_router.dart';
import '../view/customer/my_package/packageHistory/package_booking_details.dart';
import '../view/vendor/bid_management_screen/bid_management_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter myRouter = GoRouter(
  initialLocation: '/splash',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashSreen();
        }),
    GoRoute(
        path: '/landing_screen',
        builder: (BuildContext context, GoRouterState state) {
          return const LandingScreen();
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
      path: '/user_dashboard',
      builder: (BuildContext context, GoRouterState state) {
        // var data = state.extra as Map<String, dynamic>;
        return const BottomNavigationBarScreen();
      },
    ),
    // Enquiry form: send (no extra) or update (extra: {'enquiryId': int})
    GoRoute(
      path: '/enquiry_form',
      builder: (context, state) {
        final extra = state.extra is Map<String, dynamic>
            ? state.extra as Map<String, dynamic>
            : null;
        final id = extra?['enquiryId'];
        final enquiryId =
            id is int ? id : (id != null ? int.tryParse(id.toString()) : null);
        return EnquiryFormScreen(enquiryId: enquiryId);
      },
    ),
    GoRoute(
        path: '/send_enquiry',
        builder: (context, state) => const EnquiryFormScreen()),
    GoRoute(
      path: '/notification',
      builder: (BuildContext context, GoRouterState state) {
        return const NotificationPage();
      },
    ),
    GoRoute(
      path: '/package_view',
      builder: (context, state) {
        var data = state.extra as Map<String, dynamic>;
        return PackageViewScreen(
          packageId: data["packageId"],
          userType: data["userType"],
          bookingDate: data["bookingDate"],
          userId: data["userId"],
        );
      },
    ),
    GoRoute(
        path: '/profilePage',
        builder: (BuildContext context, GoRouterState state) {
          var data = state.extra as Map<String, dynamic>;

          return ProfilePage(
            user: data['userId'],
            userType: data["userType"],
          );
        },
        routes: [
          // GoRoute(
          //   path: 'editProfilePage',
          //   builder: (BuildContext context, GoRouterState state) {
          //     var data = state.extra as Map<String, dynamic>;
          //     return EditProfiePage(
          //       usrId: data['uId'],
          //     );
          //   },
          // ),
        ]),
    GoRoute(
      path: '/changePassword',
      // parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        var data = state.extra as Map<String, dynamic>;
        return ChangePassword(
          userId: data['userId'],
          userType: data['idKey'],
        );
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
          forUseVerification: data["forVerify"],
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
        var data = state.extra as HelpAndSupport;
        return HelpAndSupport(userType: data.userType);
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
        var data = state.extra as IssueViewDetails;
        return IssueViewDetails(
          issueId: data.issueId,
          userType: data.userType,
        );
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
        path: '/my_enquiry',
        builder: (context, state) {
          return const MyEnquiryScreen();
        },
        routes: [
          GoRoute(
            path: 'view_bid',
            builder: (context, state) {
              var data = state.extra as Map<String, dynamic>;
              return ViewBidScreen(enquiryId: data["enquiryId"]);
            },
          ),
          GoRoute(
            path: 'update_enquiry',
            builder: (context, state) {
              var data = state.extra as Map<String, dynamic>;
              return EnquiryFormScreen(enquiryId: data["enquiryId"]);
            },
          )
        ]),
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
      path: '/setting',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold(
          body: PageLayoutPage(
            appHeading: "Setting Page",
            child: Center(
              child: Text("Setting Page"),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/rental_booking_details',
      builder: (context, state) {
        var data = state.extra as Map<String, dynamic>;
        return RentalBookingDetailsScreen(
          bookingId: data["bookingId"],
          paymentId: data["paymentId"],
          bookingStatus: data["status"],
          userType: data["userType"],
        );
      },
    ),
    GoRoute(
        path: '/package',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const PackageScreen();
        },
        routes: [
          GoRoute(
            path: 'packageDetails',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              final extra = state.extra as Map<String, dynamic>;

              // return  const PackageDetailsOld();
              return PackageDetails(
                packageId: extra['packageID'],
                userId: extra['userId'],
                bookDate: extra['bookDate'],
                venderId: extra["venderId"],
              );
            },
          ),
          GoRoute(
            path: 'packageBookingMember',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              final extra = state.extra as Map<String, dynamic>;

              return PackageBookingMemberPage(
                packageID: extra["pkgID"],
                userID: extra['usrID'],
                amt: extra['amt'],
                bookingDate: extra['bookDate'],
                participantTypes: extra['participantTypes'],
                packageActivityList: extra['activityList'],
                venderId: extra["venderId"],
                currency: extra["currency"],
              );
            },
          ),
          GoRoute(
            path: 'pay_now',
            builder: (context, state) {
              // var data = state.extra as Map<String, dynamic>;
              final data = state.extra as BookingPaymentScreen;
              return BookingPaymentScreen(
                venderId: data.venderId,
                bookingId: data.bookingId,
                bookingDate: data.bookingDate,
                primaryCountryCode: data.primaryCountryCode,
                primaryNumber: data.primaryNumber,
                secondaryCountryCode: data.secondaryCountryCode,
                secondaryNumber: data.secondaryNumber,
                packageAmount: data.packageAmount,
                sumAmount: data.sumAmount,
                // taxAmount: data.taxAmount,
                // payableAmount: data.payableAmount,
                memberDetails: data.memberDetails,
                packageActivityList: data.packageActivityList,
                currency: data.currency,
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
              final data = state.extra as Map<String, dynamic>;

              return PackagePageViewDetails(
                userType: data['userType'],
                packageBookID: data['bookingId'],
                paymentId: data['paymentId'],
                bookingStatus: data['bookingStatus'],
              );
            },
          ),
        ]),
    GoRoute(
        path: '/rentalForm',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          return const RentalForm();
        },
        routes: [
          GoRoute(
            path: 'carsDetails',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as Map<String, dynamic>;

              return CarsDetailsAvailable(
                id: data['id'],
                longitude: data['logitude'],
                latitude: data['latitude'],
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

    /// vendor routes
    GoRoute(
        path: '/vendor_dashboard',
        builder: (context, state) => const VendorDashboardScreen(),
        routes: [
          GoRoute(
              path: 'bidManagement',
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>?;
                final userId = data != null && data.containsKey("userId")
                    ? data["userId"]
                    : null;
                return BidManagementScreen(userId: userId);
              }),
          GoRoute(
              path: 'enquiryManagement',
              builder: (context, state) {
                var data = state.extra as EnquiryManagementScreen;
                return EnquiryManagementScreen(
                  userId: data.userId,
                );
              }),
          GoRoute(
            path: 'subscription',
            builder: (context, state) => SubscriptionScreen(),
          ),
          GoRoute(
            path: '/myWallet',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              // var userId = state.extra as Map<String, dynamic>;

              return WalletScreen(
                  // userId: userId["userId"],
                  );
            },
          ),
          GoRoute(
            path: '/walletHistory',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              var data = state.extra as WalletHistoryScreen;

              return WalletHistoryScreen(
                transactionList: data.transactionList,
              );
            },
          ),
          GoRoute(
              path: '/payment_management',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (BuildContext context, GoRouterState state) {
                return PaymentManagementScreen();
              },
              routes: [
                GoRoute(
                  path: 'payment_details',
                  builder: (context, state) {
                    var data = state.extra as Map<String, dynamic>;
                    return PaymentDetailsScreen(
                      paymentId: data["paymentId"],
                      forRefunded: data["isRefunded"],
                    );
                  },
                )
              ]),
          GoRoute(
            path: 'bidNow',
            builder: (context, state) {
              final extra = state.extra as BidNowScreen?;
              if (extra == null) {
                return const Scaffold(
                  body: Center(child: Text("Invalid navigation data")),
                );
              }
              return BidNowScreen(
                bidData: extra.bidData,
                enquiryData: extra.enquiryData,
                viewPage: extra.viewPage,
              );
              // if (extra is EnquiryContent) {
              //   return BidNowScreen(enquiryData: extra);
              // } else if (extra is BidContent) {
              //   return BidNowScreen(bidData: extra);
              // } else {
              //   return const Scaffold(
              //     body: Center(child: Text("Invalid navigation data")),
              //   );
              // }
            },
          ),
          GoRoute(
              path: '/offer_management',
              builder: (context, state) {
                return OfferManagementScreen();
              },
              routes: [
                GoRoute(
                  path: 'view_offer',
                  builder: (context, state) {
                    var data = state.extra as ViewOfferScreen;
                    return ViewOfferScreen(offerId: data.offerId);
                  },
                ),
                GoRoute(
                  path: 'add_or_edit_offer',
                  builder: (context, state) {
                    var data = state.extra as AddAndEditOfferScreen;
                    return AddAndEditOfferScreen(
                      offerId: data.offerId,
                      isEdit: data.isEdit,
                    );
                  },
                )
              ]),
          GoRoute(
              path: 'activity_management',
              builder: (context, state) {
                return ActivityManagementScreen();
              },
              routes: [
                GoRoute(
                  path: 'add_edit_activity',
                  builder: (context, state) {
                    var data = state.extra as Map<String, dynamic>?;
                    return AddAndEditActivityScreen(
                      isEdit: data?["isEdit"] ?? false,
                      activityId: data?["activityId"],
                    );
                  },
                ),
                GoRoute(
                    path: 'view_activity',
                    builder: (context, state) {
                      var data = state.extra as Map<String, dynamic>;
                      return ViewActivityScreen(
                        activityId: data["activityId"],
                      );
                    })
              ]),
          GoRoute(
              path: 'package_management',
              builder: (context, state) {
                return PackageManagementScreen();
              },
              routes: [
                GoRoute(
                  path: 'add_edit_package',
                  builder: (context, state) {
                    var data = state.extra as Map<String, dynamic>?;
                    return AddAndEditPackageScreen(
                      isEdit: data?["isEdit"] ?? false,
                      packageId: data?["packageId"],
                    );
                  },
                )
              ]),
          GoRoute(
              path: 'rentalManagement',
              builder: (context, state) {
                String? userId;
                if (state.extra != null &&
                    state.extra is Map<String, dynamic> &&
                    (state.extra as Map<String, dynamic>)
                        .containsKey('userId')) {
                  userId = (state.extra as Map<String, dynamic>)['userId'];
                }
                return RentalBookingManagementScreen(userId: userId);
              }),
          GoRoute(
            path: 'package_booking_management',
            builder: (context, state) {
              String? userId;
              if (state.extra != null &&
                  state.extra is Map<String, dynamic> &&
                  (state.extra as Map<String, dynamic>).containsKey('userId')) {
                userId = (state.extra as Map<String, dynamic>)['userId'];
              }
              return PackageBookingManagement(userId: userId);
            },
          ),
          GoRoute(
              path: 'vehicle_management',
              builder: (context, state) => const VehicleManagementScreen(),
              routes: [
                GoRoute(
                    path: 'view_vehicle_details',
                    builder: (context, state) {
                      var data = state.extra as Map<String, dynamic>;
                      return ViewVehicleDetailsScreen(
                        vehicleId: data["vehicleId"],
                      );
                    }),
                GoRoute(
                  path: 'add_edit_vehicle',
                  builder: (context, state) {
                    var data = state.extra as Map<String, dynamic>?;
                    return AddAndEditVehicleScreen(
                      isEdit: data?["isEdit"] ?? false,
                      vehicleId: data?["vehicleId"],
                      ownerId: data?["ownerId"],
                      actionByOwner: data?["actionByOwner"] ?? '',
                    );
                  },
                )
              ]),
          GoRoute(
              path: 'vehicle_owner_management',
              builder: (context, state) => const VehicleOwnerManagementScreen(),
              routes: [
                GoRoute(
                    path: 'view_vehicle_owner_details',
                    builder: (context, state) {
                      var data = state.extra as Map<String, dynamic>;
                      return ViewVehicleOwnerDetailsScreen(
                        ownerId: data["ownerId"],
                      );
                    }),
              ]),
          GoRoute(
            path: 'driver_management',
            builder: (context, state) {
              return DriverManagementScreen();
            },
            routes: [
              GoRoute(
                path: 'view_driver_details',
                builder: (context, state) {
                  var data = state.extra as Map<String, dynamic>;
                  return ViewDriverDetailsScreen(
                    driverId: data["driverId"],
                  );
                },
              ),
              GoRoute(
                  path: 'add_edit_driver',
                  builder: (context, state) {
                    var data = state.extra as Map<String, dynamic>?;
                    return AddAndEditDriverScreen(
                      isEdit: data?["isEdit"] ?? false,
                      driverId: data?["driverId"],
                    );
                  })
            ],
          ),
          GoRoute(
              path: 'customer_management',
              builder: (context, state) => CustomerManagementScreen(),
              routes: [
                GoRoute(
                  path: 'view_customer',
                  builder: (context, state) {
                    var data = state.extra as ViewCustomerScreen;
                    return ViewCustomerScreen(customerData: data.customerData);
                  },
                )
              ]),
          GoRoute(
              path: 'rental_price_management',
              builder: (context, state) => RentalPriceManagement(),
              routes: [
                GoRoute(
                  path: 'add_edit_rental_price',
                  builder: (context, state) {
                    final data = state.extra as Map<String, dynamic>?;
                    return AddAndEditRentalPriceScreen(
                      isEdit: data?['isEdit'] ?? false,
                      rentalPriceItem: data?['rentalPriceItem'],
                    );
                  },
                ),
              ])
        ])
  ],
);

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view/vendor/enquiry_management/enquiry_management_screen.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/custom_drawer.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:flutter_cab/view_model/vendor_dashboard_view_model.dart';
import 'package:flutter_cab/view_model/vendor_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int unReadItem = 0;
  @override
  void initState() {
    _getVender();
    super.initState();
  }

  void _getVender() {
    context.read<VendorViewModel>().getVendorByIdApi();
    _getAllDashboardData();
  }

  void _getAllDashboardData() {
    context.read<VendorDashboardViewModel>().getAllVehicleApi();
    context.read<VendorDashboardViewModel>().getAllDriverApi();
    context.read<VendorDashboardViewModel>().getAllRentalBookingApi();
    context.read<VendorDashboardViewModel>().getAllPackageBookingApi();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: Consumer<VendorViewModel>(builder: (context, vm, snapshot) {
        var data = vm.vendorData;
        var allVenderData = data.data?.data;
        debugPrint('All status code ${data.status}');
        return Scaffold(
          backgroundColor: bgGreyColor,
          appBar: AppBar(
            backgroundColor: background,
            title: Image.asset(
              appLogo1,
              height: 24,
            ),
            centerTitle: true,
            actions: [
              Consumer<NotificationViewModel>(
                builder: (context, value, child) {
                  unReadItem = value.totalUnreadNotification ?? 0;
                  return InkWell(
                    onTap: () {
                      Provider.of<NotificationViewModel>(context, listen: false)
                          .updateNotification(context: context)
                          .then((onValue) {
                        if (onValue?.status?.httpCode == '200') {
                          // context.push('/notification',
                          //     extra: {'userId': uId}).then((onValue) {
                          //   // getNotification();
                          // });
                        }
                      });
                    },
                    child: Badge(
                      backgroundColor: btnColor,
                      isLabelVisible: unReadItem == 0 ? false : true,
                      label: Text(unReadItem.toString()),
                      child: const Icon(
                        Icons.notifications_none_outlined,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10)
            ],
          ),
          drawer: CustomDrawer(
            userName: '${allVenderData?.firstName} ${allVenderData?.lastName}',
            emailAddress: '${allVenderData?.email}',
            profileUrl: '${allVenderData?.vendorProfileImageUrl}',
            lastLogin: 'Last login: ${allVenderData?.lastLogin}',
            menuItems: [
              {
                "imgUrl": Icons.dashboard, "label": "Dashboard", "onTap": () {}},
              {
                "imgUrl": profile,
                "label": "My Profile",
                "onTap": () {
                  context.push("/profilePage", extra: {
                    "userId": allVenderData?.vendorId.toString() ?? '',
                    "userType": 'VENDOR'
                  }).then((onValue) {
                    _getVender();
                  });
                }
              },
              {
                "imgUrl": transaction,
                "label": "Enquiry Management",
                "onTap": () {
                  context.push("/vendor_dashboard/enquiryManagement",
                      extra: EnquiryManagementScreen());
                }
              },
              {
                "imgUrl": Icons.gavel_rounded,
                "label": "Bid Management",
                "onTap": () {
                  context.push("/vendor_dashboard/bidManagement");
                }
              },
              {
                "imgUrl": dollorIcon,
                "label": "Subscription",
                "onTap": () {
                  context.push("/vendor_dashboard/subscription");
                }
              },
              {
                "imgUrl": rentalbooking,
                "label": "Rental Management",
                "onTap": () {
                  context.push("/vendor_dashboard/rentalManagement");
                }
              },
              {
                "imgUrl": rentalbooking,
                "label": "Package booking Management",
                "onTap": () {
                  context.push("/vendor_dashboard/package_booking_management");
                }
              },
              {
                "imgUrl": vehicleImage,
                "label": "Vehicle Management",
                "onTap": () {
                  context.push("/vendor_dashboard/vehicle_management");
                }
              },
              {
                "imgUrl": user,
                "label": "Vehicle Owner Management",
                "onTap": () {
                  context.push("/vendor_dashboard/vehicle_owner_management");
                }
              },
              {
                "imgUrl": driverImage,
                "label": "Driver Management",
                "onTap": () {
                  context.push("/vendor_dashboard/driver_management");
                }
              },
              {
                "imgUrl": advanceBookingIcon,
                "label": "Activity Management",
                "onTap": () {
                  context.push('/vendor_dashboard/activity_management');
                }
              },
              {
                "imgUrl": package,
                "label": "Package Management",
                "onTap": () {
                  context.push('/vendor_dashboard/package_management');
                }
              },
              {
                "imgUrl": moneyTransaction,
                "label": "Payment Management",
                "onTap": () {
                  context.push("/vendor_dashboard/payment_management");
                }
              },
              {
                "imgUrl": myWallet,
                "label": "Wallet management",
                "onTap": () {
                  context.push('/vendor_dashboard/myWallet');
                }
              },
              {
                "imgUrl": offers,
                "label": "Offers Management",
                "onTap": () {
                  context.push("/vendor_dashboard/offer_management");
                }
              },
              {
                "imgUrl": Icons.groups_3_outlined,
                "label": "Customer Management",
                "onTap": () {
                  context.push("/vendor_dashboard/customer_management");
                }
              },
              {
                "imgUrl": helpSupport,
                "label": "Help & Support",
                "onTap": () {
                  context.push("/help&support");
                }
              },
              {
                "imgUrl": logout,
                "label": "Logout",
                "onTap": () {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    _confirmLogout(context);
                  });
                }
              },
            ],
          ),
          body: Builder(builder: (context) {
            if (data.status == Status.loading) {
              return const Center(
                  child: SpinKitFadingCube(
                size: 50,
                duration: Duration(milliseconds: 1200),
                color: Colors.red,
              ));
            }

            if (data.status == Status.error) {
              return const Center(
                child:
                    Text("No data found", style: TextStyle(color: Colors.red)),
              );
            }

            return SingleChildScrollView(
              child: Consumer<VendorDashboardViewModel>(
                builder: (context, vm, state) {
                  final vehicleData = vm.allVehicleData.data?.data;
                  final driverData = vm.allDriverData.data?.data;
                  final rentalData = vm.allRentalBookingData.data?.data;
                  final packageData = vm.allPackageBookingData.data?.data;
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      _customCard(
                          title: 'Vehicles',
                          children: [
                            itemText(
                                lable: 'Total',
                                value: '${vehicleData?.totalVehicle ?? 0}'),
                            itemText(
                                lable: 'Active',
                                value:
                                    '${vehicleData?.numberOfActiveVehicle ?? 0}'),
                            itemText(
                                lable: 'Inactive',
                                value:
                                    '${vehicleData?.numberOfInActiveVehicle ?? 0}')
                          ],
                          image: vehicleImage),
                      _customCard(
                          title: 'Drivers',
                          children: [
                            itemText(
                                lable: 'Total',
                                value: '${driverData?.totalDriver ?? 0}'),
                            itemText(
                                lable: 'Active',
                                value:
                                    '${driverData?.numberOfActiveDriver ?? 0}'),
                            itemText(
                                lable: 'Inactive',
                                value:
                                    '${driverData?.numberOfInActiveDriver ?? 0}')
                          ],
                          image: driverImage),
                      _customCard(
                          title: 'Rental Bookings',
                          children: [
                            itemText(
                                lable: 'UpComing',
                                value:
                                    '${rentalData?.numberOfBookedRentalBooking ?? 0}'),
                            itemText(
                                lable: 'OnGoing',
                                value:
                                    '${rentalData?.numberOfOnRunningRentalBooking ?? 0}'),
                            itemText(
                                lable: 'Completed',
                                value:
                                    '${rentalData?.numberOfCompletedRentalBooking ?? 0}'),
                            itemText(
                                lable: 'Cancelled',
                                value:
                                    '${rentalData?.numberOfCancelledRentalBooking ?? 0}')
                          ],
                          image: rentalbookingImage),
                      _customCard(
                          title: 'Package Bookings',
                          children: [
                            itemText(
                                lable: 'Total',
                                value:
                                    '${packageData?.totalPackageBooking ?? 0}'),
                            itemText(
                                lable: 'UpComing',
                                value:
                                    '${packageData?.numberOfUpcomingPackageBooking ?? 0}'),
                            itemText(
                                lable: 'Completed',
                                value:
                                    '${packageData?.numberOfCompletedPackageBooking ?? 0}'),
                            itemText(
                                lable: 'Cancelled',
                                value:
                                    '${packageData?.numberOfCancelledPackageBooking ?? 0}')
                          ],
                          image: packageImage),
                    ],
                  );
                },
              ),
            );
          }),
        );
      }),
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (context) => exitContainer(),
        );
        return shouldExit;
      },
    );
  }

  ///Exit Container Dialog Box
  Widget exitContainer() {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Text(
                'Are you sure want to exit ?',
                style: pageHeadingTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButtonSmall(
                    width: 70,
                    height: 40,
                    btnHeading: "NO",
                    onTap: () {
                      context.pop();
                    },
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  CustomButtonSmall(
                    width: 70,
                    height: 40,
                    btnHeading: "YES",
                    onTap: () {
                      exit(0);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: background,
          surfaceTintColor: background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 20),
                      child: Text(
                        'Are you sure want to Logout ?',
                        style: titleTextStyle,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButtonSmall(
                        height: 40,
                        // width: 70,
                        btnHeading: "Cancel",
                        onTap: () {
                          context.pop();
                        },
                      ),
                      CustomButtonSmall(
                        // width: 70,
                        height: 40,
                        btnHeading: "Logout",
                        onTap: () {
                          UserViewModel().remove(context);

                          context.go("/landing_screen");
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _customCard(
      {required String title,
      required List<Widget> children,
      required String image}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shadowColor: btnColor,
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: buttonText,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: children,
                  ),
                ),
                Image.asset(
                  image,
                  height: 100,
                  width: 120,
                  fit: BoxFit.cover,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget itemText({required String lable, required String value}) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            lable,
            style: titleGrayColor,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: titleGrayColor,
          ),
        )
      ],
    );
  }
}

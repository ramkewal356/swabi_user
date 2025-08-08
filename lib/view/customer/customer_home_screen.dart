import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cab/model/offer_list_model.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
// import 'package:flutter_cab/res/custom_drawer.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view/customer/account_screen.dart';
import 'package:flutter_cab/view/customer/enquiry/send_enquiry_screen.dart';
import 'package:flutter_cab/view/customer/my_rental/rental_form.dart';
import 'package:flutter_cab/view/customer/my_package/package_screen.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:badges/badges.dart' as badges;

///Home Screen Old
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen>
    with TickerProviderStateMixin {
  UserViewModel userViewModel = UserViewModel();
  // final ScrollController _scrollController = ScrollController();
  DateTime dateTime = DateTime.now();

  // String uId = '';
  int selectIndex = -1;
  int initialIndex = 0;
  int _initialIndex = 0;
  int unReadItem = 0;
  TabController? _tabcontroller;
  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUser();

      _tabcontroller?.addListener(() {
        setState(() {
          _initialIndex = _tabcontroller?.index ?? 0;
        });
        debugPrint('gfgfgfgh $_initialIndex');
      });
    });
  }

  void getUser() async {
  

      // ignore: use_build_context_synchronously
      final userProfile = await context
          .read<UserProfileViewModel>()
          .fetchUserProfileViewModelApi();

      if (userProfile != null) {
        setState(() {
          userdata = userProfile.data;
        });
        getNotification();
      }
    // }
  }

  void getNotification() {
    Provider.of<NotificationViewModel>(context, listen: false)
        .getAllNotificationList(
            context: context,
         
            pageNumber: 0,
            pageSize: 100,
            readStatus: 'FALSE');
  }

  @override
  void dispose() {
    super.dispose();
    _tabcontroller!.dispose();
  }

  bool loading = false;

  ProfileData? userdata;
  OfferListModel? offerListData;
  bool isLoadingData = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Packages(),
    const RentalForm(),
    const SendEnquiryScreen(),
    const AccountScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    userdata = context.watch<UserProfileViewModel>().dataList.data?.data;

    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          bool shouldExit = await showDialog(
            context: context,
            builder: (context) => exitContainer(),
          );
          return shouldExit;
        },
        child: Scaffold(
            backgroundColor: background,
            onDrawerChanged: (isOpened) {
              getNotification();
            },
            appBar: AppBar(
              backgroundColor: Colors.white,
              // automaticallyImplyLeading: false,
            
              scrolledUnderElevation: 0,
              titleSpacing: 0,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                radius: 20,
                child: (userdata?.profileImageUrl ?? '').isEmpty
                    ? const Icon(Icons.person)
                    : Image.network(
                        userdata?.profileImageUrl ?? '',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // leading: Builder(
            //   builder: (BuildContext context) {
            //     return IconButton(
            //       icon: const Icon(
            //         Icons.notes_rounded,
            //         size: 26,
            //         // color: Colors.white,
            //       ),
            //       onPressed: () {
            //         Scaffold.of(context)
            //             .openDrawer(); // Use the context from Builder
            //       },
            //     );
            //   },
            // ),

              centerTitle: true,
            title: _selectedIndex == 0
                ? InkWell(
                  onTap: () {
                    setState(() {
                      _tabcontroller?.index = 0;
                    });

                    context.go('/user_dashboard');
                    debugPrint("Custom Appbar");
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Image.asset(
                      // appIcon1,
                      appLogo1,
                      height: 24,
                      // width: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                  // child: Image.asset(appLogo1)
                    )
                : _selectedIndex == 1
                    ? const Text('Rental booking')
                    : _selectedIndex == 2
                        ? const Text('Send Enquiry')
                        : _selectedIndex == 3
                            ? const Text('My Account')
                            : const Text('Dashboard'),

              actions: [
                Consumer<NotificationViewModel>(
                  builder: (context, value, child) {
                    unReadItem = value.totalUnreadNotification ?? 0;
                    return InkWell(
                      onTap: () {
                        Provider.of<NotificationViewModel>(context,
                                listen: false)
                          .updateNotification(
                        context: context,
                      )
                            .then((onValue) {
                          if (onValue?.status?.httpCode == '200') {
                            context.push('/notification',
                          )
                              .then((onValue) {
                              getNotification();
                            });
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
          // drawer: CustomDrawer(
          //   userName:
          //       '${userdata?.firstName ?? ""} ${userdata?.lastName ?? ''}',
          //   emailAddress: userdata?.email ?? '',
          //   lastLogin: (userdata?.lastLogin ?? '').isEmpty
          //       ? ''
          //       : 'Last login : ${userdata?.lastLogin}',
          //   profileUrl: userdata?.profileImageUrl ?? '',
          //   menuItems: [
          //     {
          //       "imgUrl": profile,
          //       "label": "My Profile",
          //       "onTap": () {
          //         context.push("/profilePage", extra: {
          //           "userId": userdata?.userId ?? "",
          //           "userType": 'USER'
          //         }).then((onValue) {
          //           getUser();
          //         });
          //       }
          //     },
          //     {
          //       "imgUrl": transaction,
          //       "label": "My Enquiries",
          //       "onTap": () {}
          //     },
          //     {
          //       "imgUrl": rentalbooking,
          //       "label": "My Rental",
          //       "onTap": () {
          //         context.push("/rentalForm/rentalHistory",
          //             extra: {"myIdNo": userdata?.userId});
          //       }
          //     },
          //     {
          //       "imgUrl": package,
          //       "label": "My Package",
          //       "onTap": () {
          //         context.push("/package/packageHistoryManagement",
          //             extra: {"userID": userdata?.userId});
          //       }
          //     },
          //     {
          //       "imgUrl": offers,
          //       "label": "All Offers",
          //       "onTap": () {
          //         context.push("/allOffer", extra: {'initialIndex': 0});
          //       }
          //     },
          //     {
          //       "imgUrl": moneyTransaction,
          //       "label": "My Trasaction",
          //       "onTap": () {
          //         context.push("/myTransaction",
          //             extra: {"userId": userdata?.userId});
          //       }
          //     },
          //     {
          //       "imgUrl": myWallet,
          //       "label": "My Wallet",
          //       "onTap": () {
          //         context
          //             .push("/myWallet", extra: {"userId": userdata?.userId});
          //       }
          //     },
          //     {
          //       "imgUrl": helpSupport,
          //       "label": "Help & Support",
          //       "onTap": () {
          //         context.push("/help&support");
          //       }
          //     },
          //     {
          //       "imgUrl": logout,
          //       "label": "Logout",
          //       "onTap": () {
          //         Future.delayed(const Duration(milliseconds: 200), () {
          //           _confirmLogout(context);
          //         });
          //       }
          //     },
          //   ],
          // ),

          //   body: Container(
          //     color: bgGreyColor,
          //     child: Column(
          //       children: [
          //         const SizedBox(height: 10),
          //         Container(
          //           margin: const EdgeInsets.symmetric(horizontal: 10),
          //           decoration: BoxDecoration(
          //               color: background,
          //               borderRadius: BorderRadius.circular(10),
          //               border: Border.all(
          //                   color: naturalGreyColor.withOpacity(0.3))),
          //           child: TabBar(
          //               onTap: (value) {},
          //               controller: _tabcontroller,
          //               splashBorderRadius: BorderRadius.circular(20),
          //               unselectedLabelColor: Colors.black87,
          //               labelColor: btnColor,
          //               indicatorColor: Colors.transparent,
          //               dividerColor: Colors.transparent,
          //               indicatorPadding:
          //                   const EdgeInsets.symmetric(horizontal: 10),
          //               indicatorSize: TabBarIndicatorSize.tab,
          //               tabs: [
          //               // Padding(
          //               //   padding: const EdgeInsets.symmetric(vertical: 10),
          //               //   child: Column(
          //               //     children: [
          //               //       Center(
          //               //           child: Image.asset(
          //               //         holidays,
          //               //         height: 35,
          //               //         color: _initialIndex == 0
          //               //             ? btnColor
          //               //             : blackColor,
          //               //       )),
          //               //       const SizedBox(height: 5),
          //               //       Text(
          //               //         "Holiday Packages",
          //               //         style: GoogleFonts.lato(
          //               //             fontSize: 16,
          //               //             fontWeight: FontWeight.w600),
          //               //         textAlign: TextAlign.center,
          //               //         // style: titleTextStyle,
          //               //       ),
          //               //     ],
          //               //   ),
          //               // ),
          //               // Padding(
          //               //   padding: const EdgeInsets.symmetric(vertical: 10),
          //               //   child: Column(
          //               //     children: [
          //               //       Image.asset(
          //               //         carRental,
          //               //         height: 35,
          //               //         color: _initialIndex == 1
          //               //             ? btnColor
          //               //             : blackColor,
          //               //       ),
          //               //       const SizedBox(height: 5),
          //               //       Text(
          //               //         'Rental Vehicle',
          //               //         style: GoogleFonts.lato(
          //               //             fontSize: 16,
          //               //             fontWeight: FontWeight.w600),
          //               //       ),
          //               //     ],
          //               //   ),
          //               // )
          //               Tab(icon: Icon(Icons.card_travel), text: "Holiday"),
          //               Tab(icon: Icon(Icons.car_rental), text: "Rental"),
          //               Tab(icon: Icon(Icons.email), text: "Enquiry"),
          //               ]),
          //         ),
          //         Expanded(
          //           child: TabBarView(controller: _tabcontroller, children: [
          //             Packages(
          //               ursID: uId,
          //             ),
          //           RentalForm(userId: uId),
          //           Text('data')
          //           ]),
          //         )
          //       ],
          //     ),
          // ),
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xff7B1E34)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              backgroundColor: Colors.transparent,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel),
                  label: "Holiday",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.car_rental),
                  label: "Rental",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.email),
                  label: "Enquiry",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Account')
              ],
            ),
          ),
        ));
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

}

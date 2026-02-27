// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/offer_list_model.dart';
import 'package:flutter_cab/data/models/user_profile_model.dart';
import 'package:flutter_cab/view/customer/customer_home_screen.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
// import 'package:flutter_cab/res/custom_drawer.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view/customer/account_screen.dart';
// import 'package:flutter_cab/view/customer/enquiry/send_enquiry_screen.dart';
import 'package:flutter_cab/view/customer/my_rental/rental_form.dart';
import 'package:flutter_cab/view/customer/my_package/package_screen.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:badges/badges.dart' as badges;

///Home Screen Old
class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
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
    final vm = context.read<UserProfileViewModel>();
    await vm.fetchUserProfileViewModelApi();

    if (vm.dataList.data?.data != null) {
      setState(() {
        userdata = vm.dataList.data?.data;
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
    CustomerHomeScreen(),
    const PackageScreen(),
    const RentalForm(),
    // const SendEnquiryScreen(),
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

 
    return WillPopScope(
        onWillPop: () async {
          debugPrint('exziiiiiiiiii');
          final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => exitContainer(context),
              ) ??
              false;
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
                backgroundColor: Colors.grey.shade200,

                // If no user image => show local asset
                backgroundImage: null,

                // If user image available => show network
                child: (userdata?.profileImageUrl ?? '').isEmpty
                    ? Icon(Icons.person)
                    : ClipOval(
                        child: Image.network(
                          userdata?.profileImageUrl ?? '',
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              user,
                              fit: BoxFit.cover,
                              height: 35,
                              width: 35,
                            );
                          },
                        ),
                      ),
              ),
            ),

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
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 0),
                      child: Image.asset(
                        // appIcon1,
                        appLogo1,
                        height: 35,
                        // width: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                    // child: Image.asset(appLogo1)
                    )
                : _selectedIndex == 1
                    ? Text(
                        'Package booking',
                        style: appBarTitleStyle,
                      )
                    : _selectedIndex == 2
                        ? Text(
                            'Rental booking',
                            style: appBarTitleStyle,
                          )
                        // ? Text(
                        //     'Send Enquiry',
                        //     style: appBarTitleStyle,
                        //   )
                        : _selectedIndex == 3
                            ? Text(
                                'My Account',
                                style: appBarTitleStyle,
                              )
                            : Text(
                                'Dashboard',
                                style: appBarTitleStyle,
                              ),

            actions: [
              Consumer<NotificationViewModel>(
                builder: (context, value, child) {
                  unReadItem = value.totalUnreadNotification ?? 0;
                  return InkWell(
                    onTap: () {
                      Provider.of<NotificationViewModel>(context, listen: false)
                          .updateNotification(
                        context: context,
                      )
                          .then((onValue) {
                        if (onValue?.status?.httpCode == '200') {
                          // ignore: use_build_context_synchronously
                          context
                              .push(
                            '/notification',
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
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  btnColor.withOpacity(0.85),
                  btnColor,
                  // Color(0xFFEF4444), Color(0xff7B1E34)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // begin: Alignment.centerLeft,
                // end: Alignment.centerRight,
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
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel),
                  label: "Holiday",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.car_rental),
                  label: "Rental",
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.email),
                //   label: "Enquiry",
                // ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Account')
              ],
            ),
          ),
        ));
  }

  ///Exit Container Dialog Box
  Widget exitContainer(BuildContext context) {
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cab/model/offer_list_model.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view/dashboard/account_screen.dart';
import 'package:flutter_cab/view/dashboard/rental/rental_form.dart';
import 'package:flutter_cab/view/dashboard/tourPackage/package_screen.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

///Home Screen Old
class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen>
    with TickerProviderStateMixin {
  UserViewModel userViewModel = UserViewModel();
  final ScrollController _scrollController = ScrollController();
  DateTime dateTime = DateTime.now();

  String uId = '';
  int selectIndex = -1;
  int initialIndex = 0;
  int _initialIndex = 0;
  int unReadItem = 0;
  TabController? _tabcontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabcontroller = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel.getUserId().then((value) {
        setState(() {
          if (value.userId != null && value.userId != '') {
            uId = value.userId.toString();
          }
        });
        Provider.of<UserProfileViewModel>(context, listen: false)
            .fetchUserProfileViewModelApi(context, {"userId": uId});
        getNotification();
      });
      _tabcontroller?.addListener(() {
        setState(() {
          _initialIndex = _tabcontroller?.index ?? 0;
        });
        debugPrint('gfgfgfgh $_initialIndex');
      });
      // Provider.of<OfferViewModel>(context, listen: false).getOfferList(
      //     context: context, date: DateFormat('dd-MM-yyyy').format(dateTime));
    });
    // _scrollController.addListener(_scrollListener);
  }

  void getNotification() {
    Provider.of<NotificationViewModel>(context, listen: false)
        .getAllNotificationList(
            context: context,
            userId: uId,
            pageNumber: 0,
            pageSize: 100,
            readStatus: 'FALSE');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabcontroller!.dispose();
  }

  bool loading = false;

  ProfileData? userdata;
  OfferListModel? offerListData;
  bool isLoadingData = false;
  @override
  Widget build(BuildContext context) {
    // print("UserId here at homeScreen $uId");
    userdata = context.watch<UserProfileViewModel>().DataList.data?.data;

   
    return PopScope(
        canPop: false,
        onPopInvoked: (val) async {
          if (GoRouterState.of(context).uri.toString() != '/') {
            context.go('/');
            // return;
          } else if (GoRouterState.of(context).uri.toString() == '/') {
            await showDialog(
                context: context, builder: (context) => exitContainer());
          }
        },
        child: Scaffold(
            backgroundColor: background,
            onDrawerChanged: (isOpened) {
              Provider.of<UserProfileViewModel>(context,
                                listen: false)
                            .fetchUserProfileViewModelApi(
                                context, {"userId": uId});
              getNotification();
            },
            appBar: AppBar(
              backgroundColor: Colors.white,
              // automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              titleSpacing: 0,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.notes_rounded,
                      size: 26,
                      // color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context)
                          .openDrawer(); // Use the context from Builder
                    },
                  );
                },
              ),

              centerTitle: true,
              title: InkWell(
                  onTap: () {
                    setState(() {
                      _tabcontroller?.index = 0;
                    });

                    context.go('/');
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
                  ),
                  
              actions: [
                Consumer<NotificationViewModel>(
                  builder: (context, value, child) {
                    unReadItem = value.totalUnreadNotification ?? 0;
                    return InkWell(
                      onTap: () {
                        Provider.of<NotificationViewModel>(context,
                                listen: false)
                            .updateNotification(context: context, userId: uId)
                            .then((onValue) {
                          if (onValue?.status?.httpCode == '200') {
                            context.push('/notification',
                                extra: {'userId': uId}).then((onValue) {
                              getNotification();
                            });
                          }
                        });
                      },
                      child: Badge(
                        backgroundColor: btnColor,
                        isLabelVisible: unReadItem == 0 ? false : true,
                        label: Text('${unReadItem.toString()}'),
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
            drawer: Drawer(
              backgroundColor: bgGreyColor,
              child: AccountScreen(
                userId: uId,
                userdata: userdata,
              ),
            ),
            body: Container(
              color: bgGreyColor,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: naturalGreyColor.withOpacity(0.3))),
                    child: TabBar(
                        onTap: (value) {},
                        controller: _tabcontroller,
                        splashBorderRadius: BorderRadius.circular(20),
                        // indicator: BoxDecoration(
                        //     border: _initialIndex == 0
                        //         ? Border(right: BorderSide())
                        //         : Border(left: BorderSide())),
                        unselectedLabelColor: Colors.black87,
                        labelColor: btnColor,
                        indicatorColor: Colors.transparent,
                        dividerColor: Colors.transparent,
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Center(
                                    child: Image.asset(
                                  holidays,
                                  height: 35,
                                  color: _initialIndex == 0
                                      ? btnColor
                                      : blackColor,
                                )),
                                const SizedBox(height: 5),
                                Text(
                                  "Holiday Packages",
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                  // style: titleTextStyle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Image.asset(
                                  carRental,
                                  height: 35,
                                  color: _initialIndex == 1
                                      ? btnColor
                                      : blackColor,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Rental Vehicle',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                  Expanded(
                    child: TabBarView(controller: _tabcontroller, children: [
                      Packages(ursID: uId),
                      RentalForm(userId: uId)
                    ]),
                  )
                ],
              ),
            )));
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

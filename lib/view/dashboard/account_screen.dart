import 'package:flutter/material.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/custom_list_tile.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/notification_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  final String userId;
  final ProfileData? userdata;
  const AccountScreen(
      {super.key, required this.userId, required this.userdata});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool noti = false;

  UserViewModel userViewModel = UserViewModel();

  @override
  void initState() {
    super.initState();
    _loadNotiValue();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotification();
    });
  }

  // Load the saved noti value from SharedPreferences
  Future<void> _loadNotiValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      noti = prefs.getBool('noti') ?? false;
    });
  }

  // Save the noti value to SharedPreferences
  Future<void> _saveNotiValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('noti', value);
  }

  void getNotification() {
    Provider.of<NotificationViewModel>(context, listen: false)
        .getAllNotificationList(
            context: context,
            userId: widget.userId,
            pageNumber: 0,
            pageSize: 100,
            readStatus: 'FALSE');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("${widget.userdata?.lastLogin}    Data of Notification");
    debugPrint("${widget.userId}Data of UserId");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // padding: EdgeInsets.only(bottom: 20),
      children: [
        UserAccountsDrawerHeader(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(color: btnColor),
          currentAccountPictureSize: const Size.square(65),
          accountName: Text(
            '${widget.userdata?.firstName ?? ''} ${widget.userdata?.lastName ?? ''}',
            style: GoogleFonts.lato(
                color: background, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          accountEmail: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userdata?.email ?? 'xyz@gmail.com',
                style: GoogleFonts.lato(
                    color: background,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                  'Last sync : ${widget.userdata?.lastLogin.replaceAll(RegExp(r':\d{2} [A-Z]{3}$'), '') ?? ''}'),
            ],
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
              (widget.userdata?.profileImageUrl ??
                          'https://up.yimg.com/ib/th?id=OIP.eCrcK2BiqwBGE1naWwK3UwHaHa&pid=Api&rs=1&c=1&qlt=95&w=115&h=115')
                      .isNotEmpty
                  ? widget.userdata?.profileImageUrl ??
                      'https://up.yimg.com/ib/th?id=OIP.eCrcK2BiqwBGE1naWwK3UwHaHa&pid=Api&rs=1&c=1&qlt=95&w=115&h=115'
                  : 'https://up.yimg.com/ib/th?id=OIP.eCrcK2BiqwBGE1naWwK3UwHaHa&pid=Api&rs=1&c=1&qlt=95&w=115&h=115',
            ),
            child: ClipOval(
              child: Image.network(
                (widget.userdata?.profileImageUrl ??
                            'https://up.yimg.com/ib/th?id=OIP.eCrcK2BiqwBGE1naWwK3UwHaHa&pid=Api&rs=1&c=1&qlt=95&w=115&h=115')
                        .isNotEmpty
                    ? widget.userdata?.profileImageUrl ??
                        'https://up.yimg.com/ib/th?id=OIP.eCrcK2BiqwBGE1naWwK3UwHaHa&pid=Api&rs=1&c=1&qlt=95&w=115&h=115'
                    : 'https://up.yimg.com/ib/th?id=OIP.eCrcK2BiqwBGE1naWwK3UwHaHa&pid=Api&rs=1&c=1&qlt=95&w=115&h=115',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        // const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Custom_ListTile(
            img: profile,
            iconColor: btnColor,
            heading: "My Profile",
            // onTap: () => context.push("/profilePage",extra: {"userId":widget.userId}),
            onTap: () {
              Navigator.of(context).pop();
      
              Provider.of<UserProfileViewModel>(context, listen: false)
                  .fetchUserProfileViewModelApi(
                      context, {"userId": widget.userId});
              context.push("/profilePage", extra: {"userId": widget.userId});
     
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Custom_ListTile(
              img: rentalbooking,
              iconColor: btnColor,
              heading: "My Rental Trips",
              onTap: () {
                Navigator.of(context).pop();

                context.push("/rentalForm/rentalHistory",
                    extra: {"myIdNo": widget.userId});
              }
              // context.push("/booking")
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Custom_ListTile(
              iconColor: btnColor,
              img: package,
              heading: "My Packages",
              onTap: () {
                Navigator.of(context).pop();

                context.push("/package/packageHistoryManagement",
                    extra: {"userID": widget.userId});
              } // context.push("/booking")
              ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Custom_ListTile(
              img: offers,
              iconColor: btnColor,
              heading: "All Offers",
              onTap: () {
                Navigator.of(context).pop();

                context.push("/allOffer", extra: {'initialIndex': 0});
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Custom_ListTile(
              img: moneyTransaction,
              iconColor: btnColor,
              heading: "Transactions",
              onTap: () {
                Navigator.of(context).pop();
                context
                    .push("/myTransaction", extra: {"userId": widget.userId});
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Custom_ListTile(
              img: myWallet,
              iconColor: btnColor,
              heading: "My Wallet",
              onTap: () {
                Navigator.of(context).pop();

                context.push("/myWallet", extra: {"userId": widget.userId});
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Custom_ListTile(
              iconColor: btnColor,
              img: helpSupport,
              heading: "Help & Support",
              onTap: () {
                Navigator.of(context).pop();

                context.push("/help&support");
              }),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: CustomButtonLogout(
              img: logout,
              btnHeading: "Logout",
              loading: userViewModel.loading,
              onTap: () {
                Navigator.of(context).pop();

                _confirmLogout();

                // userViewModel.remove(context);
                // context.go("/login");
              }),
        ),
      ],
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: background,
          surfaceTintColor: background,
      
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
                          userViewModel.remove(context);
                          context.go("/login");
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
}

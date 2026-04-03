// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/view/help_and_support/help_and_support_screen.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    context.read<UserProfileViewModel>().fetchUserProfileViewModelApi();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = context.watch<UserProfileViewModel>().dataList.data?.data;
    return Scaffold(
      backgroundColor: bgGreyColor,
      body: Column(
        children: [
          // const SizedBox(height: 10),

          buildAccountHeader(
              url: userdata?.profileImageUrl ?? '',
              name: '${userdata?.firstName ?? ''} ${userdata?.lastName ?? ''}',
              email: userdata?.email ?? '',
              lastLogin: (userdata?.lastLogin ?? '').isNotEmpty
                  ? 'Last Login :- ${userdata?.lastLogin ?? ''}'
                  : ''),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                buildAccountOption(
                  leading: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    context.push("/profilePage", extra: {
                      "userId": userdata?.userId ?? "",
                      "userType": 'USER'
                    }).then((onValue) {
                      getUser();
                    });
                  },
                ),
                buildAccountOption(
                  leading: Icons.assignment_outlined,
                  title: 'My Enquiries',
                  onTap: () {
                    context.push('/my_enquiry');
                  },
                ),
                buildAccountOption(
                  leading: rentalbooking,
                  title: 'My Rental',
                  onTap: () {
                    context.push("/rentalForm/rentalHistory",
                        extra: {"myIdNo": userdata?.userId});
                  },
                ),
                buildAccountOption(
                  leading: Icons.card_travel_outlined,
                  title: 'My Package',
                  onTap: () {
                    context.push("/package/packageHistoryManagement",
                        extra: {"userID": userdata?.userId});
                  },
                ),
                buildAccountOption(
                  leading: Icons.local_offer_outlined,
                  title: 'Offers',
                  onTap: () {
                    context.push("/allOffer", extra: {'initialIndex': 0});
                  },
                ),
                buildAccountOption(
                  leading: Icons.payment_outlined,
                  title: 'My Transaction',
                  onTap: () {
                    context.push("/myTransaction",
                        extra: {"userId": userdata?.userId});
                  },
                ),
                buildAccountOption(
                  leading: Icons.account_balance_wallet_outlined,
                  title: 'My Wallet',
                  onTap: () {
                    context
                        .push("/myWallet", extra: {"userId": userdata?.userId});
                  },
                ),
                buildAccountOption(
                  leading: helpSupport,
                  title: 'Help & Support',
                  onTap: () {
                    context.push("/help&support",
                        extra: HelpAndSupport(
                          userType: UserType.user,
                        ));
                  },
                ),
                buildAccountOption(
                    leading: logout,
                    title: 'Logout',
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 200), () {
                        // ignore: use_build_context_synchronously
                        _confirmLogout(context);
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAccountHeader(
      {required String url,
      required String name,
      required String email,
      required String lastLogin}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [btnColor, btnColor.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,

            child: ClipOval(
              child: url.isEmpty
                  ? const Icon(Icons.person)
                  : Image.network(
                      url,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Text(email, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(lastLogin,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAccountOption({
    required dynamic leading,
    required String title,
    VoidCallback? onTap,
  }) {
    Widget leadingWidget;

    if (leading is String) {
      leadingWidget = Image.asset(
        leading,
        color: const Color(0xff7B1E34),
        height: 24,
      );
    } else if (leading is IconData) {
      leadingWidget = Icon(
        leading,
        color: const Color(0xff7B1E34),
        size: 24,
      );
    } else if (leading is Widget) {
      leadingWidget = leading;
    } else {
      leadingWidget = const SizedBox(width: 24, height: 24);
    }

    return Card(
      color: background,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: leadingWidget,
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
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
}

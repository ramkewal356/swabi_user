import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:go_router/go_router.dart';
import '../../data/network/base_apiservices.dart';
import '../../data/network/network_apiservice.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const CustomBottomNavigationBar(
      {Key? key, required this.child, required this.currentRoute})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final BaseApiServices _apiServices = NetworkApiService();

  int currentIndex = 0;

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      widget.currentRoute == '/' ? currentIndex = 0 : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location = GoRouterState.of(context).uri.toString();
    return PopScope(
      canPop: false,
      onPopInvoked: (val) async {
        // print(widget.currentRoute);
        if (GoRouterState.of(context).uri.toString() != '/') {
          context.go('/');
        } else if (GoRouterState.of(context).uri.toString() == '/') {
          final shouldPop = await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: background,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: background,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                "Confirm Exit",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Are you sure want exit",
                                style: TextStyle(
                                    color: textgreyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    onPressed: () => context.pop(),
                                  ),
                                  TextButton(
                                    child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                        )),
                                    onPressed: () => exit(0),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 0,
                          right: 0,
                          top: -50,
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: Card(
                              elevation: 8,
                              surfaceTintColor: background,
                              color: background,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                // child: Image.asset(questionIcon, height: 48.h),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              );
            },
          );

          return shouldPop ?? false;
        }
      },
      child: Scaffold(
        body: widget.child,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 7,
          showUnselectedLabels: true,
          backgroundColor: background,
          selectedLabelStyle: appbarTextStyle,
          unselectedLabelStyle: appbarTextStyle,
          items: [
            BottomNavigationBarItem(
              icon:
              Image.asset(
                profile,
                height: 25,
                width: 25,
                color: location == '/' ? primaryColor : secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(profile,
                  height: 25,
                  width: 25,
                  color: location == '/' ? primaryColor : secondaryColor),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(profile,
                  height: 25,
                  width: 25,
                  color: location == '/' ? primaryColor : secondaryColor),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(profile,
                  height: 25,
                  width: 25,
                  color: location == '/' ? primaryColor : secondaryColor),
              label: '',
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });

            switch (index) {
              case 0:
                router.go('/'); // Navigate to the home route
                break;
              case 1:
                {
                  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  //   Provider.of<ChatRoomViewModel>(context, listen: false)
                  //       .fetchChatRoomViewModelApi(context, {
                  //     'email': SharedPreferencesManager.getEmail().toString()
                  //   });
                  // });
                  router.go('/bubble_chat');
                }
                break;
              case 2:
                router.go('/news'); // Navigate to the share route
                break;
              case 3:
                router.go('/user'); // Navigate to the profile route
                break;
            }
          },
          selectedItemColor: secondaryColor,
          unselectedItemColor: primaryColor,
        ),
      ),
    );
  }
}

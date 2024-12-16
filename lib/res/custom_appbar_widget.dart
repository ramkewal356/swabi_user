import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appLeadingImage;
  final String rightIconImage;
  final VoidCallback? onTap;
  final VoidCallback? rightIconOnTapOnTap;
  final VoidCallback? backBtnOnTap;
  final String heading;
  final bool leadingIcon;
  final bool trailingIcon;
  final bool rightIconOnTapReq;
  final Widget? userIcon;

  const CustomAppBar(
      {Key? key,
      this.rightIconOnTapReq = false,
      this.appLeadingImage = "",
      this.rightIconImage = "",
      this.onTap,
      this.rightIconOnTapOnTap,
      this.backBtnOnTap,
      this.heading = "",
      this.leadingIcon = false,
      this.trailingIcon = false,
      this.userIcon})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: background,
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        leading: leadingIcon
            ? SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: onTap,
                      child: Image.asset(
                        appLeadingImage,
                        height: 20,
                        width: 20,
                      )),
                ),
              )
            : SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: backBtnOnTap ?? () => context.pop(context),
                      child: const Icon(Icons.arrow_back_rounded)),
                ),
              ),
        centerTitle: true,
        title: Text(heading, style: appbarTextStyle),
        actions: [
          trailingIcon
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                      onTap: rightIconOnTapReq
                          ? rightIconOnTapOnTap ?? () => print("Custom Appbar")
                          : null,
                      child: Image.asset(
                        rightIconImage,
                        height: 25,
                      )
                      // child: Image.asset(appLogo1)
                      ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

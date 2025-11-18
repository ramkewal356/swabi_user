import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';

class PageLayoutCurve extends StatelessWidget {
  final String appHeading;
  final String btnHeading;
  final bool saveBtn;
  final Widget child;
  final VoidCallback? backBtn;
  final Widget? icon;
  final Color? bgColor;
  final VoidCallback? onTap;
  final VoidCallback? iconOnTap;
  final String addtionalIcon;
  final bool addtionalIconReq;
  const PageLayoutCurve({
    super.key,
    required this.appHeading,
    this.btnHeading = "Save",
    this.addtionalIconReq = false,
    this.addtionalIcon = "",
    this.iconOnTap,
    this.bgColor,
    this.icon,
    this.saveBtn = false,
    required this.child,
    this.backBtn,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Scaffold(
      backgroundColor: bgColor ?? curvePageColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size(0, AppDimension.getHeight(context) * .12),
          child: AppBar(
            backgroundColor: curvePageColor,
            surfaceTintColor: curvePageColor,
            toolbarHeight: 180,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: backBtn ?? () => Navigator.pop(context),
            ),
            title: Text(
              appHeading,
              style: appbarTextStyle,
            ),
            centerTitle: true,
            titleTextStyle: appbarTextStyle,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Material(
                  color: curvePageColor,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: addtionalIconReq
                        ? iconOnTap
                        : () => debugPrint("Icon Btn Press"),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      // padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      child: addtionalIconReq
                          ? Image.asset(addtionalIcon, height: 30, width: 30)
                          : null,
                    ),
                  ),
                ),
              )
            ],
          )),
      body: LayoutBuilder(
        builder: (context, constraints) => ClipRRect(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              color: Colors.white,
            ),

            ///jdh
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  child: child,
                )),
                saveBtn
                    ?
                    // CustomButtonSmall()
                    CustomButtonBig(
                        btnHeading: btnHeading,
                        onTap: onTap ?? () => debugPrint("onTap"))
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class PageLayoutPage extends StatelessWidget {
  final String appHeading;
  final String btnHeading;
  final bool saveBtn;
  final Widget child;
  final VoidCallback? backBtn;
  final Widget? icon;
  final String bgImage;
  final EdgeInsets padding;
  final Color? bgColor;
  final VoidCallback? onTap;
  final VoidCallback? iconOnTap;
  final String addtionalIcon;
  final bool addtionalIconReq;
  final bool refreshReq;
  final PreferredSizeWidget? appBar;
  final Future<void> Function()? onRefresh;

  const PageLayoutPage(
      {super.key,
      this.appHeading = '',
      this.btnHeading = "Save",
      this.addtionalIconReq = false,
      this.addtionalIcon = "",
      this.bgImage = "",
      this.iconOnTap,
      this.bgColor,
      this.icon,
      this.saveBtn = false,
      this.padding = const EdgeInsets.fromLTRB(10, 10, 10, 10),
      required this.child,
      this.backBtn,
      this.onTap,
      this.refreshReq = false,
      this.onRefresh,
      this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor ?? Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: double.infinity,
          padding: padding,
          decoration: const BoxDecoration(
            color: bgGreyColor, // Replace bgGreyColor with Colors.grey
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: bgGreyColor, // Replace bgGreyColor with Colors.grey
                  child: RefreshIndicator(
                    color: btnColor,
                    onRefresh: onRefresh ??
                        () async {
                          // Utils.toastMessage("Data Refresh",isSuccess: true);
                        }, // Provide a default no-op if onRefresh is null
                    child: child,
                  ),
                ),
              ),
              saveBtn
                  ? CustomButtonBig(
                      btnHeading: btnHeading,
                      onTap: onTap ?? () => debugPrint("onTap"),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

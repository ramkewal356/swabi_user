import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PageLayout_Curve extends StatelessWidget {
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
  const PageLayout_Curve({
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
                        : () => print("Icon Btn Press"),
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
                        onTap: onTap ?? () => print("onTap"))
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    ));
  }
}


class PageLayout_Page extends StatelessWidget {
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

  const PageLayout_Page(
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
                      onTap: onTap ?? () => print("onTap"),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonPageLayout extends StatelessWidget {
  final String heading;
  final Widget child;
  final Widget? backButtonIcon;
  final Color? color;
  final bool tick;
  final bool create;
  final String onCreateTitle;
  final Color? backgroundColor;
  final ScrollPhysics physics;
  final VoidCallback? backButton;
  final VoidCallback? onTick;
  final VoidCallback? onCreate;
  final bool resizeToAvoidBottomInset;
  final bool customButton;
  final Widget? customWidget;
  final EdgeInsets padding;
  final bool floatingActionButton;
  final VoidCallback? floatingTap;
  final bool submitButton;
  final String submitTitle;
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;
  final Future<void> Function()? onRefresh;

  const CommonPageLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 5),
    this.floatingActionButton = false,
    this.submitButton = false,
    this.floatingTap,
    this.backButtonIcon,
    this.resizeToAvoidBottomInset = false,
    this.physics = const ScrollPhysics(),
    required this.heading,
    this.tick = false,
    // this.submitColorGradient = primaryGradient,
    this.onTick,
    this.submitTitle = 'Submit',
    this.onCancel,
    this.onSubmit,
    this.backButton,
    this.color,
    this.create = false,
    this.onCreateTitle = '',
    this.onCreate,
    this.onRefresh,
    this.customButton = false,
    this.customWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(
      //   heading: heading,
      // ),
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      floatingActionButton: floatingActionButton
          ? FloatingActionButton(
              onPressed: floatingTap,
              shape: const StadiumBorder(),
              backgroundColor: btnColor,
              child: const Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
                weight: 4,
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            backgroundColor: curvePageColor,
            body: SingleChildScrollView(
              physics: physics,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom),
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: AppDimension.getHeight(context) * .9),
                  height: constraints.maxHeight,
                  color: color ?? Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: IconButton(
                                    onPressed:
                                        backButton ?? () => context.pop(),
                                    icon: backButtonIcon ??
                                        const Icon(
                                          Icons.arrow_back_sharp,
                                          color: Colors.black,
                                        )
                                    // Image.asset(
                                    //   backIcon,
                                    //   height: 10,
                                    // ),
                                    ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: CustomAppBar(
                                heading: heading,
                              ),
                              // Text(heading,
                              //     style: appbarTextStyle),
                            ),
                            tick && create == false
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 17),
                                      child: IconButton(
                                          onPressed: onTick,
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                          // Image.asset(
                                          //   tickIcon,
                                          //   height: 10,
                                          // ),
                                          ),
                                    ),
                                  )
                                : Container(),
                            create && tick == false
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 17),
                                        child: Material(
                                          color: const Color(0x1CEC642A),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          child: InkWell(
                                            onTap: onCreate,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                              ),
                                              child: Text(
                                                onCreateTitle,
                                                style: GoogleFonts.lato(
                                                  color: textColor,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  )
                                : Container(),
                            customButton
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: customWidget ?? Container())
                                : Container(),
                          ],
                        ),
                      ),
                      Expanded(
                          child: RefreshIndicator(
                        color: btnColor,
                        onRefresh: onRefresh ?? () async {},
                        child: Padding(
                          padding: padding,
                          child: child,
                        ),
                      )),
                      submitButton
                          ? Padding(
                              padding: padding,
                              child: CustomButtonSmall(
                                btnHeading: submitTitle,
                                onTap: onCancel ?? () => context.pop(),
                                // linearGradient: submitColorGradient,
                                // : onSubmit ?? () => print('Add a onSubmit here'),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

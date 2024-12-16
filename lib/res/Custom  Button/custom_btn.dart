import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonBig extends StatelessWidget {
  final String btnHeading;
  final VoidCallback onTap;
  final double? widht;
  final double? height;
  final bool loading;
  const CustomButtonBig(
      {super.key,
      required this.btnHeading,
      this.loading = false,
      this.widht,
      this.height,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: btnColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: SizedBox(
          height: height ?? 50,
          width: widht ?? AppDimension.getWidth(context) * .95,
          child: Center(
              child: loading
                  // ? const CircularProgressIndicator(
                  //     color: background,
                  //   )
                  ? const SpinKitWave(
                      size: 15,
                      duration: Duration(milliseconds: 200),
                      color: background,
                    )
                  : Text(
                      btnHeading,
                      style: btnTextStyle,
                    )),
        ),
      ),
    );
  }
}

class CustomButtonLogout extends StatelessWidget {
  final String img;
  final String btnHeading;
  final VoidCallback onTap;
  final bool loading;
  const CustomButtonLogout(
      {super.key,
      required this.img,
      required this.btnHeading,
      this.loading = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: btnColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: loading
            ? const CircularProgressIndicator(
                color: greenColor,
              )
            : Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: AppDimension.getWidth(context) * .9,
                child: Row(
                  children: [
                    Image.asset(
                      img,
                      height: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      btnHeading,
                      style: btnTextStyle,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class CustomButtonSmall extends StatelessWidget {
  final String btnHeading;
  final String title;
  final bool titleReq;
  final bool disable;
  final VoidCallback? onTap;
  final double? elevation;
  final bool elevationReq;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final BorderRadius? borderRadius;
  final bool loading;
  const CustomButtonSmall(
      {super.key,
      required this.btnHeading,
      this.title = "",
      this.titleReq = false,
      this.disable = false,
      required this.onTap,
      this.loading = false,
      this.elevationReq = false,
      this.buttonColor,
      this.borderRadius,
      this.width,
      this.elevation,
      this.height});

  @override
  Widget build(BuildContext context) {
    debugPrint('loading status......$loading');
    return Column(
      children: [
        titleReq
            ? Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: titleTextStyle,
                ),
              )
            : const SizedBox(),
        Material(
          borderRadius: borderRadius ?? BorderRadius.circular(5),
          color: disable ? btnColor.withOpacity(.3) : btnColor,
          // color: disable ? buttonColor?.withOpacity(.7) ?? btnColor.withOpacity(.7) : (buttonColor ?? btnColor),
          elevation: elevationReq ? elevation ?? 5 : 0,
          child: InkWell(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            onTap: (disable || loading) ? null : onTap,
            child: Container(
              height: height ?? 50,
              width: width,
              // color: disable ? btnColor.withOpacity(0.4) : btnColor,
              // ?? AppDimension.getWidth(context)*.6,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                  child: loading
                      // ? const CircularProgressIndicator(color: background)
                      ? const SpinKitWave(
                          size: 15,
                          duration: Duration(milliseconds: 500),
                          color: background,
                        )
                      : Text(btnHeading,
                          style: GoogleFonts.lato(
                              color: disable
                                  ? background.withOpacity(.9)
                                  : background,
                              fontSize: AppDimension.getWidth(context) * 0.04,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                          maxLines: 1)),
            ),
          ),
        ),
      ],
    );
  }
}

class Login_SignUpBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String sideHeading;
  final String btnHeading;
  const Login_SignUpBtn(
      {super.key,
      required this.onTap,
      required this.sideHeading,
      required this.btnHeading});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          sideHeading,
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(0, 0, 0, 0.5)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            " $btnHeading",
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w700, color: greenColor),
          ),
        ),
      ],
    );
  }
}

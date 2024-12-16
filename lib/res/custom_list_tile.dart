import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class Custom_ListTile extends StatelessWidget {
  final String img;
  final bool disableColor;
  final Color? iconColor;
  final String headingTitle;
  final bool headingTitleReq;
  final VoidCallback onTap;
  final String heading;
  const Custom_ListTile(
      {this.img = "",
      this.iconColor,
      this.disableColor = false,
      this.headingTitle = "",
      this.headingTitleReq = false,
      this.heading = "",
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingTitleReq
            ? Text(headingTitle, style: titleTextStyle)
            : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 5),
          child: Material(
            // color: disableColor ? naturalGreyColor.withOpacity(.1) : background,
            elevation: 0,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Container(
                // height:50
                height: MediaQuery.of(context).size.height * 0.065,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color:
                        disableColor ? greyColor1.withOpacity(.2) : background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: naturalGreyColor.withOpacity(0.3)
                        // btnColor
                        )),
                width: AppDimension.getWidth(context) * .9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      img,
                      height: 20,
                      color: iconColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Text(
                        heading,
                        style: custom_ListTileTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class Custom_ListTileSwitch extends StatefulWidget {
  final String img;
  final String heading;
  final Widget notification;
  final VoidCallback? onTap;
  const Custom_ListTileSwitch(
      {required this.notification,
      required this.img,
      this.onTap,
      required this.heading,
      super.key});

  @override
  State<Custom_ListTileSwitch> createState() => _Custom_ListTileSwitchState();
}

class _Custom_ListTileSwitchState extends State<Custom_ListTileSwitch> {
  bool noti = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: background,
        elevation: 0,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: naturalGreyColor.withOpacity(0.3))),
            width: AppDimension.getWidth(context) * .9,
            child: Row(
              children: [
                Image.asset(
                  widget.img,
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.heading,
                    style: custom_ListTileTextStyle,
                  ),
                ),
                const Spacer(),
                widget.notification
              ],
            ),
          ),
        ),
      ),
    );
  }
}

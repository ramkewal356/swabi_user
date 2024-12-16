import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/login/login_customTextFeild.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:go_router/go_router.dart';

class VerifyPassword extends StatefulWidget {
  const VerifyPassword({super.key});

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Verify Password",
      ),
      body: PageLayout_Page(
          child: Column(
        children: [
          LoginTextFeild(
            headingReq: true,
            controller: TextEditingController(),
            heading: "Old Password",
            img: pass,
            prefixIcon: true,
            obscure: true,
            suffixIcon: true,
            hint: "Enter your old password",
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: AppDimension.getWidth(context) * .9,
              child: Text(
                "Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien.",
                style: infoTextStyle,
              )),
          const Spacer(),
          CustomButtonBig(
            btnHeading: "Next",
            onTap: () => context.push("/changePassword"),
          ),
          const SizedBox(height: 10),
        ],
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/custom_list_tile.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:go_router/go_router.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Help & Support",
      ),
      body: PageLayout_Page(
        child: Column(
          children: [
            Custom_ListTile(
              img: raiseIssue,
              iconColor: btnColor,
              heading: "Raised Issue",
              onTap: () => context.push("/raiseIssueDetail"),
            ),
           
            Custom_ListTile(
                disableColor: true,
                img: contact,
                iconColor: btnColor,
                heading: "Contact Us",
                onTap: () {
                  // context.push("/contact");
                }),
            Custom_ListTile(
              disableColor: true,
              img: privacyPolicy,
              iconColor: btnColor,
              heading: "Privacy & Policy",
              onTap: () {},
            ),
            Custom_ListTile(
                img: tnc,
                iconColor: btnColor,
                heading: "Terms & Condition",
                onTap: () {
                  context.push("/termCondition");
                }),
          ],
        ),
      ),
    );
  }
}

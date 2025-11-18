import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/widgets/custom_list_tile.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
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
      body: PageLayoutPage(
        child: Column(
          children: [
            CustomListTile(
              img: raiseIssue,
              iconColor: btnColor,
              heading: "Raised Issue",
              onTap: () => context.push("/raiseIssueDetail"),
            ),
            CustomListTile(
                disableColor: true,
                img: contact,
                iconColor: btnColor,
                heading: "Contact Us",
                onTap: () {
                  // context.push("/contact");
                }),
            CustomListTile(
              disableColor: true,
              img: privacyPolicy,
              iconColor: btnColor,
              heading: "Privacy & Policy",
              onTap: () {},
            ),
            CustomListTile(
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

import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/expansion_tile.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "FAQ's",
      ),
      body: PageLayout_Page(
          child: Column(
            children: [
              const SizedBox(height: 10),
              ExpansionTileWidget(
                  header: Text("Lorem ipsum dolor",style: titleTextStyle),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      child: Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout"),
                    )]),
              const SizedBox(height: 10),
              ExpansionTileWidget(
                  header: Text("Lorem ipsum dolor",style: titleTextStyle),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      child: Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout"),
                    )]),
              const SizedBox(height: 10),
              ExpansionTileWidget(
                  header: Text("Lorem ipsum dolor",style: titleTextStyle),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      child: Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout"),
                    )]),

            ],
          )),
    );
  }
}

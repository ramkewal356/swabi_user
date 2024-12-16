import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class TermCondition extends StatelessWidget {
  const TermCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Term & Condition",
      ),
      body: PageLayout_Page(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("TERM AND CONDITION",
          //     style: pageHeadingTextStyle, textAlign: TextAlign.left),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: AppDimension.getHeight(context) * .9,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: background, borderRadius: BorderRadius.circular(5)),
            child: Text(
                "Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et "
                "massa mi. Aliquam in hendrerit urna. Pellentesque sit amet "
                "sapien fringilla, mattis ligula consectetur, ultrices. Lorem "
                "ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. "
                "Aliquam in hendrerit urna. Pellentesque sit amet sapien "
                "fringilla, mattis ligula consectetur, ultrices.",
                style: termCondition,
                textAlign: TextAlign.left),
          ),
          const SizedBox(
            height: 25,
          ),
        
        ],
      )),
    );
  }
}

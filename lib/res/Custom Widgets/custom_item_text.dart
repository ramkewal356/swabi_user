import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class CustomItemText extends StatelessWidget {
  final String lable;
  final String value;
  const CustomItemText({super.key, required this.lable, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          lable,
          style: titleText,
        ),
        SizedBox(width: 5),
        Text(
          ':',
          style: titleText,
        ),
        SizedBox(width: 5),
        Expanded(
            child: Text(
          value,
          style: valueText1,
        ))
      ],
    );
  }
}

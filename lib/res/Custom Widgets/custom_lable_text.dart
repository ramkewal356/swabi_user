import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class CustomLableText extends StatelessWidget {
  final String lable;
  const CustomLableText({super.key, required this.lable});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text.rich(TextSpan(children: [
          TextSpan(text: lable, style: titleTextStyle),
          const TextSpan(text: ' *', style: TextStyle(color: redColor))
        ])));
  }
}

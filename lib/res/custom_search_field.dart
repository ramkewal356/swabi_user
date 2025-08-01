import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String serchHintText;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Color? borderColor;
  final Color? fillColor;
  final bool filled;
  const CustomSearchField(
      {super.key,
      required this.controller,
      this.focusNode,
      required this.serchHintText,
      this.onChanged,
      this.borderRadius,
      this.prefixIcon,
      this.borderColor,
      this.fillColor,
      this.filled = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        focusNode?.unfocus();
      },
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixIconConstraints:
              const BoxConstraints(maxWidth: 50, minWidth: 30),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          fillColor: fillColor,
          filled: filled,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            borderSide: BorderSide(
              color: borderColor ?? greyColor1,
              // width: 2.0,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
              borderSide: BorderSide(color: borderColor ?? greyColor1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
              borderSide: BorderSide(color: borderColor ?? greyColor1)),
          hintText: serchHintText,
          hintStyle: textTitleHint),
      onChanged: onChanged,
    );
  }
}

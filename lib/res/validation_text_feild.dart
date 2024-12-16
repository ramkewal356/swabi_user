import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class ValidationTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final String heading;
  final String img;
  final String hint;
  final bool headingReq;
  final bool prefixIcon;
  final bool suffixIcon;
  final bool obscure;
  final int? digitNumber;
  final bool number;
  final double? width;
  final bool readOnly;
  final TextEditingController controller;
  final Function(String)? onChange;
  final bool validation; // New parameter for validation

  const ValidationTextField({
    this.focusNode,
    this.heading = "",
    this.img = "",
    this.hint = "",
    required this.headingReq,
    this.suffixIcon = false,
    this.number = false,
    this.digitNumber,
    this.width,
    this.prefixIcon = false,
    this.obscure = false,
    required this.controller,
    this.readOnly = false,
    this.onChange,
    this.validation = false, // Default to false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingReq
            ? Text.rich(TextSpan(children: [
                TextSpan(text: heading, style: titleTextStyle),
                TextSpan(text: ' *', style: TextStyle(color: redColor))
              ]))
            : const SizedBox.shrink(),
        headingReq ? const SizedBox(height: 5) : const SizedBox(),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          color: background,
          child: Container(
            height: 50,
            width: width ?? AppDimension.getWidth(context) * .7,
            decoration: BoxDecoration(
              border: Border.all(color: naturalGreyColor.withOpacity(.3)),
              color: background,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextFormField(
              focusNode: focusNode,
              readOnly: readOnly,
              obscureText: obscure,
              controller: controller,
              keyboardType: number ? TextInputType.number : null,
              onChanged: (value) {
                if (onChange != null) {
                  onChange!(value);
                }
                if (validation) {
                  _validateInput(value);
                }
              },
              inputFormatters: [
                if (number) LengthLimitingTextInputFormatter(digitNumber ?? 10),
                if (validation) _CustomInputFormatter(number),
              ],
              style: titleTextStyle,
              decoration: InputDecoration(
                prefixIcon: prefixIcon
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(img, color: naturalGreyColor),
                      )
                    : null,
                hintText: hint,
                hintStyle: loginTextStyle,
                suffixIcon: suffixIcon
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye),
                      )
                    : null,
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: prefixIcon != true
                    ? const EdgeInsets.symmetric(horizontal: 10)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _validateInput(String value) {
    if (number) {
      if (int.tryParse(value) == null) {
        // Show error for invalid number input
        // print('Invalid number input');
      }
    } else {
      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        // Show error for invalid text input (only letters allowed)
        // print('Invalid text input');
      }
    }
  }
}

class _CustomInputFormatter extends TextInputFormatter {
  final bool isNumber;

  _CustomInputFormatter(this.isNumber);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (isNumber) {
      // Allow only numbers
      return TextEditingValue(
        text: newValue.text.replaceAll(RegExp(r'[^0-9]'), ''),
        selection: newValue.selection,
      );
    } else {
      // Allow letters and single spaces, remove extra spaces
      String formattedText =
          newValue.text.replaceAll(RegExp(r'\s+'), '').trim();
      formattedText = formattedText.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');

      // Ensure no more than one space between words
      formattedText =
          formattedText.split(' ').where((word) => word.isNotEmpty).join(' ');

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}
// class _CustomInputFormatter extends TextInputFormatter {
//   final bool isNumber;
//
//   _CustomInputFormatter(this.isNumber);
//
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     if (isNumber) {
//       // Allow only numbers
//       return TextEditingValue(
//         text: newValue.text.replaceAll(RegExp(r'[^0-9]'), ' '),
//         selection: newValue.selection,
//       );
//     } else {
//       // Allow letters and single spaces, remove extra spaces
//       String formattedText = newValue.text.replaceAll(RegExp(r'\s+'), '').trim();
//       formattedText = formattedText.replaceAll(RegExp(r'[^a-zA-Z\s]'), ' ');
//
//       return TextEditingValue(
//         text: formattedText,
//         selection: TextSelection.collapsed(offset: formattedText.length),
//       );
//     }
//     // if (isNumber) {
//     //   // Allow only numbers
//     //   return TextEditingValue(
//     //     text: newValue.text.replaceAll(RegExp(r'[^0-9]'), ''),
//     //     selection: newValue.selection,
//     //   );
//     // } else {
//     //   // Allow only letters
//     //   return TextEditingValue(
//     //     text: newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), ''),
//     //     selection: newValue.selection,
//     //   );
//     // }
//   }
// }
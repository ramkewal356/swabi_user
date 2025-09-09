import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class CustomMobilenumber extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? obscureText;
  final int? maxLines;
  final int? minLines;
  final int? textLength;
  final String? obscuringCharacter;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final bool? enabled;
  final Widget? suffixIcons;
  final Color? fillColor;
  final String? countryCode;
  final FocusNode? focusNode;
  final bool readOnly;
  final double? width;
  final double? hieght;
  final bool withoutBorder;
  const CustomMobilenumber(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.countryCode,
      this.validator,
      this.obscureText,
      this.maxLines,
      this.minLines = 1,
      this.readOnly = false,
      this.textLength,
      this.obscuringCharacter,
      this.textAlignVertical,
      this.keyboardType,
      this.suffixIcons,
      this.fillColor,
      this.onChanged,
      this.enabled,
      this.focusNode,
      this.width,
      this.hieght,
      this.withoutBorder = false});

  @override
  State<CustomMobilenumber> createState() => _CustomMobilenumberState();
}

class _CustomMobilenumberState extends State<CustomMobilenumber> {
  String? errorText;
  final String uaePattern = r'^[569]\d{8}$';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.hieght,
      width: widget.width,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText ?? false,
        obscuringCharacter: widget.obscuringCharacter ?? '•',
        controller: widget.controller,
        style: titleTextStyle1,
        textAlignVertical: widget.textAlignVertical,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.textLength),
          FilteringTextInputFormatter.digitsOnly
        ],
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          widget.focusNode?.unfocus();
        },
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines,
        keyboardType: widget.keyboardType ?? TextInputType.number,
        enabled: widget.enabled,
        decoration: InputDecoration(
          errorText: errorText,

          suffixIcon: widget.suffixIcons,
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 25, maxWidth: 85),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/flag-AE.png',
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 5),
                Text(
                  '+${widget.countryCode ?? '971'}',
                  style: titleTextStyle1,
                ),
              ],
            ),
          ),
          fillColor: widget.readOnly ? Colors.red[50] : widget.fillColor,
          filled: widget.withoutBorder ? false : widget.fillColor != null,
          hintText: widget.hintText,
          hintStyle: textTitleHint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: widget.withoutBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
                ),

          focusedBorder: widget.withoutBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
                ),

          enabledBorder: widget.withoutBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
                ),

          disabledBorder: widget.withoutBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCDCDCD)),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
                ),

          focusedErrorBorder: widget.withoutBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: redColor),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: redColor),
                ),

          errorBorder: widget.withoutBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: redColor),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: redColor),
                ),
          errorStyle: const TextStyle(
            color: redColor, // Change error text color
            fontSize: 13, // Adjust error text size if needed
          ),
         
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter mobile number';
          } else if (value.length != widget.textLength) {
            return 'Please enter valid mobile Number';
          } else if (!RegExp(uaePattern).hasMatch(value)) {
            return 'Please enter valid mobile Number';
          }
          return null;
        },
        onChanged: widget.onChanged,
      ),
    );
  }
}

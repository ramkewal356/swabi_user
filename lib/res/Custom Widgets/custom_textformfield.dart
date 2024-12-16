import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class Customtextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? obscureText;
  final bool? readOnly;
  final int? maxLines;
  final int? minLines;
  final int? textLength;
  final String? obscuringCharacter;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final bool? enableInteractiveSelection;
  final bool? enabled;
  final bool? prefixiconvisible;
  final Widget? prefixIcon;
  final String? img;
  final Widget? suffixIcons;
  final Color? fillColor;
  final FocusNode? focusNode;
  final String? errorText;
  final double? width;
  final double? hieght;
  final List<TextInputFormatter>? inputFormatters;
  const Customtextformfield(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator,
      this.obscureText,
      this.readOnly,
      this.maxLines = 1,
      this.minLines = 1,
      this.textLength,
      this.obscuringCharacter,
      this.textAlignVertical,
      this.prefixiconvisible,
      this.prefixIcon,
      this.enableInteractiveSelection,
      this.img,
      this.keyboardType,
      this.suffixIcons,
      this.fillColor,
      this.onChanged,
      this.enabled,
      this.focusNode,
      this.errorText,
      this.width,
      this.hieght,
      this.inputFormatters = const []});

  @override
  State<Customtextformfield> createState() => _CustomtextformfieldState();
}

class _CustomtextformfieldState extends State<Customtextformfield> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.hieght,
      width: widget.width,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly ?? false,
        obscureText: widget.obscureText ?? false,
        obscuringCharacter: widget.obscuringCharacter ?? '•',
        controller: widget.controller,
        textAlignVertical: widget.textAlignVertical,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.textLength),
          FilteringTextInputFormatter.allow(
            RegExp(r'^[\u0000-\u007F]*$'), // Allows ASCII characters only
          ),
          ...?widget.inputFormatters
        ],
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.textLength,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        decoration: InputDecoration(
          errorMaxLines: 2,
          errorText: widget.errorText,
          prefixIcon: widget.prefixiconvisible == true
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    widget.img ?? '',
                    width: 15,
                    height: 15,
                  ),
                )
              : widget.prefixIcon,
          suffixIcon: widget.suffixIcons,
          fillColor: widget.readOnly == true
              ? greyColor1.withOpacity(.2)
              : widget.fillColor,
          filled: widget.fillColor != null,
          hintText: widget.hintText,
          hintStyle: textTitleHint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          // border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Color(0xFFCDCDCD),
              // width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Color(0xFFCDCDCD),
              // width: 2.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Color(0xFFCDCDCD),
              // width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Color(0xFFCDCDCD),
              // width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Color(0xFFCDCDCD),
              // color: redColor,
              // width: 2.0,
            ),
          ),

          errorStyle: const TextStyle(
            color: redColor, // Change error text color
            fontSize: 13, // Adjust error text size if needed
          ),

          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(12),
          //     borderSide: BorderSide(color: Color(0xFFCDCDCD))),
        ),
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
}

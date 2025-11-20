// ignore_for_file: deprecated_member_use

import 'dart:async';
// import 'package:country_currency_pickers/countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class Customphonefield extends StatefulWidget {
  final String initalCountryCode;
  final GlobalKey? poneKey;
  final FocusNode? focusNode;
  final Color? fillColor;
  final bool readOnly;
  final bool withoutBorder;
  final String hintText;
  final Function(PhoneNumber)? onChanged;
  final Function(Country)? onCountryChanged;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final TextEditingController controller;
  const Customphonefield(
      {super.key,
      required this.initalCountryCode,
      this.poneKey,
      this.focusNode,
      this.fillColor,
      this.readOnly = false,
      this.withoutBorder = false,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.validator,
      this.onCountryChanged});

  @override
  State<Customphonefield> createState() => _CustomphonefieldState();
}

class _CustomphonefieldState extends State<Customphonefield> {
  // String initialCountryCode = 'AE';
  String? phoneError;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  String getInitialCountryCode() {
    var code =
        countries.where((test) => test.dialCode == widget.initalCountryCode);
    debugPrint('code ${code.first.code}');
    return code.first.code;

    // return widget.initalCountryCode;
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      focusNode: widget.focusNode,
      key: widget.poneKey,
      // style: titleTextStyle,
      // invalidNumberMessage: 'fhghjjkjkllkllklklklk',
      flagsButtonPadding: const EdgeInsets.only(left: 10),
      showCountryFlag: true,
      // dropdownTextStyle: titleTextStyle,
      readOnly: widget.readOnly,
      dropdownIconPosition: IconPosition.trailing,
      disableLengthCheck: true,
      keyboardType: TextInputType.phone,
      dropdownDecoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
      initialCountryCode: getInitialCountryCode(),
      controller: widget.controller,
      
      pickerDialogStyle: PickerDialogStyle(
        // searchFieldCursorColor: blackColor,
        searchFieldInputDecoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: "Enter Country Code or Name",
            // fillColor: background,
            isDense: true,
            hintStyle: titleTextStyle1,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: naturalGreyColor.withOpacity(0.3))),
            labelStyle: titleTextStyle,
            counterStyle: titleTextStyle,
            suffixStyle: titleTextStyle),
        countryCodeStyle: titleTextStyle,
        countryNameStyle: titleTextStyle,
      ),
      decoration: InputDecoration(
        // filled: true,
        // fillColor: background,
        hintText: widget.hintText,
        hintStyle: textTitleHint,
        fillColor:
            widget.readOnly ? Colors.red[50] : widget.fillColor ?? background,
        filled: widget.withoutBorder ? false : widget.fillColor != null,
        helperStyle: const TextStyle(height: 1),

        isDense: true,
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
          color: redColor,
          fontSize: 13,
        ),

        contentPadding: const EdgeInsets.symmetric(vertical: 10),

        counterText: '',
      ),
      onChanged: (p) async {
        final error = await globalPhoneValidator(
          p.completeNumber,
        );

        setState(() {
          phoneError = error;
        });
        widget.onChanged?.call(p);
      },
      onCountryChanged: widget.onCountryChanged,
      // validator: (value) => widget.validator?.call(value)
      validator: (p0) {
        if (p0 == null || p0.number.isEmpty) {
          return "Enter phone number";
        }
        return phoneError;
      },
    );
  }
}

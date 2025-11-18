// ignore_for_file: deprecated_member_use

import 'dart:async';

// import 'package:country_currency_pickers/countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class Customphonefield extends StatefulWidget {
  // final String? countryCode;
  final String initalCountryCode;
  final GlobalKey? poneKey;
  final FocusNode? focusNode;
  final Function(PhoneNumber)? onChanged;
  final Function(Country)? onCountryChanged;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final TextEditingController controller;
  const Customphonefield(
      {super.key,
      // this.countryCode,
      required this.initalCountryCode,
      this.poneKey,
      this.focusNode,
      required this.controller,
      this.onChanged,
      this.validator,
      this.onCountryChanged});

  @override
  State<Customphonefield> createState() => _CustomphonefieldState();
}

class _CustomphonefieldState extends State<Customphonefield> {
  // String initialCountryCode = 'AE';
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
        style: titleTextStyle,
        // invalidNumberMessage: 'fhghjjkjkllkllklklklk',
        flagsButtonPadding: const EdgeInsets.only(left: 10),
        showCountryFlag: true,
        dropdownTextStyle: titleTextStyle,
        dropdownIconPosition: IconPosition.trailing,
        disableLengthCheck: false,
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

          // backgroundColor: background,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: background,
          helperStyle: const TextStyle(height: 1),
          errorStyle: const TextStyle(height: 1),
          // hintStyle: titleTextStyle,
          isDense: true,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: naturalGreyColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: naturalGreyColor.withOpacity(0.3)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: naturalGreyColor.withOpacity(0.3)),
            // borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          // suffixStyle: titleTextStyle1,
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: naturalGreyColor.withOpacity(0.3))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: naturalGreyColor.withOpacity(0.3))),
          counterText: '',
          
        ),
        onChanged: widget.onChanged,
        onCountryChanged: widget.onCountryChanged,
        validator: widget.validator);
  }
}

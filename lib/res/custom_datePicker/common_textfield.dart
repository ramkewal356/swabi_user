import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';

import 'package:intl/intl.dart';









class CustomDropDownButton extends StatefulWidget {
  final String title;
  final String selectedValue;
  final List<String> dropDownValues;
  final TextEditingController controller; // Add a controller
  final VoidCallback? onTap;
  final double width;
  final String iconImg;
  final bool iconImgReq;

  final Icon icon;
  final bool iconReq;
  final String hint;
  final bool headingReq;
  const CustomDropDownButton(
      {required this.width,
      required this.title,
      required this.selectedValue,
      required this.dropDownValues,
      required this.controller,
      this.iconImg = '',
      this.iconImgReq = false,
      required this.icon,
      this.iconReq = false,
      this.onTap,
      this.hint = "",
      this.headingReq = false,
      super.key});

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  late String selectedValue; // Initial selected value
  late List<String> dropdownValues; // Dropdown options
  // late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
    dropdownValues = widget.dropDownValues;
    widget.controller.text = selectedValue;
  }

  // String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headingReq
            ? Text(
                widget.title,
                style: titleTextStyle,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 5),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 50,
            width: widget.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: btnColor)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down), iconSize: 30),
                isExpanded: false,
                hint: Text(
                  widget.hint,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: dropdownValues
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        widget.iconImgReq
                            ? Image.asset(
                                widget.iconImg,
                                color: naturalGreyColor,
                                height: 30,
                              )
                            : widget.iconReq
                                ? widget.icon
                                : const SizedBox(),
                        const SizedBox(width: 10),
                        Text(value, style: titleTextStyle),
                      ],
                    ),
                  );
                }).toList(),
                value: widget.controller.text.isNotEmpty
                    ? widget.controller.text
                    : null,
                onChanged: (String? newValue) {
                  widget.onTap?.call();
                  setState(() {
                    // _isArrow = !_isArrow;
                    selectedValue = newValue!;
                    widget.controller.text =
                        selectedValue; // Update the controller
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


///Grey Dropdown
class CustomDropDown1Button extends StatefulWidget {
  final String title;
  final String selectedValue;
  final List<String> dropDownValues;
  final TextEditingController controller; // Add a controller
  final VoidCallback? onTap;
  final double width;
  final String iconImg;
  final Color borderColor;
  final bool iconImgReq;
  final bool borderChange;
  final Icon icon;
  final bool iconReq;
  final String hint;
  final bool headingReq;
  const CustomDropDown1Button(
      {required this.width,
      required this.title,
      required this.selectedValue,
      required this.dropDownValues,
      required this.controller,
      this.iconImg = '',
      this.iconImgReq = false,
      this.borderChange = false,
      required this.borderColor,
      required this.icon,
      this.iconReq = false,
      this.onTap,
      this.hint = "",
      this.headingReq = false,
      super.key});

  @override
  State<CustomDropDown1Button> createState() => _CustomDropDown1ButtonState();
}

class _CustomDropDown1ButtonState extends State<CustomDropDown1Button> {
  late String selectedValue; // Initial selected value
  late List<String> dropdownValues; // Dropdown options
  // late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
    dropdownValues = widget.dropDownValues;
    widget.controller.text = selectedValue;
  }

  // String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headingReq
            ? Text(
                widget.title,
                style: loginTextStyle,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 5),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 50,
            width: widget.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color:
                        widget.borderChange ? widget.borderColor : btnColor)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down), iconSize: 30),
                isExpanded: false,
                hint: Text(
                  widget.hint,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: dropdownValues
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        widget.iconImgReq
                            ? Image.asset(
                                widget.iconImg,
                                color: naturalGreyColor,
                                height: 30,
                              )
                            : widget.iconReq
                                ? widget.icon
                                : const SizedBox(),
                        const SizedBox(width: 10),
                        Text(value, style: titleTextStyle),
                      ],
                    ),
                  );
                }).toList(),
                value: widget.controller.text.isNotEmpty
                    ? widget.controller.text
                    : null,
                onChanged: (String? newValue) {
                  widget.onTap?.call();
                  setState(() {
                    // _isArrow = !_isArrow;
                    selectedValue = newValue!;
                    widget.controller.text =
                        selectedValue; // Update the controller
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormDatePickerExpense extends StatefulWidget {
  final String title;
  final String hint;
  final double? width;
  final bool headingReq;
  final TextEditingController controller;
  final VoidCallback? onfocusTap;
  const FormDatePickerExpense({
    Key? key,
    required this.title,
    this.width,
    this.headingReq = true,
    required this.controller,
    this.onfocusTap,
    this.hint = '',
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FormDatePickerExpenseState createState() => _FormDatePickerExpenseState();
}

class _FormDatePickerExpenseState extends State<FormDatePickerExpense> {
  final DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    widget.controller.text.isEmpty
        ? selectedDate = DateTime.now().add(const Duration(days: 1))
        : selectedDate = DateFormat('dd-MM-yyyy').parse(widget.controller.text);
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    widget.controller.text =
        DateFormat('dd-MM-yyyy').format(selectedDate!.toLocal());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      // firstDate: DateTime(DateTime.now().year),
      // lastDate: DateTime(DateTime.now().year + 1),
      //initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(now.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                actionsPadding: const EdgeInsets.all(10)),
            colorScheme: const ColorScheme.light(
              primary: btnColor, // Change this to the desired color
            ),
            timePickerTheme: TimePickerThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: bgGreyColor,
                dialBackgroundColor: background,
                dialTextStyle: titleTextStyle),
            textTheme: TextTheme(
              bodyLarge: titleTextStyle,
              bodyMedium: titleTextStyle,
              displayMedium: titleTextStyle,
              headlineSmall: titleTextStyle,
              titleMedium: titleTextStyle,
              labelLarge: titleTextStyle,
              headlineLarge: titleTextStyle,
              labelSmall: titleTextStyle,
              titleSmall: titleTextStyle,
            ),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              backgroundColor:
                  // ignore: deprecated_member_use
                  MaterialStateProperty.all(btnColor), // Button background
              foregroundColor:
                  // ignore: deprecated_member_use
                  MaterialStateProperty.all(background), // Button text color
              // ignore: deprecated_member_use
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              colorScheme: ColorScheme.light(
                  primary: btnColor, // Change this to the desired color
                  onPrimary: btnColor),
            ),
          ),
          child: Dialog(
              insetPadding: const EdgeInsets.all(20),
              backgroundColor: background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Border radius here
              ),
              child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  child: child!)),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text =
            DateFormat('dd-MM-yyyy').format(selectedDate!.toLocal());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headingReq
            ? Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: widget.title, style: titleTextStyle),
                  const TextSpan(text: ' *', style: TextStyle(color: redColor))
                ])),
              )
            : const SizedBox(),
        // const SizedBox(height: 5,),
        Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 0,
          color: background,
          child: InkWell(
            onTap: () {
              widget.onfocusTap!();
              // FocusScope.of(context).unfocus();
              _selectDate(context);
            },
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 50,
              width: widget.width ?? AppDimension.getWidth(context) * .9,
              // margin: EdgeInsets.only(top: 5, bottom: 15),
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: background,
                border: Border.all(color: naturalGreyColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: naturalGreyColor,
                    ),
                  ),
                  Text(
                      widget.controller.text.isNotEmpty
                          ? widget.controller.text
                          : widget.hint,
                      style: widget.controller.text.isNotEmpty
                          ? titleTextStyle1
                          : loginTextStyle),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}



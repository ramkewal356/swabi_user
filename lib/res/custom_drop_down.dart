import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class TimePickerDropdown extends StatefulWidget {
  final TextEditingController hrcontroller;
  final TextEditingController mincontroller;

  const TimePickerDropdown(
      {super.key, required this.hrcontroller, required this.mincontroller});

  @override
  _TimePickerDropdownState createState() => _TimePickerDropdownState();
}

class _TimePickerDropdownState extends State<TimePickerDropdown> {
  int? selectedHour;
  int? selectedMinute;

  @override
  void initState() {
    super.initState();
    widget.hrcontroller.addListener(_updateTime);
    widget.mincontroller.addListener(_updateTime);

    widget.hrcontroller.text = formatTimeAsJson(selectedHour, selectedMinute);
    widget.mincontroller.text = formatTimeAsJson(selectedHour, selectedMinute);

    reset();
  }

  void reset() {
    print('resettime,,,,,,,,,,,,,,,,');
    setState(() {
      selectedHour = null;
      selectedMinute = null;
      widget.hrcontroller.text = formatTimeAsJson(selectedHour, selectedMinute);
    });
  }

  void _updateTime() {
    print("Time updated: ${widget.hrcontroller.text}");
    print("Time updated: ${widget.mincontroller.text}");
  }

  String formatTimeAsJson(int? hour, int? minute) {
    final formattedHour = hour != null ? hour.toString().padLeft(2, '0') : '00';
    final formattedMinute =
        minute != null ? minute.toString().padLeft(2, '0') : '00';
    return "$formattedHour:$formattedMinute";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedHour = null;
    selectedMinute = null;
    widget.hrcontroller.dispose();
    widget.mincontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, bottom: 5),
          child: CustomText(
            content: "Pickup Time",
            textColor: blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: naturalGreyColor.withOpacity(0.3))),
                width: 170,
                child: DropdownButton2<int>(
                  isExpanded: true,
                  hint: const CustomText(
                    content: 'Select Hour',
                    fontSize: 16,
                    textColor: greyColor1,
                    fontWeight: FontWeight.w600,
                  ),
                  value: widget.hrcontroller.text == '' ? null : selectedHour,
                  style: titleTextStyle,
                  dropdownStyleData: const DropdownStyleData(
                      decoration: BoxDecoration(color: background),
                      maxHeight: 250),
                  underline: Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide.none)),
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedHour = newValue!;
                      widget.hrcontroller.text =
                          formatTimeAsJson(selectedHour, selectedMinute);
                    });
                    // print("Selected time: ${widget.controller.text}");
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    24,
                    (int index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: titleTextStyle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const CustomText(
                content: ":",
                fontSize: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: naturalGreyColor.withOpacity(0.3))),
                width: 170,
                child: DropdownButton2<int>(
                  hint: const CustomText(
                    content: 'Select Min',
                    fontSize: 16,
                    textColor: greyColor1,
                    fontWeight: FontWeight.w600,
                  ),
                  underline: Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide.none)),
                  ),
                  dropdownStyleData: const DropdownStyleData(
                      decoration: BoxDecoration(color: background),
                      maxHeight: 250),
                  value:
                      widget.mincontroller.text == '' ? null : selectedMinute,
                  isExpanded: true,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedMinute = newValue!;
                      widget.mincontroller.text =
                          formatTimeAsJson(selectedHour, selectedMinute);
                    });
                    print("Selected time: ${widget.mincontroller.text}");
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    4,
                    (int index) {
                      int value = index * 15;
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            value == 0 ? '00' : '$value',
                            style: titleTextStyle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

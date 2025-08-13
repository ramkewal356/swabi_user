import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Validation {
//sync text fill check
  Future<bool> istextField(String value) async {
    return await Future.delayed(const Duration(seconds: 2),
        () => RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(value));
  }

//sync address check
  Future<bool> ispincode(String value) async {
    return await Future.delayed(const Duration(seconds: 2),
        () => RegExp(r'^[1-9]{1}\d{2}\s?\d{3}$').hasMatch(value));
  }

  Future<bool> isPinCode(String value) async {
    return await Future.delayed(const Duration(seconds: 2),
        () => RegExp(r'^(?:[+0][1-9])?[0-9]{6}$').hasMatch(value));
  }

//sync address check
  Future<bool> isAlphabetField(String value) async {
    return await Future.delayed(const Duration(seconds: 2),
        () => RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(value));
  }

  //sync email check
  Future<bool> isEmailField(String value) async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () => RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value));
  }

  //sync phone check
  Future<bool> isPhoneField(String value) async {
    return await Future.delayed(const Duration(seconds: 2),
        () => RegExp(r'^(?:[+0][1-9])?[0-9]{10}$').hasMatch(value));
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String timeFormat(int? time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time ?? 0);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }
}

String dateFormat(int? time) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time ?? 0);
  String formattedTime = DateFormat('dd-MM-yyyy').format(dateTime);
  return formattedTime;
}

double taxAmount(double amount, double taxPer) {
  return amount * taxPer / 100;
}

double payAbleAmount(double amount, double textAmount) {
  return amount + textAmount;
}

Future<DateTime?> showCustomDatePicker(BuildContext context,
    {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime(2100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: btnColor,
          ),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(btnColor), // Button background
            foregroundColor:
                WidgetStateProperty.all(background), // Button text color
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          )),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        child: Dialog(
            insetPadding: const EdgeInsets.all(20),
            backgroundColor: background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Border radius here
            ),
            child:
                SingleChildScrollView(padding: EdgeInsets.zero, child: child!)),
      );
    },
  );
}

Future<String?> pickDateRange(BuildContext context) async {
  final DateTimeRange? selectedRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialDateRange: DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    ),
  );
  if (selectedRange != null) {
    if (selectedRange.start == selectedRange.end) {
      // ✅ Single Date Selected
      return DateFormat('dd/MM/yyyy').format(selectedRange.start);
    } else {
      // ✅ Date Range Selected
      return "${DateFormat('dd/MM/yyyy').format(selectedRange.start)} - ${DateFormat('dd/MM/yyyy').format(selectedRange.end)}";
    }
  }
  return null;
}

String formatDateRange(DateTimeRange range) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy'); // or 'yyyy-MM-dd'
  return "${formatter.format(range.start)} - ${formatter.format(range.end)}";
}

Future<String?> pickSfDateRange(BuildContext context) async {
  DateTime? startDate;
  DateTime? endDate;

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          width: 350,
          height: 400,
          child: Theme(
            data: Theme.of(context).copyWith(
              // Ensure the theme supports circle shapes
              cardTheme: CardTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              showActionButtons: true,
              selectionShape: DateRangePickerSelectionShape.circle,
              selectionColor: btnColor,
              startRangeSelectionColor: btnColor,
              endRangeSelectionColor: btnColor,
              rangeSelectionColor: btnColor.withOpacity(0.2),
              todayHighlightColor: btnColor,
              monthCellStyle: DateRangePickerMonthCellStyle(
                todayCellDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: btnColor, width: 1.5),
                ),
                todayTextStyle: const TextStyle(color: Colors.black),
                cellDecoration: const BoxDecoration(shape: BoxShape.circle),
                textStyle: const TextStyle(fontSize: 14, color: Colors.black),
                disabledDatesTextStyle: const TextStyle(color: Colors.grey),
              ),

              monthViewSettings: const DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1, // Monday
                viewHeaderStyle: DateRangePickerViewHeaderStyle(),
              ),
              initialSelectedRange: null, // No preselection
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  startDate = args.value.startDate;
                  endDate = args.value.endDate ?? args.value.startDate;
                }
              },
              onCancel: () {
                Navigator.pop(context); // Close without selection
              },
              onSubmit: (val) {
                if (startDate != null && endDate != null) {
                  if (startDate == endDate) {
                    Navigator.pop(context,
                        DateFormat('dd/MM/yyyy').format(startDate!)); // single
                  } else {
                    Navigator.pop(
                        context,
                        "${DateFormat('dd/MM/yyyy').format(startDate!)} - "
                        "${DateFormat('dd/MM/yyyy').format(endDate!)}"); // range
                  }
                } else {
                  Navigator.pop(context); // No selection
                }
              },
            ),
          ),
        ),
      );
    },
  );
}

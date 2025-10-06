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

String timeFormate(int? date) {
  return DateFormat('h:mm a')
      .format(DateTime.fromMillisecondsSinceEpoch(date ?? 0));
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
          child: SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            showActionButtons: true,
            selectionShape: DateRangePickerSelectionShape.circle,
            selectionColor: btnColor,
            startRangeSelectionColor: btnColor,
            endRangeSelectionColor: btnColor,
            // ignore: deprecated_member_use
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
      );
    },
  );
}

Future<List<String>?> selectMultipleSfDate(BuildContext context) async {
  List<DateTime> selectedDates = [];

  return await showDialog<List<String>>(
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
          child: SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.multiple,
            showActionButtons: true,
            selectionShape: DateRangePickerSelectionShape.circle,
            selectionColor: btnColor,
            startRangeSelectionColor: btnColor,
            endRangeSelectionColor: btnColor,
            // ignore: deprecated_member_use
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
              if (args.value is List<DateTime>) {
                selectedDates = args.value;
              }
            },
            onCancel: () {
              Navigator.pop(context); // Close without selection
            },
            onSubmit: (val) {
              if (selectedDates.isNotEmpty) {
                // Format selected dates into string list
                final formattedDates = selectedDates
                    .map((d) => DateFormat('dd/MM/yyyy').format(d))
                    .toList();
                Navigator.pop(context, formattedDates);
              } else {
                Navigator.pop(context); // No selection
              }
            },
          ),
        ),
      );
    },
  );
}

String mapDropdownToApi(String dropdownValue) {
  // "1 hours" -> "1.0"
  return "${dropdownValue.split(" ").first}.0";
}

String mapApiHoursToDropdown(dynamic apiValue) {
  // apiValue might be double or string, e.g., "1.0"
  String value = apiValue.toString().replaceAll(".0", ""); // "1.0" -> "1"
  return "$value hours"; // "1 hours"
}

int mapDiscountToDouble(String discount) {
  if (discount == "No discount") {
    return 0; // special case (or you can use null instead)
  } else if (discount == "Free") {
    return 100; // free = 0
  } else {
    // extract the number part (remove % and spaces)
    return int.tryParse(discount.replaceAll("%", "").trim()) ?? 0;
  }
}

String mapDoubleToDiscount(double? value) {
  if (value == null || value == 0.0) {
    return "No discount";
  } else if (value == 100.0) {
    return "Free";
  } else {
    return "${value.toInt()} %"; // if API always gives whole numbers
    // or use value.toString() if decimals are possible
  }
}

bool isBestTimeWithinRange({
  required String bestTime,
  required String fromHour,
  required String fromMin,
  required String toHour,
  required String toMin,
}) {
  final bestParts = bestTime.split(":"); // assuming bestTime like "10:30"
  final bestHour = int.tryParse(bestParts[0]) ?? 0;
  final bestMin = int.tryParse(bestParts[1]) ?? 0;

  final fromTime = Duration(
    hours: int.tryParse(fromHour) ?? 0,
    minutes: int.tryParse(fromMin) ?? 0,
  );

  final toTime = Duration(
    hours: int.tryParse(toHour) ?? 0,
    minutes: int.tryParse(toMin) ?? 0,
  );

  final bestTimeDur = Duration(hours: bestHour, minutes: bestMin);

  return bestTimeDur >= fromTime && bestTimeDur <= toTime;
}

int calculateMinutesDiff({
  required String fromHour,
  required String fromMin,
  required String toHour,
  required String toMin,
}) {
  final from = Duration(
    hours: int.tryParse(fromHour) ?? 0,
    minutes: int.tryParse(fromMin) ?? 0,
  );
  final to = Duration(
    hours: int.tryParse(toHour) ?? 0,
    minutes: int.tryParse(toMin) ?? 0,
  );
  return to.inMinutes - from.inMinutes;
}

String formatToIST(int? epochSeconds) {
  if (epochSeconds == null || epochSeconds == 0) return '';

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
    epochSeconds * 1000,
    isUtc: true,
  );

  // Add IST offset (+05:30)
  const Duration offset = Duration(hours: 5, minutes: 30);
  DateTime adjustedTime = dateTime.add(offset);

  // Format time (HH:mm)
  return '${DateFormat('HH:mm').format(adjustedTime)} GMT (+05:30)';
}

bool isBlockedPickupTime(DateTime pickupTime) {
  // Start of blocked period: today at 00:00
  final blockStart =
      DateTime(pickupTime.year, pickupTime.month, pickupTime.day, 0, 0);

  // End of blocked period: today at 02:00
  final blockEnd =
      DateTime(pickupTime.year, pickupTime.month, pickupTime.day, 2, 0);

  // Check if pickupTime is inside blocked period
  if (pickupTime.isAfter(blockStart) && pickupTime.isBefore(blockEnd)) {
    return true; // blocked
  }

  return false; // allowed
}

bool isValidPickupTime({
  required String pickupTimeStr, // "HH:mm"
  required String startTimeStr, // "HH:mm"
  required String endTimeStr, // "HH:mm"
  required int activityHours, // in hours
}) {
  // Parse strings to hours/minutes
  final pickupParts = pickupTimeStr.split(":");
  final startParts = startTimeStr.split(":");
  final endParts = endTimeStr.split(":");

  final pickupMinutes =
      int.parse(pickupParts[0]) * 60 + int.parse(pickupParts[1]);
  final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
  final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

  // Blocked period: 00:00 → 02:00
  if (pickupMinutes >= 0 && pickupMinutes < 120) {
    return false;
  }

  // Earliest pickup: 2 hours before activity start
  final earliestPickup = startMinutes - 120;

  // Latest pickup: end time - 2 hours - activity duration
  final latestPickup = endMinutes - 120 - (activityHours * 60);
  debugPrint(
      'validation ${pickupMinutes >= earliestPickup && pickupMinutes <= latestPickup}');
  // Pickup must be **between earliest and latest**
  return pickupMinutes >= earliestPickup && pickupMinutes <= latestPickup;
}

DateTime parseTime(String timeStr, {DateTime? date}) {
  // Expects format "HH:mm" or "hh:mm" in 24h format
  final now = date ?? DateTime.now();
  final parsed = DateFormat("HH:mm").parse(timeStr);
  return DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
}

int parseActivityHours(String hoursStr) {
  return (double.tryParse(hoursStr) ?? 0.0).toInt();
}

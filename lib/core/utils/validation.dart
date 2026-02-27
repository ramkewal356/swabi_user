// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/data/models/currency_model.dart';
import 'package:flutter_cab/data/models/get_all_enquiry_model.dart';
import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
// import 'package:intl_phone_field/phone_number.dart';
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

  bool isValidEmiratesId(String emiratesId) {
    // final RegExp regex = RegExp(r'^784-\d{4}-\d{7}-\d{1}$');
    final RegExp regex = RegExp(r'^784\d{4}\d{7}\d{1}$');

    return regex.hasMatch(emiratesId);
  }

  bool isValidUaeVehicleNumber(String plate) {
    final RegExp regex = RegExp(r'^[A-Z]{1,3}\s?\d{1,5}$');
    return regex.hasMatch(plate.trim().toUpperCase());
  }

  bool isValidVehicleModelNo(String value) {
    final RegExp modelRegex = RegExp(r'^[A-Z]{2,}[A-Z0-9]{2,13}$');
    return modelRegex.hasMatch(value.trim().toUpperCase());
  }
  static DateTime? _parse(String val) {
    try {
      if (val.contains('-')) {
        return DateFormat('dd-MM-yyyy').parseStrict(val);
      } else {
        return DateFormat('dd/MM/yyyy').parseStrict(val);
      }
    } catch (_) {
      return null;
    }
  }

  static String? validateTravelDates(
    String? value, {
    dynamic countryType,
    List<String>? selectedCountries,
    int? minDaysPerCountry,
    bool useStartEndDates = false,
    String? startDate,
    String? endDate,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please select your travel dates';
    }

    // Parse dates
    // Accept both "-" and "/" delimiters but standardize as " - "
    final parts = value.split('-').map((e) => e.trim()).toList();
    // final dateFormat1 = RegExp(r'^\d{2}[\/-]\d{2}[\/-]\d{4}$');
    if (parts.isEmpty) {
      return "Please select your travel dates";
    }

    // Helper to parse a single date

    DateTime? start, end;
    if (useStartEndDates) {
      // Prefer to use explicit passed-in startDate, endDate (from controller split)
      if (startDate != null && startDate.isNotEmpty) start = _parse(startDate);
      if (endDate != null && endDate.isNotEmpty) end = _parse(endDate);
      // If only one available, treat as single day
      end ??= start;
    } else {
      if (parts.length == 2) {
        start = _parse(parts[0]);
        end = _parse(parts[1]);
      } else if (parts.length == 1) {
        start = _parse(parts[0]);
        end = start;
      }
    }

    if (start == null) {
      return "Start date is invalid or missing";
    }

    if (end == null) {
      return "End date is invalid or missing";
    }

    // Check: both must be today or future
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (start.isBefore(today)) {
      return "Start date cannot be before today";
    }
    if (end.isBefore(start)) {
      return "End date cannot be before start date";
    }

    // Optional: check minimum number of days per country (for multicountry trips)
    if (selectedCountries != null &&
        selectedCountries.length > 1 &&
        minDaysPerCountry != null &&
        minDaysPerCountry > 0) {
      int days = end.difference(start).inDays + 1;
      if (days < (minDaysPerCountry * selectedCountries.length)) {
        return "Minimum $minDaysPerCountry days per country required for ${selectedCountries.length} countries";
      }
    }

    return null;
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
String? getCurrencyCodeByCountry(
  List<CurrencyModel> list,
  String countryName,
) {
  try {
    return list
        .firstWhere(
          (e) =>
              e.country != null &&
              e.country!.toLowerCase() == countryName.toLowerCase(),
        )
        .code;
  } catch (_) {
    return null;
  }
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

/// Show selected start and end date in the SfDateRangePicker dialog and set text controller appropriately.
/// Returns the formatted selected date range string to be put in controller ("dd-MM-yyyy" or "dd-MM-yyyy - dd-MM-yyyy")
Future<String?> pickSfDateRange(
    BuildContext context, String? startDate, String? endDate) async {
  DateTime? selectedStart = (startDate != null && startDate.isNotEmpty)
      ? parseSimpleDate(startDate)
      : null;
  DateTime? selectedEnd =
      (endDate != null && endDate.isNotEmpty) ? parseSimpleDate(endDate) : null;

  PickerDateRange? preselect;
  if (selectedStart != null) {
    preselect = PickerDateRange(selectedStart, selectedEnd ?? selectedStart);
  }

  DateTime? resultStart;
  DateTime? resultEnd;

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 350,
              height: 450,
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
                minDate: DateTime.now(),
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
                  firstDayOfWeek: 1,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(),
                ),
                initialSelectedRange: preselect,
                headerStyle: DateRangePickerHeaderStyle(
                    textStyle: TextStyle(fontWeight: FontWeight.bold)),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    setState(() {
                      resultStart = args.value.startDate;
                      resultEnd = args.value.endDate ?? args.value.startDate;
                    });
                  }
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                onSubmit: (val) {
                  if (resultStart != null && resultEnd != null) {
                    if (resultStart == resultEnd) {
                      Navigator.pop(
                        context,
                        DateFormat('dd-MM-yyyy').format(resultStart!),
                      );
                    } else {
                      Navigator.pop(
                          context,
                          "${DateFormat('dd-MM-yyyy').format(resultStart!)} - "
                          "${DateFormat('dd-MM-yyyy').format(resultEnd!)}");
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          );
        },
      );
    },
  );
}

/// Helper: Parses a simple date string "dd-MM-yyyy" or "dd/MM/yyyy"
DateTime? parseSimpleDate(String input) {
  try {
    if (input.contains('-')) {
      return DateFormat('dd-MM-yyyy').parseStrict(input);
    } else {
      return DateFormat('dd/MM/yyyy').parseStrict(input);
    }
  } catch (_) {
    return null;
  }
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
                    .map((d) => DateFormat('dd-MM-yyyy').format(d))
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
Future<String?> globalPhoneValidator(String fullNumber) async {
  try {
    // Parse safely
    final phone = PhoneNumber.parse(fullNumber);

    // Check if valid
    final isValid = phone.isValid();

    if (!isValid) return "Invalid phone number";

    return null;
  } catch (e) {
    return "Invalid phone number";
  }
}
String formatParticipantType(ParticipantType? participantType) {
  if (participantType == null) return "--";
  var types = [
    if (participantType.adult != null && (participantType.adult ?? 0) > 0)
      "${participantType.adult} Adult",
    if (participantType.child != null && (participantType.child ?? 0) > 0)
      "${participantType.child} Child",
    if (participantType.infant != null && (participantType.infant ?? 0) > 0)
      "${participantType.infant} Infant",
    if (participantType.senior != null && (participantType.senior ?? 0) > 0)
      "${participantType.senior} Senior",
  ];
  if (types.isEmpty) return "--";
  return types.join(', ');
}

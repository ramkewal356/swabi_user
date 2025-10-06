import 'package:flutter/material.dart';
import 'package:flutter_cab/model/available_vehicle_model.dart' hide Status;

import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';

import 'package:flutter_cab/res/custom_modal_bottom_sheet.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/vehicle_view_model.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../model/package_models.dart' hide Status;

class AssignAndChangeVehicleScreen extends StatefulWidget {
  final List<AssignedVehicleOnPackageBooking>? assignedVehicleOnPackageBooking;
  final String packageBookingId;
  final String bookingDate;
  final String endDate;
  final int noOfDays;
  final VoidCallback? onSuccess;
  const AssignAndChangeVehicleScreen(
      {super.key,
      this.assignedVehicleOnPackageBooking,
      required this.bookingDate,
      required this.endDate,
      required this.packageBookingId,
      required this.noOfDays,
      this.onSuccess});

  @override
  State<AssignAndChangeVehicleScreen> createState() =>
      _AssignAndChangeVehicleScreenState();
}

class _AssignAndChangeVehicleScreenState
    extends State<AssignAndChangeVehicleScreen> {
  String _selectionType = "same";
  String? _sameVehicleId;
  Map<String, String?> _customVehicles = {};
  final _formKey = GlobalKey<FormState>();
  List<String> getPackageDates() {
    final startDate =
        DateTime.parse(widget.bookingDate.split("-").reversed.join("-"));
    // final endDate =
    //     DateTime.parse(widget.endDate.split("-").reversed.join("-"));

    // List<String> dates = [];
    // for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    //   final d = startDate.add(Duration(days: i));
    //   dates.add(
    //       "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}");
    // }
    List<String> dates = [];
    for (int i = 0; i < widget.noOfDays; i++) {
      final d = startDate.add(Duration(days: i));
      dates.add(
          "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}");
    }
    return dates;
  }

  @override
  void initState() {
    super.initState();

    final assigned = widget.assignedVehicleOnPackageBooking;

    if (assigned?.isNotEmpty == true) {
      // Extract all vehicle IDs as strings (to avoid type issues)
      final vehicleIds =
          assigned!.map((e) => e.vehicle.vehicleId.toString()).toList();

      // Check if all IDs are non-empty and exactly the same
      final allSame = vehicleIds.isNotEmpty &&
          vehicleIds.every((id) => id == vehicleIds.first) &&
          vehicleIds.first.isNotEmpty;

      if (allSame) {
        _selectionType = "same";
        _sameVehicleId = vehicleIds.first;
      } else {
        _selectionType = "custom";
        _sameVehicleId = null;
      }

      // Fill custom map anyway
      _customVehicles = {
        for (var e in assigned) e.date: e.vehicle.vehicleId.toString()
      };
    } else {
      final packageDates = getPackageDates();
      _customVehicles = {for (var d in packageDates) d: null};
      _sameVehicleId = null;
      _selectionType = "same";
    }

    getvehicles();
    getAvailableVehicles();
  }

  void getvehicles() async {
    context.read<VehicleViewModel>().fetchAllVehicles();
  }

  void getAvailableVehicles() async {
    context
        .read<VehicleViewModel>()
        .fetchAvailableVehicles(bookingId: widget.packageBookingId);
  }

  @override
  Widget build(BuildContext context) {
    var vehicles =
        context.watch<VehicleViewModel>().vehicleList.data?.data?.content ?? [];
    var availableVehicles =
        context.watch<VehicleViewModel>().availableVehicleList.data?.data ?? [];
    final status = context.watch<VehicleViewModel>().assignVehicle.status;
    final sameVehicleItems = vehicles
        .map((v) => v.vehicleId.toString())
        .toSet() // remove duplicates
        .map((id) {
      final v = vehicles.firstWhere((v) => v.vehicleId.toString() == id);
      return DropdownMenuItem(
        value: id,
        child: Text(v.carName ?? ''),
      );
    }).toList();

    final assignedVehicles = widget.assignedVehicleOnPackageBooking
            ?.map((e) => e.vehicle)
            .toList() ??
        [];

    final List<Datum> allCustomVehicles = [
      ...availableVehicles,
      ...assignedVehicles.map((v) => Datum(
            vehicleId: int.tryParse(v.vehicleId.toString()),
            carName: v.carName,
            // Add other fields from VehicleModel to Datum as needed
          )),
    ];

    final uniqueVehicles = {
      for (var v in allCustomVehicles) v.vehicleId.toString(): v
    }.values.toList();

    final customVehicleItems = uniqueVehicles.map((v) {
      return DropdownMenuItem<String>(
        value: v.vehicleId.toString(),
        child: Text(v.carName ?? 'Unknown Vehicle'),
      );
    }).toList();

    return CustomModalbottomsheet(
        buttonHeight: 40,
        title: widget.assignedVehicleOnPackageBooking?.isNotEmpty == true
            ? 'Change Vehicle'
            : 'Assign Vehicle',
        child: StatefulBuilder(builder: (context, setStateModel) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Title
                Text(
                  widget.assignedVehicleOnPackageBooking?.isNotEmpty == true
                      ? "Change Vehicle"
                      : "Assign Vehicle",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: btnColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Selection type
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        activeColor: btnColor,
                        value: "same",
                        groupValue: _selectionType,
                        onChanged: (value) {
                          setStateModel(() => _selectionType = value!);
                        },
                        title: Text(
                          "Select Same Vehicle For All Dates",
                          style: titleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        activeColor: btnColor,
                        value: "custom",
                        groupValue: _selectionType,
                        onChanged: (value) {
                          setStateModel(() => _selectionType = value!);
                        },
                        title: Text(
                          "Select Vehicle By Custom Dates",
                          style: titleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Same vehicle dropdown
                if (_selectionType == "same")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Select Vehicle",
                      ),
                      value: sameVehicleItems
                              .any((item) => item.value == _sameVehicleId)
                          ? _sameVehicleId
                          : null,
                      items: sameVehicleItems,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a vehicle';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setStateModel(() {
                          _sameVehicleId = val;
                          debugPrint('_sameVehicleId $_sameVehicleId');
                          _customVehicles.updateAll((key, value) => val);
                          debugPrint('_customVehicles $_customVehicles');
                        });
                      },
                    ),
                  ),

                // Custom vehicle per date
                if (_selectionType == "custom")
                  Column(
                    children: _customVehicles.keys.map((date) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month,
                                        color: btnColor, size: 20),
                                    SizedBox(width: 5),
                                    Text(date,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                SizedBox(
                                  width: 200,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Select Vehicle",
                                    ),
                                    value: _customVehicles[date],
                                    items: customVehicleItems,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a vehicle';
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setStateModel(() {
                                        _customVehicles[date] = val;
                                        debugPrint(
                                            '_customVehicles $_customVehicles');
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                // Submit button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ),
                      SizedBox(width: 18),
                      Expanded(
                        child: CustomButtonSmall(
                          height: 40,
                          loading: status == Status.loading,
                          borderRadius: BorderRadius.circular(25),
                          btnHeading: 'Submit',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              List<Map<String, dynamic>> assignedVehicleList =
                                  [];

                              if (_selectionType == "same" &&
                                  _sameVehicleId != null) {
                                _customVehicles.forEach((date, _) {
                                  final existingList = widget
                                      .assignedVehicleOnPackageBooking
                                      ?.where((e) => e.date == date)
                                      .toList();

                                  final existing = (existingList != null &&
                                          existingList.isNotEmpty)
                                      ? existingList.first
                                      : null;

                                  assignedVehicleList.add({
                                    "assignedId": existing?.assignedId,
                                    "date": date,
                                    "vehicleId": _sameVehicleId
                                  });
                                });
                              } else if (_selectionType == "custom") {
                                _customVehicles.forEach((date, vehicleId) {
                                  if (vehicleId != null) {
                                    final existingList = widget
                                        .assignedVehicleOnPackageBooking
                                        ?.where((e) => e.date == date)
                                        .toList();

                                    final existing = (existingList != null &&
                                            existingList.isNotEmpty)
                                        ? existingList.first
                                        : null;

                                    assignedVehicleList.add({
                                      "assignedId": existing?.assignedId,
                                      "date": date,
                                      "vehicleId": vehicleId
                                    });
                                  }
                                });
                              }

                              final payload = {
                                "packageBookingId":
                                    int.parse(widget.packageBookingId),
                                "assignedVehicleOnPackageBooking":
                                    assignedVehicleList,
                              };

                              debugPrint("Payload: $payload");
                              context
                                  .read<VehicleViewModel>()
                                  .assignVehicleApi(body: payload)
                                  .then((success) {
                                if (success.status?.httpCode == '200') {
                                  if (widget.onSuccess != null) {
                                    widget.onSuccess!();
                                  }
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context, true);
                                  Utils.toastSuccessMessage(
                                      success.data?.body ??
                                          'Vehicle assigned successfully');
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }));
  }
}

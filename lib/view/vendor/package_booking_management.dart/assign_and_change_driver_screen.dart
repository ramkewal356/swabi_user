import 'package:flutter/material.dart';

import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/driver_view_model.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../model/available_driver_model.dart' hide Status;
import '../../../model/package_models.dart' hide Status;

class AssignAndChangeDriverScreen extends StatefulWidget {
  final List<AssignedDriverOnPackageBooking>? assignedDriverOnPackageBooking;
  final String packageBookingId;
  final String bookingDate;
  final String endDate;
  final int noOfDays;
  final VoidCallback? onSuccess;
  const AssignAndChangeDriverScreen(
      {super.key,
      this.assignedDriverOnPackageBooking,
      required this.packageBookingId,
      required this.bookingDate,
      required this.endDate,
      required this.noOfDays,
      this.onSuccess});

  @override
  State<AssignAndChangeDriverScreen> createState() =>
      _AssignAndChangeDriverScreenState();
}

class _AssignAndChangeDriverScreenState
    extends State<AssignAndChangeDriverScreen> {
  String _selectionType = "same";
  String? _sameDriverId;
  Map<String, String?> _customDrivers = {};
  final _formKey = GlobalKey<FormState>();
  List<String> getPackageDates() {
    final startDate =
        DateTime.parse(widget.bookingDate.split("-").reversed.join("-"));

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

    final assigned = widget.assignedDriverOnPackageBooking;

    if (assigned?.isNotEmpty == true) {
      // Extract all vehicle IDs as strings (to avoid type issues)
      final driverIds =
          assigned!.map((e) => e.driver.driverId.toString()).toList();

      // Check if all IDs are non-empty and exactly the same
      final allSame = driverIds.isNotEmpty &&
          driverIds.every((id) => id == driverIds.first) &&
          driverIds.first.isNotEmpty == true;

      if (allSame) {
        _selectionType = "same";
        _sameDriverId = driverIds.first;
      } else {
        _selectionType = "custom";
        _sameDriverId = null;
      }

      // Fill custom map anyway
      _customDrivers = {
        for (var e in assigned) e.date: e.driver.driverId.toString()
      };
    } else {
      final packageDates = getPackageDates();
      _customDrivers = {for (var d in packageDates) d: null};
      _sameDriverId = null;
      _selectionType = "same";
    }
    getDrivers();
    getAvailableVehicles();
  }

  void getDrivers() async {
    context.read<DriverViewModel>().fetchAllDrivers(
        filterText: 'TRUE',
        isFilter: false,
        isSearch: false,
        isPagination: false,
        searchText: '',
        pageNumber1: -1,
        pageSize1: -1);
  }

  void getAvailableVehicles() async {
    context
        .read<DriverViewModel>()
        .fetchAvailableDrivers(bookingId: widget.packageBookingId);
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<DriverViewModel>().assignDriver.status;
    final drivers =
        context.watch<DriverViewModel>().driverList.data ?? [];
    final availableDrivers =
        context.watch<DriverViewModel>().availableDriverList.data?.data ?? [];
    final sameDriverItems = drivers
        .map((v) => v.driverId.toString())
        .toSet() // remove duplicates
        .map((id) {
      final d = drivers.firstWhere((v) => v.driverId.toString() == id);
      return DropdownMenuItem(
        value: id,
        child: Text('${d.firstName} ${d.lastName}'),
      );
    }).toList();

    final assignedDrivers =
        widget.assignedDriverOnPackageBooking?.map((e) => e.driver).toList() ??
            [];

    final List<Datum> allCustomVehicles = [
      ...availableDrivers,
      ...assignedDrivers.map((v) => Datum(
            driverId: int.tryParse(v.driverId.toString()),
            firstName: v.firstName,
            lastName: v.lastName,
            // Add other fields from VehicleModel to Datum as needed
          )),
    ];

    final uniqueDrivers = {
      for (var v in allCustomVehicles) v.driverId.toString(): v
    }.values.toList();

    final customDriverItems = uniqueDrivers.map((v) {
      return DropdownMenuItem<String>(
        value: v.driverId.toString(),
        child: Text('${v.firstName} ${v.lastName}'),
      );
    }).toList();

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
            widget.assignedDriverOnPackageBooking?.isNotEmpty == true
                ? "Change Driver"
                : "Assign Driver",
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
                    setState(() => _selectionType = value!);
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
                    setState(() => _selectionType = value!);
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
                value:
                    sameDriverItems.any((item) => item.value == _sameDriverId)
                        ? _sameDriverId
                        : null,
                items: sameDriverItems,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a driver';
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() {
                    _sameDriverId = val;
                    debugPrint('_sameDriverId $_sameDriverId');
                    _customDrivers.updateAll((key, value) => val);
                    debugPrint('_customDrivers $_customDrivers');
                  });
                },
              ),
            ),

          // Custom vehicle per date
          if (_selectionType == "custom")
            Column(
              children: _customDrivers.keys.map((date) {
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
                              value: _customDrivers[date],
                              items: customDriverItems,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a driver';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  _customDrivers[date] = val;
                                  debugPrint('_customDrivers $_customDrivers');
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                        List<Map<String, dynamic>> assignedDriverList = [];

                        if (_selectionType == "same" && _sameDriverId != null) {
                          _customDrivers.forEach((date, _) {
                            final existingList = widget
                                .assignedDriverOnPackageBooking
                                ?.where((e) => e.date == date)
                                .toList();

                            final existing = (existingList != null &&
                                    existingList.isNotEmpty)
                                ? existingList.first
                                : null;

                            assignedDriverList.add({
                              "driverAssignedId": existing?.driverAssignedId,
                              "date": date,
                              "driverId": _sameDriverId
                            });
                          });
                        } else if (_selectionType == "custom") {
                          _customDrivers.forEach((date, vehicleId) {
                            if (vehicleId != null) {
                              final existingList = widget
                                  .assignedDriverOnPackageBooking
                                  ?.where((e) => e.date == date)
                                  .toList();

                              final existing = (existingList != null &&
                                      existingList.isNotEmpty)
                                  ? existingList.first
                                  : null;

                              assignedDriverList.add({
                                "driverAssignedId": existing?.driverAssignedId,
                                "date": date,
                                "driverId": vehicleId
                              });
                            }
                          });
                        }

                        final payload = {
                          "packageBookingId":
                              int.parse(widget.packageBookingId),
                          "assignedDriverOnPackageBooking": assignedDriverList,
                        };

                        debugPrint("Payload: $payload");
                        context
                            .read<DriverViewModel>()
                            .assignDriverApi(body: payload)
                            .then((success) {
                          if (success.status?.httpCode == '200') {
                            if (widget.onSuccess != null) {
                              widget.onSuccess!();
                            }
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true);
                            Utils.toastSuccessMessage(success.data?.body ??
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/info_row.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/driver_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../data/models/get_driver_by_id_model.dart' hide Status;

class ViewDriverDetailsScreen extends StatefulWidget {
  final String driverId;
  const ViewDriverDetailsScreen({super.key, required this.driverId});

  @override
  State<ViewDriverDetailsScreen> createState() =>
      _ViewDriverDetailsScreenState();
}

class _ViewDriverDetailsScreenState extends State<ViewDriverDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getDriverDetails();
  }

  bool isShowRideHistory = false;
  bool isShowLeaveHistory = false;
  void getDriverDetails() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<DriverViewModel>()
          .getDriverByIdApi(driverId: widget.driverId);
    });
  }

  DateTime? parseFlexibleDate(String? input) {
    if (input == null || input.trim().isEmpty) return null;

    // Try both formats
    final formats = [
      DateFormat('yyyy-MM-dd'), // 2025-05-11
      DateFormat('dd-MM-yyyy'), // 11-05-2025
    ];

    for (var f in formats) {
      try {
        return f.parseStrict(input);
      } catch (_) {}
    }

    return null; // No valid format found
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<DriverViewModel>().getDriverById.data?.data;
    var unavailableDates = data?.unavailableDates;
    var leaveDates = unavailableDates?.where((element) {
      final parsed = parseFlexibleDate(element.date);

      return element.isCancelled == false &&
          element.driverUnavailableReason == 'LEAVE' &&
          parsed != null &&
          parsed.isAfter(DateTime.now());
    }).toList();

    var leaveHistoryDates = unavailableDates
        ?.where((element) => element.driverUnavailableReason == 'LEAVE')
        .toList();

    var rideDates = unavailableDates?.where((element) {
      final parsed = parseFlexibleDate(element.date);

      return element.isCancelled == false &&
          element.driverUnavailableReason == 'RESERVED' &&
          parsed != null &&
          parsed.isAfter(DateTime.now());
    }).toList();

    var rideHistoryDates = unavailableDates
        ?.where((element) => element.driverUnavailableReason == 'RESERVED')
        .toList();
    var status = context.watch<DriverViewModel>().getDriverById.status;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          'Driver Details',
          style: appBarTitleStyle,
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: status == Status.loading
          ? Center(
              child: CircularProgressIndicator(
              color: greenColor,
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DRIVER CARD
                  CommonContainer(
                      elevation: 0,
                      borderReq: true,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(10),
                      height: AppDimension.getHeight(context) / 4,
                      child: (data?.profileImageUrl ?? '').isEmpty
                          ? Image.asset(user)
                          : Image.network(
                              data?.profileImageUrl ?? '',
                              fit: BoxFit.cover,
                            )),
                  SizedBox(height: 10),
                  // Main Info
                  Card(
                    color: background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${data?.firstName} ${data?.lastName}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // const Spacer(),
                              Chip(
                                label: Text(
                                  data?.driverStatus == "TRUE"
                                      ? "ACTIVE"
                                      : "INACTIVE",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: data?.driverStatus == 'TRUE'
                                    ? greenColor
                                    : redColor,
                              )
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Info Grid
                          Wrap(
                            runSpacing: 8,
                            children: [
                              InfoRow(
                                  label: "Driver Id",
                                  value: "${data?.driverId}"),
                              InfoRow(label: "Email", value: "${data?.email}"),
                              InfoRow(
                                  label: "Gender", value: "${data?.gender}"),
                              InfoRow(
                                  label: "Contact No",
                                  value:
                                      "+${data?.countryCode} ${data?.mobile}"),
                              InfoRow(
                                  label: "Emirates ID",
                                  value: "${data?.emiratesId}"),
                              InfoRow(
                                  label: "Licence No.",
                                  value: "${data?.licenceNumber}"),
                              InfoRow(
                                  label: 'Country', value: '${data?.country}'),
                              InfoRow(label: "State", value: "${data?.state}"),
                              InfoRow(
                                  label: "Location",
                                  value: "${data?.driverAddress}"),
                            ],
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle('Driver Leave Requests'),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isShowLeaveHistory = !isShowLeaveHistory;
                            });
                          },
                          icon: Icon(Icons.history, color: btnColor))
                    ],
                  ),
                  leaveDates == null || leaveDates.isEmpty
                      ? _emptyBox()
                      : _rideHistory(leaveDates),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle('Driver Upcoming Rides'),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isShowRideHistory = !isShowRideHistory;
                            });
                          },
                          icon: Icon(Icons.history, color: btnColor))
                    ],
                  ),
                  rideDates == null || rideDates.isEmpty
                      ? _emptyBox()
                      : _rideHistory(rideDates),

                  Visibility(
                    visible: isShowLeaveHistory,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _sectionTitle('Driver Leave History'),
                        SizedBox(height: 8),
                        leaveHistoryDates == null || leaveHistoryDates.isEmpty
                            ? _emptyBox()
                            : _rideHistory(leaveHistoryDates),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: isShowRideHistory,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _sectionTitle('Driver Rides History'),
                        SizedBox(height: 8),
                        rideHistoryDates == null || rideHistoryDates.isEmpty
                            ? _emptyBox()
                            : _rideHistory(rideHistoryDates),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  // --- SECTION TITLE ---
  Widget _sectionTitle(String title) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border(left: BorderSide(color: btnColor, width: 3))),
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(title,
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      ),
    );
  }

  // --- EMPTY BOX (NO DATA) ---
  Widget _emptyBox() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      // margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Text("No Data Found",
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13)),
    );
  }

  // --- RIDE HISTORY TABLE ---
  Widget _rideHistory(List<UnavailableDate> dates) {
    return Container(
      // margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < dates.length; i++) ...[
            ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: Colors.blue[50],
                child: Text(
                  "${i + 1}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
              title: Text(dates[i].date?.toString().split(' ')[0] ?? '',
                  style: GoogleFonts.poppins(fontSize: 13)),
              trailing: Text(dates[i].driverUnavailableReason ?? '',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.blueGrey[700])),
            ),
            if (i < dates.length - 1) const Divider(height: 1),
          ]
        ],
      ),
    );
  }
}

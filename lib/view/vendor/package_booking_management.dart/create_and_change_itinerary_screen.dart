import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/package_models.dart' hide Status;
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/custom_modal_bottom_sheet.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/itinerary_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class CreateAndChangeItineraryScreen extends StatefulWidget {
  final GetPackageItineraryData? getItenaryData;
  final PackageHIstoryDetailsData? data;
  const CreateAndChangeItineraryScreen(
      {super.key, this.getItenaryData, this.data});

  @override
  State<CreateAndChangeItineraryScreen> createState() =>
      _CreateAndChangeItineraryScreenState();
}

class _CreateAndChangeItineraryScreenState
    extends State<CreateAndChangeItineraryScreen> {
  late List<String?> selectedActivities;
  late List<String?> selectedTimes;
  late List<String?> selectedActivityIds;

  @override
  void initState() {
    super.initState();
    final noOfDays = widget.getItenaryData != null
        ? widget.getItenaryData!.itineraryDetails.length
        : int.tryParse(widget.data?.pkg.noOfDays ?? '') ?? 0;

    selectedActivities = List.generate(noOfDays, (index) {
      return widget.getItenaryData != null
          ? widget.getItenaryData!.itineraryDetails[index].activity.activityName
          : widget.data?.pkg.packageActivities[index].activity.activityName;
    });

    selectedTimes = List.generate(noOfDays, (index) {
      return widget.getItenaryData != null
          ? widget.getItenaryData!.itineraryDetails[index].pickupTime
          : null;
    });
    selectedActivityIds = List.generate(noOfDays, (index) {
      return widget.getItenaryData != null
          ? widget.getItenaryData!.itineraryDetails[index].activity.activityId
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final status =
        context.watch<ItineraryViewModel>().addOrEditItinerary.status;
    return CustomModalbottomsheet(
      buttonHeight: 40,
      title: widget.getItenaryData == null
          ? 'Create Itinerary'
          : 'Change Itinerary',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            Text(
              widget.getItenaryData == null
                  ? "Create Itinerary"
                  : "Change Itinerary",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            // List of itinerary days
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: selectedActivities.length,
              itemBuilder: (context, index) {
                final iDay = "${index + 1}";

                final String iDate;
                if (widget.getItenaryData == null) {
                  final bookingDateStr = widget.data?.bookingDate ?? "";
                  final bookingDate =
                      DateFormat("dd-MM-yyyy").parse(bookingDateStr);
                  final newDate = bookingDate.add(Duration(days: index));
                  iDate = DateFormat("dd-MM-yyyy")
                      .format(newDate); // e.g. 19 Sep 2025
                } else {
                  iDate = widget.getItenaryData!.itineraryDetails[index].date;
                }

                return Card(
                  color: background,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day $iDay ($iDate)",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Pick-up Time
                        StatefulBuilder(builder: (context, setstate) {
                          return Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    // side: BorderSide(color: btnColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.access_time),
                                  label: Text(
                                    selectedTimes[index] == null ||
                                            selectedTimes[index]!.isEmpty
                                        ? "Select Pick Time"
                                        : selectedTimes[index]!,
                                  ),
                                  onPressed: () async {
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTimes[index] != null
                                          ? TimeOfDay.fromDateTime(
                                              DateFormat("HH:mm")
                                                  .parse(selectedTimes[index]!))
                                          : TimeOfDay.now(),
                                    );

                                    if (picked != null) {
                                      if (selectedActivityIds[index] == null) {
                                        Utils.toastMessage(
                                            '  Please select activity first');
                                        return;
                                      }

                                      // --- convert string activity times to DateTime / int ---
                                      final activity = widget
                                          .data!.pkg.packageActivities
                                          .firstWhere(
                                        (a) =>
                                            a.activity.activityId ==
                                            selectedActivityIds[index],
                                      );

                                      final activityHours = parseActivityHours(
                                          activity.activity
                                              .activityHours); // String → int

                                      final now = DateTime.now();
                                      final pickupDateTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          picked.hour,
                                          picked.minute);
                                      // valid → save
                                      final formatted = DateFormat("HH:mm")
                                          .format(pickupDateTime);
                                      if (!isValidPickupTime(
                                        pickupTimeStr: formatted,
                                        startTimeStr:
                                            activity.activity.startTime,
                                        endTimeStr: activity.activity.endTime,
                                        activityHours: activityHours,
                                      )) {
                                        Utils.toastMessage(
                                            'Pick-up time for ${activity.activity.activityName} is not valid');
                                        return;
                                      }

                                      setstate(() {
                                        selectedTimes[index] = formatted;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 16),

                        // Activity Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedActivityIds[index],
                          decoration: InputDecoration(
                            labelText: "Select Activity",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: widget.data?.pkg.packageActivities.map((a) {
                            final name = a.activity.activityName;
                            return DropdownMenuItem(
                              value: a.activity.activityId,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedActivityIds[index] = val;
                              debugPrint('selected Id $selectedActivityIds');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: CustomButtonSmall(
                  height: 40,
                  loading: status == Status.loading,
                  borderRadius: BorderRadius.circular(25),
                  btnHeading: 'Save',
                  onTap: () {
                    final bookingId = widget.data?.packageBookingId ?? 0;

                    final List<Map<String, dynamic>> itineraryDetails = [];

                    for (int i = 0; i < selectedActivityIds.length; i++) {
                      // Day
                      final day = i + 1;

                      // Date
                      String date;
                      if (widget.getItenaryData == null) {
                        final bookingDateStr = widget.data?.bookingDate ?? "";
                        final bookingDate =
                            DateFormat("dd-MM-yyyy").parse(bookingDateStr);
                        final newDate = bookingDate.add(Duration(days: i));
                        date = DateFormat("dd-MM-yyyy").format(newDate);
                      } else {
                        date = widget.getItenaryData!.itineraryDetails[i].date;
                      }

                      itineraryDetails.add({
                        if (widget.getItenaryData != null)
                          "itineraryDetailsId": widget.getItenaryData!
                              .itineraryDetails[i].itineraryDetailsId,
                        "date": date,
                        "activityId": selectedActivityIds[i],
                        "day": day,
                        if (widget.getItenaryData != null)
                          "dayStatus": widget
                              .getItenaryData!.itineraryDetails[i].dayStatus,
                        "index": 0,
                        "pickupTime": selectedTimes[i] ?? "",
                      });
                    }

                    final payload = {
                      "packageBookingId": bookingId,
                      "itineraryDetails": itineraryDetails,
                      if (widget.getItenaryData != null)
                        "itineraryId": widget.getItenaryData!.itineraryId,
                    };

                    debugPrint("Final Payload: $payload");
                    context.read<ItineraryViewModel>().addEditItineraryApi(
                          // context: context,
                          body: payload,
                          isEdit: widget.getItenaryData != null,
                          onSuccess: () {
                            if (mounted) {
                              context.pop(); // Safe
                            }
                          },
                        );
                    // Navigator.pop(context, payload); //
                  },
                ))
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

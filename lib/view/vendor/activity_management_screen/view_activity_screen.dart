import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/view_model/activity_management_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class ViewActivityScreen extends StatefulWidget {
  final String? activityId;
  const ViewActivityScreen({super.key, this.activityId});

  @override
  State<ViewActivityScreen> createState() => _ViewActivityScreenState();
}

class _ViewActivityScreenState extends State<ViewActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getActivityById();
    });
  }

  void getActivityById() {
    context
        .read<ActivityManagementViewModel>()
        .getActivityByIdApi(activityId: widget.activityId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgGreyColor,
        appBar: AppBar(
          backgroundColor: background,
          title: const Text("Activity Details"),
          centerTitle: true,
        ),
        body: Consumer<ActivityManagementViewModel>(
          builder: (context, value, child) {
            if (value.getActivityById.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              var data = value.getActivityById.data?.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel / Banner
                    CommonContainer(
                      elevation: 0,
                      borderReq: true,
                      // color: naturalGreyColor.withOpacity(.4),
                      borderRadius: BorderRadius.circular(10),
                      height: AppDimension.getHeight(context) / 4,
                      child: MultiImageSlider(
                        images: (data?.activityImageUrl) ?? [],
                      ),
                    ),

                    const SizedBox(height: 16),

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
                                    "${data?.activityName}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // const Spacer(),
                                Chip(
                                  label: Text(
                                    data?.activityStatus == 'TRUE'
                                        ? "ACTIVE"
                                        : "INACTIVE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      data?.activityStatus == 'TRUE'
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
                                    title: "Activity Id",
                                    value: "${data?.activityId}"),
                                InfoRow(
                                    title: "Country",
                                    value: "${data?.country}"),
                                InfoRow(
                                    title: "State", value: "${data?.state}"),
                                InfoRow(
                                    title: "Price",
                                    value: "AED ${data?.activityPrice}"),
                                InfoRow(
                                    title: "Category",
                                    value: "${data?.activityCategory}"),
                                InfoRow(
                                    title: "Suitable For",
                                    value:
                                        "${data?.participantType?.join(', ')}"),
                                InfoRow(
                                    title: 'Infant Discount',
                                    value: data?.ageGroupDiscountPercent
                                                ?.infant ==
                                            100.0
                                        ? "Free"
                                        : data?.ageGroupDiscountPercent
                                                    ?.infant ==
                                                0.0
                                            ? "No Discount"
                                            : "${data?.ageGroupDiscountPercent?.infant}% "),
                                InfoRow(
                                    title: "Child Discount",
                                    value: data?.ageGroupDiscountPercent
                                                ?.child ==
                                            100.0
                                        ? "Free"
                                        : data?.ageGroupDiscountPercent
                                                    ?.child ==
                                                0.0
                                            ? "No Discount"
                                            : "${data?.ageGroupDiscountPercent?.child}% "),
                                InfoRow(
                                    title: "Senior Discount",
                                    value: data?.ageGroupDiscountPercent
                                                ?.senior ==
                                            100.0
                                        ? 'Free'
                                        : data?.ageGroupDiscountPercent
                                                    ?.senior ==
                                                0.0
                                            ? "No Discount"
                                            : "${data?.ageGroupDiscountPercent?.senior}% "),
                                InfoRow(
                                    title: "Weekly Off",
                                    value: "${data?.weeklyOff?.join(', ')}"),
                                InfoRow(
                                    title: "Applied Offer",
                                    value: data?.activityOfferMapping?.offer
                                            ?.offerName ??
                                        'N/A'),
                                InfoRow(
                                    title: "Discount %",
                                    value:
                                        "${data?.activityOfferMapping?.offer?.discountPercentage}%"),
                                InfoRow(
                                    title: "Created Date",
                                    value: DateFormat('dd-MM-yyyy').format(
                                        data?.createdDate ?? DateTime.now())),
                                InfoRow(
                                    title: "Updated Date",
                                    value: data?.modifiedDate == null
                                        ? 'N/A'
                                        : DateFormat('dd-MM-yyyy').format(
                                            data?.modifiedDate ??
                                                DateTime.now())),
                                InfoRow(
                                    title: "Hours",
                                    value: "${data?.activityHours} Hours"),
                                InfoRow(
                                    title: "Best Time To Visit",
                                    value: "${data?.bestTimeToVisit}"),
                                InfoRow(
                                    title: "Location",
                                    value: "${data?.address}"),
                              ],
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              "About the activity",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${data?.description}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Religious Off Dates
                    Card(
                      color: background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: ListTile(
                        title: const Text("Religious Off Date"),
                        subtitle: Text(
                            "${data?.activityReligiousOffDates?.map((toElement) => toElement.religiousOffDate.toString().split(' ')[0]).join(', ')}"),
                        leading: const Icon(Icons.event, color: btnColor),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(value,
              style: const TextStyle(color: Colors.black87, fontSize: 14)),
        ),
      ],
    );
  }
}

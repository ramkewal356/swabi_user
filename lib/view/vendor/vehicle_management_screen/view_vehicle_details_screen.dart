import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';

import 'package:flutter_cab/view_model/vehicle_view_model.dart';

import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../core/utils/dimensions.dart';

class ViewVehicleDetailsScreen extends StatefulWidget {
  final String vehicleId;
  const ViewVehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  State<ViewVehicleDetailsScreen> createState() =>
      _ViewVehicleDetailsScreenState();
}

class _ViewVehicleDetailsScreenState extends State<ViewVehicleDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVehicleDetails();
    });
  }

  void getVehicleDetails() {
    context
        .read<VehicleViewModel>()
        .getVehicleByIdApi(vehicleId: widget.vehicleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgGreyColor,
        appBar: AppBar(
          backgroundColor: background,
          title: Text(
            "Vehicle Details",
            style: appBarTitleStyle,
          ),
          centerTitle: true,
        ),
        body: Consumer<VehicleViewModel>(
          builder: (context, value, child) {
            if (value.getVehicleDetails.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              var data = value.getVehicleDetails.data?.data;
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
                        images: (data?.images) ?? [],
                      ),
                    ),

                    const SizedBox(height: 16),
                    titleText(title: 'Vehicle Details'),
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
                                    "${data?.carName}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // const Spacer(),
                                Chip(
                                  label: Text(
                                    data?.vehicleStatus == 'TRUE'
                                        ? "ACTIVE"
                                        : "INACTIVE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: data?.vehicleStatus == 'TRUE'
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
                                    title: "Vehicle Id",
                                    value: "${data?.vehicleId}"),
                                InfoRow(
                                    title: "Car Type",
                                    value: "${data?.carType}"),
                                InfoRow(
                                    title: "Brand Name",
                                    value: "${data?.brandName}"),
                                InfoRow(
                                    title: "Fuel Type",
                                    value: "${data?.fuelType}"),
                                InfoRow(
                                    title: "Seats", value: "${data?.seats}"),
                                InfoRow(
                                    title: "Year",
                                    value:
                                        "${data?.year.toString().substring(0, 4)}"),
                                InfoRow(
                                    title: 'Vehicle No',
                                    value: '${data?.vehicleNumber}'),
                                InfoRow(
                                    title: "Model No",
                                    value: "${data?.modelNo}"),
                                InfoRow(
                                    title: "Color", value: "${data?.color}"),
                              ],
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    titleText(title: 'Vehicle Documents Image'),
                    Card.outlined(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data?.vehicleDocUrl ?? '',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    titleText(title: 'Vehicle Owner Image'),
                    Card.outlined(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data?.vehicleOwnerInfo?.vehicleOwnerImageUrl ?? '',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    titleText(title: 'Vehicle Owner Details'),
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
                            InfoRow(
                                title: "Owner Name",
                                value:
                                    "${data?.vehicleOwnerInfo?.firstName} ${data?.vehicleOwnerInfo?.lastName}"),
                            SizedBox(height: 5),
                            InfoRow(
                                title: "Owner Contact No",
                                value:
                                    "+${data?.vehicleOwnerInfo?.countryCode} ${data?.vehicleOwnerInfo?.mobile}"),
                            SizedBox(height: 5),
                            InfoRow(
                                title: "Owner Email",
                                value: "${data?.vehicleOwnerInfo?.email}"),
                            SizedBox(height: 5),
                            InfoRow(
                                title: 'Emirates Id',
                                value: '${data?.vehicleOwnerInfo?.emiratesId}'),
                            SizedBox(height: 5),
                            InfoRow(
                                title: 'State',
                                value: '${data?.vehicleOwnerInfo?.state}'),
                            SizedBox(height: 5),
                            InfoRow(
                                title: 'Country',
                                value: '${data?.vehicleOwnerInfo?.country}'),
                            SizedBox(height: 5),
                            InfoRow(
                                title: "Owner Address",
                                value: "${data?.vehicleOwnerInfo?.address}"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ));
  }

  Widget titleText({required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 4.0, color: btnColor),
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          title,
          style: TextStyle(
              color: blackColor, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
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

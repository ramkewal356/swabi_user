import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/custom_container.dart';
import 'package:flutter_cab/widgets/info_row.dart';

import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/view_model/vehicle_owner_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class ViewVehicleOwnerDetailsScreen extends StatefulWidget {
  final String ownerId;
  const ViewVehicleOwnerDetailsScreen({super.key, required this.ownerId});

  @override
  State<ViewVehicleOwnerDetailsScreen> createState() =>
      _ViewVehicleOwnerDetailsScreenState();
}

class _ViewVehicleOwnerDetailsScreenState
    extends State<ViewVehicleOwnerDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVehicleOwnerDetails();
    });
    super.initState();
  }

  void getVehicleOwnerDetails() {
    context
        .read<VehicleOwnerViewModel>()
        .getVehicleOwnerByIdApi(ownerId: widget.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text('Vehicle Owner Details'),
      ),
      body: Consumer<VehicleOwnerViewModel>(
        builder: (context, vehicleOwnerVM, child) {
          var vehicleOwnerDetails = vehicleOwnerVM.vehicleOwnerById.data?.data;
          if (vehicleOwnerVM.vehicleOwnerById.status == Status.loading) {
            return const Center(
                child: CircularProgressIndicator(
              color: greenColor,
            ));
          } else if (vehicleOwnerVM.vehicleOwnerById.status == Status.error) {
            return Center(
                child:
                    Text('Error: ${vehicleOwnerVM.vehicleOwnerById.message}'));
          } else if (vehicleOwnerDetails == null) {
            return const Center(child: Text('No details found.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel / Banner
                    CommonContainer(
                        elevation: 0,
                        borderReq: true,
                        // color: naturalGreyColor.withOpacity(.4),
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(10),
                        height: AppDimension.getHeight(context) / 4,
                        child: Image.network(
                          vehicleOwnerDetails.vehicleOwnerImageUrl ?? '',
                          fit: BoxFit.cover,
                        )),

                    const SizedBox(height: 16),
                    titleText(title: 'Vehicle Owner Details'),
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
                                    "${vehicleOwnerDetails.firstName} ${vehicleOwnerDetails.lastName}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // const Spacer(),
                                Chip(
                                  label: Text(
                                    vehicleOwnerDetails.status == true
                                        ? "ACTIVE"
                                        : "INACTIVE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      vehicleOwnerDetails.status == true
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
                                    label: "Owner Id",
                                    value:
                                        "${vehicleOwnerDetails.vehicleOwnerId}"),
                                InfoRow(
                                    label: "Email",
                                    value: "${vehicleOwnerDetails.email}"),
                                InfoRow(
                                    label: "Contact No",
                                    value:
                                        "+${vehicleOwnerDetails.countryCode} ${vehicleOwnerDetails.mobile}"),
                                InfoRow(
                                    label: "Government Id",
                                    value: "${vehicleOwnerDetails.emiratesId}"),
                                InfoRow(
                                    label: 'Country',
                                    value: '${vehicleOwnerDetails.country}'),
                                InfoRow(
                                    label: "State",
                                    value: "${vehicleOwnerDetails.state}"),
                                InfoRow(
                                    label: "Location",
                                    value: "${vehicleOwnerDetails.address}"),
                              ],
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Add more fields as necessary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleText(title: 'Vehicle List'),
                        CustomButtonSmall(
                          height: 40,
                          btnHeading: 'Add Vehicle',
                          onTap: () {
                            context.push(
                                '/vendor_dashboard/vehicle_management/add_edit_vehicle',
                                extra: {
                                  "ownerId": widget.ownerId,
                                  "actionByOwner": 'add vehicle',
                                }).then((onValue) {
                              getVehicleOwnerDetails();
                            });
                          },
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10),

                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vehicleOwnerDetails.vehicleList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final v = vehicleOwnerDetails.vehicleList![index];
                        return Card(
                          color: background,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            horizontalTitleGap: 10,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                (v.images != null && v.images!.isNotEmpty)
                                    ? v.images!.first
                                    : '',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.directions_car,
                                  size: 60,
                                ),
                              ),
                            ),
                            title: Text(
                              '${v.brandName} (${v.vehicleId})',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '${v.carType} • ${v.seats} seats \nVehicle No : ${v.vehicleNumber} \nModel No : ${v.modelNo}',
                              style: const TextStyle(height: 1.3),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: v.vehicleStatus == 'TRUE'
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    v.vehicleStatus == 'TRUE'
                                        ? 'ACTIVE'
                                        : 'INACTIVE',
                                    style: TextStyle(
                                      color: v.vehicleStatus == 'TRUE'
                                          ? Colors.green[800]
                                          : Colors.red[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('${v.year}',
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            onTap: () {},
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
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

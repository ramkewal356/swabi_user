import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RentalCancelledPageView extends StatefulWidget {
  final String cancelledId;
  const RentalCancelledPageView({super.key, required this.cancelledId});

  @override
  State<RentalCancelledPageView> createState() =>
      _RentalCancelledPageViewState();
}

class _RentalCancelledPageViewState extends State<RentalCancelledPageView> {
  var data, userData, driverDetails, vehicleDetails, guestDetails;
  @override
  Widget build(BuildContext context) {
    data =
        context.watch<RentalViewDetailViewModel>().dataList1.data?.data ?? "";
    userData =
        context.watch<RentalViewDetailViewModel>().dataList1.data?.data.user ??
            "";
    driverDetails = context
            .watch<RentalViewDetailViewModel>()
            .dataList1
            .data
            ?.data
            .driver ??
        "";
    guestDetails =
        context.watch<RentalViewDetailViewModel>().dataList1.data?.data.guest ??
            "";
    vehicleDetails = context
            .watch<RentalViewDetailViewModel>()
            .dataList1
            .data
            ?.data
            .vehicle ??
        "";

    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Cancelled",
      ),
      body: PageLayout_Page(
          child: ListView(
        children: [
          RentalCancelledContainer(
            bookingId: data.rentalBookingId,
            // carName: data.carType,
            hour: data.totalRentTime,
            id: widget.cancelledId,
            kilometer: data.kilometers,
            pickDate: data.date,
            pickTime: data.pickupTime,
            rentalCharge: data.rentalCharge,
            status: data.bookingStatus,
            // fuel: "Petrol",s
            pickUpLocation: data.pickupLocation,
            paid: data.paidStatus,
            cancelReason: data.cancellationReason,
            cancelledBy: data.cancelledBy == 'null' ? "N/A" : data.cancelledBy,
            // vehicle: data.vehicle,
            firstName: data.guest!.guestName?.toString() ?? '',
            lastName: data.guest!.guestName?.toString() ?? '',
            contact: data.guest!.guestName?.toString() ?? '',
            email: data.guest!.guestName?.toString() ?? '',
            // firstName: guestDetails.toString().isEmpty || guestDetails != "null" ? guestMap['guestName'] : "",
            // lastName: guestDetails.toString().isEmpty || guestDetails != "null" ? "" : "",
            // contact: guestDetails.toString().isEmpty || guestDetails != "null" ? guestMap['guestMobile'] : "",
            // email: guestDetails.toString().isEmpty || guestDetails != "null" ? guestMap['gender'] : "",
          ),
          const SizedBox(height: 10),
          vehicleDetails != null &&
                  vehicleDetails.carName != null &&
                  vehicleDetails.carName!.isNotEmpty
              ? VechicleDetailsContainer(
                  color: data.vehicle?.color?.toString() ?? '',
                  vehicleName: data.vehicle?.carName?.toString() ?? '',
                  brandName: data.vehicle?.brandName?.toString() ?? '',
                  vehicleNo: data.vehicle?.vehicleNumber?.toString() ?? '',
                  fuelType: data.vehicle?.fuelType?.toString() ?? '',
                  seats: data.vehicle?.seats?.toString() ?? '',
                  vehicleImage: const [],
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          driverDetails != null &&
                  driverDetails.firstName != null &&
                  driverDetails.firstName!.isNotEmpty
              ? DriverDetailsContainer(
                  firstName: data.driver.firstName?.toString() ?? '',
                  lastName: data.driver.lastName?.toString() ?? '',
                  gender: data.driver.gender?.toString() ?? '',
                  mobile: data.driver.mobile?.toString() ?? '',
                  email: data.driver.email?.toString() ?? '',
                )
              : Container(),
        ],
      )),
    );
  }
}

class RentalCancelledContainer extends StatelessWidget {
  // final String carName;
  final String pickDate;
  final String pickTime;
  final String hour;
  final String id;
  final String firstName;
  final String lastName;
  final String contact;
  final String email;
  final String kilometer;
  final String status;
  final String rentalCharge;
  final String bookingId;
  final String pickUpLocation;
  final String paid;
  final String cancelReason;
  final String cancelledBy;

  const RentalCancelledContainer({
    super.key,
    // required this.carName,
    required this.pickDate,
    required this.pickTime,
    required this.hour,
    required this.id,
    required this.kilometer,
    required this.status,
    required this.rentalCharge,
    required this.bookingId,
    required this.pickUpLocation,
    required this.paid,
    required this.firstName,
    required this.lastName,
    required this.contact,
    required this.email,
    required this.cancelReason,
    required this.cancelledBy,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        // height: AppDimension.getHeight(context) * .5,
        width: AppDimension.getWidth(context) * .9,
        // padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: background,
            border: Border.all(
              color: naturalGreyColor.withOpacity(0.3),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(9),
                    topLeft: Radius.circular(9),
                  ),
                  color: btnColor,
                  border: Border(
                      bottom: BorderSide(
                          color: naturalGreyColor.withOpacity(0.3)))),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Cancelled Booking Details",
                    style: GoogleFonts.lato(
                        color: background,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )),
            ),

            ///3rd Container
            Container(
              // height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              // decoration: const BoxDecoration(
              //     border: Border(bottom: BorderSide(color: greyColor))
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Id : ", style: titleTextStyle),
                              SizedBox(
                                width: 50,
                                child: Text(id, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(status, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(pickDate, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hour : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(hour, style: titleTextStyle1),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kilometer : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(kilometer, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rental Charge : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child:
                                    Text(rentalCharge, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Time : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(pickTime, style: titleTextStyle1),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PickUp Location : ", style: titleTextStyle),
                      SizedBox(
                        width: 200,
                        child: Text(pickUpLocation, style: titleTextStyle1),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Canceled By : ", style: titleTextStyle),
                      SizedBox(
                        width: 200,
                        child: Text(cancelledBy, style: titleTextStyle1),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cancel Reason : ", style: titleTextStyle),
                      SizedBox(
                        width: 200,
                        child: Text(cancelReason, style: titleTextStyle1),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Booking ID : ", style: titleTextStyle),
                      SizedBox(
                        width: 230,
                        child: Text(bookingId, style: titleTextStyle1),
                      )
                    ],
                  )
                ],
              ),
            ),
            firstName.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: greyColor))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Guest Details",
                                style: titleTextStyle,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Guest Name : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text('$firstName $lastName',
                                    style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Contact No: ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(contact, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(email, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}

class VechicleDetailsContainer extends StatelessWidget {
  final String vehicleName;
  final String vehicleNo;
  final String fuelType;
  final String brandName;
  final String seats;
  final String color;
  final List<String> vehicleImage;

  const VechicleDetailsContainer({
    super.key,
    required this.vehicleName,
    this.seats = '',
    required this.vehicleNo,
    required this.fuelType,
    required this.brandName,
    required this.color,
    required this.vehicleImage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        // height: AppDimension.getHeight(context) * .5,
        width: AppDimension.getWidth(context) * .9,
        // padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: background,
            border: Border.all(
              color: naturalGreyColor.withOpacity(0.3),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(9),
                    topLeft: Radius.circular(9),
                  ),
                  color: btnColor,
                  border: Border(
                      bottom: BorderSide(
                          color: naturalGreyColor.withOpacity(0.3)))),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Vehicle Details",
                    style: GoogleFonts.lato(
                        color: background,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )),
            ),
            SizedBox(
              height: 220,
              child: MultiImageSlider(images: vehicleImage),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Vehicle Name : ", style: titleTextStyle),
                              SizedBox(
                                width: 110,
                                child:
                                    Text(vehicleName, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Brand Name : ", style: titleTextStyle),
                              SizedBox(
                                width: 110,
                                child: Text(brandName, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Vehicle No. : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(vehicleNo, style: titleTextStyle1),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Color : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(color, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Fuel Type : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(fuelType, style: titleTextStyle1),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Seats : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(seats, style: titleTextStyle1),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverDetailsContainer extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String gender;

  const DriverDetailsContainer({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        // height: AppDimension.getHeight(context) * .5,
        width: AppDimension.getWidth(context) * .9,
        // padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: background,
            border: Border.all(
              color: naturalGreyColor.withOpacity(0.3),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(9),
                    topLeft: Radius.circular(9),
                  ),
                  color: btnColor,
                  border: Border(
                      bottom: BorderSide(
                          color: naturalGreyColor.withOpacity(0.3)))),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Driver Details",
                    style: GoogleFonts.lato(
                        color: background,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("First Name : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(
                                  firstName,
                                  style: titleTextStyle1,
                                  maxLines: 3,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mobile No. : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(
                                  mobile,
                                  style: titleTextStyle1,
                                  maxLines: 3,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email : ", style: titleTextStyle),
                              SizedBox(
                                // width: 100,
                                child: Text(
                                  email,
                                  style: titleTextStyle1,
                                  maxLines: 3,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Last Name : ", style: titleTextStyle),
                                SizedBox(
                                  // width: 100,
                                  child: Text(
                                    lastName,
                                    style: titleTextStyle1,
                                    maxLines: 3,
                                  ),
                                )
                              ]),
                          const SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gender : ", style: titleTextStyle),
                                SizedBox(
                                  // width: 100,
                                  child: Text(
                                    gender,
                                    style: titleTextStyle1,
                                    maxLines: 3,
                                  ),
                                )
                              ]),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

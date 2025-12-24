// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/response/status.dart';

class CarsDetailsAvailable extends StatefulWidget {
  final String id;
  final double longitude;
  final double latitude;

  const CarsDetailsAvailable({
    super.key,
    required this.id,
    required this.longitude,
    required this.latitude,
  });

  @override
  State<CarsDetailsAvailable> createState() => _CarsDetailsAvailableState();
}

class _CarsDetailsAvailableState extends State<CarsDetailsAvailable> {
  @override
  void initState() {
    super.initState();
  }


  int? selectIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Cars Available",
      ),
      body: PageLayoutPage(child: Consumer<RentalViewModel>(
        builder: (context, value, child) {
          if (value.dataList.status == Status.loading) {
            return CircularProgressIndicator(
              color: greenColor,
            );
          } else if (value.dataList.status == Status.completed) {
            var rentalData = value.dataList.data?.data.body ?? [];
            return rentalData.isEmpty
                ? Center(
                    child: Text(
                    value.dataList.data?.data.errorMessage ?? '',
                    style: nodataTextStyle,
                  ))
                : ListView.builder(
                    itemCount: rentalData.length,
                    itemBuilder: (context, index) {
                      return TransContainer(
                          carName: rentalData[index].carName,
                          carImage: rentalData[index].carImage,
                          pickTime: rentalData[index].pickupTime,
                          price: rentalData[index].price,
                          pickDate: rentalData[index].date,
                          totalPrice: rentalData[index].totalPrice,
                          hour: rentalData[index].hours,
                          seats: rentalData[index].seats,
                          kilometers: rentalData[index].kilometers,
                          currency: rentalData[index].currency,
                          pickUpLocation: rentalData[index].pickUpLocation,
                          loading: selectIndex == index,
                          onTap: () {
                            setState(() {
                              // load = true;
                              selectIndex = index;
                            });
                            // double amount =
                            //     double.parse(rentalData[index].totalPrice);

                            context.push('/rentalForm/bookYourCab', extra: {
                              "carType": rentalData[index].carName,
                              "userId": widget.id.toString(),
                              "bookdate": rentalData[index].date,
                              "totalAmt": rentalData[index].totalPrice,
                              "longitude": rentalData[index].longitude,
                              "latitude": rentalData[index].latitude
                            });
                            setState(() {
                              // load = false;
                              selectIndex = null;
                            });
                          });
                    });
          } else {
            return Container();
          }
        },
      )),
    );
  }
}

class TransContainer extends StatelessWidget {
  final String carName;
  final String carImage;

  final String pickTime;
  final String pickDate;
  final String price;
  final String hour;
  final String seats;
  final String totalPrice;
  final String kilometers;
  final bool loading;
  final String pickUpLocation;
  final String currency;
  final VoidCallback onTap;

  const TransContainer(
      {this.carName = "",
      this.carImage = "",
      this.pickTime = "",
      this.pickDate = "",
      this.loading = false,
      this.hour = "",
      this.seats = "",
      this.price = "",
      this.totalPrice = "",
      required this.currency,
      this.kilometers = "",
      this.pickUpLocation = "",
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 0,
        color: background,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // height: AppDimension.getHeight(context)*.25,
          width: AppDimension.getWidth(context) * .9,
          decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: naturalGreyColor.withOpacity(.3))),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: curvePageColor))),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 60,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: carImage.isNotEmpty
                                ? Image.network(
                                    carImage,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    rentalCar1,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  carName,
                                  style: GoogleFonts.lato(
                                      color: greyColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Seats : $seats",
                                  style: GoogleFonts.lato(
                                      color: greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hour : $hour",
                                  style: GoogleFonts.lato(
                                      color: greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Date : $pickDate",
                                  style: GoogleFonts.lato(
                                      color: greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),

              ///Second Line Design
              Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: curvePageColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTile(
                        dense: true,
                        horizontalTitleGap: 10,
                        // contentPadding:
                        //     const EdgeInsets.symmetric(horizontal: 10),
                        leading: const Icon(Icons.edit_road),
                        title: Text(
                          "Kilometer",
                          style: titleText,
                        ),
                        subtitle: Text('$kilometers KM', style: titleText),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        dense: true,
                        horizontalTitleGap: 10,
                        contentPadding: const EdgeInsets.only(left: 45),
                        leading: const Icon(Icons.lock_clock),
                        title: Text(
                          'Pickup Time',
                          style: titleText,
                        ),
                        subtitle: Text(
                          pickTime,
                          style: titleText,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              ///Third Line Design
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: curvePageColor))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location : ",
                        style: titleText,
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          pickUpLocation,
                          style: titleText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: greyColor1.withOpacity(.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: currency, style: appbarTextStyle),
                      TextSpan(
                          text: " $totalPrice".toUpperCase(),
                          style: appbarTextStyle),
                    ])),
                    CustomButtonSmall(
                      width: 120,
                      height: 40,
                      loading: loading,
                      btnHeading: "BOOK NOW",
                      onTap: onTap,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

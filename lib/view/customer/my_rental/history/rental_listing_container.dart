import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/text_styles.dart';

class RentalCarListingContainer extends StatelessWidget {
  final String carName;
  final String date;
  final String rentalCharge;
  final String status;
  final List<dynamic> images;
  final String time;
  final String bookingID;
  final String pickUplocation;
  final VoidCallback? onTapContainer;
  final bool loader;
  const RentalCarListingContainer(
      {super.key,
      this.onTapContainer,
      required this.carName,
      required this.date,
      required this.time,
      required this.images,
      required this.bookingID,
      required this.pickUplocation,
      required this.rentalCharge,
      required this.loader,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          // onTap:onTapContainer,
          child: Container(
            // width: AppDimension.getWidth(context) * .9,
            decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: naturalGreyColor.withOpacity(0.3))),
            child: Column(
              children: [
                ///First Line of Design
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: naturalGreyColor.withOpacity(0.3)))),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      horizontalTitleGap: 10,
                      leading: SizedBox(
                        width: 80,
                        height: 60,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: images.isEmpty
                                ? Image.asset(
                                    rentalCar1,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    images[0],
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      title: Text(
                        carName,
                        style: titleTextStyle,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  size: 18),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(date, style: titleTextStyle1),
                            ],
                          ),
                          Text(
                            "Booking Id : $bookingID",
                            style: titleTextStyle1,
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Charges",
                            style: titleTextStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "AED $rentalCharge",
                            style: titleTextStyle1,
                          ),
                        ],
                      ),
                    )),

                ///Second Line Design
                Container(
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: curvePageColor))),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          horizontalTitleGap: 0,
                          leading: SizedBox(
                            width: 35,
                            height: 35,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(location),
                                )),
                          ),
                          title: Text(
                            "PickUp Location",
                            style: titleTextStyle,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  pickUplocation,
                                  style: titleTextStyle1,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(left: 30),
                          dense: true,
                          horizontalTitleGap: 0,
                          leading:
                              const Icon(Icons.watch_later_outlined, size: 18),
                          title: Text('PickUp Time', style: titleTextStyle),
                          subtitle: Text(time, style: titleTextStyle1),
                        ),
                      )
                    ],
                  ),
                ),

                ///Second Line Design
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: status == "CANCELLED"
                                  ? redColor.withOpacity(.1)
                                  : greenColor.withOpacity(.1),
                              // color: status == "BOOKED"?greenColor.withOpacity(.1):status == "CANCELLED"?redColor.withOpacity(.1):status == "ON_RUNNING"?Colors.yellowAccent.withOpacity(.1):Colors.blue.withOpacity(.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                status,
                                style: GoogleFonts.lato(
                                    color: status == "CANCELLED"
                                        ? redColor
                                        : greenColor,
                                    // color: status == "BOOKED"?greenColor:status == "CANCELLED"?redColor:status == "ON_RUNNING"?Colors.yellowAccent:Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )),
                      CustomButtonSmall(
                          loading: loader,
                          height: 40,
                          width: 120,
                          btnHeading: 'View Details',
                          onTap: onTapContainer)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

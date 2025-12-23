import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/widgets/custom_container.dart';

import 'package:flutter_cab/common/styles/app_color.dart';

import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

class PackageHistoryContainer extends StatelessWidget {
  final String status;
  final String pkgID;
  final String bookingDate;
  final String members;
  final String price;
  final String pkgName;
  final String location;
  final String customerName;
  final String currency;
  final List<String> imageList;
  final VoidCallback onTap;
  final bool loader;
  const PackageHistoryContainer(
      {super.key,
      required this.status,
      required this.pkgID,
      required this.bookingDate,
      this.members = '',
      required this.pkgName,
      required this.location,
      required this.imageList,
      required this.onTap,
      this.customerName = '',
      required this.loader,
      required this.price,
      required this.currency});
  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "BOOKED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      case "COMPLETED":
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      borderRadius: BorderRadius.circular(5),
      elevation: 2,
      // ignore: deprecated_member_use
      borderColor: naturalGreyColor.withOpacity(0.3),

      borderReq: true,
      child: Material(
        color: background,
        child: Column(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: MultiImageSlider(
                images: List.generate(
                    imageList.length, (index) => imageList[index]),
              ),
              // child: Image.asset(tour,width: double.infinity,fit: BoxFit.fill,),
            ),
            Row(
              children: [
                Expanded(child: _builtText(lable: 'Booking Id', value: pkgID)),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Chip(
                      color: WidgetStatePropertyAll(_statusColor(status)),
                      label: Text(
                        status,
                        style: TextStyle(color: background),
                      )),
                )
              ],
            ),
            _builtText(lable: 'Package Name', value: pkgName),
            _builtText(lable: 'Booking Date', value: bookingDate),
            if (customerName.isNotEmpty)
              _builtText(lable: 'Customer Name', value: customerName),
            if (members.isNotEmpty)
              _builtText(lable: 'Members', value: members),
            _builtText(lable: 'Location', value: location),

            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   margin: const EdgeInsets.only(bottom: 5, top: 10),
            //   child: Row(
            //     children: [
            //       const CustomTextWidget(
            //         content: "Package Name : ",
            //         fontWeight: FontWeight.w600,
            //         fontSize: 16,
            //         textColor: textColor,
            //       ),
            //       SizedBox(
            //         width: AppDimension.getWidth(context) * .55,
            //         child: CustomText(
            //           content: pkgName,
            //           fontWeight: FontWeight.w400,
            //           fontSize: 15,
            //           align: TextAlign.start,
            //           textEllipsis: true,
            //           maxline: 1,
            //           textColor: textColor,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   // height: 50,
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   margin: const EdgeInsets.only(bottom: 5),

            //   child: textTile(
            //       lable1: 'Booking Id',
            //       value1: pkgID,
            //       lable2: 'Status',
            //       value2: status),
            // ),
            // Container(
            //     // height: 50,
            //     padding: const EdgeInsets.symmetric(horizontal: 10),
            //     margin: const EdgeInsets.only(bottom: 5),
            //     child: textTile(
            //         lable1: 'Date',
            //         value1: bookingDate,
            //         lable2: "Member's",
            //         value2: members)),
            // Container(
            //     // height: 50,
            //     padding: const EdgeInsets.symmetric(horizontal: 10),
            //     margin: const EdgeInsets.only(bottom: 5),
            //     // decoration: const BoxDecoration(
            //     //     border:
            //     //         Border(bottom: BorderSide(color: naturalGreyColor))),
            //     child: Center(
            //       child: _builtText(lable: 'Location', value: location),
            //     )),
            Container(
              // height: 50,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // ignore: deprecated_member_use
                  color: greyColor1.withOpacity(.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Price :",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: " $currency $price".toUpperCase(),
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ])),
                  CustomButtonSmall(
                      loading: loader,
                      height: 40,
                      width: 120,
                      btnHeading: 'View Details',
                      onTap: onTap),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textTile({
    required String lable1,
    required String value1,
    required String lable2,
    required String value2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _builtText(lable: lable1, value: value1)),
        Expanded(flex: 2, child: _builtText(lable: lable2, value: value2))
      ],
    );
  }

  Widget _builtText({required String lable, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style: titleTextStyle,
          ),
          const SizedBox(width: 5),
          Text(
            ':',
            style: titleTextStyle,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: titleTextStyle1,
            ),
          )
        ],
      ),
    );
  }
}

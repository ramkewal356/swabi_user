import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class Custompaymentdetailscontainer extends StatelessWidget {
  final String paymentId;
  final String paymentDate;
  final String amount;
  final String paymentTime;
  final String taxAmount;
  final String discountAmount;
  final String rentalAmount;
  const Custompaymentdetailscontainer(
      {super.key,
      required this.paymentId,
      required this.paymentDate,
      required this.amount,
      required this.paymentTime,
      required this.taxAmount,
      required this.discountAmount,
      required this.rentalAmount});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: naturalGreyColor.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(10),
            color: background),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                  color: btnColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: const Center(
                  child: Text(
                'Payment Details',
                style: TextStyle(
                    color: background,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              )),
            ),
            textItem(lable: 'Payment Id', value: paymentId),
            textItem(lable: 'Rental Amount', value: 'AED $rentalAmount'),
            textItem(lable: 'Tax Amount (5%)', value: 'AED $taxAmount'),
            discountAmount == '0.0'
                ? const SizedBox.shrink()
                : textItem(
                    lable: 'Discount Amount', value: 'AED $discountAmount'),
            textItem(lable: 'Total Amount', value: 'AED $amount'),
            textItem(lable: 'Payment Date', value: paymentDate),
            textItem(lable: 'Payment Time', value: paymentTime),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  textItem({required String lable, required String value}) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: Row(
        children: [
          Text(
            lable,
            style: titleTextStyle,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            ':',
            style: titleTextStyle,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            value,
            style: titleTextStyle1,
          )
        ],
      ),
    );
  }
}

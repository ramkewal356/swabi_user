import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:intl/intl.dart';

class RefundPaymentContainer extends StatelessWidget {
  // final String refundId;
  final String refundAmount;
  final String refundStatus;
  // final int refundDate;
  const RefundPaymentContainer(
      {super.key,
      // required this.refundId,
      required this.refundAmount,
      // required this.refundDate
      required this.refundStatus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
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
                  'Refund Details',
                  style: TextStyle(
                      color: background,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                )),
              ),
              // textItem(lable: 'Refund Id', value: refundId),
              textItem(lable: 'Refund Amount', value: 'AED $refundAmount'),
              textItem(
                  lable: 'Refund Status',
                  value: refundStatus == "created"
                      ? "PENDING"
                      : refundStatus == "processed"
                          ? "PROCESSED"
                          : refundStatus),

              // textItem(
              //     lable: 'Refund Date',
              //     value: DateFormat('dd-MM-yyyy').format(
              //         DateTime.fromMillisecondsSinceEpoch((refundDate) * 1000,
              //             isUtc: true))),
              const SizedBox(
                height: 10,
              )
            ],
          ),
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
          Expanded(
            flex: 2,
            child: Text(
              lable,
              style: titleTextStyle,
            ),
          ),
          Text(
            ':',
            style: titleTextStyle,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
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

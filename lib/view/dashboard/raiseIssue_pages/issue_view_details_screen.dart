import 'package:flutter/material.dart';
import 'package:flutter_cab/model/issuedetail_model.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Issueviewdetails extends StatefulWidget {
  const Issueviewdetails({super.key});

  @override
  State<Issueviewdetails> createState() => _IssueviewdetailsState();
}

class _IssueviewdetailsState extends State<Issueviewdetails> {
  Data? issueData;
  @override
  Widget build(BuildContext context) {
    issueData = context.watch<RaiseissueViewModel>().issueDetail.data?.data;
    return Scaffold(
      appBar: const CustomAppBar(
        heading: 'Issue Details',
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Status",
                        style: titleTextStyle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      ':',
                      style: titleTextStyle,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            // width: 120,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: issueData?.issueStatus == 'OPEN'
                                    ? redColor
                                    : issueData?.issueStatus == 'IN_PROGRESS'
                                        ? Colors.orange
                                        : Colors.green,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                issueData?.issueStatus.toString() ==
                                        'IN_PROGRESS'
                                    ? 'INPROGRESS'
                                    : issueData?.issueStatus ?? '',
                                style: const TextStyle(color: background),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                itemText(
                    lable: 'Issue Id',
                    value: issueData?.issueId.toString() ?? ''),
                itemText(
                    lable: 'Booking Id',
                    value: issueData?.bookingId.toString() ?? ''),
                itemText(
                    lable: 'Created Date',
                    value: DateFormat('dd-MM-yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            issueData?.createdDate ?? 0))),
                itemText(
                    lable: 'Booking Type',
                    value: issueData?.bookingType == 'PACKAGE_BOOKING'
                        ? 'PACKAGE BOOKING'
                        : 'RENTAL BOOKING'),
                itemText(
                    lable: 'Issue Description',
                    value: issueData?.issueDescription.toString() ?? ''),
                issueData?.resolutionDescription == null
                    ? const SizedBox()
                    : Text(
                        'Resolution Description :-',
                        style: titleTextStyle,
                      ),
                Text(
                  issueData?.resolutionDescription ?? '',
                  style: titleTextStyle1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  itemText({required String lable, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            lable,
            style: titleTextStyle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          ':',
          style: titleTextStyle,
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: titleTextStyle1,
          ),
        )
      ],
    );
  }

  itemtile({required String lable, required String vale}) {
    return Row(children: [
      Text(
        lable,
        style: titleTextStyle,
      ),
      const SizedBox(width: 5),
      Text(':'),
      const SizedBox(width: 5),
      Text(
        vale,
        style: titleTextStyle1,
      )
    ]);
  }
}

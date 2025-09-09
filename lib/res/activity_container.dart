import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_viewmore_viewless.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/string_extenstion.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class ActivityContainer extends StatefulWidget {
  final List<String> actyImage;
  final String? days;
  final String? pickupTime;
  final String? pickupDate;
  final String activityName;
  final String description;
  final String activityHour;
  final String activityVisit;
  final List<String> suitableFor;
  final String openTime;
  final String closeTime;
  final String address;
  final double? activityPrice;
  final double? discountPrice;
  final double? activityDiscountPer;
  final double? infantDiscount;
  final double? childDiscount;
  final double? seniorDiscount;
  final String activityStatus;
  final String? activityOfferDate;
  final bool visible;
  const ActivityContainer(
      {required this.actyImage,
      this.days,
      this.pickupTime,
      this.pickupDate,
      required this.activityName,
      required this.description,
      required this.activityHour,
      required this.activityVisit,
      required this.suitableFor,
      required this.openTime,
      required this.closeTime,
      required this.address,
      this.activityPrice,
      this.discountPrice,
      this.activityDiscountPer,
      this.infantDiscount,
      this.childDiscount,
      this.seniorDiscount,
      this.activityStatus = '',
      this.activityOfferDate,
      this.visible = true,
      super.key});

  @override
  State<ActivityContainer> createState() => _ActivityContainerState();
}

class _ActivityContainerState extends State<ActivityContainer> {
  @override
  Widget build(BuildContext context) {
    // String currentDate = DateFormat('dd-MM-yyyy').format(_dateTime);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CommonContainer(
        borderReq: true,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // ignore: deprecated_member_use
        borderColor: naturalGreyColor.withOpacity(.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.activityStatus.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(width: 4, color: btnColor)),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          'Day ${widget.days} Activity',
                          style: titleTextStyle,
                        ),
                      ),
                      Chip(
                          color: WidgetStatePropertyAll(
                              widget.activityStatus == 'PENDING'
                                  ? redColor
                                  : greenColor),
                          label: Text(
                            widget.activityStatus,
                            style: subtitleTextStyle,
                          ))
                    ],
                  )
                : SizedBox.shrink(),

            CommonContainer(
              elevation: 0,
              height: 220,
              borderRadius: BorderRadius.circular(10),
              child: MultiImageSlider(
                images: widget.actyImage,
              ),
            ),
            const SizedBox(height: 5),
            CustomText(
              align: TextAlign.start,
              content: widget.activityName,
              maxline: 3,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              textColor: btnColor,
            ),
            const SizedBox(height: 5),

            CustomViewmoreViewless(
                moreText: widget.description.replaceAll(RegExp(r'\s+'), '')),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "Activity Hours : ", style: titleText),
                    TextSpan(text: widget.activityHour, style: valueText)
                  ])),
                ),
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "Time To Visit : ", style: titleText),
                    TextSpan(text: widget.activityVisit, style: valueText)
                  ])),
                )
              ],
            ),
            const SizedBox(height: 10),

            ///2nd Row of Details
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "Opening Time : ", style: titleText),
                    TextSpan(text: widget.openTime, style: valueText)
                  ])),
                ),
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "Closing Time : ", style: titleText),
                    TextSpan(text: widget.closeTime, style: valueText)
                  ])),
                )
              ],
            ),
            if (widget.activityStatus.isNotEmpty) const SizedBox(height: 10),
            if (widget.activityStatus.isNotEmpty)
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "Pickup Date : ", style: titleText),
                      TextSpan(text: widget.pickupDate, style: valueText)
                    ])),
                  ),
                  Expanded(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "Pickup Time : ", style: titleText),
                      TextSpan(text: widget.pickupTime, style: valueText)
                    ])),
                  )
                ],
              ),
            Visibility(
              visible: widget.visible,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  widget.suitableFor.contains('SENIOR') == true
                      ? discountTile(
                          lable: 'Senior Discount',
                          value: (widget.seniorDiscount == null ||
                                  widget.seniorDiscount == 0)
                              ? 'No Discount'
                              : widget.seniorDiscount == 100
                                  ? 'Free'
                                  : '${widget.seniorDiscount?.round()} %')
                      : const SizedBox.shrink(),
                  widget.suitableFor.contains('CHILD')
                      ? discountTile(
                          lable: 'Child Discount',
                          value: (widget.childDiscount == null ||
                                  widget.childDiscount == 0)
                              ? 'No Discount'
                              : widget.childDiscount == 100
                                  ? 'Free'
                                  : '${widget.childDiscount?.round()} %')
                      : const SizedBox.shrink(),
                  widget.suitableFor.contains('INFANT')
                      ? discountTile(
                          lable: 'Infant Discount',
                          value: (widget.infantDiscount == null ||
                                  widget.infantDiscount == 0)
                              ? 'No Discount'
                              : widget.infantDiscount == 100
                                  ? 'Free'
                                  : '${widget.infantDiscount?.round()} %')
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            widget.suitableFor.isNotEmpty
                ? const SizedBox(height: 10)
                : const SizedBox(),
            widget.suitableFor.isNotEmpty
                ? RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      TextSpan(text: "Suitable For : ", style: titleText),
                      TextSpan(
                          children:
                              widget.suitableFor.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String text = entry.value;

                            // Add a space after each TextSpan except the last one
                            return TextSpan(
                              text: idx < widget.suitableFor.length - 1
                                  ? '$text, '
                                  : text.toString(),
                            );
                          }).toList(),
                          style: valueText)
                    ]))
                : const SizedBox(),
            const SizedBox(height: 10),
            RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(text: "Location : ", style: titleText),
                  TextSpan(
                      text: widget.address.capitalizeFirstOfEach,
                      style: valueText)
                ])),
            const SizedBox(height: 5),
            Row(
              children: [
                widget.activityStatus == ''
                    ? const SizedBox.shrink()
                    : (widget.activityDiscountPer == null ||
                            widget.activityDiscountPer == 0)
                        ? const SizedBox.shrink()
                        : Text(
                            '${widget.activityDiscountPer?.round()} % OFF',
                            style: offText,
                          ),
                const Spacer(),
                widget.activityPrice == null
                    ? const SizedBox.shrink()
                    : Text(
                        'AED ${widget.activityPrice?.round()}',
                        style: (widget.discountPrice == null ||
                                widget.discountPrice == 0)
                            ? buttonText
                            : TextStyle(
                                decoration: (widget.discountPrice == null ||
                                        widget.discountPrice == 0)
                                    ? null
                                    : TextDecoration.lineThrough,
                                decorationThickness: 2,
                                decorationColor: btnColor),
                      ),
                const SizedBox(width: 5),
                (widget.discountPrice == null || widget.discountPrice == 0)
                    ? const SizedBox.shrink()
                    : Text(
                        'AED ${widget.discountPrice?.round()}',
                        style: buttonText,
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget discountTile({required String lable, required String value}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lable,
          style: titleText,
        ),
        const SizedBox(width: 5),
        Text(
          ':',
          style: titleTextStyle,
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: valueText,
        )
      ],
    );
  }

  Widget textItem({required String lable, required String value}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lable,
          style: titleText,
        ),
        const SizedBox(width: 5),
        Text(
          ':',
          style: titleTextStyle,
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: valueText,
        )
      ],
    );
  }
}

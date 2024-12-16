import 'package:flutter/material.dart';
import 'package:flutter_cab/model/get_package_details_by_id_model.dart';
// import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_viewmore_viewless.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/string_extenstion.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PackageDetails extends StatefulWidget {
  final String packageId;
  final String userId;
  final String bookDate;

  const PackageDetails(
      {super.key,
      required this.packageId,
      required this.userId,
      required this.bookDate});

  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  Data? packageActivity;
  List<String> allParticipantTypes = [];
  List<dynamic> imageList = [];
  List<PackageActivity> packageActivityList = [];
  List<String> sutableFor = [];
  @override
  Widget build(BuildContext context) {
    packageActivity = context
        .watch<GetPackageActivityByIdViewModel>()
        .getPackageActivityById
        .data
        ?.data;
    packageActivityList = context
            .watch<GetPackageActivityByIdViewModel>()
            .getPackageActivityById
            .data
            ?.data
            ?.packageActivities ??
        [];
    imageList = context
            .watch<GetPackageActivityByIdViewModel>()
            .getPackageActivityById
            .data
            ?.data
            ?.packageActivities
            ?.expand((e) => e.activity?.activityImageUrl ?? [])
            .toList() ??
        [];
 

    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Package View",
      ),
      body: PageLayout_Page(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  children: [
                    const SizedBox(height: 10),
                    // const CustomTextWidget(
                    //     sideLogo: true,
                    //     content: "Package Images",
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.w700,
                    //     textColor: textColor),
                    // const SizedBox(height: 10),
                    CommonContainer(
                      elevation: 0,
                      borderReq: true,
                      // color: naturalGreyColor.withOpacity(.4),
                      borderRadius: BorderRadius.circular(10),
                      height: AppDimension.getHeight(context) / 4,
                      child: MultiImageSlider(
                        images: List.generate(
                            imageList.length, (index) => imageList[index]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CustomTextWidget(
                        sideLogo: true,
                        content: "Package Details",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: textColor),
                    const SizedBox(height: 10),
                    CommonContainer(
                      borderReq: true,
                      // height: AppDimension.getHeight(context) / 7,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      borderColor: naturalGreyColor.withOpacity(0.3),
                      elevation: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          detailItem(
                              lable: 'Name',
                              value: packageActivity?.packageName
                                      .toString()
                                      .capitalizeFirstOfEach ??
                                  ''),
                          // detailItem(
                          //     lable: 'Total Price',
                          //     value: 'AED ${packageActivity?.totalPrice}'),
                          detailItem(
                              lable: 'No. Of Activities',
                              value: "${packageActivityList.length}"),
                          detailItem(
                              lable: 'Duration',
                              value:
                                  "${packageActivity?.noOfDays} Days / ${int.parse(packageActivity?.noOfDays ?? '') - 1} Nights"),
                          detailItem(
                              lable: 'Country',
                              value:
                                  "${packageActivity?.location} ${packageActivity?.country} ${packageActivity?.state}"),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CommonContainer(
                      borderReq: false,
                      borderRadius: BorderRadius.circular(0),
                      color: bgGreyColor,
                      borderColor: btnColor,
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextWidget(
                              sideLogo: true,
                              content: "Activity Details",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              textColor: textColor),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: packageActivityList.length,
                            itemBuilder: (context, index) {
                              final acticityImage = packageActivityList[index]
                                  .activity
                                  ?.activityImageUrl;

                              for (var activity in packageActivityList) {
                                List<String> activityParticipantTypes =
                                    activity.activity?.participantType ??
                                        [].map((e) => e.toString()).toList();
                                allParticipantTypes
                                    .addAll(activityParticipantTypes);
                              }

                              // Remove duplicates if needed
                              allParticipantTypes =
                                  allParticipantTypes.toSet().toList();
                              sutableFor = packageActivityList
                                  .expand((activity) =>
                                      activity.activity?.participantType ??
                                      []
                                          .map((type) => type.toString())
                                          .toList())
                                  .toSet()
                                  .toList();

                              debugPrint(
                                  'pdsubdsndbchdcbnmxcb.....$allParticipantTypes');
                              debugPrint(
                                  'pdsubdsndbchdcbnmxcb..222...$sutableFor');
                              return ActivityContainer(
                                days: packageActivityList[index].day == "null"
                                    ? "Activity ${index + 1}"
                                    : "Activity ${packageActivityList[index].day}",
                                actyImage: List.generate(
                                    acticityImage?.length ?? 0,
                                    (index) => acticityImage![index]),
                                activityName: packageActivityList[index]
                                        .activity
                                        ?.activityName ??
                                    '',
                                description: packageActivityList[index]
                                        .activity
                                        ?.description ??
                                    '',
                                activityHour: packageActivityList[index]
                                        .activity
                                        ?.activityHours
                                        .toString() ??
                                    '',
                                activityVisit: packageActivityList[index]
                                        .activity
                                        ?.bestTimeToVisit ??
                                    "",
                                openTime: packageActivityList[index]
                                        .activity
                                        ?.startTime ??
                                    "",
                                closeTime: packageActivityList[index]
                                        .activity
                                        ?.endTime ??
                                    '',
                                suitableFor: packageActivityList[index]
                                        .activity
                                        ?.participantType ??
                                    [].map((e) => e.toString()).toList(),
                                address: packageActivityList[index]
                                        .activity
                                        ?.address ??
                                    "",
                                activityPrice: packageActivityList[index]
                                        .activity
                                        ?.activityPrice ??
                                    0,
                                discountPrice: packageActivityList[index]
                                        .activity
                                        ?.discountedAmount ??
                                    0,
                                activityDiscountPer: packageActivityList[index]
                                        .activity
                                        ?.activityOfferMapping
                                        ?.offer
                                        ?.discountPercentage ??
                                    0,
                                infantDiscount: packageActivityList[index]
                                        .activity
                                        ?.ageGroupDiscountPercent
                                        ?.infant ??
                                    0,
                                childDiscount: packageActivityList[index]
                                        .activity
                                        ?.ageGroupDiscountPercent
                                        ?.child ??
                                    0,
                                seniorDiscount: packageActivityList[index]
                                        .activity
                                        ?.ageGroupDiscountPercent
                                        ?.senior ??
                                    0,
                                activityOfferDate: packageActivityList[index]
                                    .activity
                                    ?.activityOfferMapping
                                    ?.startDate,
                                activityStatus: packageActivityList[index]
                                    .activity
                                    ?.activityOfferMapping
                                    ?.status,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ///Package Total Booking Container
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      // TextSpan(
                      //     text: "AED ",
                      //     style: GoogleFonts.lato(
                      //       color: background,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //     )),
                      //Total Amt
                      (packageActivity?.totalPrice ==
                              packageActivity?.packageDiscountedAmount)
                          ? TextSpan()
                          : TextSpan(
                              text:
                                  "AED ${packageActivity?.totalPrice?.round()}",
                              style: GoogleFonts.lato(
                            color: background,
                                  fontSize: (packageActivity
                                                  ?.packageDiscountedAmount ==
                                              null ||
                                          packageActivity
                                                  ?.packageDiscountedAmount ==
                                              0)
                                      ? 20
                                      : 16,
                            fontWeight: FontWeight.w600,
                                  decoration: (packageActivity
                                                  ?.packageDiscountedAmount ==
                                              null ||
                                          packageActivity
                                                  ?.packageDiscountedAmount ==
                                              0)
                                      ? null
                                      : TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                  decorationColor: btnColor),
                            ),
                      (packageActivity?.packageDiscountedAmount == null ||
                              packageActivity?.packageDiscountedAmount == 0)
                          ? const TextSpan()
                          : const TextSpan(text: '\n'),
                      (packageActivity?.packageDiscountedAmount == null ||
                              packageActivity?.packageDiscountedAmount == 0)
                          ? const TextSpan()
                          : TextSpan(
                              text:
                                  "AED ${packageActivity?.packageDiscountedAmount?.round()}",
                              style: GoogleFonts.lato(
                                color: background,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      TextSpan(
                        text: " / Person",
                        style: GoogleFonts.lato(
                          color: background,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ])),
                    CustomButtonSmall(
                      width: 155,
                      height: 40,
                      borderRadius: BorderRadius.circular(5),
                      btnHeading: "BOOK PACKAGE",
                      onTap: () =>
                          // context.push('/package/packageMember')
                          context.push("/package/packageBookingMember", extra: {
                        "pkgID": widget.packageId,
                        "usrID": widget.userId,
                        "amt": packageActivity?.totalPrice,
                        "bookDate": widget.bookDate,
                        "participantTypes": allParticipantTypes,
                        "activityList": packageActivityList
                      }),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  detailItem({required String lable, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CustomText(
              align: TextAlign.start,
              content: lable,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              textColor: textColor),
        ),
        const Text(
          ':',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: CustomText(
              content: value,
              align: TextAlign.start,
              fontSize: 15,
              maxline: 3,
              fontWeight: FontWeight.w400,
              textColor: textColor),
        )
      ],
    );
  }
}

class ActivityContainer extends StatefulWidget {
  final List<String> actyImage;
  final String days;
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
  final bool? activityStatus;
  final String? activityOfferDate;
  const ActivityContainer(
      {required this.actyImage,
      required this.days,
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
      this.activityStatus,
      this.activityOfferDate,
      super.key});

  @override
  State<ActivityContainer> createState() => _ActivityContainerState();
}

class _ActivityContainerState extends State<ActivityContainer> {
  DateTime _dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd-MM-yyyy').format(_dateTime);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CommonContainer(
        borderReq: true,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderColor: naturalGreyColor.withOpacity(.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
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
            widget.suitableFor.isNotEmpty
                ? const SizedBox(height: 10)
                : const SizedBox(),
            widget.suitableFor.isNotEmpty
                ? RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Suitable For : ",
                          style: titleText),
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
                  TextSpan(
                      text: "Location : ", style: titleText),
                  TextSpan(
                      text: widget.address.capitalizeFirstOfEach,
                      style: valueText)
                ])),
            const SizedBox(height: 5),
            Row(
              children: [
                widget.activityStatus == false
                    ? const SizedBox.shrink()
                    : (DateFormat("dd-MM-yyyy").parse(
                                    widget.activityOfferDate ?? "01-01-2000") ==
                                _dateTime ||
                            (DateFormat("dd-MM-yyyy")
                                .parse(widget.activityOfferDate ?? "01-01-2000")
                                .isBefore(DateTime.now())))
                        ? (widget.activityDiscountPer == null ||
                                widget.activityDiscountPer == 0)
                            ? const SizedBox.shrink()
                            : Text(
                                '${widget.activityDiscountPer?.round()} % OFF',
                                style: offText,
                              )
                        : const SizedBox.shrink(),
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

  discountTile({required String lable, required String value}) {
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

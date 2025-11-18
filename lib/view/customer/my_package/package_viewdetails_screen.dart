// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/get_package_details_by_id_model.dart';
// import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/widgets/activity_container.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/widgets/custom_container.dart';
import 'package:flutter_cab/widgets/custom_text_widget.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/extensions/string_extenstion.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PackageDetails extends StatefulWidget {
  final String packageId;
  final String userId;
  final String bookDate;
  final String venderId;
  const PackageDetails(
      {super.key,
      required this.packageId,
      required this.userId,
      required this.bookDate,
      required this.venderId});

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
      body: PageLayoutPage(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  children: [
                    const SizedBox(height: 10),
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
                                            ?.status ==
                                        true
                                    ? 'Active'
                                    : "Inactive",
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
                      (packageActivity?.totalPrice ==
                              packageActivity?.packageDiscountedAmount)
                          ? const TextSpan()
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
                        "activityList": packageActivityList,
                        "venderId": widget.venderId
                      }),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

Widget detailItem({required String lable, required String value}) {
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

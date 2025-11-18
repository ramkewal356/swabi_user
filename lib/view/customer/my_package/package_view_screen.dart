import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_viewmore_viewless.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/widgets/custom_container.dart';
import 'package:flutter_cab/widgets/custom_text_widget.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/extensions/string_extenstion.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PackageViewScreen extends StatefulWidget {
  final String packageId;
  final String userType;
  final String userId;
  final String bookingDate;
  const PackageViewScreen(
      {super.key,
      required this.packageId,
      required this.userType,
      required this.userId,
      required this.bookingDate});

  @override
  State<PackageViewScreen> createState() => _PackageViewScreenState();
}

class _PackageViewScreenState extends State<PackageViewScreen> {
  List<String> allParticipantTypes = [];
  List<String> sutableFor = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewPackage();
    });
  }

  void viewPackage() {
    context
        .read<GetPackageActivityByIdViewModel>()
        .getPackageByIdApi(packageId: widget.packageId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('cvbnxm,c,vcx ${widget.userType}');
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text('Package View'),
      ),
      body: Consumer<GetPackageActivityByIdViewModel>(
        builder: (context, value, child) {
          if (value.getPackageActivityById.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: greenColor,
              ),
            );
          } else {
            var packageData = value.getPackageActivityById.data?.data;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  //package details
                  const CustomTextWidget(
                      sideLogo: true,
                      content: "Package Details",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      textColor: textColor),
                  Divider(
                    color: btnColor,
                  ),
                  CommonContainer(
                    elevation: 0,
                    borderReq: true,
                    // color: naturalGreyColor.withOpacity(.4),
                    borderRadius: BorderRadius.circular(10),
                    height: AppDimension.getHeight(context) / 4,
                    child: MultiImageSlider(
                      images: (packageData?.packageActivities
                              ?.expand(
                                  (e) => e.activity?.activityImageUrl ?? [])
                              .map((url) => url.toString())
                              .toList()) ??
                          [],
                    ),
                  ),
                  SizedBox(height: 10),
                  CommonContainer(
                    borderReq: true,
                    // height: AppDimension.getHeight(context) / 7,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    // ignore: deprecated_member_use
                    borderColor: naturalGreyColor.withOpacity(0.3),
                    elevation: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        widget.userType == 'Customer'
                            ? SizedBox.shrink()
                            : detailItem(
                                lable: 'Package Id',
                                value: packageData?.packageId.toString() ?? ''),
                        detailItem(
                            lable: 'Name',
                            value: packageData?.packageName
                                    .toString()
                                    .capitalizeFirstOfEach ??
                                ''),
                        detailItem(
                            lable: 'No. Of Activities',
                            value: "${packageData?.packageActivities?.length}"),
                        detailItem(
                            lable: 'Duration',
                            value:
                                "${packageData?.noOfDays} Days / ${int.tryParse(packageData?.noOfDays ?? '') ?? 0 - 1} Nights"),
                        detailItem(
                            lable: 'Country',
                            value:
                                "${packageData?.location} ${packageData?.country} ${packageData?.state}"),
                        widget.userType == 'Customer'
                            ? SizedBox.shrink()
                            : detailItem(
                                lable: 'Created Date',
                                value: dateFormat(packageData?.createdDate)),
                        widget.userType == 'Customer'
                            ? SizedBox.shrink()
                            : detailItem(
                                lable: 'Updated Date',
                                value: dateFormat(packageData?.modifiedDate)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.userType == 'Customer'
                                ? SizedBox.shrink()
                                : Chip(
                                    backgroundColor:
                                        packageData?.packageStatus == 'TRUE'
                                            ? greenColor
                                            : redColor,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    label: Text(
                                      packageData?.packageStatus == 'TRUE'
                                          ? 'ACTIVE'
                                          : "INACTIVE",
                                      style: subtitleTextStyle,
                                    )),
                            Spacer(),
                            packageData?.totalPrice == null
                                ? const SizedBox.shrink()
                                : Text(
                                    'AED ${packageData?.totalPrice?.round()}',
                                    style: (packageData
                                                    ?.packageDiscountedAmount ==
                                                null ||
                                            packageData
                                                    ?.packageDiscountedAmount ==
                                                0)
                                        ? buttonText
                                        : TextStyle(
                                            decoration: (packageData
                                                            ?.packageDiscountedAmount ==
                                                        null ||
                                                    packageData
                                                            ?.packageDiscountedAmount ==
                                                        0)
                                                ? null
                                                : TextDecoration.lineThrough,
                                            decorationThickness: 2,
                                            decorationColor: btnColor),
                                  ),
                            const SizedBox(width: 5),
                            (packageData?.packageDiscountedAmount == null ||
                                    packageData?.packageDiscountedAmount == 0)
                                ? const SizedBox.shrink()
                                : Text(
                                    'AED ${packageData?.packageDiscountedAmount?.round()}',
                                    style: buttonText,
                                  )
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //Activity details
                  const CustomTextWidget(
                      sideLogo: true,
                      content: "Activity Details",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      textColor: textColor),
                  Divider(
                    color: btnColor,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: packageData?.packageActivities?.length ?? 0,
                    itemBuilder: (context, index) {
                      var activityData = packageData?.packageActivities?[index];
                      allParticipantTypes = activityData
                              ?.activity?.participantType
                              ?.map((e) => e.toString())
                              .toList() ??
                          [];
                      // for (var activity in packageData?.packageActivities??[]) {
                      //   List<String> activityParticipantTypes =
                      //       activity.activity?.participantType ??
                      //           [].map((e) => e.toString()).toList();
                      //   allParticipantTypes.addAll(activityParticipantTypes);
                      // }

                      // // Remove duplicates if needed
                      // allParticipantTypes =
                      //     allParticipantTypes.toSet().toList();
                      // sutableFor = packageData?.packageActivities
                      //         ?.expand((activity) =>
                      //             activity.activity?.participantType ??
                      //             [].map((type) => type.toString()).toList())
                      //         .toSet()
                      //         .toList() ??
                      //     [];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CommonContainer(
                          borderReq: true,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          // ignore: deprecated_member_use
                          borderColor: naturalGreyColor.withOpacity(.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonContainer(
                                elevation: 0,
                                height: 220,
                                borderRadius: BorderRadius.circular(10),
                                child: MultiImageSlider(
                                  images: activityData
                                          ?.activity?.activityImageUrl ??
                                      [],
                                ),
                              ),
                              const SizedBox(height: 5),
                              CustomText(
                                align: TextAlign.start,
                                content:
                                    activityData?.activity?.activityName ?? '',
                                maxline: 3,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                textColor: btnColor,
                              ),
                              const SizedBox(height: 5),
                              CustomViewmoreViewless(
                                  moreText: activityData?.activity?.description
                                          ?.replaceAll(RegExp(r'\s+'), '') ??
                                      ""),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: textItem(
                                        lable: 'Activity Hours',
                                        value:
                                            '${activityData?.activity?.activityHours}'),
                                  ),
                                  Expanded(
                                    child: textItem(
                                        lable: 'Time To Visit',
                                        value: activityData
                                                ?.activity?.bestTimeToVisit ??
                                            ''),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: textItem(
                                        lable: 'Opening Time',
                                        value:
                                            '${activityData?.activity?.startTime}'),
                                  ),
                                  Expanded(
                                    child: textItem(
                                        lable: 'Closing Time',
                                        value:
                                            activityData?.activity?.endTime ??
                                                ''),
                                  )
                                ],
                              ),
                              activityData?.activity?.participantType
                                          ?.contains('SENIOR') ==
                                      true
                                  ? textItem(
                                      lable: 'Senior Discount',
                                      value: (activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.senior ==
                                                  null ||
                                              activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.senior ==
                                                  0)
                                          ? 'No Discount'
                                          : activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.senior ==
                                                  100
                                              ? 'Free'
                                              : '${activityData?.activity?.ageGroupDiscountPercent?.senior?.round()} %')
                                  : const SizedBox.shrink(),
                              activityData?.activity?.participantType
                                          ?.contains('CHILD') ==
                                      true
                                  ? textItem(
                                      lable: 'Child Discount',
                                      value: (activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.child ==
                                                  null ||
                                              activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.child ==
                                                  0)
                                          ? 'No Discount'
                                          : activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.child ==
                                                  100
                                              ? 'Free'
                                              : '${activityData?.activity?.ageGroupDiscountPercent?.child?.round()} %')
                                  : const SizedBox.shrink(),
                              activityData?.activity?.participantType
                                          ?.contains('INFANT') ==
                                      true
                                  ? textItem(
                                      lable: 'Infant Discount',
                                      value: (activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.infant ==
                                                  null ||
                                              activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.infant ==
                                                  0)
                                          ? 'No Discount'
                                          : activityData
                                                      ?.activity
                                                      ?.ageGroupDiscountPercent
                                                      ?.infant ==
                                                  100
                                              ? 'Free'
                                              : '${activityData?.activity?.ageGroupDiscountPercent?.infant?.round()} %')
                                  : const SizedBox.shrink(),
                              textItem(
                                  lable: 'Suitable For',
                                  value: activityData?.activity?.participantType
                                          ?.join(',') ??
                                      ""),
                              textItem(
                                  lable: 'Location',
                                  value: activityData?.activity?.address ?? ""),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.userType == 'Customer'
                                      ? SizedBox.shrink()
                                      : Chip(
                                          backgroundColor: activityData
                                                      ?.activity
                                                      ?.activityStatus ==
                                                  'TRUE'
                                              ? greenColor
                                              : redColor,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                          label: Text(
                                            activityData?.activity
                                                        ?.activityStatus ==
                                                    'TRUE'
                                                ? 'ACTIVE'
                                                : "INACTIVE",
                                            style: subtitleTextStyle,
                                          )),
                                  Spacer(),
                                  activityData?.activity?.activityPrice == null
                                      ? const SizedBox.shrink()
                                      : Text(
                                          'AED ${activityData?.activity?.activityPrice?.round()}',
                                          style: (activityData?.activity
                                                          ?.discountedAmount ==
                                                      null ||
                                                  activityData?.activity
                                                          ?.discountedAmount ==
                                                      0)
                                              ? buttonText
                                              : TextStyle(
                                                  decoration: (activityData
                                                                  ?.activity
                                                                  ?.discountedAmount ==
                                                              null ||
                                                          activityData?.activity
                                                                  ?.discountedAmount ==
                                                              0)
                                                      ? null
                                                      : TextDecoration
                                                          .lineThrough,
                                                  decorationThickness: 2,
                                                  decorationColor: btnColor),
                                        ),
                                  const SizedBox(width: 5),
                                  (activityData?.activity?.discountedAmount ==
                                              null ||
                                          activityData?.activity
                                                  ?.discountedAmount ==
                                              0)
                                      ? const SizedBox.shrink()
                                      : Text(
                                          'AED ${activityData?.activity?.discountedAmount?.round()}',
                                          style: buttonText,
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  widget.userType == 'Customer'
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                (packageData?.totalPrice ==
                                        packageData?.packageDiscountedAmount)
                                    ? const TextSpan()
                                    : TextSpan(
                                        text:
                                            "AED ${packageData?.totalPrice?.round()}",
                                        style: GoogleFonts.lato(
                                            color: background,
                                            fontSize: (packageData
                                                            ?.packageDiscountedAmount ==
                                                        null ||
                                                    packageData
                                                            ?.packageDiscountedAmount ==
                                                        0)
                                                ? 20
                                                : 16,
                                            fontWeight: FontWeight.w600,
                                            decoration: (packageData
                                                            ?.packageDiscountedAmount ==
                                                        null ||
                                                    packageData
                                                            ?.packageDiscountedAmount ==
                                                        0)
                                                ? null
                                                : TextDecoration.lineThrough,
                                            decorationThickness: 2,
                                            decorationColor: btnColor),
                                      ),
                                (packageData?.packageDiscountedAmount == null ||
                                        packageData?.packageDiscountedAmount ==
                                            0)
                                    ? const TextSpan()
                                    : const TextSpan(text: '\n'),
                                (packageData?.packageDiscountedAmount == null ||
                                        packageData?.packageDiscountedAmount ==
                                            0)
                                    ? const TextSpan()
                                    : TextSpan(
                                        text:
                                            "AED ${packageData?.packageDiscountedAmount?.round()}",
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
                                    context.push(
                                        "/package/packageBookingMember",
                                        extra: {
                                      "pkgID": widget.packageId,
                                      "usrID": widget.userId,
                                      "amt": packageData?.totalPrice,
                                      "bookDate": widget.bookingDate,
                                      "participantTypes": allParticipantTypes,
                                      "activityList":
                                          packageData?.packageActivities,
                                      "venderId": packageData?.vendor?.vendorId
                                          .toString()
                                    }),
                              )
                            ],
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            );
          }
        },
      ),
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

  Widget textItem({required String lable, required String value}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,

      crossAxisAlignment: CrossAxisAlignment.center,
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
        Expanded(
          child: Text(
            value,
            style: valueText,
          ),
        )
      ],
    );
  }
}

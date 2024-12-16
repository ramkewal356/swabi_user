

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cab/model/get_issue_by_booking_id_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/model/payment_details_model.dart';
import 'package:flutter_cab/model/payment_refund_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_viewmore_viewless.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_raise_issue_form.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/string_extenstion.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view/dashboard/rental/cancel_booking.dart';
import 'package:flutter_cab/view/dashboard/tourPackage/package_viewdetails_screen.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:marqueer/marqueer.dart';
import 'package:provider/provider.dart';
import '../../../../view_model/package_view_model.dart';

class PackagePageViewDetails extends StatefulWidget {
  final String userId;
  final String packageBookID;
  final String paymentId;
  const PackagePageViewDetails(
      {super.key,
      required this.userId,
      required this.packageBookID,
      required this.paymentId});

  @override
  State<PackagePageViewDetails> createState() => _PackagePageViewDetailsState();
}

class _PackagePageViewDetailsState extends State<PackagePageViewDetails> {
  TextEditingController cancelController = TextEditingController();
  TextEditingController alertController = TextEditingController();
  GetIssueByBookingIdModel? getIssueByBookingId;
  bool loading = false;
  int? day;
  PaymentDetailsModel? paymentDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GetPackageItineraryViewModel>(context, listen: false)
          .fetchGetPackageItineraryViewModelApi(
              context, {"packageBookingId": widget.packageBookID});
      getPaymentDetail();
      Provider.of<RaiseissueViewModel>(context, listen: false)
          .getIssueByBookingId(
              context: context,
              bookingId: widget.packageBookID,
              userId: widget.userId,
              bookingType: 'PACKAGE_BOOKING');
      // Provider.of<GetPaymentRefundViewModel>(context, listen: false)
      //     .getPaymentRefundApi(context: context, paymentId: widget.paymentId);
    });
    // day = detailsData.bookingDate * pkgDetails.noOfDays;
  }

  Future<void> getPaymentDetail() async {
    await Provider.of<RentalPaymentDetailsViewModel>(context, listen: false)
        .rentalPaymentDetail(context: context, paymentId: widget.paymentId)
        .then((onValue) {
      if (onValue?.status?.httpCode == '200') {
        setState(() {
          paymentDetails = onValue;
        });
      }
    });
  }

  var detailsData, pkgDetails, userDetails, dataPackage;
  List<PackageHIstoryDetailsMemberList> memberListDetails = [];
  List<PackageHIstoryDetailsPackageActivity> packageHistoryActivityList = [];
  List<AssignedDriverOnPackageBooking> packageDriverDetails = [];
  List<AssignedVehicleOnPackageBooking> packageVehicleDetail = [];
  List<String> packageImage = [];
  FocusNode? focusNode;
  ////GetPackageItinerary
  var getPackageItinerary;
  String? selectedText;
  List<ItineraryDetail> getPackageItineraryList = [];
  @override
  void dispose() {
    // TODO: implement dispose
    cancelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var httpStatus = context
        .watch<GetPackageHistoryDetailByIdViewModel>()
        .getPackageHistoryDetailById
        .status
        .toString();

    if (httpStatus == "Status.completed") {
      detailsData = context
              .watch<GetPackageHistoryDetailByIdViewModel>()
              .getPackageHistoryDetailById
              .data
              ?.data ??
          [];
      memberListDetails = context
              .watch<GetPackageHistoryDetailByIdViewModel>()
              .getPackageHistoryDetailById
              .data
              ?.data
              .memberList ??
          [];
      userDetails = context
              .watch<GetPackageHistoryDetailByIdViewModel>()
              .getPackageHistoryDetailById
              .data
              ?.data
              .user ??
          '';

      pkgDetails = context
          .watch<GetPackageHistoryDetailByIdViewModel>()
          .getPackageHistoryDetailById
          .data
          ?.data
          .pkg;

      packageHistoryActivityList = context
              .watch<GetPackageHistoryDetailByIdViewModel>()
              .getPackageHistoryDetailById
              .data
              ?.data
              .pkg
              .packageActivities ??
          [];
      packageImage = context
              .watch<GetPackageHistoryDetailByIdViewModel>()
              .getPackageHistoryDetailById
              .data
              ?.data
              .pkg
              .packageActivities
              .expand((e) => e.activity.activityImageUrl)
              .toList() ??
          [];
      packageDriverDetails = context
              .watch<GetPackageHistoryDetailByIdViewModel>()
              .getPackageHistoryDetailById
              .data
              ?.data
              .assignedDriverOnPackageBookings ??
          [];
      packageVehicleDetail = context
              .watch<GetPackageHistoryDetailByIdViewModel>()
              .getPackageHistoryDetailById
              .data
              ?.data
              .assignedVehicleOnPackageBookings ??
          [];
    }

    getPackageItineraryList = context
            .watch<GetPackageItineraryViewModel>()
            .getPackageItineraryList
            .data
            ?.data
            ?.itineraryDetails ??
        [];
    getPackageItinerary = context
            .watch<GetPackageItineraryViewModel>()
            .getPackageItineraryList
            .data
            ?.data
            ?.packageBookingId ??
        '';
    getIssueByBookingId =
        context.watch<RaiseissueViewModel>().getIssueBybookingId.data;
    // debugPrint("${getPackageItineraryList.length} GetItineraryDetailsList");
    debugPrint("${widget.paymentId} paymentId......ramji");

    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Booking Details",
      ),
      body: PageLayout_Page(
          // onRefresh: () async {
          //   await Provider.of<GetPackageHistoryDetailByIdViewModel>(
          //       context,
          //       listen: false)
          //       .fetchGetPackageHistoryDetailByIdViewModelApi(
          //       context,
          //       {
          //         "packageBookingId": widget.packageBookID
          //       },
          //       widget.userId,
          //       widget.packageBookID);
          // },
          child: ListView(
        children: [
          detailsData != []
              ? PackageDetailsContainer(
                  getIssueByBookingId: getIssueByBookingId,
                  id: widget.packageBookID,
                  pkgImage: packageImage,
                  packageName: pkgDetails.packageName,
                  bookingStatus: detailsData.bookingStatus,
                  location: pkgDetails.location,
                  primaryCountryCode: detailsData.countryCode,
                  primaryMobileNo: detailsData.mobile,
                  secondaryCountryCode: detailsData.alternateMobileCountryCode,
                  secondaryMobileNo: detailsData.alternateMobile,
                  country: pkgDetails.country,
                  startTime: detailsData.bookingDate,
                  endTime: detailsData.endDate,
                  totalMembers: memberListDetails.length.toString(),
                  days: pkgDetails.noOfDays,
                  cancelReason: detailsData.cancellationReason,
                  cancelledBy: detailsData.cancelledBy,
                  pickUpLocation: detailsData.pickupLocation,
                  controllerWidget: alertController,
                  taxAmount: detailsData.taxAmount,
                  discountAmount: detailsData.discountAmount,
                  packageAmount: detailsData.packagePrice,
                  iteneryList: getPackageItineraryList,

                  alertOnTap: () {
                    Provider.of<AddPickUpLocationPackageViewModel>(context,
                            listen: false)
                        .fetchAddPickUpLocationPackageViewModelApi(
                            context,
                            {
                              "packageBookingId": widget.packageBookID,
                              "pickupLocation": alertController.text
                            },
                            widget.packageBookID);
                   
                  },
                 
                  totalAmt: detailsData.totalPayableAmount,
                  paymentDetails: paymentDetails,
                  memberList: List.generate(
                      memberListDetails.length,
                      (index) => PackageHIstoryDetailsMemberList(
                          memberId: memberListDetails[index].memberId,
                          name: memberListDetails[index].name,
                          ageUnit: memberListDetails[index].ageUnit,
                          age: memberListDetails[index].age,
                          gender: memberListDetails[index].gender)),
                  driverDetails: List.generate(
                      packageDriverDetails.length,
                      (index) => AssignedDriverOnPackageBooking(
                          date: packageDriverDetails[index].date,
                          driverAssignedId: "",
                          isCancelled: false,
                          driver: Driver(
                              driverId:
                                  packageDriverDetails[index].driverAssignedId,
                              firstName:
                                  packageDriverDetails[index].driver.firstName,
                              lastName:
                                  packageDriverDetails[index].driver.lastName,
                              driverAddress: "",
                              emiratesId: "",
                              mobile: packageDriverDetails[index].driver.mobile,
                              countryCode: "",
                              email: "",
                              gender: packageDriverDetails[index].driver.gender,
                              licenceNumber: "",
                              createdDate: "",
                              modifiedDate: "",
                              profileImageUrl: "",
                              userType: "",
                              vendorId: "",
                              driverStatus: ""))),
                  vehicleDetails: List.generate(
                      packageVehicleDetail.length,
                      (index) => AssignedVehicleOnPackageBooking(
                            vehicle: Vehicle(
                                vehicleId: "",
                                carName:
                                    packageVehicleDetail[index].vehicle.carName,
                                year: "",
                                carType: "",
                                brandName: "",
                                fuelType: "",
                                seats: "",
                                color: "",
                                vehicleNumber: packageVehicleDetail[index]
                                    .vehicle
                                    .vehicleNumber,
                                modelNo: "",
                                createdDate: "",
                                modifiedDate: "",
                                images: [],
                                vehicleStatus: ""),
                            date: packageVehicleDetail[index].date,
                            assignedId: "",
                            isCancelled: false,
                          )),

                  ///Activity Details List
                  child: getPackageItineraryList.isNotEmpty
                      ? ItineraryActivityContainer(
                          itineraryDataList: getPackageItineraryList.isNotEmpty
                              ? getPackageItineraryList
                              : packageHistoryActivityList,
                          isPackageItinerary:
                              getPackageItineraryList.isNotEmpty,
                        )

                     
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: packageHistoryActivityList.length,
                          itemBuilder: (context, index) {
                            final data = packageHistoryActivityList[index];
                            final List image = packageHistoryActivityList[index]
                                .activity
                                .activityImageUrl;
                            return ActivityContainer(
                              days:
                                  "Activity ${data.day == "null" ? index + 1 : data.day}",
                              actyImage: List.generate(
                                  image.length, (index) => image[index]),
                              activityName: data.activity.activityName,
                              description: data.activity.description,
                              activityHour: data.activity.activityHours,
                              activityVisit: data.activity.bestTimeToVisit,
                              openTime: data.activity.startTime,
                              closeTime: data.activity.endTime,
                              suitableFor: data.activity.participantType,
                              address: data.activity.address,
                              // activityPrice: data.activity.activityPrice ?? "",
                              // discountPrice:
                              //     data.activity.discountedAmount ?? 0,
                            );
                          },
                        ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        backgroundColor: background,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context)
                                  .viewInsets
                                  .bottom, // Adjust modal size when keyboard opens
                            ),
                            child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setstate) {
                                  bool cancelStatus = context
                                      .watch<PackageCancelViewModel>()
                                      .isLoading;
                                  return CancelContainerDialog(
                                    loading: cancelStatus,
                                    controllerCancel: cancelController,
                                    onTap: () async {
                                      await Provider.of<PackageCancelViewModel>(
                                              context,
                                              listen: false)
                                          .fetchPackageCancelViewModelApi(
                                              context,
                                              {
                                                "packageBookingId":
                                                    widget.packageBookID,
                                                "cancellationReason":
                                                    cancelController.text,
                                                "cancelledBy": "USER"
                                              },
                                              widget.userId,
                                              widget.packageBookID,
                                              widget.paymentId);

                                      // controller.dispose();
                                    },
                                  );
                                })),
                          );
                        });
                  },
                )
              : const SizedBox()
        ],
      )),
    );
  }
}

class PackageDetailsContainer extends StatefulWidget {
  final GetIssueByBookingIdModel? getIssueByBookingId;
  final String id;
  final String bookingStatus;
  final String packageName;
  final String location;
  final List<String> pkgImage;
  final String startTime;
  final TextEditingController controllerWidget;
  final VoidCallback? alertOnTap;
  final String endTime;
  final String totalMembers;
  final String totalAmt;
  final String primaryCountryCode;
  final String primaryMobileNo;
  final String secondaryCountryCode;
  final String secondaryMobileNo;
  final String country;
  final String pickUpLocation;
  final String days;
  final String cancelReason;
  final String cancelledBy;
  final Widget child;
  final List<PackageHIstoryDetailsMemberList> memberList;
  final List<AssignedVehicleOnPackageBooking> vehicleDetails;
  final List<AssignedDriverOnPackageBooking> driverDetails;
  final List<ItineraryDetail> iteneryList;
  final PaymentDetailsModel? paymentDetails;
  final VoidCallback? onTap;
  final String packageAmount;
  final String taxAmount;
  final String discountAmount;

  const PackageDetailsContainer(
      {super.key,
      required this.getIssueByBookingId,
      required this.id,
      required this.bookingStatus,
      this.onTap,
      required this.packageName,
      required this.location,
      required this.pkgImage,
      required this.child,
      required this.pickUpLocation,
      required this.controllerWidget,
      this.alertOnTap,
      required this.totalAmt,
      required this.primaryCountryCode,
      required this.primaryMobileNo,
      required this.secondaryCountryCode,
      required this.secondaryMobileNo,
      required this.country,
      required this.startTime,
      required this.endTime,
      required this.totalMembers,
      required this.cancelReason,
      required this.cancelledBy,
      required this.memberList,
      required this.vehicleDetails,
      required this.driverDetails,
      required this.paymentDetails,
      required this.iteneryList,
      required this.packageAmount,
      required this.taxAmount,
      required this.discountAmount,
      required this.days});

  @override
  State<PackageDetailsContainer> createState() =>
      _PackageDetailsContainerState();
}

class _PackageDetailsContainerState extends State<PackageDetailsContainer> {
  String apiKey = 'AIzaSyADRdiTbSYUR8oc6-ryM1F1NDNjkHDr0Yo';
  String sourceLocation = "Source Location";
  double logitude = 0.0;
  double latitude = 0.0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController primaryController = TextEditingController();
  TextEditingController secondaryController = TextEditingController();
  String initialCountryCode = 'AE';
  PaymentRefundModel? paymentRefund;
  @override
  void initState() {
    super.initState();
    locationFocus.addListener(() {
      setState(() {
        // Rebuild to adjust padding when focus changes
      });
    });
  }

  Future<List<double>?> getCoordinates(String location) async {
    try {
      final places = GoogleMapsPlaces(
        apiKey: apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      var locations = await places
          .searchByText(location)
          .then((result) => result.results)
          .then((results) => results.map((result) => result.geometry!.location))
          .then((locations) => locations.toList());

      if (locations.isNotEmpty) {
        debugPrint("${locations.first.lat}Location");
        return [locations.first.lat, locations.first.lng];
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Error getting coordinates: $e");
      return [];
    }
  }

  String getIsoCode(String countryCode) {
    var list = countries
        .where(
            (code) => code.dialCode == countryCode.replaceAll('+', '').trim())
        .toList();
    String countryCode1 = '';
    if (list.isNotEmpty) {
      // controllers[4].text = list.first.dialCode;
      countryCode1 = list.first.code;

      debugPrint('isocode.................... ${list.first.code}');
    }
    return countryCode1;
  }

  /// Add memeber
  void _changeContact(
      {required String primaryCode,
      required String primaryNo,
      required String secondaryCode,
      required String secondaryNo}) {
    FocusNode focusNode2 = FocusNode();
    String primaryCountryCode = primaryCode;
    String secondaryCountryCode = secondaryCode;
    primaryController.text = primaryNo;
    secondaryController.text = secondaryNo;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setstate) {
          debugPrint('Country code on dialog open: $secondaryCountryCode');
          bool changeStatus = context.watch<ChangeMobileViewModel>().isLoading;
          return LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom, // Adjust modal size when keyboard opens
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Change Contact',
                              style: TextStyle(
                                  color: btnColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                                padding: const EdgeInsets.only(left: 15),
                                onPressed: () {
                                  context.pop();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: btnColor,
                                ))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Secondary Contact',
                                style: titleTextStyle),
                            const TextSpan(
                                text: ' *', style: TextStyle(color: redColor))
                          ])),
                        ),
                        CustomMobilenumber(
                            textLength: 9,
                            focusNode: focusNode2,
                            controller: secondaryController,
                            hintText: 'Enter phone number',
                            countryCode: secondaryCountryCode),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButtonSmall(
                          width: double.infinity,
                          height: 45,
                          loading: changeStatus,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              debugPrint('succes');
                              Map<String, dynamic> body = {
                                "packageBookingId": widget.id,
                                "mobile": primaryController.text,
                                // "countryCode": primaryCode,
                                "countryCode": primaryCountryCode,

                                "alternateMobile": secondaryController.text,
                                // "alternateMobileCountryCode": secondaryCode
                                "alternateMobileCountryCode":
                                    secondaryCountryCode
                              };
                              debugPrint(
                                  'bodyData....//////////////////////.$changeStatus');
                              Provider.of<ChangeMobileViewModel>(context,
                                      listen: false)
                                  .changeMobileApi(
                                      context: context,
                                      body: body,
                                      bookingId: widget.id);
                            }
                          },
                          btnHeading: "Submit",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
      },
    );
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    locationFocus.dispose(); // Dispose focus node to avoid memory leaks
    _scrollController.dispose();
    // widget.controllerWidget.dispose();
    super.dispose();
  }

  final marqueeController = MarqueerController();
  // bool isLoading = false;
  String? selectedText;
  FocusNode locationFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        (widget.paymentDetails?.data?.createdAt ?? 0) * 1000,
        isUtc: true);

    Duration offset = const Duration(hours: 5, minutes: 30);
    DateTime adjustedTime = dateTime.add(offset);

    String formattedTime =
        '${DateFormat('HH:mm').format(adjustedTime)} GMT (+05:30)';
    paymentRefund =
        context.watch<GetPaymentRefundViewModel>().getPaymentRefund.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonContainer(
            height: 220,
            elevation: 0,
            width: double.infinity,
            borderRadius: BorderRadius.circular(5),
            borderReq: true,
            borderColor: naturalGreyColor.withOpacity(0.3),
            child: MultiImageSlider(
              images: widget.pkgImage,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomTextWidget(
                content: "Booking Details",
                sideLogo: true,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              Row(
                children: [
                  Text(
                    'Price :',
                    style: titleTextStyle,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                        text: ' AED ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: '${double.tryParse(widget.totalAmt)?.round()}',
                        style: const TextStyle(
                            color: btnColor, fontWeight: FontWeight.w600))
                  ]))
                ],
              )
            ],
          ),
        ),

        ///Booking Details Container
        CommonContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          elevation: 0,
          borderRadius: BorderRadius.circular(5),
          borderReq: true,
          borderColor: naturalGreyColor.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CustomTextWidget(
                        content: "Booking Id : ",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomTextWidget(
                        content: widget.id,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CustomTextWidget(
                        content: "Status : ",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        height: 25,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        // width: 90,
                        decoration: BoxDecoration(
                            color: widget.bookingStatus == 'CANCELLED'
                                ? redColor
                                : greenColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                          widget.bookingStatus,
                          style: const TextStyle(color: background),
                        )),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              bookingItem(
                  lable: 'Package Name',
                  value: widget.packageName.capitalizeFirstOfEach),
              bookingItem(
                  lable: 'Numbers Of Member', value: widget.totalMembers),
              bookingItem(lable: 'Booking Start Date', value: widget.startTime),
              bookingItem(lable: 'Booking End Date', value: widget.endTime),
              contactTile(
                  title: 'Primary Contact',
                  value:
                      '+${widget.primaryCountryCode} ${widget.primaryMobileNo}',
                  iconButton: widget.bookingStatus == "BOOKED"
                      ? widget.secondaryMobileNo.isEmpty
                          ? InkWell(
                              onTap: () {
                                _changeContact(
                                    primaryCode: widget.primaryCountryCode,
                                    primaryNo: widget.primaryMobileNo,
                                    secondaryCode: '971',
                                    secondaryNo: widget.secondaryMobileNo);
                              },
                              child: const Icon(
                                Icons.add_call,
                                size: 20,
                                color: btnColor,
                                shadows: [
                                  BoxShadow(
                                      offset: Offset(
                                        1,
                                        2,
                                      ),
                                      color: greyColor1)
                                ],
                              ),
                            )
                          : const SizedBox.shrink()
                      : const SizedBox.shrink()),
              widget.bookingStatus == "BOOKED"
                  ? widget.secondaryMobileNo.isNotEmpty
                      // ? bookingItem(
                      //     lable: 'Secondary Contact',
                      //     value:
                      //         '+${widget.secondaryCountryCode} ${widget.secondaryMobileNo}')
                      ? contactTile(
                          title: 'Secondary Contact',
                          value:
                              '+${widget.secondaryCountryCode} ${widget.secondaryMobileNo}',
                          iconButton: InkWell(
                            onTap: () {
                              _changeContact(
                                  primaryCode: widget.primaryCountryCode,
                                  primaryNo: widget.primaryMobileNo,
                                  secondaryCode: '971',
                                  secondaryNo: widget.secondaryMobileNo);
                            },
                            child: const Icon(
                              Icons.border_color_outlined,
                              color: btnColor,
                              shadows: [
                                BoxShadow(
                                    offset: Offset(
                                      1,
                                      1,
                                    ),
                                    color: greyColor1)
                              ],
                            ),
                          ))
                      : const SizedBox()
                  : const SizedBox.shrink(),
              bookingItem(
                  lable: 'Duration',
                  value:
                      '${widget.days}Days / ${int.parse(widget.days) - 1}Nights'),
              bookingItem(lable: 'Country', value: widget.country),
              (widget.getIssueByBookingId?.data ?? []).isEmpty
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Created Issue',
                            style: titleTextStyle,
                          ),
                        ),
                        Text(':', style: titleTextStyle),

                        const SizedBox(width: 10),
                        Flexible(
                          child: GestureDetector(
                              onTap: () {
                                context.push("/raiseIssueDetail");
                              },
                              child: const Text(
                                'View Issue',
                                style: TextStyle(
                                    color: greenColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: greenColor,
                                    decorationThickness: 1.5),
                              )),
                        ),
                       
                      ],
                    ),
             
              contactTile(
                  title: 'Pickup Location',
                  value: widget.pickUpLocation.isEmpty
                      ? 'N/A'
                      : widget.pickUpLocation,
                  iconButton: widget.bookingStatus == "BOOKED"
                      ? widget.pickUpLocation != "N/A" &&
                              widget.pickUpLocation.isEmpty
                          ? InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isDismissible: false,
                                    backgroundColor: background,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom, // Adjust modal size when keyboard opens
                                        ),
                                        child: SingleChildScrollView(
                                          // physics:
                                          //     const NeverScrollableScrollPhysics(),
                                          child: StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setstate) {
                                            bool pickupstatus = context
                                                .watch<
                                                    AddPickUpLocationPackageViewModel>()
                                                .isLoading;
                                            return Container(
                                              margin: const EdgeInsets.all(20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Add PickUp Location',
                                                        style: TextStyle(
                                                            color: btnColor,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      IconButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 15),
                                                          onPressed: () {
                                                            context.pop();
                                                          },
                                                          icon: const Icon(
                                                            Icons.close,
                                                            color: btnColor,
                                                          ))
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text.rich(TextSpan(children: [
                                                    TextSpan(
                                                        text: 'Pickup Location',
                                                        style: titleTextStyle),
                                                    const TextSpan(
                                                        text: ' *',
                                                        style: TextStyle(
                                                            color: redColor))
                                                  ])),
                                                  const SizedBox(height: 5),
                                                  Form(
                                                    key: _formKey,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    child: CustomSearchLocation(
                                                        controller: widget
                                                            .controllerWidget,
                                                        state: '',
                                                        // stateValidation: false,
                                                        hintText:
                                                            'Search your location'),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  CustomButtonSmall(
                                                      height: 50,
                                                      loading: pickupstatus,
                                                      width: double.infinity,
                                                      btnHeading: "Submit",
                                                      onTap: () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          widget.alertOnTap
                                                              ?.call();
                                                        }
                                                      })
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    });
                              },
                              child: Material(
                                elevation: 2,
                                child: Image.asset(
                                  addLocation,
                                  height: 22,
                                  width: 22,
                                  color: btnColor,
                                  // filterQuality: FilterQuality.high,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                      : const SizedBox.shrink()),
              widget.bookingStatus == "CANCELLED"
                  ? bookingItem(
                      lable: 'Cancelled By', value: widget.cancelledBy)
                  : const SizedBox(),
              widget.bookingStatus == "CANCELLED"
                  ? bookingItem(
                      lable: 'Cancellation Reason', value: widget.cancelReason)
                  : const SizedBox(),
            ],
          ),
        ),
        widget.paymentDetails?.data != null
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CustomTextWidget(
                  content: "Payment Details",
                  fontSize: 20,
                  sideLogo: true,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Container(),
        widget.paymentDetails?.data != null
            ? CommonContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                elevation: 0,
                borderRadius: BorderRadius.circular(5),
                borderReq: true,
                borderColor: naturalGreyColor.withOpacity(0.3),
                child: Column(
                  children: [
                    textItem(
                        lable: 'Payment Id',
                        value: widget.paymentDetails?.data?.id ?? ''),
                    textItem(
                        lable: 'Package Amount',
                        value: 'AED ${widget.packageAmount}'),
                    textItem(
                        lable: 'Tax Amount (5%)',
                        value:
                            'AED ${double.parse(widget.taxAmount).toStringAsFixed(2)}'),
                    widget.discountAmount == '0.0'
                        ? const SizedBox()
                        : textItem(
                            lable: 'Discount Amount',
                            value: 'AED ${widget.discountAmount}'),
                    textItem(
                        lable: 'Total Amount',
                        value:
                            'AED ${double.parse(widget.paymentDetails?.data?.amount.toString() ?? '') / 100}'),
                    textItem(
                      lable: 'Payment Date',
                      value: DateFormat('dd-MM-yyyy').format(dateTime),
                    ),
                    textItem(lable: 'Payment Time', value: formattedTime)
                  ],
                ),
              )
            : Container(),
        paymentRefund?.data != null && widget.bookingStatus == "CANCELLED"
            ? const Padding(
                padding: EdgeInsets.only(top: 10),
                child: CustomTextWidget(
                  content: "Refund Details",
                  fontSize: 20,
                  sideLogo: true,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Container(),
        paymentRefund?.data != null && widget.bookingStatus == "CANCELLED"
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Refund will be processed within 5 working days.',
                  style:
                      TextStyle(color: btnColor, fontWeight: FontWeight.w600),
                ),
              )
            : const SizedBox.shrink(),
        paymentRefund?.data != null && widget.bookingStatus == "CANCELLED"
            ? CommonContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.infinity,
                elevation: 0,
                borderRadius: BorderRadius.circular(5),
                borderReq: true,
                borderColor: naturalGreyColor.withOpacity(0.3),
                child: Column(
                  children: [
                    textItem(
                        lable: 'Refund Amount',
                        value:
                            'AED ${paymentRefund?.data?.refundedAmount?.toStringAsFixed(2)}'),
                    textItem(
                        lable: 'Refund Status',
                        value: paymentRefund?.data?.refundStatus == 'created'
                            ? "PENDING"
                            : paymentRefund?.data?.refundStatus == 'processed'
                                ? "PROCESSED"
                                : '${paymentRefund?.data?.refundStatus}'),
                   
                  ],
                ),
              )
            : Container(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CustomTextWidget(
            content: "Travellers Details",
            fontSize: 20,
            sideLogo: true,
            fontWeight: FontWeight.w600,
          ),
        ),

        ///Members Details Container
        Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          radius: const Radius.circular(10),
          child: CommonContainer(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            width: double.infinity,
            elevation: 0,
            borderRadius: BorderRadius.circular(5),
            borderReq: true,
            borderColor: naturalGreyColor.withOpacity(0.3),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columnSpacing: 18,
                  headingRowHeight: 40,
                  dividerThickness: 0,
                  dataTextStyle: titleTextStyle1,
                  columns: const [
                    DataColumn(
                        label: CustomTextWidget(
                      content: "Id",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )),
                    DataColumn(
                        label: SizedBox(
                            // width: 60,
                            child: CustomTextWidget(
                                content: "Name",
                                fontSize: 18,
                                fontWeight: FontWeight.w700))),
                    DataColumn(
                        label: CustomTextWidget(
                            content: "Age",
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    DataColumn(
                        label: CustomTextWidget(
                            content: "Type",
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    DataColumn(
                        label: CustomTextWidget(
                            content: "Gender",
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                  ],
                  rows: widget.memberList
                      .map((PackageHIstoryDetailsMemberList members) => DataRow(
                            cells: [
                              DataCell(CustomText(
                                content: members.memberId.toString(),
                                textEllipsis: true,
                              )),
                              DataCell(SizedBox(
                                  // width: 60,
                                  child: CustomText(
                                      // maxline: 2,
                                      textLenght: 20,
                                      needTextLenght: true,
                                      align: TextAlign.start,
                                      textEllipsis: true,
                                      content: utf8.decode(
                                          members.name.runes.toList())))),
                              DataCell(CustomText(
                                  content:
                                      '${members.age} ${members.ageUnit}')),
                              DataCell(CustomText(
                                textColor: (() {
                                  int age = int.parse(members.age.toString());
                                  return age >= 60
                                      ? redColor
                                      : null; // Set color to red for Senior, otherwise use default
                                })(),
                                content: (() {
                                  int age = int.parse(members.age.toString());

                                  if (members.ageUnit == 'Month') {
                                    return 'Infant';
                                  }
                                  if (age < 18) return 'Child';
                                  if (age < 60) return 'Adult';
                                  return 'Senior*';
                                  // return age.toString();  // Display the age as-is for other cases
                                })(),
                              )),
                              DataCell(CustomText(content: members.gender)),
                            ],
                          ))
                      .toList()),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              const CustomTextWidget(
                content: "Activities Details",
                fontSize: 20,
                sideLogo: true,
                fontWeight: FontWeight.w600,
              ),
              // const Text(
              //   '*The itinerary will be shared 24 hours before the package start *',
              //   textAlign: TextAlign.start,
              // ),
              widget.bookingStatus == "CANCELLED" ||
                      widget.iteneryList.isNotEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 20,
                      child: Marqueer(
                        pps: 100,
                        controller: marqueeController,
                        direction: MarqueerDirection.rtl,
                        restartAfterInteractionDuration:
                            const Duration(seconds: 0),
                        restartAfterInteraction: true,
                        onChangeItemInViewPort: (index) {
                          debugPrint('item index: $index');
                        },
                        onInteraction: () {
                          debugPrint('on interaction callback');
                        },
                        onStarted: () {
                          debugPrint('on started callback');
                        },
                        onStopped: () {
                          debugPrint('on stopped callback');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 2),
                          child: const Text(
                            '*The itinerary will be shared 24 hours before the package start *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: btnColor,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),

        Container(
          child: widget.child,
        ),

        widget.driverDetails.isNotEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CustomTextWidget(
                  content: "Driver Details",
                  fontSize: 20,
                  sideLogo: true,
                  fontWeight: FontWeight.w600,
                ),
              )
            : const SizedBox(),

        ///Driver Details Container
        widget.driverDetails.isNotEmpty
            ? Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(10),
                child: CommonContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  width: double.infinity,
                  elevation: 0,
                  borderRadius: BorderRadius.circular(5),
                  borderReq: true,
                  borderColor: naturalGreyColor.withOpacity(0.3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: DataTable(
                        horizontalMargin: 10,
                        columnSpacing: 20,
                        headingRowHeight: 40,
                        dividerThickness: 0,
                        dataTextStyle: titleTextStyle1,
                        columns: const [
                          DataColumn(
                              label: CustomTextWidget(
                            content: "Date",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          )),
                          DataColumn(
                              label: SizedBox(
                                  // width: 60,
                                  child: CustomTextWidget(
                                      content: "Name",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700))),
                          DataColumn(
                              label: CustomTextWidget(
                                  content: "Gender",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          DataColumn(
                              label: CustomTextWidget(
                                  content: "Contact No",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ],
                        rows: widget.driverDetails
                            .map((AssignedDriverOnPackageBooking driver) =>
                                DataRow(
                                  cells: [
                                    DataCell(CustomText(
                                      content: driver.date.toString(),
                                      textEllipsis: true,
                                    )),
                                    DataCell(CustomText(
                                        // maxline: 2,
                                        align: TextAlign.start,
                                        textEllipsis: true,
                                        content:
                                            "${driver.driver.firstName.toString()} ${driver.driver.lastName.toString()}")),
                                    DataCell(CustomText(
                                        content:
                                            driver.driver.gender.toString())),
                                    DataCell(CustomText(
                                        content:
                                            '+971 ${driver.driver.mobile}')),
                                  ],
                                ))
                            .toList()),
                  ),
                ),
              )
            : const SizedBox(),
        widget.vehicleDetails.isNotEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CustomTextWidget(
                  content: "Vehicle Details",
                  fontSize: 20,
                  sideLogo: true,
                  fontWeight: FontWeight.w600,
                ),
              )
            : const SizedBox(),

        ///Vehicle Details Container
        widget.vehicleDetails.isNotEmpty
            ? Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(10),
                child: CommonContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  width: double.infinity,
                  elevation: 0,
                  borderRadius: BorderRadius.circular(5),
                  borderReq: true,
                  borderColor: naturalGreyColor.withOpacity(0.3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columnSpacing: 30,
                        headingRowHeight: 40,
                        dividerThickness: 0,
                        dataTextStyle: titleTextStyle1,
                        columns: const [
                          DataColumn(
                              label: CustomTextWidget(
                            content: "Date",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          )),
                          DataColumn(
                              label: SizedBox(
                                  width: 100,
                                  child: CustomTextWidget(
                                      content: "Name",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700))),
                          DataColumn(
                              label: CustomTextWidget(
                                  content: "Number",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                        ],
                        rows: widget.vehicleDetails
                            .map((AssignedVehicleOnPackageBooking vehicle) =>
                                DataRow(
                                  cells: [
                                    DataCell(CustomText(
                                      content: vehicle.date.toString(),
                                      textEllipsis: true,
                                    )),
                                    DataCell(CustomText(
                                        align: TextAlign.start,
                                        textLenght: 20,
                                        needTextLenght: true,
                                        maxline: 2,
                                        content: vehicle.vehicle.carName
                                            .toString())),
                                    DataCell(CustomText(
                                        content: vehicle.vehicle.vehicleNumber
                                            .toString())),
                                  ],
                                ))
                            .toList()),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (widget.bookingStatus == "CANCELLED" ||
                    widget.bookingStatus == "COMPLETED")
                ? Container()
                : (widget.getIssueByBookingId?.data ?? []).isEmpty
                    ? CustomButtonSmall(
                        width: 120,
                        height: 40,
                        btnHeading: 'Raised Issue',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            backgroundColor: background,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: SingleChildScrollView(child:
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setstate) {
                                  return RaiseIssueDialog(
                                    bookingId: widget.id,
                                    bookingType: 'PACKAGE_BOOKING',
                                  );
                                })),
                              );
                            },
                          );
                        })
                    : const SizedBox(),
            widget.bookingStatus != "CANCELLED"
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomButtonSmall(
                      height: 40,
                      width: AppDimension.getWidth(context) * .35,
                      btnHeading: "Cancel Booking",
                      onTap: widget.onTap ?? () => print("Cancel Button Press"),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }

  textItem({required String lable, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
          Expanded(
            // flex: 3,
            child: Text(
              value,
              style: titleTextStyle1,
            ),
          )
        ],
      ),
    );
  }

  bookingItem({required String lable, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              lable,
              style: titleTextStyle,
            ),
          ),
          // const SizedBox(
          //   width: 10,
          // ),
          Text(
            ':',
            style: titleTextStyle,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 4,
            child: Text(
              value,
              style: titleTextStyle1,
            ),
          )
        ],
      ),
    );
  }

  contactTile(
      {required String title,
      required String value,
      required Widget iconButton}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          title,
          style: titleTextStyle,
        )),
        Text(
          ':',
          style: titleTextStyle,
        ),
        const SizedBox(width: 5),
        Expanded(
            child: Row(
          children: [
            Flexible(
              child: Text(
                value,
                style: titleTextStyle1,
              ),
            ),
            const SizedBox(width: 5),
            iconButton
          ],
        )),
      ],
    );
  }
}

class ItineraryActivityContainer extends StatefulWidget {
  final List<dynamic> itineraryDataList;
  final bool isPackageItinerary;

  const ItineraryActivityContainer({
    required this.itineraryDataList,
    required this.isPackageItinerary,
    Key? key,
  }) : super(key: key);

  @override
  State<ItineraryActivityContainer> createState() =>
      _ItineraryActivityContainerState();
}

class _ItineraryActivityContainerState
    extends State<ItineraryActivityContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.isPackageItinerary
        ? _buildPackageItineraryList()
        : _buildPackageHistoryList();
  }

  Widget _buildPackageItineraryList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.itineraryDataList.length,
      itemBuilder: (context, index) {
        final itineraryData = widget.itineraryDataList[index];
        final List image = itineraryData.activity.activityImageUrl;

        if (index == 0 ||
            itineraryData.day != widget.itineraryDataList[index - 1].day) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: index == 0 ||
                        itineraryData.day !=
                            widget.itineraryDataList[index - 1].day
                    ? 2
                    : 5),
            child: CommonContainer(
              borderReq: true,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              borderColor: naturalGreyColor.withOpacity(.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextWidget(
                              content:
                                  "Day ${itineraryData.day == "null" ? "" : itineraryData.day} (${itineraryData.date})",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              sideLogo: true,
                            ),
                            CommonContainer(
                              padding: const EdgeInsets.all(5),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(10),
                              color: itineraryData.dayStatus == "COMPLETED"
                                  ? greenColor
                                  : redColor,
                              child: CustomText(
                                content: itineraryData.dayStatus,
                                fontSize: 16,
                                textColor: background,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        widget.itineraryDataList[index].startTimestamp
                                .toString()
                                .isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextWidget(
                                      content:
                                          "Start Time : ${widget.itineraryDataList[index].startTimestamp.toString().isEmpty ? "N/A" : widget.itineraryDataList[index].startTimestamp.toString().split(' ')[1].substring(0, 5)}",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomTextWidget(
                                      content:
                                          "End Time : ${widget.itineraryDataList[index].endTimestamp.toString().isEmpty ? "N/A" : widget.itineraryDataList[index].endTimestamp.toString().split(' ')[1].substring(0, 5)}",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    'Pickup Time : ',
                                    style: titleTextStyle,
                                  ),
                                  Text(
                                    widget.itineraryDataList[index].pickupTime
                                            .toString() ??
                                        '',
                                    style: titleTextStyle1,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  _buildActivityContent(itineraryData, image, "Activity 1"),
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CommonContainer(
              borderReq: true,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              borderColor: naturalGreyColor.withOpacity(.3),
              child: _buildActivityContent(
                  itineraryData, image, "Activity ${index + 1}"),
            ),
          );
        }
      },
    );
  }

  Widget _buildPackageHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.itineraryDataList.length,
      itemBuilder: (context, index) {
        final data = widget.itineraryDataList[index];
        final List image = data.activity.activityImageUrl;
        return CommonContainer(
          borderReq: true,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          borderColor: naturalGreyColor.withOpacity(.3),
          child: _buildActivityContent(
            data,
            image,
            "Activity ${data.day == "null" ? index + 1 : data.day}",
          ),
        );
      },
    );
  }

  Widget _buildActivityContent(dynamic data, List image, String days) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
      
        CommonContainer(
          elevation: 0,
          height: 200,
          borderRadius: BorderRadius.circular(10),
          child: MultiImageSlider(
            images: List.generate(image.length, (index) => image[index]),
          ),
        ),
        const SizedBox(height: 5),
        CustomText(
          align: TextAlign.start,
          content: data.activity.activityName,
          maxline: 3,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          textColor: btnColor,
        ),
        const SizedBox(height: 5),
        CustomViewmoreViewless(moreText: data.activity.description),

        const SizedBox(height: 5),
        _buildInfoRow("Activity Hours", data.activity.activityHours,
            "Time To Visit", data.activity.bestTimeToVisit),
        const SizedBox(height: 10),
        _buildInfoRow("Opening Time", data.activity.startTime, "Closing Time",
            data.activity.endTime),
        // const SizedBox(height: 10),
        // _buildInfoRow("Activity Price", data.activity.activityPrice,
        //     "Activity Offer price", data.activity.discountedAmount),
        data.activity.participantType.isNotEmpty
            ? const SizedBox(height: 10)
            : const SizedBox(),
        data.activity.participantType.isNotEmpty
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Suitable For : ',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Row(
                    children: List.generate(
                        data.activity.participantType.length, (e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(data.activity.participantType[e]),
                      );
                    }),
                  )
                ],
              )
            : const SizedBox(),
        const SizedBox(height: 10),
        _buildLocationInfo(data.activity.address),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRichText(label1, value1),
        _buildRichText(label2, value2),
      ],
    );
  }

  Widget _buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(String address) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Location: ",
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          TextSpan(
            text: address,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

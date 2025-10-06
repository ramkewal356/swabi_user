// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/model/get_issue_by_booking_id_model.dart'
    hide Status;
import 'package:flutter_cab/model/package_models.dart' hide Status;
import 'package:flutter_cab/model/payment_details_model.dart' hide Status;
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/activity_container.dart';
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
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/utils/validation.dart';
import 'package:flutter_cab/view/customer/my_rental/cancel_booking.dart';
import 'package:flutter_cab/view/vendor/package_booking_management.dart/assign_and_change_driver_screen.dart';
import 'package:flutter_cab/view/vendor/package_booking_management.dart/assign_and_change_vehicle_screen.dart';
import 'package:flutter_cab/view/vendor/package_booking_management.dart/create_and_change_itinerary_screen.dart';
import 'package:flutter_cab/view_model/itinerary_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/response/status.dart';
import '../../../../view_model/package_view_model.dart';

class PackagePageViewDetails extends StatefulWidget {
  final String userType;
  final String packageBookID;
  final String paymentId;
  final String bookingStatus;
  const PackagePageViewDetails(
      {super.key,
      required this.userType,
      required this.packageBookID,
      required this.paymentId,
      required this.bookingStatus});

  @override
  State<PackagePageViewDetails> createState() => _PackagePageViewDetailsState();
}

class _PackagePageViewDetailsState extends State<PackagePageViewDetails> {
  TextEditingController cancelController = TextEditingController();
  TextEditingController alertController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController primaryContactController = TextEditingController();
  TextEditingController secondaryContactController = TextEditingController();
  TextEditingController changeContactController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchLocationController = TextEditingController();

  GetIssueByBookingIdModel? getIssueByBookingId;
  bool loading = false;
  int? day;
  List<String> allParticipantTypes = [];
  List<dynamic> imageList = [];
  List<PackageActivity> packageActivityList = [];
  List<String> sutableFor = [];
  PaymentDetailsModel? paymentDetails;
  String countryCode = '971';
  String primaryCountryCode = '971';
  String? selectedText;
  FocusNode? focusNode;
  String selectedTime = '';
  String? selectedActivity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPackageDetails();
      if (widget.bookingStatus == "CANCELLED" && widget.paymentId.isNotEmpty) {
        getrefund();
      }
      context.read<ItineraryViewModel>().addListener(() {
        final status =
            context.read<ItineraryViewModel>().addOrEditItinerary.status;
        if (status == Status.completed) {
          getItenery(); // refresh itinerary automatically
        }
      });
    
    });
  }

  void getPackageDetails() {
    context
        .read<GetPackageHistoryDetailByIdViewModel>()
        .fetchGetPackageHistoryDetailByIdViewModelApi(
            bookingId: widget.packageBookID);
    getItenery();
    getIssue();
    if (widget.paymentId.isNotEmpty) {
      getPaymentDetail();
    }
  }

  void getItenery() {
    context
        .read<GetPackageItineraryViewModel>()
        .fetchGetPackageItineraryViewModelApi(
            context, {"packageBookingId": widget.packageBookID});
  }

  void getrefund() {
    context
        .read<GetPaymentRefundViewModel>()
        .getPaymentRefundApi(context: context, paymentId: widget.paymentId);
  }

  void getIssue() {
    context.read<RaiseissueViewModel>().getIssueByBookingId(
        bookingId: widget.packageBookID,
        // userId: widget.userId,
        bookingType: 'PACKAGE_BOOKING');
  }

  void changeContact() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChangeMobileViewModel>().changeMobileApi(
        body: {
          "packageBookingId": widget.packageBookID,
          "mobile": primaryContactController.text,
          "countryCode": primaryCountryCode,
          "alternateMobile": countryCode,
          "alternateMobileCountryCode": secondaryContactController.text
        },
      ).then((onValue) {
        if (onValue?.status?.httpCode == "200") {
          Navigator.pop(context); // close bottom sheet safely
          Utils.toastSuccessMessage(onValue?.data?.body ?? '');
          getPackageDetails(); // refresh safely
        } else {
          Navigator.pop(context);
          getPackageDetails();
        }
      });
    });
  }

  void getAddPickUpLocation() {
    context
        .read<AddPickUpLocationPackageViewModel>()
        .fetchAddPickUpLocationPackageViewModelApi(
      context,
      {
        "packageBookingId": widget.packageBookID,
        "pickupLocation": searchLocationController.text
      },
    ).then((onValue) {
      if (onValue?.status?.httpCode == "200") {
        debugPrint('locationbnkjjlklkl....${searchLocationController.text}');
        Utils.toastSuccessMessage(onValue?.data?.body ?? '');
        context.pop(context);
        getPackageDetails();
      }
    });
  }

  void getPaymentDetail() {
    context
        .read<RentalPaymentDetailsViewModel>()
        .rentalPaymentDetail(paymentId: widget.paymentId);
  }

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
  void dispose() {
    cancelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentDetails = context
        .watch<RentalPaymentDetailsViewModel>()
        .rentalPaymentDetails
        .data
        ?.data;
    final paymentRefund =
        context.watch<GetPaymentRefundViewModel>().getPaymentRefund.data?.data;
    final getIssueByBookingId =
        context.watch<RaiseissueViewModel>().getIssueBybookingId.data;
    final getItenaryData = context
        .watch<GetPackageItineraryViewModel>()
        .getPackageItineraryList
        .data
        ?.data;

    // DateTime dateTime = DateTime.now();
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Booking Details",
      ),
      body: PageLayoutPage(child:
          Consumer<GetPackageHistoryDetailByIdViewModel>(
              builder: (context, viewModel, snapshot) {
        if (viewModel.getPackageHistoryDetailById.status == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else if (viewModel.getPackageHistoryDetailById.status ==
            Status.error) {
          return Center(
            child: Text(
              'No Data Found',
              style: nodataTextStyle,
            ),
          );
        } else if (viewModel.getPackageHistoryDetailById.status ==
            Status.completed) {
          var data = viewModel.getPackageHistoryDetailById.data?.data;
          primaryCountryCode = data?.countryCode ?? '971';
          countryCode = data?.alternateMobileCountryCode ?? '971';
          primaryContactController.text = data?.mobile ?? '';

          return ListView(
            children: [
              CommonContainer(
                  height: 220,
                  elevation: 0,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(5),
                  borderReq: true,
                  borderColor: naturalGreyColor.withOpacity(0.3),
                  child: MultiImageSlider(
                    images: data?.pkg.packageActivities
                            .expand((e) => e.activity.activityImageUrl)
                            .toList() ??
                        [],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleText(title: 'Booking Details'),
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
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          TextSpan(
                              text:
                                  '${double.tryParse(((data?.totalPayableAmount ?? '0').isEmpty ? (data?.packagePrice ?? '0') : (data?.totalPayableAmount ?? '0')))?.round()}',
                              style: const TextStyle(
                                  color: btnColor, fontWeight: FontWeight.w600))
                        ]))
                      ],
                    )
                  ],
                ),
              ),
              CommonContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              content: data?.packageBookingId ?? '',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          // width: 90,
                          decoration: BoxDecoration(
                              color: _statusColor(data?.bookingStatus ?? ''),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                            data?.bookingStatus ?? '',
                            style: const TextStyle(color: background),
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    bookingItem(
                        lable: 'Package Name',
                        value:
                            data?.pkg.packageName.capitalizeFirstOfEach ?? ''),
                    bookingItem(
                        lable: 'Numbers Of Member',
                        value: data?.numberOfMembers ?? ''),
                    bookingItem(
                        lable: 'Booking Start Date',
                        value: data?.bookingDate ?? ''),
                    bookingItem(
                        lable: 'Booking End Date', value: data?.endDate ?? ''),
                    bookingItem(
                        lable: 'Duration',
                        value:
                            '${data?.pkg.noOfDays}Days/${int.parse(data?.pkg.noOfDays ?? '') - 1}Nights'),
                    contactTile(
                        title: 'Primary Contact',
                        value: '+${data?.countryCode} ${data?.mobile}',
                        iconButton: data?.bookingStatus == "BOOKED"
                            ? data?.alternateMobile.isEmpty == true
                                ? InkWell(
                                    onTap: () {
                                      _showBottomSheetModal(
                                          context,
                                          (setState) => _formContainer(
                                                title: 'Add Secondory Contact',
                                                onTap: () {
                                                  debugPrint(
                                                      'contact....$countryCode...${secondaryContactController.text}');
                                                  changeContact();
                                                },
                                                isChangeContact: true,
                                              ));
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
                    data?.bookingStatus == "BOOKED"
                        ? data?.alternateMobile.isNotEmpty == true
                            ? contactTile(
                                title: 'Secondary Contact',
                                value:
                                    '+${data?.alternateMobileCountryCode} ${data?.alternateMobile}',
                                iconButton: InkWell(
                                  onTap: () {
                                    _showBottomSheetModal(
                                        context,
                                        (setState) => _formContainer(
                                              title: 'Change Secondory contact',
                                              onTap: () {
                                                changeContact();
                                              },
                                              isChangeContact: true,
                                            ));
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
                        lable: 'Country', value: data?.pkg.country ?? ''),
                    (getIssueByBookingId?.data ?? []).isEmpty
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
                        value: data?.pickupLocation.isEmpty == true
                            ? 'N/A'
                            : data?.pickupLocation ?? 'N/A',
                        iconButton: data?.bookingStatus == "BOOKED"
                            ? data?.pickupLocation != "N/A" &&
                                    data?.pickupLocation.isEmpty == true
                                ? InkWell(
                                    onTap: () {
                                      _showBottomSheetModal(
                                          context,
                                          (setState) => _formContainer(
                                                title: 'Add Pickup Location',
                                                onTap: () {
                                                  getAddPickUpLocation();
                                                },
                                                isChangeContact: false,
                                              ));
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
                    data?.bookingStatus == "CANCELLED"
                        ? bookingItem(
                            lable: 'Cancelled By',
                            value: data?.cancelledBy ?? '')
                        : const SizedBox(),
                    data?.bookingStatus == "CANCELLED"
                        ? bookingItem(
                            lable: 'Cancellation Reason',
                            value: data?.cancellationReason ?? '')
                        : const SizedBox(),
                  ],
                ),
              ),
              (paymentDetails != null && widget.paymentId.isNotEmpty)
                  ? titleText(title: 'Payment Details')
                  : SizedBox.shrink(),
              (paymentDetails != null && widget.paymentId.isNotEmpty)
                  ? CommonContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: double.infinity,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(5),
                      borderReq: true,
                      borderColor: naturalGreyColor.withOpacity(0.3),
                      child: Column(
                        children: [
                          textItem(
                              lable: 'Payment Id',
                              value: paymentDetails.id ?? ''),
                          textItem(
                              lable: 'Package Amount',
                              value: 'AED ${data?.packagePrice}'),
                          textItem(
                              lable: 'Tax Amount (5%)',
                              value:
                                  'AED ${double.parse(data?.taxAmount ?? '').toStringAsFixed(2)}'),
                          data?.discountAmount == '0.0'
                              ? const SizedBox()
                              : textItem(
                                  lable: 'Discount Amount',
                                  value: 'AED ${data?.discountAmount}'),
                          textItem(
                              lable: 'Total Amount',
                              value:
                                  'AED ${(paymentDetails.amount ?? 0) / 100}'),
                          textItem(
                            lable: 'Payment Date',
                            value: dateFormat(
                                (paymentDetails.createdAt ?? 0) * 1000),
                          ),
                          textItem(
                              lable: 'Payment Time',
                              value:
                                  formatToIST(paymentDetails.createdAt ?? 0)),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              paymentRefund != null && data?.bookingStatus == "CANCELLED"
                  ? titleText(title: 'Refund Details')
                  : SizedBox.shrink(),
              paymentRefund != null && data?.bookingStatus == "CANCELLED"
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Refund will be processed within 5 working days.',
                        style: TextStyle(
                            color: btnColor, fontWeight: FontWeight.w600),
                      ),
                    )
                  : const SizedBox.shrink(),
              paymentRefund != null && data?.bookingStatus == "CANCELLED"
                  ? CommonContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                                  'AED ${paymentRefund.refundedAmount?.toStringAsFixed(2)}'),
                          textItem(
                              lable: 'Refund Status',
                              value: paymentRefund.refundStatus == 'created'
                                  ? "PENDING"
                                  : paymentRefund.refundStatus == 'processed'
                                      ? "PROCESSED"
                                      : '${paymentRefund.refundStatus}'),
                        ],
                      ),
                    )
                  : Container(),
              titleText(title: 'Travellers Details'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data?.memberList.length,
                itemBuilder: (context, index) {
                  var t = data?.memberList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red.shade700,
                                child: Text(
                                  (t?.name.isNotEmpty == true)
                                      ? t?.name[0].toUpperCase() ?? ''
                                      : '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  t?.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  t?.ageUnit == 'Month'
                                      ? 'Infant'
                                      : (int.parse(t?.age ?? '') < 18)
                                          ? "Child"
                                          : (int.parse(t?.age ?? '') < 60)
                                              ? 'Adult'
                                              : "Senior*",
                                  style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 20),

                          // Details row (grid-like)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoBox("ID", t?.memberId ?? ''),
                              _infoBox(
                                  "Age",
                                  "${t?.age ?? ''} "
                                      "${t?.ageUnit == 'Month' ? 'M' : 'Y'}"),
                              _infoBox("Gender", t?.gender ?? ''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(title: 'Activities Details'),
                  (widget.userType == 'USER' ||
                          data?.bookingStatus == "CANCELLED" ||
                          data?.bookingStatus == "COMPLETED")
                      ? SizedBox.shrink()
                      : CreateAndChangeItineraryScreen(
                          data: data,
                          getItenaryData: getItenaryData,
                        )
                ],
              ),
              if (getItenaryData == null &&
                  (data?.bookingStatus != 'CANCELLED' &&
                      data?.bookingStatus != 'COMPLETED' &&
                      widget.userType == 'USER'))
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '*The itinerary will be shared 24 hours before the package start*',
                    style: nodataTextStyle,
                  ),
                ),
              (getItenaryData != null &&
                      getItenaryData.itineraryDetails.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: getItenaryData.itineraryDetails.length,
                      itemBuilder: (context, index) {
                        final packageActivityList =
                            getItenaryData.itineraryDetails[index];

                        return ActivityContainer(
                          days: packageActivityList.day.toString(),
                          pickupDate: packageActivityList.date,
                          pickupTime: packageActivityList.pickupTime,
                          actyImage:
                              packageActivityList.activity.activityImageUrl,
                          activityName:
                              packageActivityList.activity.activityName,
                          description: packageActivityList.activity.description,
                          activityHour: packageActivityList
                              .activity.activityHours
                              .toString(),
                          activityVisit:
                              packageActivityList.activity.bestTimeToVisit,
                          openTime: packageActivityList.activity.startTime,
                          closeTime: packageActivityList.activity.endTime,
                          suitableFor:
                              packageActivityList.activity.participantType,
                          address: packageActivityList.activity.address,
                          activityOfferDate:
                              packageActivityList.activity.startTime,
                          activityStatus: packageActivityList.dayStatus,
                          visible: false,
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data?.pkg.packageActivities.length,
                      itemBuilder: (context, index) {
                        final acticityImage = data?.pkg.packageActivities[index]
                            .activity.activityImageUrl;

                        for (var activity
                            in data?.pkg.packageActivities ?? []) {
                          List<String> activityParticipantTypes =
                              activity.activity?.participantType ??
                                  [].map((e) => e.toString()).toList();
                          allParticipantTypes.addAll(activityParticipantTypes);
                        }

                        // Remove duplicates if needed
                        allParticipantTypes =
                            allParticipantTypes.toSet().toList();
                        sutableFor = data?.pkg.packageActivities
                                .expand((activity) => activity
                                    .activity.participantType
                                    .map((type) => type.toString())
                                    .toList())
                                .toSet()
                                .toList() ??
                            [];

                        final packageActivityList =
                            data?.pkg.packageActivities[index];
                        return ActivityContainer(
                          days: getItenaryData == null
                              ? ''
                              : packageActivityList?.day,
                          pickupDate: '',
                          pickupTime: '',
                          // actyImage: List.generate(acticityImage?.length ?? 0,
                          //     (index) => acticityImage?[index] ?? ''),
                          actyImage: acticityImage ?? [],
                          activityName:
                              packageActivityList?.activity.activityName ?? '',
                          description:
                              packageActivityList?.activity.description ?? '',
                          activityHour: packageActivityList
                                  ?.activity.activityHours
                                  .toString() ??
                              '',
                          activityVisit:
                              packageActivityList?.activity.bestTimeToVisit ??
                                  "",
                          openTime:
                              packageActivityList?.activity.startTime ?? "",
                          closeTime:
                              packageActivityList?.activity.endTime ?? '',
                          suitableFor:
                              packageActivityList?.activity.participantType ??
                                  [].map((e) => e.toString()).toList(),
                          address: packageActivityList?.activity.address ?? "",
                          activityOfferDate: packageActivityList?.startTime,
                          activityStatus: '',
                          visible: false,
                        );
                      },
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(title: 'Vehicle Details'),
                  widget.userType == 'VENDOR'
                      ? (data?.bookingStatus != "CANCELLED" &&
                                  data?.bookingStatus != 'COMPLETED' &&
                                  (data?.assignedVehicleOnPackageBookings
                                          .isEmpty ==
                                      false) ||
                              getItenaryData != null)
                          ? AssignAndChangeVehicleScreen(
                              packageBookingId: data?.packageBookingId ?? '',
                              assignedVehicleOnPackageBooking:
                                  data?.assignedVehicleOnPackageBookings,
                              bookingDate: data?.bookingDate ?? '',
                              endDate: data?.endDate ?? '',
                              noOfDays: int.parse(data?.pkg.noOfDays ?? '0'),
                              onSuccess: () {
                                getPackageDetails();
                              },
                            )
                          : SizedBox.shrink()
                      : SizedBox.shrink()
                ],
              ),
              data?.assignedVehicleOnPackageBookings.isEmpty == true
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: naturalGreyColor.withOpacity(0.3),
                      ),
                      child: Center(
                          child: Text(
                        "No Vehicle Assigned",
                        style: nodataTextStyle,
                      )))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _modernCard(
                              details: [
                                {
                                  "label": "Assign ID",
                                  "value":
                                      '${data?.assignedVehicleOnPackageBookings[index].assignedId}'
                                },
                                {
                                  "label": "Car Name",
                                  "value": data
                                          ?.assignedVehicleOnPackageBookings[
                                              index]
                                          .vehicle
                                          .carName ??
                                      ''
                                },
                                {
                                  "label": "Vehicle Number",
                                  "value": data
                                          ?.assignedVehicleOnPackageBookings[
                                              index]
                                          .vehicle
                                          .vehicleNumber ??
                                      ''
                                },
                                {
                                  "label": "Date",
                                  "value": data
                                          ?.assignedVehicleOnPackageBookings[
                                              index]
                                          .date ??
                                      ''
                                },
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                      itemCount:
                          data?.assignedVehicleOnPackageBookings.length ?? 0,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleText(title: 'Driver Details'),
                  widget.userType == 'VENDOR'
                      ? (data?.bookingStatus != "CANCELLED" &&
                                  data?.bookingStatus != 'COMPLETED' &&
                                  (data?.assignedDriverOnPackageBookings
                                          .isEmpty ==
                                      false) ||
                              (data?.assignedVehicleOnPackageBookings
                                      .isNotEmpty ==
                                  true))
                          ? CustomButtonSmall(
                              height: 40,
                              btnHeading:
                                  (data?.assignedDriverOnPackageBookings ?? [])
                                          .isEmpty
                                      ? 'Add Driver'
                                      : "Change Driver",
                              onTap: () {
                                _showBottomSheetModal(
                                    context,
                                    (setState) => AssignAndChangeDriverScreen(
                                          packageBookingId:
                                              data?.packageBookingId ?? '',
                                          assignedDriverOnPackageBooking:
                                              data?.assignedDriverOnPackageBookings ??
                                                  [],
                                          bookingDate: data?.bookingDate ?? '',
                                          endDate: data?.endDate ?? '',
                                          noOfDays: int.parse(
                                              data?.pkg.noOfDays ?? '0'),
                                          onSuccess: () {
                                            getPackageDetails();
                                          },
                                        ));
                              },
                            )
                          : SizedBox.shrink()
                      : SizedBox.shrink()
                ],
              ),
              data?.assignedDriverOnPackageBookings.isEmpty == true
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: naturalGreyColor.withOpacity(0.3),
                      ),
                      child: Center(
                          child: Text(
                        "No Driver Assigned",
                        style: nodataTextStyle,
                      )))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _modernCard(
                              details: [
                                {
                                  "label": "Driver Name",
                                  "value":
                                      '${data?.assignedDriverOnPackageBookings[index].driver.firstName} ${data?.assignedDriverOnPackageBookings[index].driver.lastName}'
                                },
                                {
                                  "label": "Mobile",
                                  "value":
                                      '+${data?.assignedDriverOnPackageBookings[index].driver.countryCode} ${data?.assignedDriverOnPackageBookings[index].driver.mobile}'
                                },
                                {
                                  "label": "Date",
                                  "value": data
                                          ?.assignedDriverOnPackageBookings[
                                              index]
                                          .date ??
                                      ''
                                },
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                      itemCount:
                          data?.assignedDriverOnPackageBookings.length ?? 0,
                    ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (data?.bookingStatus == "CANCELLED" ||
                          data?.bookingStatus == "COMPLETED" ||
                          widget.userType == 'VENDOR')
                      ? Container()
                      : (getIssueByBookingId?.data ?? []).isEmpty
                          ? CustomButtonSmall(
                              width: 120,
                              height: 40,
                              btnHeading: 'Raised Issue',
                              onTap: () {
                                _showBottomSheetModal(
                                    context,
                                    (setState) => RaiseIssueDialog(
                                          bookingId:
                                              data?.packageBookingId ?? '',
                                          bookingType: 'PACKAGE_BOOKING',
                                          venderId: data?.pkg.vendor?.vendorId
                                                  .toString() ??
                                              '',
                                        ));
                              })
                          : const SizedBox(),
                  (data?.bookingStatus == "CANCELLED" ||
                          data?.bookingStatus == 'COMPLETED')
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: CustomButtonSmall(
                            height: 40,
                            width: AppDimension.getWidth(context) * .35,
                            btnHeading: "Cancel Booking",
                            onTap: () {
                              _showBottomSheetModal(
                                  context,
                                  (setState) => CancelContainerDialog(
                                        loading: false,
                                        controllerCancel: cancelController,
                                        onTap: () {
                                          context
                                              .read<PackageCancelViewModel>()
                                              .fetchPackageCancelViewModelApi(
                                            query: {
                                              "packageBookingId":
                                                  widget.packageBookID,
                                              "cancellationReason":
                                                  cancelController.text,
                                              "cancelledBy": "USER"
                                            },
                                          ).then((onValue) {
                                            if (onValue?.status?.httpCode ==
                                                "200") {
                                              // context.pop();
                                              context.pop();
                                              Utils.toastSuccessMessage(
                                                  onValue?.data?.body ?? '');
                                              getPackageDetails();
                                              getrefund();
                                            }
                                          });

                                          // controller.dispose();
                                        },
                                      ));
                            },
                          ),
                        )
                ],
              ),
            ],
          );
        }
        return Container();
      })),
    );
  }

  void _showBottomSheetModal(
      BuildContext context, Widget Function(StateSetter) childBuilder) {
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return childBuilder(setstate);
          })),
        );
      },
    );
  }

  Widget _formContainer({
    required String title,
    required VoidCallback onTap,
    required bool isChangeContact,
  }) {
    return Container(
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
                      Text(
                        title,
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
                          text: isChangeContact
                              ? 'Secondary Contact'
                              : "Location",
                          style: titleTextStyle),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: redColor))
                    ])),
                  ),
                  if (isChangeContact)
                    CustomMobilenumber(
                      textLength: 9,
                      controller: secondaryContactController,
                      hintText: 'Enter phone number',
                      countryCode: countryCode,
                    ),
                  if (!isChangeContact)
                    CustomSearchLocation(
                        controller: searchLocationController,
                        state: '',
                        // stateValidation: false,
                        hintText: 'Search your location'),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButtonSmall(
                    loading: context
                                .watch<AddPickUpLocationPackageViewModel>()
                                .addPickUpLocationPackage
                                .status ==
                            Status.loading ||
                        context
                                .watch<ChangeMobileViewModel>()
                                .changeMobile
                                .status ==
                            Status.loading,
                    height: 45,
                    width: double.infinity,
                    btnHeading: 'Submit',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        onTap();
                      }
                    },
                  )
                ])));
  }

  Widget _modernCard({
    required List<Map<String, String>> details,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: bgGreyColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: details.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(item['label']!,
                        style: const TextStyle(color: Colors.grey)),
                  ),
                  Expanded(
                    child: Text(item['value']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            )),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget textItem({required String lable, required String value}) {
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

  Widget bookingItem({required String lable, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget contactTile(
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

  Widget titleText({required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 4.0, color: btnColor),
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          title,
          style: TextStyle(
              color: blackColor, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

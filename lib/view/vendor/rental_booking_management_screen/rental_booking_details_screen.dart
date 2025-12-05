import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/custom_raise_issue_form.dart';
import 'package:flutter_cab/widgets/info_row.dart';
import 'package:flutter_cab/widgets/section_card.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view/customer/my_rental/cancel_booking.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
// import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
// import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class RentalBookingDetailsScreen extends StatefulWidget {
  final String bookingId;
  final String paymentId;
  final String bookingStatus;
  final String userType;
  const RentalBookingDetailsScreen(
      {super.key,
      required this.bookingId,
      required this.paymentId,
      required this.bookingStatus,
      this.userType = 'USER'});

  @override
  State<RentalBookingDetailsScreen> createState() =>
      _RentalBookingDetailsScreenState();
}

class _RentalBookingDetailsScreenState
    extends State<RentalBookingDetailsScreen> {
  final TextEditingController cancelController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getRentalDetails();
      if (widget.bookingStatus == 'CANCELLED') {
        refundPayment();
      }
    });

    super.initState();
  }

  void _getRentalDetails() {
    context
        .read<RentalViewDetailViewModel>()
        .fetchRentalBookedViewDetialViewModelApi(context, {
      "id": widget.bookingId,
    });
    getPaymentDetail();
    if (widget.userType == 'USER') {
      getissueDetail();
    }
  }

  void getissueDetail() async {
    // String? userId = await UserViewModel().getUserId() ?? '';
    Provider.of<RaiseissueViewModel>(context, listen: false)
        .getIssueByBookingId(
            bookingId: widget.bookingId,
            // userId: userId,
            bookingType: 'RENTAL_BOOKING');
  }

  void getPaymentDetail() {
    context
        .read<RentalPaymentDetailsViewModel>()
        .rentalPaymentDetail(paymentId: widget.paymentId);
  }

  void refundPayment() {
    context
        .read<GetPaymentRefundViewModel>()
        .getPaymentRefundApi(context: context, paymentId: widget.paymentId);
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
  Widget build(BuildContext context) {
    final paymentDetails = context
        .watch<RentalPaymentDetailsViewModel>()
        .rentalPaymentDetails
        .data
        ?.data;
    final refundData =
        context.watch<GetPaymentRefundViewModel>().getPaymentRefund.data?.data;
    final getIssueByBookingId =
        context.watch<RaiseissueViewModel>().getIssueBybookingId.data?.data;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          "Booking Details",
          style: appBarTitleStyle,
        ),
        backgroundColor: background,
      ),
      body: Consumer<RentalViewDetailViewModel>(
        builder: (context, vm, state) {
          if (vm.dataList.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: greenColor,
              ),
            );
          } else {
            var data = vm.dataList.data?.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionCard(
                    title: "Booking Details",
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Booking Status',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Chip(
                              label: Text(data?.bookingStatus ?? '',
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor:
                                  _statusColor(data?.bookingStatus ?? ''),
                            ),
                          ),
                        ],
                      ),
                      InfoRow(label: "Booking ID", value: "${data?.id}"),
                      InfoRow(
                          label: "Created Date",
                          value: dateFormat(data?.createdDate)),
                      InfoRow(label: "Ride Date", value: data?.date ?? ''),
                      InfoRow(label: "Time", value: data?.pickupTime ?? ''),
                      InfoRow(
                          label: "Ride Start Time",
                          value: data?.rideStartTime == ''
                              ? 'Ride not started'
                              : data?.rideStartTime ?? ''),
                      InfoRow(
                          label: "Ride Distance",
                          value: "${data?.kilometers} KM"),
                      InfoRow(
                          label: "Extra Ride Distance",
                          value: data?.extraKilometers == ''
                              ? 'N/A'
                              : "${data?.extraKilometers} KM"),
                      InfoRow(
                          label: "Extra Ride Time",
                          value:
                              "${0} Hour : ${data?.extraMinutes == '' ? 0 : data?.extraMinutes} Min"),
                      InfoRow(
                          label: "Total Ride Time",
                          value: "${data?.totalRentTime} Hours"),
                      InfoRow(label: "Car Type", value: "${data?.carType}"),
                      if (data?.bookingStatus == 'CANCELLED')
                        InfoRow(
                            label: "Cancelled By",
                            value: "${data?.cancelledBy}"),
                      if (data?.bookingStatus == 'CANCELLED')
                        InfoRow(
                            label: "Cancellation Reason",
                            value: "${data?.cancellationReason}"),
                      if (widget.userType == 'USER' &&
                          (getIssueByBookingId ?? []).isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text('Created Issue',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey))),
                            Expanded(
                              child: Text(
                                'View Issue',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    color: greenColor),
                              ),
                            )
                          ],
                        ),
                      InfoRow(
                          label: "Pick Up Location",
                          value: "${data?.pickupLocation}"),
                    ],
                  ),
                  if (widget.userType == 'VENDOR')
                    SectionCard(title: 'Customer Information', children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: (data?.user.profileImageUrl ?? '').isEmpty
                              ? Icon(Icons.person)
                              : ClipOval(
                                  child: Image.network(
                                      data?.user.profileImageUrl ?? '')),
                        ),
                        title: Text(
                            "${data?.user.firstName} ${data?.user.lastName} (${data?.user.userId})"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data?.user.email ?? ''),
                            Text('+971 ${data?.user.mobile}'),
                          ],
                        ),
                      )
                    ]),
                  data?.guest == null
                      ? SizedBox.shrink()
                      : SectionCard(title: 'Guest Details', children: [
                          InfoRow(
                              label: "Guest Id",
                              value: "${data?.guest?.guestId}"),
                          InfoRow(
                              label: "Guest Name",
                              value: "${data?.guest?.guestName}"),
                          InfoRow(
                              label: "Gender", value: "${data?.guest?.gender}"),
                          InfoRow(
                              label: "Guest Contact",
                              value:
                                  "+${data?.guest?.countryCode} ${data?.guest?.guestMobile}"),
                        ]),
                  SectionCard(
                    title: "Payment Details",
                    children: [
                      InfoRow(
                          label: "Payment ID", value: "${paymentDetails?.id}"),
                      InfoRow(
                        label: "Payment Time",
                        value: formatToIST(paymentDetails?.createdAt),
                      ),
                      InfoRow(
                        label: "Payment Date",
                        value: dateFormat(data?.createdDate),
                      ),
                      InfoRow(
                        label: "Amount",
                        value: "AED ${data?.rentalCharge}",
                      ),
                      InfoRow(
                        label: "Tax Amount(5%)",
                        value: "AED ${data?.taxAmount}",
                      ),
                      InfoRow(
                          label: "Total Amount",
                          value: "AED ${data?.totalPayableAmount}",
                          isHighlight: true),
                    ],
                  ),
                  if (refundData != null && data?.bookingStatus == 'CANCELLED')
                    SectionCard(
                      title: "Refund Details",
                      children: [
                        InfoRow(
                            label: "Refund Amount",
                            value: "AED ${refundData.refundedAmount}"),
                        InfoRow(
                          label: "Refund Status",
                          value: "${refundData.refundStatus?.toUpperCase()}",
                          isHighlight: true,
                        ),
                      ],
                    ),
                  if (widget.userType == 'VENDOR')
                    SectionCard(
                      title: "Vehicle Details",
                      children: [
                        data?.vehicle == null
                            ? Center(
                            child: Text("Vehicle not Assigned",
                                    style: TextStyle(color: Colors.red)))
                            : Text(data?.vehicle.carName ?? ''),
                      ],
                    ),
                  if (widget.userType == 'VENDOR')
                    SectionCard(
                      title: "Driver Details",
                      children: [
                        Center(
                            child: Text("Driver not Assigned",
                                style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  SizedBox(height: 10),
                  data?.bookingStatus == "COMPLETED"
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (widget.userType == 'USER')
                                  ? (getIssueByBookingId ?? []).isEmpty
                                      ? CustomButtonSmall(
                                          height: 40,
                                          width: 120,
                                          btnHeading: 'Raised Issue',
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isDismissible: false,
                                              backgroundColor: background,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(10),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: SingleChildScrollView(
                                                      child: StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setstate) {
                                                    return RaiseIssueDialog(
                                                      bookingId:
                                                          widget.bookingId,
                                                      bookingType:
                                                          'RENTAL_BOOKING',
                                                      venderId:
                                                          data?.vendorId ?? '',
                                                    );
                                                  })),
                                                );
                                              },
                                            );
                                          })
                                      : SizedBox.shrink()
                                  : SizedBox.shrink(),
                              data?.bookingStatus == "BOOKED"
                                  ? CustomButtonSmall(
                                      width:
                                          AppDimension.getWidth(context) * .35,
                                      height: 40,
                                      btnHeading: "Cancel Booking",
                                      // loading: cancelledStatus == "Status.loading" && loading,
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isDismissible: false,
                                            backgroundColor: background,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
                                            ),
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: SingleChildScrollView(
                                                    child: StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setstate) {
                                                  String cancelledStatus = context
                                                      .watch<
                                                          RentalBookingCancelViewModel>()
                                                      .cancelldataList
                                                      .status
                                                      .toString();
                                                  return CancelContainerDialog(
                                                      loading:
                                                          cancelledStatus ==
                                                              "Status.loading",
                                                      controllerCancel:
                                                          cancelController,
                                                      onTap: () async {
                                                        // controller.dispose();
                                                      });
                                                })),
                                              );
                                            });
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

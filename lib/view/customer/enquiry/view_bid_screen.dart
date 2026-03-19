// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/services/payment_service.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/data/models/get_all_enquiry_model.dart';
// import 'package:flutter_cab/data/models/get_enquiry_by_id_model.dart'
//     hide Status;
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ViewBidScreen extends StatefulWidget {
  final int enquiryId;
  const ViewBidScreen({super.key, required this.enquiryId});

  @override
  State<ViewBidScreen> createState() => _ViewBidScreenState();
}

class _ViewBidScreenState extends State<ViewBidScreen> {
  @override
  void initState() {
    super.initState();
    getEnquiryById();
  }

  void getEnquiryById() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<EnquiryViewModel>()
          .getEnquiryByIdApi(enquiryId: widget.enquiryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bidStatus = context.watch<BidViewModel>().confirmBookingBid.status;
    final acceptStatus = context.watch<BidViewModel>().acceptOrRejectBid.status;

    return PageLayoutPage(
      bgColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        title: Text(
          'Enquiry & Bids',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: greyColor,
          ),
        ),
        centerTitle: true,
      ),
      onRefresh: () async {
        getEnquiryById();
      },
      child: Consumer<EnquiryViewModel>(
        builder: (context, vm, _) {
          if (vm.getEnquiryById.status == Status.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: btnColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading enquiry...',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: greyColor1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final enquiry = vm.getEnquiryById.data?.data;

          if (enquiry == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded,
                      size: 64, color: greyColor1.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No enquiry data found',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: greyColor1,
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 8, 5, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Header Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: btnColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.travel_explore_rounded,
                                        size: 18,
                                        color: btnColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Enquiry Details",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: greyColor,
                                          ),
                                        ),
                                        Text(
                                          "(${dateFormat(enquiry.createdAt)})",
                                          style:
                                              GoogleFonts.poppins(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ],
                                ),

                                /// Region Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: enquiry.closeInquiryStatus == false
                                        ? btnColor.withOpacity(0.08)
                                        : greenColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    enquiry.closeInquiryStatus == false
                                        ? 'Closed'
                                        : "Active",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: enquiry.closeInquiryStatus == false
                                          ? btnColor
                                          : greenColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            _infoRow(
                              _miniInfo(Icons.tag_rounded, "ID",
                                  '${enquiry.id ?? '-'}'),
                              _miniInfo(Icons.currency_rupee_rounded, "Budget",
                                  '${enquiry.currency ?? ''} ${enquiry.budget ?? 'N/A'}'),
                            ),
                            const SizedBox(height: 14),
                            _infoRow(
                              // _miniInfo(
                              // Icons.calendar_today_rounded,
                              // "Enquiry Date",
                              // dateFormat(enquiry.createdAt)),
                              (enquiry.travelDates ?? '').isEmpty
                                  ? _miniInfo(
                                      Icons.date_range_rounded,
                                      "Tentative Dates",
                                      "${enquiry.tentativeDates ?? '--'}"
                                          "${enquiry.tentativeDays != null ? ' (${enquiry.tentativeDays} days)' : ''}",
                                    )
                                  : _miniInfo(
                                      Icons.date_range_rounded,
                                      "Travel Dates",
                                      enquiry.travelDates ?? '--',
                                    ),
                              _miniInfo(
                                  Icons.group_rounded,
                                  "Guests",
                                  formatParticipantType(
                                      enquiry.participantType!)),
                              //     Icons.group_rounded,
                              //     "Guests",
                              //     _formatParticipantType(
                              //         enquiry.participantType)),
                            ),
                            const SizedBox(height: 14),
                            _infoRow(
                                _miniInfo(Icons.hotel_rounded, "Accommodation",
                                    enquiry.accommodationPreferences ?? '--'),
                                _miniInfo(
                                    Icons.train_sharp,
                                    'Transportation',
                                    enquiry.transportation == 'Sheared'
                                        ? "Sheared (${enquiry.shareCount} People)"
                                        : enquiry.transportation ?? '')),
                            const SizedBox(height: 14),
                            _infoRow(
                                _miniInfo(
                                    Icons.restaurant_rounded,
                                    'Meal Type',
                                    (enquiry.mealType != null &&
                                            enquiry.mealType!.isNotEmpty)
                                        ? enquiry.mealType ?? ''
                                        : '--'),
                                _miniInfo(
                                    Icons.lunch_dining_rounded,
                                    'Meals Per Day',
                                    (enquiry.mealsPerDay != null &&
                                            (enquiry.mealsPerDay ?? '')
                                                .isNotEmpty)
                                        ? enquiry.mealsPerDay ?? ''
                                        : "--")),
                            const SizedBox(height: 14),
                            _infoRow(
                              _miniInfo(Icons.public_rounded, "Region",
                                  enquiry.region ?? ''),
                              _miniInfo(Icons.flight_rounded, "Country Type",
                                  enquiry.countryType ?? ''),
                            ),
                            SizedBox(height: 14),
                            enquiry.countryType == 'MULTI'
                                ? _miniInfo(
                                    Icons.flag_rounded,
                                    "Countries",
                                    (enquiry.countries?.isNotEmpty ?? false)
                                        ? enquiry.countries!.join(', ')
                                        : '--')
                                : _infoRow(
                                    _miniInfo(
                                        Icons.flag_rounded,
                                        "Country",
                                        (enquiry.countries?.isNotEmpty ?? false)
                                            ? enquiry.countries!.join(', ')
                                            : '--'),
                                    _miniInfo(
                                        Icons.location_on_rounded,
                                        "Destinations",
                                        (enquiry.destinations?.isNotEmpty ??
                                                false)
                                            ? enquiry.destinations!.join(', ')
                                            : '--'),
                                  ),
                            SizedBox(height: 14),
                            _miniInfo(
                                Icons.note_alt_rounded,
                                'Special Request.',
                                (enquiry.specialRequests != null &&
                                        enquiry.specialRequests!.isNotEmpty)
                                    ? enquiry.specialRequests!
                                        .map((req) => req.request)
                                        .where((r) => r != null && r.isNotEmpty)
                                        .join(', ')
                                    : '--')
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Bids Section Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: btnColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(Icons.gavel_rounded,
                                color: btnColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Received Bids',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: greyColor,
                            ),
                          ),
                          if (enquiry.bids != null &&
                              enquiry.bids!.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: greenColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${enquiry.bids!.length}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: greenColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (enquiry.bids == [] || enquiry.bids!.isEmpty)
                        _buildEmptyBidsState()
                      else ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: enquiry.bids!.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (ctx, idx) {
                            final bid = enquiry.bids?[idx];
                            return _buildBidCard(bid, getEnquiryById);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
              if (bidStatus == Status.loading || acceptStatus == Status.loading)
                Container(
                  color: Colors.black.withOpacity(.15),
                  alignment: Alignment.center,
                  child: const SpinKitCircle(
                    color: btnColor,
                    size: 60,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyBidsState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: greyColor1.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.gavel_rounded,
              size: 40,
              color: greyColor1.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No bids yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: greyColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vendors will send their bids here. Check back later.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: greyColor1,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidCard(dynamic bid, Function getEnquiryById) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: btnColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: bid?.vendor?.vendorProfileImageUrl != null
                      ? Image.network(
                          bid?.vendor?.vendorProfileImageUrl ?? '',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _vendorAvatar(),
                        )
                      : _vendorAvatar(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bid?.vendor?.firstName ?? ""} ${bid?.vendor?.lastName ?? ""}'
                            .trim(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: greyColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bid?.vendor?.email ?? "",
                        style: GoogleFonts.inter(
                          color: greyColor1,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _modernStatusOrActions(
                  context: context,
                  bid: bid,
                  getEnquiryById: getEnquiryById,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: greenColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: greenColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${bid?.currency ?? ''} ${bid?.price ?? '--'}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: greenColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _bidInfoTile(Icons.hotel_rounded, "Accommodation",
                    bid?.accommodation ?? '--'),
                _bidInfoTile(
                    Icons.restaurant_rounded, "Meals", bid?.meals ?? '--'),
                _bidInfoTile(Icons.directions_car_rounded, "Transportation",
                    bid?.transportation ?? '--'),
                _bidInfoTile(
                    Icons.map_rounded, "Itinerary", bid?.itinerary ?? '--'),
                _bidInfoTile(
                    Icons.extension_rounded, 'Extras', bid?.extras ?? '--'),
                if (bid?.rejectionReason != null)
                  _bidInfoTile(Icons.info_outline_rounded, "Reason",
                      bid?.rejectionReason ?? '--'),
                _bidInfoTile(Icons.calendar_month_rounded, "Bid Date",
                    dateFormat(bid?.createdAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _vendorAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: btnColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.person_rounded, color: btnColor, size: 26),
    );
  }

  Widget _infoRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _miniInfo(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: btnColor.withOpacity(0.7)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                // maxLines: 1,
                // overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: greyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bidInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: btnColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: btnColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: btnColor, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: greyColor,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: greyColor1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernStatusOrActions({
    required BuildContext context,
    required dynamic bid,
    required Function getEnquiryById,
  }) {
    if (bid.accepted == true) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: greenColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: greenColor.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: greenColor, size: 18),
            const SizedBox(width: 6),
            Text(
              'Accepted',
              style: GoogleFonts.inter(
                color: greenColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    } else if (bid.rejected == true) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: redColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: redColor.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel_rounded, color: redColor, size: 18),
            const SizedBox(width: 6),
            Text(
              'Rejected',
              style: GoogleFonts.inter(
                color: redColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    } else {
      return Material(
          color: Colors.transparent,
          child: PopupMenuButton<String>(
            color: Colors.white,
            offset: const Offset(0, 48),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            padding: EdgeInsets.zero,
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: btnColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: btnColor.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Actions',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: btnColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      color: btnColor, size: 18),
                ],
              ),
            ),
            onSelected: (value) async {
              double taxsAmount =
                  taxAmount(double.tryParse(bid.price ?? '0') ?? 0, 5);
              double payableAmount = payAbleAmount(
                  double.tryParse(bid.price ?? '0') ?? 0, taxsAmount);

              if (value == 'accepted') {
                await context
                    .read<PaymentCreateOrderIdViewModel>()
                    .paymentCreateOrderIdViewModelApi(
                      amount: double.tryParse(bid.price ?? '0') ?? 0,
                      taxAmount: taxsAmount,
                      taxPercentage: 5,
                      discountAmount: 0,
                      totalPayableAmount: payableAmount,
                      currency: bid.currency ?? '',
                    )
                    .then((onValue) {
                  if (onValue?.status.httpCode == '200') {
                    PaymentService paymentService = PaymentService(
                      onPaymentError: (PaymentFailureResponse response) {},
                      onPaymentSuccess: (PaymentSuccessResponse response) {
                        debugPrint('paymentResponse#${response.orderId}');
                        Map<String, dynamic> body = {
                          "bidId": bid.id ?? 0,
                          "paymentId": response.paymentId ?? '',
                          "razorpayOrderId": response.orderId ?? '',
                          "razorpaySignature": response.signature ?? '',
                          "transactionStatus": 'Captured',
                          "vendorId": bid.vendor?.vendorId ?? 0,
                          "orderId": onValue?.data.orderId ?? '',
                          "bookingType": "BID_BOOKING"
                        };
                        context
                            .read<BidViewModel>()
                            .confirmBookingBidApi(body: body)
                            .then((onResp) {
                          if (onResp == true) {
                            Provider.of<PaymentVerifyViewModel>(context,
                                    listen: false)
                                .paymentVerifyViewModelApi(
                              context: context,
                              userId: bid.user?.userId.toString() ?? '',
                              venderId: bid.vendor?.vendorId.toString() ?? '',
                              paymentId: response.paymentId,
                              razorpayOrderId: response.orderId,
                              razorpaySignature: response.signature,
                            )
                                .then((value) {
                              if (value?.status.httpCode == '200') {
                                debugPrint(
                                    'payment verification is successful${value?.data.transactionId}');
                                context
                                    .read<BidViewModel>()
                                    .acceptOrRejectBidApi(
                                        bidId: bid.id ?? 0, accept: true)
                                    .then((_) => getEnquiryById());
                              }
                            });
                          }
                        });
                      },
                    );
                    paymentService.openCheckout(
                      coutryCode: bid.user?.countryCode ?? '',
                      mobileNo: bid.user?.mobile ?? '',
                      email: bid.user?.email ?? '',
                      razorpayOrderId: onValue?.data.razorpayOrderId ?? '',
                      payableAmount: payableAmount,
                      currency: bid.currency ?? '',
                    );
                  }
                });
              } else if (value == 'rejected') {
                await context
                    .read<BidViewModel>()
                    .acceptOrRejectBidApi(bidId: bid.id ?? 0, accept: false)
                    .then((_) => getEnquiryById());
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'accepted',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 20, color: greenColor),
                    const SizedBox(width: 12),
                    Text(
                      'Accept & Pay',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'rejected',
                child: Row(
                  children: [
                    Icon(Icons.cancel_rounded, size: 20, color: redColor),
                    const SizedBox(width: 12),
                    Text(
                      'Reject',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          )
    );
    }
  }
}

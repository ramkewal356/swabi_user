// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';

import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/core/services/payment_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        appBar: AppBar(
          title: const Text('View Bids Screen'),
          backgroundColor: background,
        ),
        child: Consumer<EnquiryViewModel>(
          builder: (context, vm, state) {
            if (vm.getEnquiryById.status == Status.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: greenColor,
                ),
              );
            } else {
              return Stack(
                children: [
                  Column(
                    children: [
                      Card(
                        color: background,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Travelers details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const Divider(),
                              Text(
                                  'Name : ${vm.getEnquiryById.data?.data?.name ?? 'N/A'}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                'Enquiry ID : ${vm.getEnquiryById.data?.data?.id ?? 'N/A'}',
                              ),
                              Text(
                                  "Budget : ${vm.getEnquiryById.data?.data?.currency} ${vm.getEnquiryById.data?.data?.budget ?? 'N/A'}"),
                              Text(
                                  'Enquiry Date : ${dateFormat(vm.getEnquiryById.data?.data?.createdAt)}'),
                              Text(
                                  'Travel Dates : ${vm.getEnquiryById.data?.data?.travelDates ?? 'N/A'}'),
                             
                              Text(
                                  "destination: ${vm.getEnquiryById.data?.data?.destinations?.join(' , ') ?? 'N/A'}"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child:
                              (vm.getEnquiryById.data?.data?.bids ?? []).isEmpty
                                  ? Center(
                                      child: Text(
                                        'No bids available',
                                        style: nodataTextStyle,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: vm.getEnquiryById.data?.data
                                          ?.bids?.length,
                                      itemBuilder: (context, index) {
                                        var bids = vm.getEnquiryById.data?.data
                                            ?.bids?[index];
                                        return Card(
                                          color: background,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: travelItem(
                                                            Icons.person,
                                                            '${bids?.vendor?.firstName ?? ''} ${bids?.vendor?.lastName ?? ''}')),
                                                    // If status is pending, show popup menu
                                                    if (bids?.accepted ==
                                                            false &&
                                                        bids?.rejected == false)
                                                      PopupMenuButton<String>(
                                                        color: background,
                                                        position:
                                                            PopupMenuPosition
                                                                .under,
                                                        onSelected: (value) {
                                                          double taxsAmount =
                                                              taxAmount(
                                                                  double.parse(
                                                                      bids?.price ??
                                                                          ''),
                                                                  5);
                                                          double payableAmount =
                                                              payAbleAmount(
                                                                  double.parse(
                                                                      bids?.price ??
                                                                          ''),
                                                                  taxsAmount);
                                                          if (value ==
                                                              'accepted') {
                                                            context
                                                                .read<
                                                                    PaymentCreateOrderIdViewModel>()
                                                                .paymentCreateOrderIdViewModelApi(
                                                                   
                                                                    amount: double.parse(
                                                                        bids?.price ??
                                                                            ''),
                                                                    // userId: bids
                                                                    //         ?.user
                                                                    //         ?.userId
                                                                    //         .toString() ??
                                                                    //     '',
                                                                    taxAmount:
                                                                        taxsAmount,
                                                                    taxPercentage:
                                                                        5,
                                                                    discountAmount:
                                                                        0,
                                                                    totalPayableAmount:
                                                                        payableAmount,
                                                                    currency:
                                                                        bids?.currency ??
                                                                            '')
                                                                .then(
                                                                    (onValue) {
                                                              if (onValue
                                                                      ?.status
                                                                      .httpCode ==
                                                                  '200') {
                                                                PaymentService
                                                                    paymentService =
                                                                    PaymentService(
                                                                  // context:
                                                                  //     context,
                                                                  onPaymentError:
                                                                      (PaymentFailureResponse
                                                                          response) {},
                                                                  onPaymentSuccess:
                                                                      (PaymentSuccessResponse
                                                                          response) {
                                                                    debugPrint(
                                                                        'paymentResponse#${response.orderId}');
                                                                    context
                                                                        .read<
                                                                            BidViewModel>()
                                                                        .confirmBookingBidApi(
                                                                            bidId: bids?.id ??
                                                                                0,
                                                                            paymentId: response.paymentId ??
                                                                                '',
                                                                            orderId: response.orderId ??
                                                                                '',
                                                                            signature: response.signature ??
                                                                                '',
                                                                            transactionStatus:
                                                                                'Captured',
                                                                            vendorId: bids?.vendor?.vendorId ??
                                                                                0)
                                                                        .then(
                                                                            (onResp) {
                                                                      if (onResp ==
                                                                          true) {
                                                                        Provider.of<PaymentVerifyViewModel>(context, listen: false)
                                                                            .paymentVerifyViewModelApi(
                                                                                context: context,
                                                                                userId: bids?.user?.userId.toString() ?? '',
                                                                                venderId: bids?.vendor?.vendorId.toString() ?? '',
                                                                                paymentId: response.paymentId,
                                                                                razorpayOrderId: response.orderId,
                                                                                razorpaySignature: response.signature)
                                                                            .then(
                                                                          (value) {
                                                                            if (value?.status.httpCode ==
                                                                                '200') {
                                                                              debugPrint('payment verification is successfull${value?.data.transactionId}');
                                                                              context.read<BidViewModel>().acceptOrRejectBidApi(bidId: bids?.id ?? 0, accept: true).then((onValue) {
                                                                                getEnquiryById();
                                                                              });
                                                                            }
                                                                          },
                                                                        );
                                                                      }
                                                                    });

                                                                    // Call verify payment function after successful payment
                                                                    // _verifyPayment(context, response);
                                                                  },
                                                                );
                                                                paymentService.openCheckout(
                                                                    coutryCode:
                                                                        bids?.user?.countryCode ??
                                                                            '',
                                                                    mobileNo: bids
                                                                            ?.user
                                                                            ?.mobile ??
                                                                        '',
                                                                    email: bids
                                                                            ?.user
                                                                            ?.email ??
                                                                        '',
                                                                    razorpayOrderId:
                                                                        onValue?.data.razorpayOrderId ??
                                                                            '',
                                                                    payableAmount:
                                                                        payableAmount,
                                                                    currency:
                                                                        bids?.currency ??
                                                                            '');
                                                              }
                                                            });
                                                          } else if (value ==
                                                              'rejected') {
                                                            context
                                                                .read<
                                                                    BidViewModel>()
                                                                .acceptOrRejectBidApi(
                                                                    bidId:
                                                                        bids?.id ??
                                                                            0,
                                                                    accept:
                                                                        false)
                                                                .then(
                                                                    (onValue) {
                                                              getEnquiryById();
                                                            });
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (context) => [
                                                          const PopupMenuItem(
                                                            value: 'accepted',
                                                            child: Text(
                                                              'Accept',
                                                              style: TextStyle(
                                                                  color:
                                                                      greenColor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          const PopupMenuItem(
                                                              value: 'rejected',
                                                              child: Text(
                                                                'Reject',
                                                                style: TextStyle(
                                                                    color:
                                                                        redColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )),
                                                        ],
                                                      )
                                                    else
                                                      // If status is accepted/rejected, show label
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              bids?.accepted ==
                                                                      true
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          bids?.accepted == true
                                                              ? 'Accepted'
                                                              : "Rejected",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                travelItem(Icons.calendar_today,
                                                    "Enquiry Date : ${dateFormat(bids?.createdAt)}"),
                                                const SizedBox(height: 8),
                                                travelItem(Icons.restaurant,
                                                    'Meals : ${bids?.meals ?? 'N/A'}'),
                                                const SizedBox(height: 8),
                                                travelItem(Icons.directions_bus,
                                                    'Transportation : ${bids?.transportation ?? 'N/A'}'),
                                                const SizedBox(height: 8),
                                                travelItem(Icons.attach_money,
                                                    'Price : ${bids?.currency} ${bids?.price ?? 'N/A'}'),
                                                const SizedBox(height: 8),
                                                travelItem(Icons.card_giftcard,
                                                    'Itinerary : ${bids?.itinerary ?? 'N/A'}'),
                                                const SizedBox(height: 8),
                                                travelItem(Icons.date_range,
                                                    'Extra : ${bids?.extras ?? 'N/A'}'),
                                                const SizedBox(height: 8),
                                                travelItem(Icons.hotel,
                                                    'Accommodation : ${bids?.accommodation ?? 'N/A'}'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                    ],
                  ),
                  if (bidStatus == Status.loading ||
                      acceptStatus == Status.loading)
                    const SpinKitCircle(
                      color: btnColor,
                      size: 60,
                    )
                ],
              );
            }
          },
        ));
  }

Widget travelItem(IconData? icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: btnColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

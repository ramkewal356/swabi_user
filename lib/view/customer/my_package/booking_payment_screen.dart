// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/services/payment_service.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/models/get_package_details_by_id_model.dart'
    hide Status;
import 'package:flutter_cab/data/models/payment_getway_model.dart' hide Status;
import 'package:flutter_cab/data/models/traveller_model.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/offer_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../data/response/status.dart';

class BookingPaymentScreen extends StatefulWidget {
  final String venderId;
  final String bookingId;
  final String bookingDate;
  final String primaryCountryCode;
  final String primaryNumber;
  final String? secondaryCountryCode;
  final String? secondaryNumber;
  final List<Traveller> memberDetails;
  final List<PackageActivity> packageActivityList;
  final double sumAmount;
  final double packageAmount;
  final String currency;
  const BookingPaymentScreen(
      {super.key,
      required this.venderId,
      required this.bookingId,
      required this.bookingDate,
      required this.primaryCountryCode,
      required this.primaryNumber,
      this.secondaryCountryCode,
      this.secondaryNumber,
      required this.sumAmount,
      required this.packageAmount,
      required this.memberDetails,
      required this.packageActivityList,
      required this.currency});

  @override
  State<BookingPaymentScreen> createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  final _formCouponKey = GlobalKey<FormState>();
  TextEditingController couponController = TextEditingController();
  FocusNode couponFocus = FocusNode();
  String? offerCode;
  double payAbleAmount = 0.0;
  double taxPercent = 5.0;
  double taxAmount = 0.0;
  double discountAmount = 0.0;
  double getDicountAmount(
      {required double disCountPer, required double maxDisAmount}) {
    double discount = (disCountPer / 100) * widget.sumAmount;
    if (discount > maxDisAmount) {
      discount = maxDisAmount;
    }
    return discount;
  }

  void _calculateAmount({double disCountPer = 0.0, double maxDisAmount = 0.0}) {
    discountAmount =
        getDicountAmount(disCountPer: disCountPer, maxDisAmount: maxDisAmount);
    var totalPayAmt = widget.sumAmount - discountAmount;
    taxAmount = (totalPayAmt * taxPercent) / 100;
    payAbleAmount = totalPayAmt + taxAmount;
  }

  Future<void> _onPayNow() async {
    final paymentVM = context.read<PaymentCreateOrderIdViewModel>();
    final bookingVM = context.read<GetPackageBookingByIdViewModel>();
    final verifyVM = context.read<PaymentVerifyViewModel>();
    final confirmVM = context.read<ConfirmPackageBookingViewModel>();

    final orderResp = await paymentVM.paymentCreateOrderIdViewModelApi(
        amount: widget.sumAmount,
        taxAmount: taxAmount,
        taxPercentage: taxPercent,
        discountAmount: discountAmount,
        totalPayableAmount: payAbleAmount,
        currency: widget.currency);

    if (orderResp?.status.httpCode != '200') return;

    final bookingResp = await bookingVM.fetchGetPackageBookingByIdViewModelApi(
      _bookingPayload(orderResp),
    );

    if (bookingResp?.status.httpCode != '200') return;

    _openPayment(
      orderResp: orderResp,
      email: bookingResp?.data.user.email ?? '',
      verifyVM: verifyVM,
      confirmVM: confirmVM,
    );
  }

  List<Map<String, dynamic>> get memberListPayload =>
      widget.memberDetails.map((e) => e.toPayloadJson()).toList();

  Map<String, dynamic> _bookingPayload(PaymentCreateOderIdModel? resp) => {
        "userId": resp?.data.userId,
        "packageId": widget.bookingId,
        "bookingDate": widget.bookingDate,
        "orderId": resp?.data.orderId,
        "vendorId": widget.venderId,
        "countryCode": widget.primaryCountryCode,
        "mobile": widget.primaryNumber,
        "alternateMobileCountryCode": (widget.secondaryNumber ?? '').isEmpty
            ? ''
            : widget.secondaryCountryCode,
        "alternateMobile": widget.secondaryNumber,
        "offerCode": offerCode,
        "discountAmount": discountAmount.toStringAsFixed(2),
        "numberOfMembers": widget.memberDetails.length.toString(),
        "memberList": memberListPayload,
        "packagePrice": widget.sumAmount.toStringAsFixed(2),
        "taxAmount": taxAmount.toInt().toStringAsFixed(2),
        "taxPercentage": taxPercent,
        "totalPayableAmount": payAbleAmount.round(),
        "currency": widget.currency
      };

  void _openPayment({
    required PaymentCreateOderIdModel? orderResp,
    required String email,
    required PaymentVerifyViewModel verifyVM,
    required ConfirmPackageBookingViewModel confirmVM,
  }) {
    PaymentService(
      onPaymentError: (_) {},
      onPaymentSuccess: (PaymentSuccessResponse res) async {
        final verifyResp = await verifyVM.paymentVerifyViewModelApi(
          context: context,
          userId: orderResp?.data.userId ?? '',
          venderId: widget.venderId,
          paymentId: res.paymentId,
          razorpayOrderId: res.orderId,
          razorpaySignature: res.signature,
        );

        if (verifyResp?.status.httpCode == '200') {
          confirmVM.confirmBooking(
            // ignore: use_build_context_synchronously
            context: context,
            packageBookingId: verifyResp?.data.bookingId ?? '',
            transactionId: verifyResp?.data.transactionId ?? '',
            userId: orderResp?.data.userId ?? '',
          );
        }
      },
    ).openCheckout(
        payableAmount: payAbleAmount,
        razorpayOrderId: orderResp?.data.razorpayOrderId ?? '',
        coutryCode: widget.primaryCountryCode,
        mobileNo: widget.primaryNumber,
        email: email,
        currency: widget.currency);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPackageOfferList();
    });
    _calculateAmount();
  }

  void _getPackageOfferList() {
    context.read<OfferViewModel>().getOfferByVenderApi(
        venderId: widget.venderId,
        date: widget.bookingDate,
        offerType: 'package_booking');
  }

  @override
  Widget build(BuildContext context) {
    var offerList =
        context
            .watch<OfferViewModel>()
            .getOfferListByVender
            .data
            ?.data
            ?.content ??
        [];
    var paymentStatus =
        context.watch<PaymentCreateOrderIdViewModel>().paymentOrderID.status;
    var bookingStatus = context
        .watch<GetPackageBookingByIdViewModel>()
        .getPackageBookingById
        .status;
    var verifyStatus =
        context.watch<PaymentVerifyViewModel>().paymentVerify.status;
    var confirmStatus = context
        .watch<ConfirmPackageBookingViewModel>()
        .getConfirmPackageBooking
        .status;
    final isLoading = paymentStatus == Status.loading ||
        bookingStatus == Status.loading ||
        verifyStatus == Status.loading ||
        confirmStatus == Status.loading;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: bgGreyColor,
        appBar: AppBar(
          title: Text('Payment screen'),
          backgroundColor: background,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _paymentSummaryCard(),
              Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: background,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border:
                        Border.all(color: naturalGreyColor.withOpacity(.3))),
                child: Form(
                  key: _formCouponKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Customtextformfield(
                              focusNode: couponFocus,
                              controller: couponController,
                              hintText: 'Coupon code',
                              readOnly: discountAmount > 0 ? true : false,
                              validator: (p0) {
                                if (widget.memberDetails.isEmpty) {
                                  return 'Please add members first';
                                } else if (p0 == null || p0.isEmpty) {
                                  return "Please enter offer coupon";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          discountAmount > 0
                              ? CustomButtonSmall(
                                  height: 45,
                                  width: 80,
                                  btnHeading: 'Remove',
                                  onTap: () {
                                    FocusScope.of(context).unfocus();

                                    // Optionally, unfocus specific fields
                                    couponFocus.unfocus();
                                    setState(() {
                                      discountAmount = 0;
                                      offerCode = null;
                                    });
                                    _calculateAmount();
                                  },
                                )
                              : CustomButtonSmall(
                                  height: 45,
                                  width: 80,
                                  btnHeading: 'Apply',
                                  onTap: () {
                                    if (_formCouponKey.currentState!
                                        .validate()) {
                                      context
                                          .read<OfferViewModel>()
                                          .validateOffer(
                                              context: context,
                                              offerCode: couponController.text,
                                              bookingType: 'PACKAGE_BOOKING',
                                              bookigAmount: widget.sumAmount)
                                          .then((onValue) {
                                        if (onValue?.status?.httpCode ==
                                            '200') {
                                          Utils.toastSuccessMessage(
                                              'Coupon applied successfully');
                                          offerCode = onValue?.data?.offerCode;
                                          _calculateAmount(
                                              disCountPer: onValue?.data
                                                      ?.discountPercentage ??
                                                  0,
                                              maxDisAmount: onValue?.data
                                                      ?.maxDiscountAmount ??
                                                  0);
                                        } else {
                                          setState(() {
                                            discountAmount = 0;
                                          });
                                        }
                                      });
                                    }
                                  },
                                )
                        ],
                      ),
                      // offerVisible
                      discountAmount > 0
                          ? Text(
                              'Congrats!  You have availed discount of ${widget.currency} ${discountAmount.toStringAsFixed(2)}.',
                              style: const TextStyle(color: greenColor),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: offerList.length,
                itemBuilder: (context, index) {
                  var offer = offerList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: OfferCard(
                      imageUrl: offer.imageUrl ?? '',
                      title: offer.offerName ?? '',
                      minimumBookingAmount:
                          offer.minimumBookingAmount.toString(),
                      discountPercentage:
                          offer.discountPercentage?.toInt().toString() ?? '0',
                      maxDiscountAmount: offer.maxDiscountAmount.toString(),
                      code: offer.offerCode ?? '',
                      description: offer.description ?? '',
                      endDate: offer.endDate ?? '',
                      termsAndConditions: offer.termsAndConditions ?? '',
                      maxCurrency: offer.maxCurrency ?? '',
                      minCurrency: offer.minCurrency ?? '',
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
            child: _payNowButton(
                loader: isLoading, onTap: isLoading ? null : _onPayNow)));
  }

  Widget _paymentSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          // _priceRow("Package Amount", widget.packageAmount),
          _priceRow("Total Amount", widget.sumAmount.toStringAsFixed(2),
              isShowCurrency: true),
          if (discountAmount > 0)
            _priceRow(
              "Discount",
              discountAmount.toStringAsFixed(2),
              isShowCurrency: true,
              isMinus: true,
              valueColor: Colors.green,
            ),
          _priceRow("Tax (5%)", taxAmount.toStringAsFixed(2),
              isShowCurrency: true, isPluse: true),

          const Divider(thickness: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payable Amount \n(Inclusive of taxes)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Column(
                children: [
                  Text('${widget.currency} ${payAbleAmount.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            decorationColor: greenColor,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5), // removes internal padding
                        minimumSize: Size(0, 0), // removes default height
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _showPaymentDailog,
                      child: Text(
                        'Show Details',
                        style: TextStyle(
                            color: greenColor, fontWeight: FontWeight.w600),
                      )),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String title,
    String value, {
    bool isShowCurrency = false,
    bool isMinus = false,
    bool isPluse = false,
    bool isBold = false,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            "${isPluse ? "+" : ""} ${isMinus ? "-" : ""} ${isShowCurrency ? widget.currency : ""} $value",
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _payNowButton({required VoidCallback? onTap, required bool loader}) {
    debugPrint('loader $loader');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            )
          ],
        ),
        child: loader
            ? const SpinKitWave(
                size: 15,
                duration: Duration(milliseconds: 500),
                color: background,
              )
            : Center(
                child: Text(
                'Pay Now • ${widget.currency} ${payAbleAmount.round()}',
                style:
                    TextStyle(color: background, fontWeight: FontWeight.w700),
              )),
      ),
    );
  }

  void _showPaymentDailog() {
    bool isVisible = false;
    int selectedIndex = -1;
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
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Details',
                        style: buttonText,
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
                  const Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.packageActivityList.length,
                    itemBuilder: (context, index) {
                      var data = widget.packageActivityList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            minVerticalPadding: 0,
                            minTileHeight: 5,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              data.activity?.activityName ?? '',
                              // style: selectedIndex == index
                              //     ? buttonText
                              //     : titleTextStyle,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: selectedIndex == index
                                      ? btnColor
                                      : blackColor),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  setstate(() {
                                    // isVisible = !isVisible;
                                    selectedIndex = index;
                                  });
                                },
                                icon: Icon(
                                  isVisible
                                      // ignore: dead_code
                                      ? Icons.keyboard_arrow_up_outlined
                                      : Icons.keyboard_arrow_down_outlined,
                                  color: selectedIndex == index
                                      ? btnColor
                                      : blackColor,
                                )),
                          ),
                          Visibility(
                            visible: selectedIndex == index,
                            child: Column(
                              children: [
                                data.activity?.participantType
                                            ?.contains('INFANT') ==
                                        true
                                    ? _priceRow(
                                        'Infant Discount',
                                        data.activity?.ageGroupDiscountPercent
                                                    ?.infant ==
                                                100
                                            ? 'Free'
                                            : data
                                                        .activity
                                                        ?.ageGroupDiscountPercent
                                                        ?.infant ==
                                                    0
                                                ? 'No Discount'
                                                : '${data.activity?.ageGroupDiscountPercent?.infant ?? 0} %')
                                    : const SizedBox.shrink(),
                                data.activity?.participantType
                                            ?.contains('CHILD') ==
                                        true
                                    ? _priceRow(
                                        'Child Discount',
                                        data.activity?.ageGroupDiscountPercent
                                                    ?.child ==
                                                100
                                            ? 'Free'
                                            : data
                                                        .activity
                                                        ?.ageGroupDiscountPercent
                                                        ?.child ==
                                                    0
                                                ? 'No Discount'
                                                : '${data.activity?.ageGroupDiscountPercent?.child ?? 0} %')
                                    : const SizedBox.shrink(),
                                data.activity?.participantType
                                            ?.contains('SENIOR') ==
                                        true
                                    ? _priceRow(
                                        "Senior Discount",
                                        data.activity?.ageGroupDiscountPercent
                                                    ?.senior ==
                                                100
                                            ? 'Free'
                                            : data
                                                        .activity
                                                        ?.ageGroupDiscountPercent
                                                        ?.senior ==
                                                    0
                                                ? 'No Discount'
                                                : '${data.activity?.ageGroupDiscountPercent?.senior ?? 0} %')
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                  const Divider(),
                  _priceRow(
                      "Package Amount", widget.packageAmount.toStringAsFixed(2),
                      isShowCurrency: true),
                  _priceRow("Subtotal", widget.sumAmount.toStringAsFixed(2),
                      isShowCurrency: true),
                  if (discountAmount > 0)
                    _priceRow("Discount", discountAmount.toStringAsFixed(2),
                        isShowCurrency: true,
                        valueColor: Colors.green,
                        isMinus: true),
                  _priceRow("Tax (5%)", taxAmount.toStringAsFixed(2),
                      isShowCurrency: true, isPluse: true),
                  const Divider(),
                  _priceRow(
                    "Payable Amount \n(Inclusive of taxes)",
                    '${payAbleAmount.ceil()}',
                    isShowCurrency: true,
                    isBold: true,
                  ),
                ],
              ),
            ));
          });
        });
  }
}

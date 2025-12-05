import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/offer_card.dart';
import 'package:provider/provider.dart';

class BookingPaymentScreen extends StatefulWidget {
  final String venderId;
  final String bookingDate;
  const BookingPaymentScreen(
      {super.key, required this.venderId, required this.bookingDate});

  @override
  State<BookingPaymentScreen> createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  final _formCouponKey = GlobalKey<FormState>();
  TextEditingController couponController = TextEditingController();
  FocusNode couponFocus = FocusNode();
  bool offerVisible = false;
  String? offerCode;
  double payAbleAmount = 500.0;
  double disCountPer = 0.0;
  double maxDisAmount = 0.0;
  double discountAmount = 0.0;
  double getPercentage() {
    double discount = (disCountPer / 100) * payAbleAmount;
    if (discount > maxDisAmount) {
      discount = maxDisAmount;
    }
    setState(() {
      discountAmount = discount;
    });
    return discount;
  }

  double disAmount = 0.0;
  List offerList = [];
  List members = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPackageOfferList();
    });
  }

  void _getPackageOfferList() {
    context.read<OfferViewModel>().getOfferByVenderApi(
        venderId: widget.venderId,
        date: widget.bookingDate,
        offerType: 'PACKAGE_BOOKING');
  }

  @override
  Widget build(BuildContext context) {
    var offerList =
        context.watch<OfferViewModel>().getOfferListByVender.data?.data ?? [];
    return PageLayoutPage(
        appBar: AppBar(
          title: Text('Payment screen'),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: background,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                      // ignore: deprecated_member_use
                      color: naturalGreyColor.withOpacity(.3))),
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
                            readOnly: offerVisible ? true : false,
                            validator: (p0) {
                              if (members.isEmpty) {
                                return 'Please add members first';
                              } else if (p0 == null || p0.isEmpty) {
                                return "Please enter offer coupon";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        offerVisible
                            ? CustomButtonSmall(
                                height: 45,
                                width: 80,
                                btnHeading: 'Remove',
                                onTap: () {
                                  FocusScope.of(context).unfocus();

                                  // Optionally, unfocus specific fields
                                  couponFocus.unfocus();
                                  setState(() {
                                    offerVisible = false;
                                    discountAmount = 0;
                                    disAmount = 0;
                                  });
                                },
                              )
                            : CustomButtonSmall(
                                height: 45,
                                width: 80,
                                btnHeading: 'Apply',
                                onTap: () {
                                  if (_formCouponKey.currentState!.validate()) {
                                    context
                                        .read<OfferViewModel>()
                                        .validateOffer(
                                            context: context,
                                            offerCode: couponController.text,
                                            bookingType: 'PACKAGE_BOOKING',
                                            bookigAmount: payAbleAmount)
                                        .then((onValue) {
                                      if (onValue?.status?.httpCode == '200') {
                                        Utils.toastSuccessMessage(
                                            onValue?.status?.message ?? '');
                                        offerCode = onValue?.data?.offerCode;
                                        disCountPer =
                                            onValue?.data?.discountPercentage ??
                                                0;
                                        maxDisAmount =
                                            onValue?.data?.maxDiscountAmount ??
                                                0;
                                        setState(() {
                                          offerVisible = true;
                                          discountAmount = getPercentage();
                                          debugPrint(
                                              'discountpercentage.....,..,.,$discountAmount');
                                        });
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
                    offerVisible
                        ? Text(
                            'Congrats!  You have availed discount of AED ${disAmount.toStringAsFixed(2)}.',
                            style: const TextStyle(color: greenColor),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: offerList.length,
              itemBuilder: (context, index) {
                var offer = offerList[index];
                return OfferCard(
                  imageUrl: offer.imageUrl ?? '',
                  title: offer.offerName ?? '',
                  minimumBookingAmount: offer.minimumBookingAmount.toString(),
                  discountPercentage:
                      offer.discountPercentage?.toInt().toString() ?? '0',
                  maxDiscountAmount: offer.maxDiscountAmount.toString(),
                  code: offer.offerCode ?? '',
                  description: offer.description ?? '',
                  endDate: offer.endDate ?? '',
                  termsAndConditions: offer.termsAndConditions ?? '',
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}

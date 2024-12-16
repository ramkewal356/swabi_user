import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view/dashboard/rental/book_your_ride_screen_.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:flutter_cab/view_model/services/payment_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CustomPaynowModal extends StatefulWidget {
  final double sumAmount;
  final String userId;
  final double taxAmount;
  final double taxPercentage;
  final double discountAmount;
  final double totalPayableAmount;
  final String date;
  final String pickUpTime;
  final String carType;
  final String kilometer;
  final String hour;
  final String lati;
  final String longi;
  final String price;
  final String pickUpLocation;
  final String offerCode;
  final String countryCode;
  final String mobile;
  final String email;

  const CustomPaynowModal(
      {super.key,
      required this.sumAmount,
      required this.userId,
      required this.taxAmount,
      required this.taxPercentage,
      required this.discountAmount,
      required this.totalPayableAmount,
      required this.date,
      required this.carType,
      required this.pickUpTime,
      required this.kilometer,
      required this.hour,
      required this.price,
      required this.pickUpLocation,
      required this.lati,
      required this.longi,
      required this.offerCode,
      required this.countryCode,
      required this.email,
      required this.mobile});

  @override
  State<CustomPaynowModal> createState() => _CustomPaynowModalState();
}

class _CustomPaynowModalState extends State<CustomPaynowModal> {
  int selectValue = 1;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();

  String countryCode = '';
  void bookRide() {
    String razorpayId = '';
    String bookingId = '';
    Provider.of<PaymentCreateOrderIdViewModel>(context, listen: false)
        .paymentCreateOrderIdViewModelApi(
      context: context,
      amount: widget.sumAmount,
      userId: widget.userId,
      taxAmount: widget.taxAmount,
      taxPercentage: widget.taxPercentage,
      discountAmount: widget.discountAmount,
      totalPayableAmount: widget.totalPayableAmount,
    )
        .then((onValue) {
      if (onValue?.status.httpCode == '200') {
        setState(() {
          razorpayId = onValue?.data.razorpayOrderId ?? '';
        });
        Map<String, dynamic> body = {
          "date": widget.date,
          "pickupTime": widget.pickUpTime,
          "bookerId": widget.userId,
          "bookingForId": selectValue == 1 ? widget.userId : '',
          "carType": widget.carType,
          "kilometers": widget.kilometer,
          "hours": widget.hour,
          "price": widget.price,
          "orderId": onValue?.data.orderId,
          "pickUpLocation": widget.pickUpLocation,
          "guestName": nameController.text,
          "countryCode": countryCode,
          "guestMobile": mobileController.text,
          "gender": genderController.text,
          "locationLatitude": widget.lati,
          "locationLongitude": widget.longi,
          "offerCode": widget.offerCode,
          "discountAmount": widget.discountAmount,
          "taxAmount": widget.taxAmount,
          "taxPercentage": widget.taxPercentage,
          "totalPayableAmount": widget.totalPayableAmount.ceil(),
        };
        Provider.of<RentalBookingViewModel>(
          context,
          listen: false,
        )
            .rentalBookingViewModel(
          context: context,
          body: body,
          userId: widget.userId,
        )
            .then((onValue) {
          if (onValue?.status.httpCode == '200') {
            setState(() {
              bookingId = onValue?.data.id ?? '';
            });
            PaymentService paymentService = PaymentService(
              context: context,
              onPaymentError: (PaymentFailureResponse response) {
                setState(() {
                  debugPrint(
                      'onpaymentfail status  ,,,,,,,,,,${response.message}${response.code}');
                });
              },
              onPaymentSuccess: (PaymentSuccessResponse response) {
                debugPrint('paymentResponse#${response.orderId}');
                Provider.of<PaymentVerifyViewModel>(context, listen: false)
                    .paymentVerifyViewModelApi(
                        context: context,
                        userId: widget.userId,
                        paymentId: response.paymentId,
                        razorpayOrderId: response.orderId,
                        razorpaySignature: response.signature)
                    .then(
                  (value) {
                    // if (!mounted) return;
                    // Navigator.pop(context);

                    if (value?.status.httpCode == '200') {
                      debugPrint(
                          'payment verification is successfull${value?.data.transactionId}');
                      // context.pop();
                      debugPrint(response.orderId);
                      debugPrint(
                        response.paymentId,
                      );
                      debugPrint(response.signature);

                      Provider.of<ConfirmRentalBookingViewModel>(context,
                              listen: false)
                          .confirmBookingViewModel(
                              context: context,
                              rentalId: bookingId,
                              transactionId: value?.data.transactionId ?? "",
                              userId: widget.userId);
                    }
                  },
                );
              },
            );
            paymentService.openCheckout(
                payableAmount: widget.totalPayableAmount,
                razorpayOrderId: razorpayId,
                coutryCode: widget.countryCode,
                mobileNo: widget.mobile,
                email: widget.email);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool bookingStatus =
        context.watch<ConfirmRentalBookingViewModel>().isLoading;
    bool orderStatus = context.watch<RentalBookingViewModel>().isLoading;
    print('object.......$bookingStatus');
    print('vnmnmnvmncmvnmc, $orderStatus');
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Confirm Booking',
                style: TextStyle(
                    color: btnColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: btnColor,
                  )),
            ],
          ),
          Text(
            "Please select for whom you booking",
            style: titleTextStyle,
          ),
          selectValue == 1
              ? Column(
                  children: [
                    RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: btnColor,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      value: 1,
                      groupValue: selectValue,
                      onChanged: (value) {
                        setState(() {
                          selectValue = value!;
                          countryCode = '';
                          nameController.text = '';
                          genderController.text = '';
                          mobileController.text = '';
                        });
                      },
                      title: Transform.translate(
                        offset: const Offset(-10, 0),
                        child: Text(
                          'Self',
                          style: titleTextStyle1,
                        ),
                      ),
                    ),
                    RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: btnColor,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      value: 2,
                      groupValue: selectValue,
                      onChanged: (value) {
                        setState(() {
                          selectValue = value!;
                          countryCode = '971';
                        });
                      },
                      title: Transform.translate(
                        offset: const Offset(-10,
                            0), // Adjust this value to move the title closer to the radio button
                        child: Text(
                          'Someone Else',
                          style: titleTextStyle1,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: btnColor,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        value: 1,
                        groupValue: selectValue,
                        onChanged: (value) {
                          setState(() {
                            selectValue = value!;
                            countryCode = '';
                            nameController.text = '';
                            genderController.text = '';
                            mobileController.text = '';
                          });
                        },
                        title: Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Text(
                            'Self',
                            style: titleTextStyle1,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: btnColor,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        value: 2,
                        groupValue: selectValue,
                        onChanged: (value) {
                          setState(() {
                            selectValue = value!;
                            countryCode = '971';
                          });
                        },
                        title: Transform.translate(
                          offset: const Offset(-10,
                              0), // Adjust this value to move the title closer to the radio button
                          child: Text(
                            'Someone Else',
                            style: titleTextStyle1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          selectValue == 2
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(text: 'Guest Name', style: titleTextStyle),
                        const TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: redColor,
                            ))
                      ])),
                      const SizedBox(
                        height: 5,
                      ),
                      Customtextformfield(
                        focusNode: focusNode1,
                        controller: nameController,
                        fillColor: background,
                        hintText: 'Enter your name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(text: 'Gender', style: titleTextStyle),
                        const TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: redColor,
                            ))
                      ])),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomDropdownButton(
                        focusNode: focusNode2,
                        itemsList: const ['Male', 'Female'],
                        hintText: 'Select gender',
                        controller: genderController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(text: 'Contact No', style: titleTextStyle),
                        const TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: redColor,
                            ))
                      ])),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomMobilenumber(
                          focusNode: focusNode3,
                          textLength: 9,
                          controller: mobileController,
                          hintText: 'Enter phone number',
                          fillColor: background,
                          countryCode: countryCode),
                    ],
                  ))
              : const SizedBox.shrink(),
          const SizedBox(height: 15),
          CustomButtonSmall(
              height: 45,
              loading: bookingStatus || orderStatus,
              btnHeading: 'PAY NOW',
              onTap: () {
                if (selectValue == 2) {
                  if (_formKey.currentState!.validate()) {
                    debugPrint('nmvcnvcmnvcvnn......');
                    bookRide();
                  }
                } else {
                  debugPrint('nmvcnvcmnvcvnn');
                  bookRide();
                }
              })
        ],
      ),
    );
  }
}

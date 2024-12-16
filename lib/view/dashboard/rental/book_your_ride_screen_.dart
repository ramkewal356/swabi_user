import 'package:flutter/material.dart';
import 'package:flutter_cab/model/rentalbooking_model.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_paynow_modal.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/res/custom_modal_bottom_sheet.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookYourCab extends StatefulWidget {
  final String carType;
  final String userId;
  final String bookingDate;
  final String totalAmt;
  final String logitude;
  final String latitude;

  const BookYourCab(
      {super.key,
      required this.carType,
      required this.userId,
      required this.logitude,
      required this.latitude,
      required this.bookingDate,
      required this.totalAmt});

  @override
  State<BookYourCab> createState() => _BookYourCabState();
}

class _BookYourCabState extends State<BookYourCab> {
  List<TextEditingController> controller =
      List.generate(9, (index) => TextEditingController());

  List rentalBooking = ['Self', "Someone Others"];
  TextEditingController checkControler = TextEditingController();
  TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RentalValidationViewModel>(context, listen: false)
          .fetchRentalValidationModelApi(context, {
        "date": widget.bookingDate,
        "userId": widget.userId,
        // "date":"01-06-2024",
        // "userId":"1001",
      });
      Provider.of<UserProfileViewModel>(context, listen: false)
          .fetchUserProfileViewModelApi(context, {'userId': widget.userId});
    });
  }

  bool isloading = false;
  // late BuildContext _savedContext;

  

  String? offerCode;
  double discountPercentage = 0;
  double discountedAmount = 0;
  bool visibleCoupon = false;
  double disAmount = 0;
  double taxPercentage = 5;
  double payableAmount = 0;
  double taxAmount = 0;
  double maxDisAmount = 0;
  double taxamount() {
    double amt = double.parse(widget.totalAmt);
    return (taxPercentage / 100) * amt;
    // return sumAmount + taxamt;
  }

  double getPercentage() {
    double amt = (discountPercentage / 100) * payableAmount;
    disAmount = amt > maxDisAmount ? maxDisAmount : amt;
    return payableAmount - disAmount.toInt();
  }

  int checkBox = 0;
  List<Body> rentalData = [];
  var rentalValidation, paymentOrderId;

  @override
  Widget build(BuildContext context) {
    debugPrint("${widget.userId}UserID");
    debugPrint("${widget.bookingDate} Booking Date");
    debugPrint("${widget.latitude} Booking latitude");
    debugPrint("${widget.logitude} Booking logitude");

    rentalData =
        context.watch<RentalViewModel>().DataList.data?.data.body ?? [];
    rentalValidation = context
        .watch<RentalValidationViewModel>()
        .DataList
        .data
        ?.status
        .message;
    taxAmount = taxamount();
    payableAmount = double.parse(widget.totalAmt) + taxAmount;
    debugPrint('fhjhjbdhdhjdhjdhjdjh${widget.totalAmt.toString()}');
    debugPrint('taxamount.......$taxAmount');
    debugPrint('payAbleamount.......$payableAmount');
    debugPrint('discountamount.......$disAmount');

    ProfileData? profileUser =
        context.watch<UserProfileViewModel>().DataList.data?.data;
    List<Body> filteredData =
        rentalData.where((rental) => rental.carType == widget.carType).toList();
    debugPrint(widget.carType);
    // debugPrint(paymentOrderId);
    String status = context
        .watch<ConfirmRentalBookingViewModel>()
        .rentalDataList
        .status
        .toString();
    return Scaffold(
      appBar: CustomAppBar(
        heading: "Book Your Ride",
        backBtnOnTap: () => context.pop(context),
      ),
      backgroundColor: bgGreyColor,
      body: ListView(
        // physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final rental = filteredData[index];

                return Stack(
                  children: [
                    BookingContainer(
                      carName: rental.carType,
                      carImage: rental.carImage,
                      seats: rental.seats,
                      hour: rental.hours,
                      kilometers: rental.kilometers,
                      pickDate: rental.date,
                      pickTime: rental.pickupTime,
                      pickUpLocation: rental.pickUpLocation,
                      // price: rental.price,
                      loading: false,
                      totalPrice: rental.totalPrice,
                      couponController: couponController,
                      discountedAmount: discountedAmount,
                      couponVisible: visibleCoupon,
                      offerDisAmount: disAmount,
                      taxAmount: taxAmount,
                      payableAmount: payableAmount,
                      onCouponRemoveTap: () {
                        setState(() {
                          visibleCoupon = false;
                          discountedAmount = 0;
                          disAmount = 0;
                        });
                      },
                      onCouponTap: () {
                        // double? amount = double.parse(rental.totalPrice);
                        // if (couponController.text.isEmpty) {
                        //   Utils.toastMessage('Please Enter Offer Coupon');
                        // } else {
                        Provider.of<OfferViewModel>(context, listen: false)
                            .validateOffer(
                                context: context,
                                offerCode: couponController.text,
                                bookingType: 'RENTAL_BOOKING',
                                bookigAmount: payableAmount)
                            .then((onValue) {
                          if (onValue?.status?.httpCode == '200') {
                            Utils.toastSuccessMessage(
                                onValue?.status?.message ?? '');
                            offerCode = onValue?.data?.offerCode;
                            maxDisAmount =
                                onValue?.data?.maxDiscountAmount ?? 0;
                            discountPercentage =
                                onValue?.data?.discountPercentage ?? 0;
                            setState(() {
                              visibleCoupon = true;
                              discountedAmount = getPercentage();
                              print(
                                  'discountpercentage.....,..,.,$discountedAmount');
                            });
                          } else {
                            setState(() {
                              discountedAmount = 0;
                            });
                          }
                        });
                        // }
                      },

                      confirmBooking: CustomModalbottomsheet(
                        title: 'CONFIRM BOOKING',
                        child: (rentalValidation.toString().isNotEmpty &&
                                rentalValidation == "Success")
                            ? CustomPaynowModal(
                                sumAmount: double.parse(rental.totalPrice),
                                discountAmount: disAmount,
                                taxAmount: taxAmount,
                                taxPercentage: taxPercentage,
                                totalPayableAmount: discountedAmount == 0
                                    ? payableAmount
                                    : discountedAmount,
                                carType: rental.carType,
                                date: rental.date,
                                userId: widget.userId,
                                price: rental.totalPrice,
                                hour: rental.hours,
                                kilometer: rental.kilometers,
                                offerCode: offerCode ?? '',
                                pickUpLocation: rental.pickUpLocation,
                                pickUpTime: rental.pickupTime,
                                lati: widget.latitude,
                                longi: widget.logitude,
                                countryCode: profileUser?.countryCode ?? '',
                                mobile: profileUser?.mobile ?? '',
                                email: profileUser?.email ?? '',
                              )
                            : showConfirmation(
                                context: context,
                                title: 'Booking Alert',
                                child: CustomPaynowModal(
                                  sumAmount: double.parse(rental.totalPrice),
                                  discountAmount: disAmount,
                                  taxAmount: taxAmount,
                                  taxPercentage: taxPercentage,
                                  totalPayableAmount: discountedAmount == 0
                                      ? payableAmount
                                      : discountedAmount,
                                  carType: rental.carType,
                                  date: rental.date,
                                  userId: widget.userId,
                                  price: rental.totalPrice,
                                  hour: rental.hours,
                                  kilometer: rental.kilometers,
                                  offerCode: offerCode ?? '',
                                  pickUpLocation: rental.pickUpLocation,
                                  pickUpTime: rental.pickupTime,
                                  lati: widget.latitude,
                                  longi: widget.logitude,
                                  countryCode: profileUser?.countryCode ?? '',
                                  mobile: profileUser?.mobile ?? '',
                                  email: profileUser?.email ?? '',
                                )),
                      ),

                      onTap: () {},
                    ),
                    // status == 'Status.loading'
                    //     ? Center(
                    //         child: Container(
                    //           height: 200,
                    //           width: 200,
                    //           decoration: BoxDecoration(
                    //               color: background,
                    //               borderRadius: BorderRadius.circular(10)),
                    //           child: const Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               SpinKitCircle(
                    //                 size: 60,
                    //                 color: btnColor,
                    //               ),
                    //               SizedBox(height: 10),
                    //               Text(
                    //                 'Please wait.....',
                    //                 style: TextStyle(color: greenColor),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     : const SizedBox()
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget showConfirmation(
      {required BuildContext context,
      required String title,
      required Widget child}) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
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
      backgroundColor: background,
      insetPadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      actionsPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Text(
          "You already have a booking on this date. Are you sure "
          "you want to proceed with this new booking?",
          textAlign: TextAlign.center,
          style: titleTextStyle1,
        ),
      ),
      actions: <Widget>[
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(color: btnColor),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
                child: Text(
              'No',
              style: titleTextStyle1,
            )),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        CustomModalbottomsheet(title: 'Yes', exit: true, child: child),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class BookingContainer extends StatefulWidget {
  final String carName;
  final String carImage;
  final String pickTime;
  final String pickDate;
  final String price;
  final String hour;
  final String seats;
  final String totalPrice;
  final String kilometers;
  final bool loading;
  final String pickUpLocation;
  final TextEditingController couponController;
  final VoidCallback onCouponTap;
  final VoidCallback onCouponRemoveTap;
  final bool couponVisible;
  final VoidCallback onTap;
  final double discountedAmount;
  final double offerDisAmount;
  final double taxAmount;
  final double payableAmount;
  final Widget confirmBooking;
  const BookingContainer(
      {this.carName = "",
      this.carImage = "",
      this.pickTime = "",
      this.pickDate = "",
      this.loading = false,
      this.hour = "",
      this.seats = "",
      this.price = "",
      this.totalPrice = "",
      this.kilometers = "",
      this.pickUpLocation = "",
      required this.couponController,
      required this.onTap,
      required this.onCouponTap,
      required this.onCouponRemoveTap,
      required this.couponVisible,
      required this.discountedAmount,
      required this.offerDisAmount,
      required this.taxAmount,
      required this.payableAmount,
      required this.confirmBooking,
      super.key});

  @override
  State<BookingContainer> createState() => _BookingContainerState();
}

class _BookingContainerState extends State<BookingContainer> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    debugPrint('payableAmount...............,,,, ${widget.payableAmount}');
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: naturalGreyColor.withOpacity(.3))),
            child: Column(

              children: [
                ///First Line of Design
                Container(
                    padding:
                        const EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 10),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: curvePageColor))),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 60,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: widget.carImage.isNotEmpty
                                  ? Image.network(
                                      widget.carImage,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      rentalCar1,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.carName,
                                    style: GoogleFonts.lato(
                                        color: greyColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "Seats : ${widget.seats}",
                                    style: GoogleFonts.lato(
                                        color: greyColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Hour : ${widget.hour}",
                                    style: GoogleFonts.lato(
                                        color: greyColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Date : ${widget.pickDate}",
                                    style: GoogleFonts.lato(
                                        color: greyColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )),

                ///Second Line Design
                Container(
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: curvePageColor))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          dense: true,
                          horizontalTitleGap: 10,
                          // contentPadding:
                          //     const EdgeInsets.symmetric(horizontal: 10),
                          leading: const Icon(Icons.edit_road),
                          title: Text(
                            "Kilometer",
                            style: titleText,
                          ),
                          subtitle:
                              Text('${widget.kilometers} KM', style: titleText),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          dense: true,
                          horizontalTitleGap: 10,
                          contentPadding: const EdgeInsets.only(left: 45),
                          leading: const Icon(Icons.lock_clock),
                          title: Text(
                            'Pickup Time',
                            style: titleText,
                          ),
                          subtitle: Text(
                            widget.pickTime,
                            style: titleText,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///Third Line Design
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: curvePageColor))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location : ",
                          style: titleText,
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            widget.pickUpLocation,
                            style: titleText,
                          ),
                        )
                       
                      ],
                    )),

                ///Forth Line Design
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rental Amount',
                            style: titleText,
                          ),
                          Text(
                            "AED ${widget.totalPrice}",
                            style: titleText,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax Amount  (5 %)',
                            style: titleText,
                          ),
                          Text(
                            "+ AED ${widget.taxAmount.toStringAsFixed(2)}",
                            style: titleText,
                          ),
                        ],
                      ),
                      widget.discountedAmount == 0
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount Amount',
                                  style: titleText,
                                ),
                                Text(
                                  "- AED ${widget.offerDisAmount}",
                                  style: titleText,
                                ),
                              ],
                            ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payable Amount ',
                            style: pageHeadingTextStyle,
                          ),
                          Text(
                            widget.discountedAmount == 0
                                ? 'AED ${widget.payableAmount.ceil()}'
                                : "AED ${widget.discountedAmount.ceil()}",
                            style: pageHeadingTextStyle,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "(Inclusive of Taxes)",
                          style: titleTextStyle1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: naturalGreyColor.withOpacity(.3))),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Customtextformfield(
                          controller: widget.couponController,
                          readOnly: widget.couponVisible ? true : false,
                          hintText: 'Coupon code',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter offer coupon';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      widget.couponVisible
                          ? CustomButtonSmall(
                              // disable: widget.couponVisible ?? false,
                              height: 45,
                              width: 80,
                              btnHeading: 'Remove',
                              onTap: widget.onCouponRemoveTap)
                          : CustomButtonSmall(
                              // disable: widget.couponVisible ?? false,
                              height: 45,
                              width: 80,
                              btnHeading: 'Apply',
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  widget.onCouponTap();
                                }
                              })
                    ],
                  ),
                  widget.couponVisible
                      ? Text(
                          'Congrats!  You have availed discount of AED ${widget.offerDisAmount.toInt()}.',
                          style: const TextStyle(color: greenColor),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          ///Benefits and Tax Details
          Material(
            elevation: 0,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: background,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: naturalGreyColor.withOpacity(.3))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      content:
                          "Cab and driver details will be shared up to 30 min prior to departure.",
                      fontSize: 16,
                      maxline: 2,
                      align: TextAlign.start,
                      fontWeight: FontWeight.w400,
                      textColor: textColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Material(
            elevation: 0,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: background,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: naturalGreyColor.withOpacity(.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                          content: "Estimated Fare",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w700,
                          textColor: textColor),
                      CustomText(
                          content: "AED ${widget.totalPrice}",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w600,
                          textColor: textColor),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      CustomText(
                          content: "Applied rate card",
                          fontSize: 16,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w700,
                          textColor: textColor),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          content:
                              "Base fare ${widget.hour} hr ${widget.kilometers} km",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w500,
                          textColor: textColor),
                      CustomText(
                          content: "AED ${widget.totalPrice}",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w600,
                          textColor: textColor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          content:
                              "Extra km fare after ${widget.kilometers} km",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w500,
                          textColor: textColor),
                      const CustomText(
                          content: "AED 15 / km",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w600,
                          textColor: textColor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          content:
                              "Extra ride time fare after ${widget.hour} hr",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w500,
                          textColor: textColor),
                      const CustomText(
                          content: "AED 3 / min",
                          fontSize: 16,
                          maxline: 2,
                          align: TextAlign.start,
                          fontWeight: FontWeight.w600,
                          textColor: textColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const CustomText(
                      maxline: 5,
                      align: TextAlign.start,
                      fontSize: 16,
                      textColor: blackColor,
                      content:
                          "Extra charges on exceeding package. GST and Toll, if applicable, will"
                          " be added to the bill. Please pay parking as and when required. "
                          "Base fare amount is the minimum bill amount a customer has to pay for package.")
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          widget.confirmBooking,
        
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

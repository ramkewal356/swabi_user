import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/model/get_all_bid_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../model/get_all_enquiry_model.dart' hide Status;

class BidNowScreen extends StatefulWidget {
  final EnquiryContent? enquiryData;
  final BidContent? bidData;
  const BidNowScreen({super.key, this.enquiryData, this.bidData});

  @override
  State<BidNowScreen> createState() => _BidNowScreenState();
}

class _BidNowScreenState extends State<BidNowScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();
  // final TextEditingController controller = TextEditingController();
  final TextEditingController mealsController = TextEditingController();
  final TextEditingController transportController = TextEditingController();
  final TextEditingController extrasController = TextEditingController();
  final TextEditingController accommodationController = TextEditingController();
  final TextEditingController itineraryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getBidById();
  }

  void getBidById() {
    if (widget.bidData != null) {
      // Editing existing bid → prefill fields
      priceController.text = widget.bidData?.price ?? '';
      mealsController.text = widget.bidData?.meals ?? '';
      transportController.text = widget.bidData?.transportation ?? '';
      extrasController.text = widget.bidData?.extras ?? '';
      accommodationController.text = widget.bidData!.accommodation ?? '';
      itineraryController.text = widget.bidData!.itinerary ?? '';
    }
    // String? bidId = widget.enquiryData?.id.toString();
    // if (bidId != null) {
    //   context.read<BidViewModel>().getBidByIdApi(bidId: bidId);
    // } else {
    //   Utils.toastMessage("Bid ID is null");
    // }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<EnquiryViewModel>().createBid.status;
    final bidStatus = context.watch<BidViewModel>().updateBid.status;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(widget.bidData == null ? "Enquiry Details" : "Bid Details"),
        backgroundColor: background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              /// Travel Inquiry Details Card
              Card(
                color: background,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Travel Inquiry Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      travelItem(Icons.person,
                          'Name : ${widget.enquiryData?.name ?? widget.bidData?.travelInquiry?.name ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      travelItem(Icons.calendar_today,
                          "Travel Date : ${widget.enquiryData?.travelDates ?? widget.bidData?.travelInquiry?.travelDates ?? 'N/A'}"),
                      const SizedBox(height: 8),
                      travelItem(Icons.restaurant,
                          'Meals : ${widget.enquiryData?.meals ?? widget.bidData?.travelInquiry?.meals ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      travelItem(Icons.directions_bus,
                          'Transportation : ${widget.enquiryData?.transportation ?? widget.bidData?.travelInquiry?.transportation ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      travelItem(Icons.attach_money,
                          'Budget : AED ${widget.enquiryData?.budget ?? widget.bidData?.travelInquiry?.budget ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      travelItem(Icons.card_giftcard,
                          'Special Requests : ${widget.enquiryData?.specialRequests ?? widget.bidData?.travelInquiry?.specialRequests ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      travelItem(Icons.date_range,
                          'Tentative Dates : ${widget.enquiryData?.tentativeDates ?? widget.bidData?.travelInquiry?.tentativeDates ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      travelItem(Icons.location_on,
                          'Destination : ${widget.enquiryData?.destinations?.join(',') ?? widget.bidData?.travelInquiry?.destinations?.join(',') ?? 'N/A'}'),
                      const SizedBox(height: 8),
                      travelItem(Icons.hotel,
                          'Accommodation : ${widget.enquiryData?.accommodationPreferences ?? widget.bidData?.travelInquiry?.accommodationPreferences ?? 'N/A'}'),
                      const SizedBox(height: 16),
                      const Text("User Information",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: btnColor,
                            child: ClipOval(
                                child: Image.network(
                                    widget.enquiryData?.user?.profileImageUrl ??
                                        widget.bidData?.travelInquiry?.user
                                            ?.profileImageUrl ??
                                        'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                    height: 60,
                                    width: 60,
                                    errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person,
                                  size: 40, color: Colors.white);
                            })),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${widget.enquiryData?.user?.firstName ?? widget.bidData?.travelInquiry?.user?.firstName ?? 'N/A'} ${widget.enquiryData?.user?.lastName ?? widget.bidData?.travelInquiry?.user?.lastName ?? 'N/A'}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                // Text(
                                //     "Country: ${widget.enquiryData?.user?.country ?? 'N/A'}"),
                                // Text(
                                //     "State: ${widget.enquiryData?.user?.state ?? 'N/A'}"),
                                Text(
                                    "Address: ${widget.enquiryData?.user?.address ?? widget.bidData?.travelInquiry?.user?.address ?? 'N/A'}"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Submit Bid Card
              Card(
                color: background,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.bidData == null
                                ? "Submit Your Bid"
                                : "Update Your Bid",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const Divider(),
                        const SizedBox(height: 10),
                        Customtextformfield(
                          controller: priceController,
                          hintText: '',
                          lable: 'Price (AED) *',
                          // prefixiconvisible: true,
                          prefixIcon: const Icon(
                            Icons.monetization_on,
                            color: btnColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Customtextformfield(
                          controller: mealsController,
                          hintText: '',
                          lable: 'Meals *',
                          prefixIcon: const Icon(
                            Icons.restaurant,
                            color: btnColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter meals';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Customtextformfield(
                          controller: transportController,
                          hintText: '',
                          lable: 'Transportation *',
                          prefixIcon: const Icon(
                            Icons.directions_bus,
                            color: btnColor,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter transportation details';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Customtextformfield(
                            controller: extrasController,
                            hintText: '',
                            lable: 'Extras',
                            prefixIcon: const Icon(
                              Icons.card_giftcard,
                              color: btnColor,
                            )),
                        const SizedBox(height: 10),
                        Customtextformfield(
                            controller: accommodationController,
                            hintText: '',
                            lable: 'Accommodation',
                            prefixIcon: const Icon(
                              Icons.hotel,
                              color: btnColor,
                            ),
                            maxLines: 2),
                        const SizedBox(height: 10),
                        Customtextformfield(
                          controller: itineraryController,
                          hintText: '',
                          lable: 'Itinerary *',
                          prefixIcon: const Icon(
                            Icons.list,
                            color: btnColor,
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter itinerary details';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomButtonSmall(
                          loading: status == Status.loading ||
                              bidStatus == Status.loading,
                          btnHeading: widget.bidData == null
                              ? 'Submit Bid'
                              : "Update Bid",
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (widget.bidData == null) {
                                context
                                    .read<EnquiryViewModel>()
                                    .createBidApi(
                                      travelEnquiryId:
                                          widget.enquiryData?.id ?? 0,
                                      price: priceController.text,
                                      accommodation:
                                          accommodationController.text,
                                      meals: mealsController.text,
                                      transportation: transportController.text,
                                      extra: extrasController.text,
                                      itinerary: itineraryController.text,
                                    )
                                    .then((onValue) {
                                  context.pop();
                                });
                              } else {
                                context
                                    .read<BidViewModel>()
                                    .updateBidApi(
                                      bidId: widget.bidData?.id ?? 0,
                                      price: priceController.text,
                                      accommodation:
                                          accommodationController.text,
                                      meals: mealsController.text,
                                      transportation: transportController.text,
                                      extra: extrasController.text,
                                      itinerary: itineraryController.text,
                                    )
                                    .then((onValue) {
                                  context.pop();
                                });
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  travelItem(IconData? icon, String title) {
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

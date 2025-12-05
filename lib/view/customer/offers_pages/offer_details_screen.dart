// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:provider/provider.dart';

class OfferdetailsScreen extends StatefulWidget {
  final String offerId;
  const OfferdetailsScreen({super.key, required this.offerId});

  @override
  State<OfferdetailsScreen> createState() => _OfferdetailsScreenState();
}

class _OfferdetailsScreenState extends State<OfferdetailsScreen> {
  bool isCopied = false;
  // Function to copy the text to the clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      setState(() {
        isCopied = true;
      });
      // Optionally reset "Copied" text after a few seconds
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isCopied = false;
        });
      });
    });
  }

  // final List<String> terms = [
  //   "ffgffjgfjf",
  //   "gfhghdbmnbjhkdjjhnmdbjk nmkjkjbnhjkjkjh hkjjdjkdjkjdkj nkjkkjdjkj bjdkj",
  //   "gfg",
  //   "jagrthewr",
  // ];
  @override
  void initState() {
    getOfferDetails();
    super.initState();
  }

  void getOfferDetails() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<OfferViewModel>()
          .getOfferDetailsApi(offerId: widget.offerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferViewModel>(
      builder: (context, viewModel, child) {
        String termConditions =
            """${viewModel.getOfferDetails.data?.data?.termsAndConditions}""";
        // final document = html_parser.parse(termConditions);
        // final List<String> termsList = [
        //   ...document.getElementsByTagName('p').map((p) => p.text.trim()),
        //   ...document.getElementsByTagName('li').map((li) => li.text.trim()),
        // ];
        final List<String> termsList =
            termConditions.split(RegExp(r'\n')).map((e) => e.trim()).toList();
        var data = viewModel.getOfferDetails.data?.data;
        return Scaffold(
          appBar: const CustomAppBar(
            heading: 'Offer Details',
          ),
          body: PageLayoutPage(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: naturalGreyColor.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(5)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            data?.imageUrl ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS23qSvFQm2bH4nUAwxBk7ZzBQm5Qi__4imxg&s',
                            // fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data?.offerType ==
                                  'PACKAGE_BOOKING'
                              ? "PACKAGE OFFER"
                              : "RENTAL OFFER",
                          style: textTitleHeading,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${data?.offerName}',
                        style: pageHeadingTextStyle,
                      ),
                      Text(
                        'Save up to AED ${data?.maxDiscountAmount?.toInt()} on ${data?.offerType == 'RENTAL_BOOKING' ? 'RENTAL BOOKING' : "PACKAGE BOOKING"}',
                        style: titleTextStyle1,
                      ),
                      Text(
                        'Min booking AED ${data?.minimumBookingAmount?.toInt()}',
                        style: titleTextStyle1,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: offerTile(
                                lable: 'Expire on ',
                                value:
                                    '${data?.endDate}'),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isCopied
                                    ? const Text(
                                        'Copied',
                                        style: TextStyle(color: Colors.green),
                                      )
                                    : Text(
                                        data
                                                ?.offerCode ??
                                            '',
                                        style: titleTextStyle,
                                      ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    copyToClipboard(data
                                            ?.offerCode ??
                                        '');
                                  },
                                  child: isCopied
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : const Icon(Icons.copy),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Description :-',
                        style: titleTextStyle,
                      ),
                      Text(
                        data?.description ?? '',
                        // style: titleTextStyle1,
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Terms & Conditions :-',
                        style: titleTextStyle,
                      ),
                      Column(
                        children: termsList.map((e) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  e,
                                  style: titleTextStyle1,
                                ),
                              ))
                            ],
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }

  Widget offerTile({required String lable, required String value}) {
    return Row(
      children: [
        Text(
          lable,
          style: titleTextStyle,
        ),
        Text(
          ':',
          style: titleTextStyle,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: titleTextStyle1,
        )
      ],
    );
  }
}

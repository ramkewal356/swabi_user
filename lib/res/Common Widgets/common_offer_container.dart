import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/model/offer_list_model.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommonOfferContainer extends StatefulWidget {
  final String bookingType;
  const CommonOfferContainer({super.key, required this.bookingType});

  @override
  State<CommonOfferContainer> createState() => _CommonOfferContainerState();
}

class _CommonOfferContainerState extends State<CommonOfferContainer> {
  final ScrollController _scrollController = ScrollController();
  DateTime dateTime = DateTime.now();
  String uId = '';
  int selectIndex = -1;
  int initialIndex = 0;
  OfferListModel? offerListData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OfferViewModel>(context, listen: false).getOfferList(
          context: context,
          date: DateFormat('dd-MM-yyyy').format(dateTime),
          bookingType: widget.bookingType);
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double offset = _scrollController.offset;
    int newIndex = (offset / 310)
        .round(); // Adjust this divisor based on card width and padding
    if (newIndex != initialIndex) {
      setState(() {
        initialIndex = newIndex;
        print('indexvalue $initialIndex');
      });
    }
  }

  bool isCopied = false; // To manage the "Copied" text visibility

  // Function to copy the text to the clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      setState(() {
        isCopied = true;
      });
      // Optionally reset "Copied" text after a few seconds
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isCopied = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    offerListData = context.watch<OfferViewModel>().offerListModel;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ///Top Offer Container
          (offerListData?.data ?? []).isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        content: "TRENDING OFFERS",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      CommonContainer(
                        color: bgGreyColor,
                        onTap: () {
                          context.push('/allOffer', extra: {
                            "initialIndex":
                                widget.bookingType == 'PACKAGE_BOOKING' ? 1 : 0
                          }).then((onValue) {
                            Provider.of<OfferViewModel>(context, listen: false)
                                .getOfferList(
                                    context: context,
                                    date: DateFormat('dd-MM-yyyy')
                                        .format(dateTime),
                                    bookingType: widget.bookingType);
                          });
                        },
                        elevation: 0,
                        borderRadius: BorderRadius.circular(0),
                        child: const CustomText(
                          content: "View all",
                          textColor: greenColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          (offerListData?.data ?? []).isNotEmpty
              ? SizedBox(
                  height: 160,
                  child: ListView.separated(
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: offerListData?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = offerListData?.data?[index];
                      return GestureDetector(
                        onTap: () {
                          Provider.of<OfferViewModel>(context, listen: false)
                              .getOfferDetails(
                                  context: context,
                                  offerId: data?.offerId ?? 0);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 300,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Colors.pinkAccent,
                              Colors.purpleAccent
                            ]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 100,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: background, width: 2)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data?.imageUrl ??
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTePpXbUcvlhV4a1px1UFFfXeZWZANowRWZXw&s',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data?.offerName}',
                                    style: const TextStyle(
                                        color: background,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    child: Text(
                                      data?.offerType == 'RENTAL_BOOKING'
                                          ? 'Rental Offer'
                                          : 'Package Offer',
                                      style: const TextStyle(
                                          color: background,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Valid till : ${data?.endDate}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Container(
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: background,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        isCopied && selectIndex == index
                                            ? const Text(
                                                'Copied',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            : Text(
                                                data?.offerCode ?? '',
                                                style: titleTextStyle,
                                              ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectIndex = index;
                                            });
                                            copyToClipboard(
                                                data?.offerCode ?? '');
                                          },
                                          child:
                                              isCopied && selectIndex == index
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
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                  ),
                )
              : Container(),
          (offerListData?.data ?? []).isNotEmpty
              ? const SizedBox(height: 10)
              : const SizedBox(),
          (offerListData?.data ?? []).isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate((offerListData?.data ?? []).length,
                      (index) {
                    return AnimatedContainer(
                      height: initialIndex == index ? 12 : 10,
                      width: initialIndex == index ? 20 : 10,
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black12,
                              strokeAlign: BorderSide.strokeAlignOutside),
                          borderRadius: BorderRadius.circular(5),
                          // shape: initialIndex == index
                          //     ? BoxShape.rectangle
                          //     : BoxShape.circle,
                          color:
                              initialIndex == index ? redColor : Colors.white),
                    );
                  }),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

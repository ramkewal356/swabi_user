import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlloffersScreen extends StatefulWidget {
  final int? initialIndex;
  const AlloffersScreen({super.key, this.initialIndex});

  @override
  State<AlloffersScreen> createState() => _AlloffersScreenState();
}

class _AlloffersScreenState extends State<AlloffersScreen>
    with SingleTickerProviderStateMixin {
  bool isCopied = false; // To manage the "Copied" text visibility
  DateTime dateTime = DateTime.now();
  List<String> tabList = ['Rental Offers', 'Package Offers'];
  TabController? _tabController;
  int _intialIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _intialIndex = widget.initialIndex ?? _intialIndex;

    _tabController = TabController(
        length: tabList.length, vsync: this, initialIndex: _intialIndex);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Provider.of<OfferViewModel>(context, listen: false).getOfferList(
      //     context: context,
      //     date: DateFormat('dd-MM-yyyy').format(dateTime),
      //     bookingType: 'ALL');
      getOfferList();
    });
    _tabController?.addListener(() {
      _intialIndex = _tabController?.index ?? 0;
      // setState(() {
      //   currentPage = 0;
      //   allRaiseList.clear();
      //   isLastPage = false;
      // });
      getOfferList();
    });
  }

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

  void getOfferList() async {
    String bookingType = tabList[_intialIndex] == 'Rental Offers'
        ? 'RENTAL_BOOKING'
        : tabList[_intialIndex] == 'Package Offers'
            ? 'PACKAGE_BOOKING'
            : "ALL";
    try {
      await Provider.of<OfferViewModel>(context, listen: false).getOfferList(
          context: context,
          date: DateFormat('dd-MM-yyyy').format(dateTime),
          bookingType: bookingType);
    } catch (e) {
      debugPrint('error $e');
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();

    super.dispose();
  }

  int selectIndex = -1;
  String coupne = 'xzcxvcvbbvb';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        heading: 'All Offers',
      ),
      body: PageLayout_Page(
        child: Column(
          children: [
            TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                // indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: btnColor),
                    color: btnColor),
                tabAlignment: TabAlignment.fill,
                labelPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                // indicatorPadding: EdgeInsets.zero,
                // indicatorWeight: 2.5,
                indicatorColor: btnColor,
                labelColor: background,
                dividerColor: Colors.transparent,
                unselectedLabelColor: blackColor,
                controller: _tabController,
                tabs: List.generate(
                  tabList.length,
                  (index) {
                    return Tab(
                        child: Text(
                      tabList[index].toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ));
                  },
                )),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: List.generate(
                    tabList.length,
                    (index) {
                      return Consumer<OfferViewModel>(
                          builder: (context, viewModel, child) {
                        return viewModel.isLoading1
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: greenColor,
                              ))
                            : (viewModel.offerListModel?.data ?? []).isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        viewModel.offerListModel?.data?.length,
                                    itemBuilder: (context, index) {
                                      var data = viewModel
                                          .offerListModel?.data?[index];
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   data?.offerName ?? '',
                                            //   style: titleTextStyle,
                                            // ),
                                            // const SizedBox(height: 10),
                                            Container(
                                              width: double.infinity,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: naturalGreyColor
                                                          .withOpacity(0.3)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                  data?.imageUrl ??
                                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS23qSvFQm2bH4nUAwxBk7ZzBQm5Qi__4imxg&s',
                                                  // fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    data?.offerType ==
                                                            'PACKAGE_BOOKING'
                                                        ? "PACKAGE OFFER"
                                                        : "RENTAL OFFER",
                                                    style: textTitleHeading,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      isCopied &&
                                                              selectIndex ==
                                                                  index
                                                          ? const Text(
                                                              'Copied',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : Text(
                                                              data?.offerCode ??
                                                                  '',
                                                              style:
                                                                  titleTextStyle,
                                                            ),
                                                      const SizedBox(width: 20),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectIndex = index;
                                                          });
                                                          copyToClipboard(
                                                              data?.offerCode ??
                                                                  '');
                                                        },
                                                        child: Row(
                                                          children: [
                                                            isCopied &&
                                                                    selectIndex ==
                                                                        index
                                                                ? const Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : const Icon(
                                                                    Icons.copy)
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${data?.offerName}',
                                              style: textTitleHeading,
                                            ),
                                            Text(
                                              'Save up to AED ${data?.maxDiscountAmount?.toInt()}',
                                              style: titleTextStyle1,
                                            ),
                                            Text(
                                              'Min booking AED ${data?.minimumBookingAmount?.toInt()}',
                                              style: titleTextStyle1,
                                            ),
                                            // const SizedBox(height: 10),

                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    'Expire on : ${data?.endDate}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                CustomButtonSmall(
                                                    height: 40,
                                                    width: 120,
                                                    loading: viewModel
                                                            .isLoading &&
                                                        selectIndex == index,
                                                    btnHeading: 'View Details',
                                                    onTap: () {
                                                      setState(() {
                                                        selectIndex = index;
                                                      });
                                                      // context.push('/offerDetails');
                                                      viewModel.getOfferDetails(
                                                          context: context,
                                                          offerId:
                                                              data?.offerId ??
                                                                  0);
                                                    })
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Text(
                                      'No Offers Available',
                                      style: nodataTextStyle,
                                    ),
                                  );
                      });
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}

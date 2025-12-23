// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/offer_card.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
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
    super.initState();
    _intialIndex = widget.initialIndex ?? _intialIndex;

    _tabController = TabController(
        length: tabList.length, vsync: this, initialIndex: _intialIndex);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getOfferList();
    });
    _tabController?.addListener(() {
      _intialIndex = _tabController?.index ?? 0;

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

  int? selectIndex;
  String coupne = 'xzcxvcvbbvb';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        heading: 'All Offers',
      ),
      body: PageLayoutPage(
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
                                      var offer = viewModel
                                          .offerListModel?.data?[index];
                                      return OfferCard(
                                        imageUrl: offer?.imageUrl ?? '',
                                        title: offer?.offerName ?? '',
                                        minimumBookingAmount: offer
                                                ?.minimumBookingAmount
                                                .toString() ??
                                            "",
                                        discountPercentage: offer
                                                ?.discountPercentage
                                                ?.toInt()
                                                .toString() ??
                                            '0',
                                        maxDiscountAmount: offer
                                                ?.maxDiscountAmount
                                                .toString() ??
                                            "",
                                        code: offer?.offerCode ?? '',
                                        description: offer?.description ?? '',
                                        endDate: offer?.endDate ?? '',
                                        termsAndConditions:
                                            offer?.termsAndConditions ?? '',
                                        maxCurrency: offer?.maxCurrency ?? '',
                                        minCurrency: offer?.minCurrency ?? '',
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

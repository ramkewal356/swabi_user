// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/models/get_all_enquiry_model.dart';
import 'package:flutter_cab/view/vendor/enquiry_management/bid_now_screen.dart';
import 'package:flutter_cab/view_model/wallet_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/gradient_button.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/no_data_found_widget.dart';
import 'package:flutter_cab/widgets/custom_filter_popup_widget.dart';
import 'package:flutter_cab/widgets/custom_search_field.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class EnquiryManagementScreen extends StatefulWidget {
  final String? userId;
  const EnquiryManagementScreen({super.key, this.userId});

  @override
  State<EnquiryManagementScreen> createState() =>
      _EnquiryManagementScreenState();
}

class _EnquiryManagementScreenState extends State<EnquiryManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Map<String, String> bidFilter = {
    "All": '',
    "Bid Sent": 'true',
    "Not Bid Sent": 'false',
  };
  String title = "All";
  String? _selectedbidding;
  String searchText = '';
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllEnquirys(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllEnquirys({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<EnquiryViewModel>().getAllEnquiryApi(
          isFilter: isFilter,
          isSearch: isSearch,
          isPagination: isPagination,
          searchText: searchText,
          filterText: _selectedbidding ?? '',
        userId: widget.userId ?? ''
        );
    debugPrint("Fetching all bids");
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllEnquirys(isSearch: true, isFilter: false, isPagination: false);
    });
    // Handle search logic here
    debugPrint("Search value: $value");
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _selectedbidding = value;
      // Handle filter logic here
      debugPrint("Selected urgency: $_selectedbidding");
    });
    _getAllEnquirys(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllEnquirys(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayoutPage(
      bgColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          "Enquiry Management",
          style: appBarTitleStyle,
        ),
        backgroundColor: background,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  filled: true,
                  fillColor: Colors.white,
                  focusNode: _searchFocus,
                  controller: _searchController,
                  serchHintText: 'Search by name or email',
                  // prefixIcon: const Icon(Icons.search),
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(width: 10),
              CustomFilterPopupWidget(
                  title: title,
                  filterOptions: bidFilter,
                  onFilterChanged: _onFilterChanged),
            ],
          ),
          Expanded(
            child: Consumer<EnquiryViewModel>(
              builder: (context, vm, state) {
                if (vm.bidData.status == Status.loading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: greenColor,
                  ));
                } else if (vm.bidData.status == Status.error) {
                  return NoDataFoundWidget(
                    text: 'No enquiry data found',
                  );
                } else if (vm.bidData.data == null ||
                    vm.bidData.data!.isEmpty) {
                  return Center(
                      child: Column(
                    children: [
                      Icon(Icons.upload_rounded),
                      Text(
                        'No bids found',
                        style: nodataTextStyle,
                      ),
                    ],
                  ));
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: (vm.bidData.data ?? []).length +
                        (vm.isLastPage
                            ? 0
                            : 1), // Replace with your data length
                    itemBuilder: (context, index) {
                      if (index == vm.bidData.data?.length) {
                        // Show loading indicator at the end if more data is being loaded
                        if (vm.isLoadingMore) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: greenColor,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                      var enquiryData = vm.bidData.data?[index];
                      return premiumEnquiryCard(enquiryData!);
                     
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget premiumEnquiryCard(EnquiryContent enquiryData) {
    final bool isMulti = (enquiryData.countries?.length ?? 0) > 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF4F6FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: btnColor,
            backgroundImage: enquiryData.user?.profileImageUrl != null
                ? NetworkImage(enquiryData.user!.profileImageUrl!)
                : null,
            child: enquiryData.user?.profileImageUrl == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          title: Text(
            "${enquiryData.name}  #${enquiryData.id}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              /// Budget Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: btnColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${enquiryData.currency} ${enquiryData.budget}",
                  style: TextStyle(
                      fontSize: 12,
                      color: btnColor,
                      fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 6),

              /// Destination
              Row(
                children: [
                  const Icon(Icons.public, size: 14),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      getDestinationText(enquiryData),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (isMulti)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Multi",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ],
          ),
          trailing: enquiryData.bidPlacedByVendor == true
              ? _statusBadge("Bid Sent", Colors.green)
              // : _premiumBidButton(enquiryData),
              : GradientButton(
                                      icon: Icons.monetization_on_outlined,
                                      onPressed: () {
                    if (enquiryData.show == true) {
                                          context
                                              .push(
                                            '/vendor_dashboard/bidNow',
                                            extra: BidNowScreen(
                                              enquiryData: enquiryData,
                                            ),
                                          )
                                              .then((onValue) {
                                            // Refresh the enquiry list after bid creation
                                            _getAllEnquirys(
                                              isFilter: true,
                                              isSearch: false,
                                              isPagination: false,
                                            );
                                          });
                                        } else {
                                          showPaymentConfirmationModal(
                                              payableAmount:
                                                  enquiryData.viewAmount ?? 0,
                          enquiryId: enquiryData.id ?? 0,
                                              enquiryData: enquiryData);
                                        }
                                      },
                                      label: 'Bid Now',
                                    ),
                             
          children: [
            _premiumDetailItem("Region", enquiryData.region ?? "NA"),
            _premiumDetailItem(
                "Accommodation", enquiryData.accommodationPreferences ?? "NA"),
            _premiumDetailItem("MealsType", enquiryData.mealType ?? 'NA'),
            _premiumDetailItem("MealsPerDay", enquiryData.mealsPerDay ?? 'NA'),
            if (enquiryData.travelDates != null &&
                enquiryData.travelDates!.isNotEmpty)
              _premiumDetailItem("Travel Dates", enquiryData.travelDates ?? ""),
            if (enquiryData.tentativeDates != null &&
                enquiryData.tentativeDates!.isNotEmpty)
              _premiumDetailItem("Tentative",
                  "${enquiryData.tentativeDates} (${enquiryData.tentativeDays} Days)"),
            if (enquiryData.specialRequests != null &&
                enquiryData.specialRequests!.isNotEmpty)
              _premiumDetailItem(
                "Special Request",
                enquiryData.specialRequests!.map((e) => e.request).join(", "),
              ),
          ],
        ),
      ),
    );
  }

  Widget _premiumDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

 
  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  String getDestinationText(EnquiryContent data) {
    final countries = data.countries ?? [];

    if (countries.isEmpty) return "NA";

    if (countries.length == 1) {
      return countries.first;
    }

    return "${countries.first} +${countries.length - 1} more";
  }

  void showPaymentConfirmationModal(
      {required int payableAmount,
      required int enquiryId,
      EnquiryContent? enquiryData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateA) {
          var status =
              context.watch<WalletViewModel>().viewBidPaymentData.status;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Drag Handle
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                /// Icon
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.deepOrange.shade600
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.monetization_on_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 18),

                /// Title
                const Text(
                  "Unlock & View Bid",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "To view this enquiry details and place your bid, please proceed with payment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// Amount Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orange.withOpacity(.08),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Payable Amount",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "USD $payableAmount",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// Buttons
                Row(
                  children: [
                    /// Cancel
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 15),

                    /// Pay Button
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade500,
                              Colors.deepOrange.shade700
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: status == Status.loading
                              ? null
                              : () async {
                                  // Navigator.pop(context);
                                  var resp = context.read<WalletViewModel>();
                                  final success =
                                      await resp.viewBidPaymentApi(body: {
                                    "amount": payableAmount,
                                    "currency": "USD",
                                    "paymentType": "Inquiry View",
                                    "travelInquiryId": enquiryId
                                  });
                                  if (success) {
                                    Navigator.pop(context);
                                    // Navigate to the bid now screen with the enquiry data
                                    Utils.toastSuccessMessage(
                                        'Payment successfully');
                                    context
                                        .push(
                                      '/vendor_dashboard/bidNow',
                                      extra: BidNowScreen(
                                        enquiryData: enquiryData,
                                      ),
                                    )
                                        .then((onValue) {
                                      // Refresh the enquiry list after bid creation
                                      _getAllEnquirys(
                                        isFilter: true,
                                        isSearch: false,
                                        isPagination: false,
                                      );
                                    });
                                  }

                                  /// 🔥 Add your payment logic here
                                },
                          child: status == Status.loading
                              ? Center(
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Proceed to Pay",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        });
      },
    );
  }

  Widget textItem({String label = 'Label', String value = 'Value'}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: titleText,
          ),
        ),
        const SizedBox(width: 10),
        const Text(':'),
        const SizedBox(width: 10),
        Expanded(flex: 3, child: Text(value))
      ],
    );
  }
}

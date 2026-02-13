// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/view/vendor/enquiry_management/bid_now_screen.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/response/status.dart';
import '../../../widgets/Custom Page Layout/common_page_layout.dart';
import '../../../widgets/custom_filter_popup_widget.dart';
import '../../../widgets/custom_search_field.dart';

class BidManagementScreen extends StatefulWidget {
  const BidManagementScreen({super.key});

  @override
  State<BidManagementScreen> createState() => _BidManagementScreenState();
}

class _BidManagementScreenState extends State<BidManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Map<String, String> bidFilter = {
    "All": '',
    "Accepted": 'accepted',
    "Rejected": 'rejected',
    "Pending": "pending"
  };
  String title = "All";
  String? _selectedbidding;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllBids(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllBids({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<BidViewModel>().getAllBidsApi(
          isFilter: isFilter,
          isSearch: isSearch,
          isPagination: isPagination,
          searchText: searchText,
          filterText: _selectedbidding ?? '',
        );
    debugPrint("Fetching all bids");
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllBids(isSearch: true, isFilter: false, isPagination: false);
    });
    // Handle search logic here
    debugPrint("Search value: $value");
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _selectedbidding = value;
      // Handle filter logic here
      debugPrint("Selected bid: $_selectedbidding");
    });
    _getAllBids(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllBids(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayoutPage(
      appBar: AppBar(
        title: Text(
          "Bid Management",
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
          const SizedBox(height: 5),
          // Displaying the list of bids
          Expanded(
            child: Consumer<BidViewModel>(
              builder: (context, vm, state) {
                if (vm.bidData.status == Status.loading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: greenColor,
                  ));
                } else if (vm.bidData.status == Status.error) {
                  return Center(child: Text(vm.bidData.message ?? 'Error'));
                } else if (vm.bidData.data == null ||
                    vm.bidData.data!.isEmpty) {
                  return Center(
                      child: Text(
                    'No bids found',
                    style: nodataTextStyle,
                  ));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      (vm.bidData.data ?? []).length + (vm.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == vm.bidData.data?.length) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: greenColor,
                      ));
                    }
                    final bid = vm.bidData.data?[index];
                   
                    return modernBidCard(
                      context: context,
                      bid: bid,
                      onRefresh: () {},
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget modernBidCard({
    required BuildContext context,
    required dynamic bid,
    required VoidCallback onRefresh,
  }) {
    final bool isAccepted = bid?.accepted == true;
    final bool isRejected = bid?.rejected == true;
    final bool isPaid = bid?.paid == true;

    Color statusColor = isAccepted
        ? Colors.green
        : isRejected
            ? Colors.red
            : Colors.orange;

    String statusText = isAccepted
        ? "Accepted"
        : isRejected
            ? "Rejected"
            : "Pending";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Top Row (ID + Status)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bid Id: ${bid?.id ?? '--'}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 User Info
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: btnColor.withOpacity(.1),
                child: const Icon(Icons.person, color: btnColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${bid?.user?.firstName ?? ''} ${bid?.user?.lastName ?? ''}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bid?.user?.email ?? "No Enquiry",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// 🔹 Price Highlight Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: btnColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quotation Price",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "${bid?.currency ?? ''} ${bid?.price ?? '--'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: btnColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 🔹 Paid Status
          Row(
            children: [
              Icon(
                isPaid ? Icons.check_circle : Icons.cancel,
                size: 18,
                color: isPaid ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                isPaid ? "Payment Completed" : "Payment Pending",
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          /// 🔹 Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// 👁 View
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                ),
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () {
                  context
                      .push(
                        '/vendor_dashboard/bidNow',
                        extra: BidNowScreen(
                          bidData: bid,
                          viewPage: true,
                        ),
                      )
                      .then((_) => onRefresh());
                },
              ),

              const SizedBox(width: 8),

              /// ✏ Update (Only if not accepted/rejected)
              if (!isAccepted && !isRejected)
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: btnColor,
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    context
                        .push(
                          '/vendor_dashboard/bidNow',
                          extra: BidNowScreen(
                            bidData: bid,
                          ),
                        )
                        .then((_) => onRefresh());
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}

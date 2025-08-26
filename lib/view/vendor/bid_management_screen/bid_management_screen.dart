import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/gradient_button.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../res/Custom Page Layout/common_page_layout.dart';
import '../../../res/custom_filter_popup_widget.dart';
import '../../../res/custom_search_field.dart';

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
        title: const Text("Bid Management"),
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
                    return Card(
                      color: background,
                      surfaceTintColor: background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Header Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "#${bid?.id} - ${bid?.travelInquiry?.name ?? 'Unknown'}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                (bid?.accepted == true || bid?.rejected == true)
                                    ? const SizedBox.shrink()
                                    : GradientButton(
                                        icon: Icons.edit,
                                        onPressed: () {
                                          context
                                              .push(
                                            '/vendor_dashboard/bidNow',
                                            extra: bid,
                                          )
                                              .then((onValue) {
                                            // Refresh the bids after creating a new bid
                                            _getAllBids(
                                              isFilter: true,
                                              isSearch: false,
                                              isPagination: false,
                                            );
                                          });
                                        },
                                        label: 'Update')
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// Details
                            Text(
                                'Name: ${bid?.user?.firstName ?? 'N/A'} ${bid?.user?.lastName ?? 'N/A'}'),
                            Text("Email: ${bid?.user?.email ?? 'N/A'}"),
                            Text(
                                "Accommodation: ${bid?.accommodation ?? 'N/A'}"),
                            Text(
                                "Transportation: ${bid?.transportation ?? 'N/A'}"),
                            Text("Meals: ${bid?.meals ?? 'N/A'}"),
                            Text("Extras: ${bid?.extras ?? 'N/A'}"),
                            Text("Quotation Price: AED ${bid?.price ?? 'N/A'}"),

                            const SizedBox(height: 8),

                            /// Status Row
                            Row(
                              children: [
                                Chip(
                                  side: BorderSide(
                                      color: bid?.paid == true
                                          ? Colors.green
                                          : Colors.red),
                                  label: Text(
                                      bid?.paid == true ? 'Paid' : 'Not Paid'),
                                  backgroundColor: bid?.paid == true
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,

                                  //  Colors.yellow.shade100,
                                  labelStyle: const TextStyle(
                                      color: Colors.brown, fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  side: BorderSide(
                                      color: bid?.accepted == true
                                          ? Colors.green
                                          : bid?.rejected == true
                                              ? Colors.red
                                              : Colors.orange),
                                  label: Text(bid?.accepted == true
                                      ? 'Accepted'
                                      : bid?.rejected == true
                                          ? 'Rejected'
                                          : 'Pending'),
                                  backgroundColor: bid?.accepted == true
                                      ? Colors.green.shade100
                                      : bid?.rejected == true
                                          ? Colors.red.shade100
                                          : Colors.orange.shade100,
                                  labelStyle: TextStyle(
                                    color: bid?.accepted == true
                                        ? Colors.green
                                        : bid?.rejected == true
                                            ? Colors.red
                                            : Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget actionButton(
      {void Function()? onTap,
      Color? color,
      required String title,
      IconData icon = Icons.check}) {
    if (title.isEmpty) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: onTap ??
          () {
            // Handle bid action
            debugPrint("Bid action tapped");
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color ?? btnColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 2),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

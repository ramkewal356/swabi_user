// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/view/vendor/enquiry_management/bid_now_screen.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';

import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/no_data_found_widget.dart';
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
                  // return Center(child: Text(vm.bidData.message ?? 'Error'));
                  return NoDataFoundWidget(text: 'No bids found');
                } else if (vm.bidData.data == null ||
                    vm.bidData.data!.isEmpty) {
                  return NoDataFoundWidget(text: "No bids found");
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
                      onRefresh: () {
                        _getAllBids(isFilter: true);
                      },
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
    final List<String> countries = bid?.countries ?? [];
    final bool isMultiCountry = countries.length > 1;

    final String destinationText = countries.isEmpty
        ? "--"
        : isMultiCountry
            ? "${countries.first} +${countries.length - 1} more"
            : countries.first;
    Color bidStatusColor = isAccepted
        ? Colors.green
        : isRejected
            ? Colors.red
            : Colors.orange;

    String bidStatusText = isAccepted
        ? "Accepted"
        : isRejected
            ? "Rejected"
            : "Pending";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 TOP ROW (ID + ACTIONS)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bid #${bid?.id ?? '--'}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              PopupMenuButton<String>(
                color: background,
                onSelected: (value) {
                  if (value == "view") {
                    context
                        .push(
                          '/vendor_dashboard/bidNow',
                          extra: BidNowScreen(
                            bidData: bid,
                            viewPage: true,
                          ),
                        )
                        .then((_) => onRefresh());
                  } else if (value == "edit") {
                    context
                        .push(
                          '/vendor_dashboard/bidNow',
                          extra: BidNowScreen(bidData: bid),
                        )
                        .then((_) => onRefresh());
                  } else if (value == "delete") {
                    _showCancelBidDialog(context, bid, onRefresh);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "view", child: Text("View Bid")),
                  if (!isAccepted && !isRejected)
                    const PopupMenuItem(
                        value: "edit", child: Text("Update Bid")),
                  if (!isAccepted && !isRejected)
                    const PopupMenuItem(
                        value: "delete", child: Text("Cancel Bid")),
                ],
                child: const Icon(Icons.more_vert),
              )
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 CUSTOMER INFO
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: btnColor.withOpacity(.1),
                child: const Icon(Icons.person, color: btnColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${bid?.user?.firstName ?? ''} ${bid?.user?.lastName ?? ''}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Text(
                      "${bid?.user?.email ?? ''}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 10),
                    )
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔹 PRICE COMPARISON ROW
          Row(
            children: [
              Expanded(
                child: _priceBox(
                  title: "Bidding Price",
                  value:
                      "${bid?.currency ?? ''} ${bid?.travelInquiry?.budget ?? '--'}",
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _priceBox(
                  title: "Quotation Price",
                  value: "${bid?.currency ?? ''} ${bid?.price ?? '--'}",
                  isPrimary: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔹 DESTINATIONS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.public, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    destinationText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (isMultiCountry)
                  Text(
                    "Multi Country",
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// 🔹 STATUS ROW
          Row(
            children: [
              _statusChip(
                text: isPaid ? "Paid" : "Not Paid",
                color: isPaid ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 10),
              _statusChip(
                text: bidStatusText,
                color: bidStatusColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _priceBox({
    required String title,
    required String value,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary ? btnColor.withOpacity(.08) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isPrimary ? btnColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the cancel bid dialog and integrate cancel bid api
  void _showCancelBidDialog(
      BuildContext context, dynamic bid, VoidCallback onRefresh) async {
    final TextEditingController reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool submitting = false;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black54,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, setModalState) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: 20 + bottomInset,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Text(
                    'Cancel Bid',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Are you sure you want to cancel this bid? Please provide a reason.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  // Make sure to import the correct custom textformfield for vendor
                  Customtextformfield(
                    controller: reasonController,
                    hintText: 'Enter reason',
                    minLines: 2,
                    maxLines: 4,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please provide a reason";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: OutlinedButton(
                            onPressed: submitting
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            child: const Text('Cancel'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButtonSmall(
                          btnHeading: 'Cancel Bid',
                          loading: submitting,
                          height: 45,
                          borderRadius: BorderRadius.circular(25),
                          onTap: submitting
                              ? null
                              : () async {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    setModalState(() => submitting = true);
                                    // Call cancel bid API
                                    try {
                                      final String? bidId = bid?.id?.toString();
                                      final String reason =
                                          reasonController.text.trim();

                                      final Map<String, dynamic> cancelBody = {
                                        "id": bidId,
                                        "reason": reason,
                                      };

                                      final result = await context
                                          .read<BidViewModel>()
                                          .cancelBidApi(body: cancelBody);

                                      if (result == true) {
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                        onRefresh();

                                        Utils.toastSuccessMessage(
                                            'Bid cancelled successfully!');
                                      }
                                    } catch (e) {
                                      debugPrint('Cancel Bid error: $e');
                                    } finally {
                                      setModalState(() => submitting = false);
                                    }
                                  }
                                },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

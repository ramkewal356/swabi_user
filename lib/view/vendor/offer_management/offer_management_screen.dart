// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view/vendor/offer_management/view_offer_screen.dart';
import 'package:flutter_cab/view/vendor/offer_management/add_edit_offer_screen.dart'; // You need to create this if not exists
import 'package:flutter_cab/view_model/offer_management_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/custom_filter_popup_widget.dart';
import 'package:flutter_cab/widgets/custom_search_field.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/response/status.dart';
import 'dart:async';

class OfferManagementScreen extends StatefulWidget {
  const OfferManagementScreen({super.key});

  @override
  State<OfferManagementScreen> createState() => _OfferManagementScreenState();
}

class _OfferManagementScreenState extends State<OfferManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';
  String offerStatus = 'ALL';
  final FocusNode _focusNode = FocusNode();
  String title = 'ALL';
  Map<String, String> statusFilter = {
    "All": 'ALL',
    "Active": 'ACTIVE',
    "Inactive": 'INACTIVE',
    "Expired": "EXPIRED"
  };

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _loadOffers(isFilter: true);
    });
    _scrollController.addListener(_onScroll);
  }

  void _loadOffers(
      {bool isPagination = false,
      bool isSearch = false,
      bool isFilter = false}) {
    context.read<OfferManagementViewModel>().getOfferListApi(
        isSearch: isSearch,
        isFilter: isFilter,
        isPagination: isPagination,
        offerStatus: offerStatus,
        search: searchQuery);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    // Debounce: call _loadOffers only after 400ms of no typing
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        _loadOffers(isSearch: true);
      }
    });
  }

  void _onFilterChanged(String value) {
    setState(() {
      offerStatus = value;
    });
    _loadOffers(isFilter: true);
  }

  Future<void> _refreshOffers() async {
    _loadOffers(isFilter: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadOffers(isPagination: true);
    }
  }

  Widget offerStatusChip(String? status) {
    String label;
    Color bgColor;
    Color textColor;

    switch ((status ?? "").toUpperCase()) {
      case 'ACTIVE':
        label = "Active";
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'INACTIVE':
        label = "Inactive";
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case 'EXPIRED':
        label = "Expired";
        bgColor = Colors.grey.shade300;
        textColor = Colors.grey.shade700;
        break;
      default:
        label = "Unknown";
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w600, fontSize: 12),
      ),
      backgroundColor: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
    );
  }

  Future<void> _toggleOfferStatus(dynamic offer) async {
    // Prevent toggling status if expired
    if (offer.offerStatus?.toUpperCase() == 'EXPIRED') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cannot activate or deactivate an expired offer.')),
      );
      return;
    }
    // You should implement API call logic here. This is a simple example.
    final vm = context.read<OfferManagementViewModel>();
    bool activating = offer.offerStatus?.toUpperCase() == 'INACTIVE';
    String action = activating ? 'Activate' : 'Deactivate';

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$action Offer'),
        content: Text('Are you sure you want to $action this offer?'),
        actions: [
          TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(ctx).pop(false)),
          CustomButtonSmall(
              width: 120,
              height: 42,
              borderRadius: BorderRadius.circular(25),
              loading: vm.activeDeactiveResponse.status == Status.loading,
              btnHeading: action,
              onTap: () => Navigator.of(ctx).pop(true))
        ],
      ),
    );

    if (confirmed == true) {
      await vm.activateOrDeactivateOffer(
          offerId: offer.offerId.toString(), isActivate: activating);

      _refreshOffers();
    }
  }

  void _showOfferActionSheet(BuildContext context, dynamic offer) {
    final isExpired = offer.offerStatus?.toUpperCase() == 'EXPIRED';
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Offer'),
              onTap: () {
                Navigator.of(ctx).pop();
                context.push(
                  '/vendor_dashboard/offer_management/view_offer',
                  extra: ViewOfferScreen(offerId: offer.offerId.toString()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Offer'),
              enabled: !isExpired,
              onTap: !isExpired
                  ? () {
                      Navigator.of(ctx).pop();

                      context
                          .push(
                              '/vendor_dashboard/offer_management/add_or_edit_offer',
                              extra: AddAndEditOfferScreen(
                                offerId: offer.offerId.toString(),
                                isEdit: true,
                              ))
                          .then((onValue) {
                        if (onValue == true) {
                          _refreshOffers();
                        }
                      });
                    }
                  : null,
            ),
            ListTile(
              leading: Icon(
                  offer.offerStatus?.toUpperCase() == 'ACTIVE'
                      ? Icons.block
                      : Icons.check_circle,
                  color: offer.offerStatus?.toUpperCase() == 'ACTIVE'
                      ? Colors.red
                      : Colors.green),
              title: Text(offer.offerStatus?.toUpperCase() == 'ACTIVE'
                  ? "Deactivate"
                  : "Activate"),
              enabled: !isExpired,
              onTap: !isExpired
                  ? () async {
                      Navigator.of(ctx).pop();
                      await _toggleOfferStatus(offer);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: background,
        title: const Text(
          "Offer Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshOffers,
            tooltip: 'Refresh',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Box
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    filled: true,
                    fillColor: Colors.white,
                    focusNode: _focusNode,
                    controller: _searchController,
                    serchHintText: 'Search offers',
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 10),
                CustomFilterPopupWidget(
                    title: title,
                    filterOptions: statusFilter,
                    onFilterChanged: _onFilterChanged),
              ],
            ),
            const SizedBox(height: 16),
            // Offer List
            Expanded(
              child: Consumer<OfferManagementViewModel>(
                builder: (context, vm, snapshot) {
                  if (vm.offerListResponse.status == Status.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (vm.offerListResponse.status == Status.error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load offers.\nplease refresh',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            onPressed: _refreshOffers,
                          ),
                        ],
                      ),
                    );
                  }

                  final offerList = vm.offerListResponse.data ?? [];
                  if (offerList.isEmpty) {
                    return Center(
                      child: Text(
                        "No offers found.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshOffers,
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: offerList.length + (vm.isLastPage ? 0 : 1),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == offerList.length) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                        final offer = offerList[index];
                        // final isExpired =
                        //     offer.offerStatus?.toUpperCase() == 'EXPIRED';
                        return Card(
                          color: background,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.15),
                              child: Icon(
                                Icons.local_offer,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              offer.offerName ?? "Untitled Offer",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (offer.offerType != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      "${offer.offerType == 'PACKAGE_BOOKING' ? "PACKAGE" : offer.offerType == "RENTAL" ? "RENTAL" : offer.offerType} OFFER",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                Text('Offer Code: ${offer.offerCode}'),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        size: 15,
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Valid: ${offer.startDate ?? '--'} to ${offer.endDate ?? '--'}",
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: offerStatusChip(offer.offerStatus),
                            onTap: () {
                              _showOfferActionSheet(context, offer);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: btnColor,
        icon: const Icon(
          Icons.add,
          color: background,
        ),
        label: Text(
          "Add Offer",
          style: TextStyle(color: background),
        ),
        onPressed: () {
          context
              .push('/vendor_dashboard/offer_management/add_or_edit_offer',
                  extra: AddAndEditOfferScreen(
                    isEdit: false,
                  ))
              .then((onValue) {
            if (onValue == true) {
              _refreshOffers();
            }
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

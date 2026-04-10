import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/models/rental_price_list_model.dart'
    hide Status;
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/rental_price_management_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/no_data_found_widget.dart';
import 'package:flutter_cab/widgets/custom_filter_popup_widget.dart';
import 'package:flutter_cab/widgets/custom_search_field.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RentalPriceManagement extends StatefulWidget {
  const RentalPriceManagement({super.key});

  @override
  State<RentalPriceManagement> createState() => _RentalPriceManagementState();
}

class _RentalPriceManagementState extends State<RentalPriceManagement> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final Map<String, String> _filterOptions = {
    "All": 'ALL',
    "Active": 'TRUE',
    "InActive": 'FALSE',
  };

  String _filterText = 'ALL';
  String _filterTitle = 'All';
  String _searchText = '';

  // For dialog loading
  bool _dialogLoading = false;
  int? _dialogItemId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchList(
          isFilter: true,
          isSearch: false,
          isPagination: false,
        ));
  }

  void _fetchList({
    required bool isFilter,
    required bool isSearch,
    required bool isPagination,
  }) {
    context.read<RentalPriceManagementViewModel>().getRentalPriceListApi(
          isFilter: isFilter,
          isSearch: isSearch,
          isPagination: isPagination,
          searchText: _searchText,
          statusText: _filterText,
        );
  }

  void _onSearchChanged(String value) {
    setState(() => _searchText = value);
    _fetchList(isFilter: false, isSearch: true, isPagination: false);
  }

  void _onFilterChanged(String newFilter) {
    setState(() {
      _filterTitle = newFilter;
      _filterText = newFilter;
    });
    _fetchList(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchList(isFilter: false, isSearch: false, isPagination: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _showActivateDeactivateDialog(
      BuildContext context,
      RentalPriceContent item,
      bool isLoading,
      bool targetStatus,
      Future<void> Function() onTap) {
    showDialog(
      context: context,
      barrierDismissible: !(_dialogLoading &&
          _dialogItemId == item.id), // Don't dismiss if loading
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext dialogCtx, StateSetter setState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: targetStatus
                          ? const Color(0xFFEAF3DE)
                          : const Color(0xFFFCEBEB),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      targetStatus
                          ? Icons.check_circle_outline_rounded
                          : Icons.cancel_outlined,
                      color: targetStatus
                          ? const Color(0xFF3B6D11)
                          : const Color(0xFFA32D2D),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    targetStatus
                        ? 'Activate Rental Price'
                        : 'Deactivate Rental Price',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Are you sure you want to ${targetStatus ? "activate" : "deactivate"} "${item.carType}"?',
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF888780), height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              (_dialogLoading && _dialogItemId == item.id)
                                  ? null
                                  : () => Navigator.of(dialogCtx).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(
                                color: Color(0xFFD3D1C7), width: 0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel',
                              style: TextStyle(color: Color(0xFF5F5E5A))),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        // Show loader while performing API call
                        child: CustomButtonSmall(
                          height: 42,
                          loading: (_dialogLoading && _dialogItemId == item.id),
                          btnHeading: targetStatus ? 'Activate' : 'Deactivate',
                          onTap: (_dialogLoading && _dialogItemId == item.id)
                              ? null
                              : () async {
                                  setState(() {
                                    _dialogLoading = true;
                                    _dialogItemId = item.id;
                                  });
                                  await onTap().whenComplete(() {
                                    setState(() {
                                      _dialogLoading = false;
                                    });
                                  });
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3),
      appBar: AppBar(
        title: Text('Rental Price Management', style: appbarTextStyle),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE8E7E2)),
        ),
      ),
      body: Column(
        children: [
          // Search + Filter + Add bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F3),
                    focusNode: _searchFocus,
                    controller: _searchController,
                    serchHintText: 'Search by car type',
                    onChanged: _onSearchChanged,
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFFAAAAAA)),
                  ),
                ),
                const SizedBox(width: 8),
                CustomFilterPopupWidget(
                  title: _filterTitle,
                  filterOptions: _filterOptions,
                  onFilterChanged: _onFilterChanged,
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label:
                      const Text('Add', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Navigate to Add Rental Price Screen
                    context.push(
                      '/vendor_dashboard/rental_price_management/add_edit_rental_price',
                      extra: {
                        'isEdit': false,
                        'rentalPriceItem': null,
                      },
                    ).then((onValue) {
                      _fetchList(
                        isFilter: true,
                        isSearch: false,
                        isPagination: false,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: Consumer<RentalPriceManagementViewModel>(
              builder: (context, vm, _) {
                // Show loader when fetching the main list
                if (vm.rentalPriceData.status == Status.loading) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: btnColor, strokeWidth: 2.5));
                }
                if (vm.rentalPriceData.status == Status.error) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Color(0xFFA32D2D), size: 40),
                        const SizedBox(height: 12),
                        Text(vm.rentalPriceData.message ?? 'Failed to load.',
                            style: const TextStyle(color: Color(0xFF888780))),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _fetchList(
                              isFilter: true,
                              isSearch: false,
                              isPagination: false),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (vm.rentalPriceData.status == Status.completed) {
                  final items = vm.rentalPriceData.data ?? [];
                  if (items.isEmpty) {
                    return Center(
                        child:
                            NoDataFoundWidget(text: 'No Rental Prices Found'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: items.length + (vm.isLastPage ? 0 : 1),
                    itemBuilder: (ctx, idx) {
                      if (idx == items.length) {
                        if (!vm.isLastPage) {
                          return const Center(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: CircularProgressIndicator(
                                      color: btnColor, strokeWidth: 2.2)));
                        }
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RentalPriceCard(
                          item: items[idx],
                          onEdit: () {
                            // Send to Add/Edit Rental Price Screen in edit mode
                            context.push(
                              '/vendor_dashboard/rental_price_management/add_edit_rental_price',
                              extra: {
                                'isEdit': true,
                                'rentalPriceItem': items[idx],
                              },
                            ).then((onValue) {
                              _fetchList(
                                isFilter: true,
                                isSearch: false,
                                isPagination: false,
                              );
                            });
                          },
                          onToggleActive: () {
                            final targetStatus = !(items[idx].status ?? false);
                            // BEGIN REWRITE FOR DIALOG CLOSE ON SUCCESS
                            _showActivateDeactivateDialog(
                              ctx,
                              items[idx],
                              _dialogLoading && _dialogItemId == items[idx].id,
                              targetStatus,
                              () async {
                                // This closure runs when the confirm button is tapped.
                                // We'll move the pop here so dialog closes after API success.
                                await context
                                    .read<RentalPriceManagementViewModel>()
                                    .activateDeactivateRentalPriceApi(
                                      id: items[idx].id ?? 0,
                                      isActivate: targetStatus,
                                      onComplete: (success, errorMsg) async {
                                        // if (success) {

                                        // }
                                        Utils.toastSuccessMessage(targetStatus
                                            ? 'Rental price activated successfully'
                                            : 'Rental price deactivated successfully');
                                        if (mounted) {
                                          // Ensure dialog closes after activate/deactivate success
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        }
                                        _fetchList(
                                          isFilter: true,
                                          isSearch: false,
                                          isPagination: false,
                                        );
                                      },
                                    );
                              },
                            );
                            // END REWRITE FOR DIALOG CLOSE ON SUCCESS
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card Widget
// ---------------------------------------------------------------------------

class _RentalPriceCard extends StatelessWidget {
  final RentalPriceContent item;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;

  const _RentalPriceCard({
    required this.item,
    required this.onEdit,
    required this.onToggleActive,
  });

  String _formatDate(String? raw) {
    if (raw == null) return '-';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = item.status ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E7E2), width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: ID + name + status pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('#${item.id ?? '-'}',
                                  style: const TextStyle(
                                      fontSize: 11, color: Color(0xFFAAAAAA))),
                              const SizedBox(height: 2),
                              Text(
                                item.carType ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _StatusPill(isActive: isActive),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Price boxes
                    Row(
                      children: [
                        Expanded(
                          child: _PriceBox(
                            label: 'Per hour',
                            currency: item.currencyHour ?? '₹',
                            amount: item.perHourPrice,
                            unit: '/hr',
                            icon: Icons.access_time_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PriceBox(
                            label: 'Per km',
                            currency: item.currencyKm ?? '₹',
                            amount: item.perKilometerPrice,
                            unit: '/km',
                            icon: Icons.route_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(
                        height: 1, thickness: 0.5, color: Color(0xFFE8E7E2)),
                    const SizedBox(height: 10),

                    // Footer: dates + actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _DateChip(
                                label: 'Created',
                                date: _formatDate(item.createdDate.toString())),
                            const SizedBox(width: 16),
                            _DateChip(
                                label: 'Modified',
                                date:
                                    _formatDate(item.modifiedDate.toString())),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit_outlined,
                                  size: 18, color: greenColor),
                              tooltip: 'Edit',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(6),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: onToggleActive,
                              icon: Icon(
                                item.status == true
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline,
                                size: 22,
                                color: item.status == true
                                    ? const Color(0xFFA32D2D)
                                    : greenColor,
                              ),
                              tooltip: item.status == true
                                  ? 'Deactivate'
                                  : 'Activate',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _StatusPill extends StatelessWidget {
  final bool isActive;
  const _StatusPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEAF3DE) : const Color(0xFFFCEBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFFC0DD97) : const Color(0xFFF7C1C1),
          width: 0.5,
        ),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF3B6D11) : const Color(0xFFA32D2D),
        ),
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  final String label;
  final String currency;
  final int? amount;
  final String unit;
  final IconData icon;

  const _PriceBox({
    required this.label,
    required this.currency,
    required this.amount,
    required this.unit,
    required this.icon,
  });

  String _currencySymbol(String code) {
    const map = {'INR': '₹', 'USD': '\$', 'EUR': '€', 'GBP': '£'};
    return map[code.toUpperCase()] ?? code;
  }

  @override
  Widget build(BuildContext context) {
    final symbol = _currencySymbol(currency);
    final display =
        amount != null ? '$symbol${amount!.toStringAsFixed(0)}' : '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: const Color(0xFFAAAAAA)),
              const SizedBox(width: 4),
              Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA))),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: display,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF888780)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String date;
  const _DateChip({required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: Color(0xFFBBBBB0))),
        const SizedBox(height: 1),
        Text(date,
            style: const TextStyle(fontSize: 12, color: Color(0xFF888780))),
      ],
    );
  }
}

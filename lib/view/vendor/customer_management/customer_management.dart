import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view/vendor/customer_management/view_customer_screen.dart';
import 'package:flutter_cab/view_model/customer_management_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/no_data_found_widget.dart';
import 'package:flutter_cab/widgets/custom_filter_popup_widget.dart';
import 'package:flutter_cab/widgets/custom_search_field.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterText = 'ALL';
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
      fetchCustomer(isFilter: true);
    });
    _scrollController.addListener(_onScroll);
  }

  void fetchCustomer(
      {bool isFilter = false,
      bool isPagination = false,
      bool isSearch = false}) {
    context.read<CustomerManagementViewModel>().getAllCustomerApi(
        isFilter: isFilter,
        isPagination: isPagination,
        isSearch: isSearch,
        searhText: _searchQuery,
        filterText: _filterText);
  }

  void _onFilterChanged(String value) {
    setState(() {
      _filterText = value;
    });
    fetchCustomer(isFilter: true);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        fetchCustomer(isSearch: true);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      fetchCustomer(isPagination: true);
    }
  }

  // Show only limited data in the list item, but show all in detail
  Widget _buildCustomerItem(dynamic customer) {
    final user = customer?.user;
    String initial = '';
    if (user?.firstName != null &&
        user.firstName is String &&
        user.firstName.isNotEmpty) {
      initial = user.firstName[0].toUpperCase();
    }

    return Card(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: user?.profileImageUrl != null &&
                user.profileImageUrl is String &&
                (user.profileImageUrl as String).isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(user.profileImageUrl),
                backgroundColor: Colors.transparent,
              )
            : CircleAvatar(
                backgroundColor: Colors.blue.shade200,
                child: Text(
                  initial,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
        title: Text(
          '${user?.firstName ?? ""} ${user?.lastName ?? ""}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        // Show only very basic info in the list
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.email ?? '-', style: const TextStyle(fontSize: 12)),
            Text(
              user?.mobile != null && user?.countryCode != null
                  ? '+${user.countryCode} ${user.mobile}'
                  : (user?.mobile ?? ''),
              style: const TextStyle(fontSize: 12),
            ),
            // Only show status chip in the list
          ],
        ),
        trailing: Chip(
          label: Text(
            user?.status == true ? "Active" : "Inactive",
            style: TextStyle(
              color: user?.status == true ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor:
              user?.status == true ? Colors.green.shade50 : Colors.red.shade50,
          visualDensity: VisualDensity.compact,
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
        title: const Text('Customer Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Simulate refresh
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    filled: true,
                    fillColor: Colors.white,
                    focusNode: _focusNode,
                    controller: _searchController,
                    serchHintText: 'Search customers',
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 10),
                CustomFilterPopupWidget(
                    title: _filterText,
                    filterOptions: statusFilter,
                    onFilterChanged: _onFilterChanged),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<CustomerManagementViewModel>(
                builder: (context, vm, child) {
                  if (vm.customerList.status == Status.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: greenColor,
                      ),
                    );
                  } else if (vm.customerList.status == Status.error) {
                    return NoDataFoundWidget(text: 'No found customer');
                  } else {
                    final datList = vm.customerList.data ?? [];
                    if (datList.isEmpty) {
                      return NoDataFoundWidget(text: 'No found customer');
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: datList.length + (vm.isLastPage ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == datList.length) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                        final customer = vm.customerList.data?[index];
                        return GestureDetector(
                            onTap: () {
                              context.push(
                                  '/vendor_dashboard/customer_management/view_customer',
                                  extra: ViewCustomerScreen(
                                      customerData: customer));
                            },
                            child: _buildCustomerItem(customer));
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

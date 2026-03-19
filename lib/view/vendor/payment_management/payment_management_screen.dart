// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/widgets/custom_search_field.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cab/view_model/payment_management_view_model.dart';

import '../../../data/response/status.dart';

enum PaymentStatus { all, success, pending, refunded, failed }

PaymentStatus? paymentStatusFromString(String? status) {
  if (status == null) return null;
  switch (status.toLowerCase()) {
    case 'success':
      return PaymentStatus.success;
    case 'pending':
      return PaymentStatus.pending;
    case 'refunded':
      return PaymentStatus.refunded;
    case 'failed':
      return PaymentStatus.failed;
    case 'captured':
      return PaymentStatus.success;
    case 'created':
      return PaymentStatus.pending;
    default:
      return null;
  }
}

String statusToString(PaymentStatus? status) {
  if (status == null) return "ALL";
  switch (status) {
    case PaymentStatus.success:
      return 'Success';
    case PaymentStatus.pending:
      return 'Pending';
    case PaymentStatus.refunded:
      return 'Refunded';
    case PaymentStatus.failed:
      return 'Failed';
    default:
      return "ALL";
  }
}

Color statusColor(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.success:
      return Colors.green;
    case PaymentStatus.pending:
      return Colors.orange;
    case PaymentStatus.refunded:
      return Colors.blue;
    case PaymentStatus.failed:
      return Colors.red;
    default:
      return Colors.red;
  }
}

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({super.key});

  @override
  State<PaymentManagementScreen> createState() =>
      _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {
  String searchQuery = '';
  PaymentStatus? selectedStatus;
  String selectedType = 'ALL';
  final _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late PaymentManagementViewModel viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _fetchByStatus(isFilter: true);
    });
    _scrollController.addListener(_handleScrollPagination);
    // Initial load based on default
  }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_handleScrollPagination);
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  String? mapSelectedStatusToApiValue(PaymentStatus? status) {
    if (status == null) return 'ALL';
    if (status == PaymentStatus.success) {
      return "Captured";
    } else if (status == PaymentStatus.pending) {
      return "Created";
    } else if (status == PaymentStatus.refunded) {
      // return "Refunded";
      return "ALL";
    } else if (status == PaymentStatus.failed) {
      return "Failed";
    }
    return statusToString(status);
  }

  void _fetchByStatus(
      {bool isFilter = false,
      bool isSearch = false,
      bool isPagination = false}) {
    if (selectedStatus == PaymentStatus.refunded) {
      fetchRefunds(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
      );
    } else {
      fetchPayments(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
      );
    }
  }

  void fetchPayments(
      {bool isFilter = false,
      bool isSearch = false,
      bool isPagination = false}) {
    final apiStatus = mapSelectedStatusToApiValue(selectedStatus);
    context.read<PaymentManagementViewModel>().getTransactionListApi(
          isFilter: isFilter,
          isSearch: isSearch,
          isPagination: isPagination,
          bookingType: selectedType,
          status: apiStatus ?? "ALL",
          searchQuery: searchQuery,
        );
  }

  void fetchRefunds(
      {bool isFilter = false,
      bool isSearch = false,
      bool isPagination = false}) {
    final apiStatus = mapSelectedStatusToApiValue(selectedStatus);
    context.read<PaymentManagementViewModel>().getRefundListApi(
          isFilter: isFilter,
          isSearch: isSearch,
          isPagination: isPagination,
          bookingType: selectedType,
          status: apiStatus ?? "ALL",
          searchQuery: searchQuery,
        );
  }

  void _onBookingFilter(String? value) {
    setState(() {
      selectedType = value ?? 'ALL';
    });
    _fetchByStatus(isFilter: true);
  }

  void _onStatusFilter(PaymentStatus? value) {
    setState(() {
      selectedStatus = value == PaymentStatus.all ? null : value;
    });
    // If selecting All Status (value == null), always run API with ALL status value.
    _fetchByStatus(isFilter: true);
  }

  void _handleSearch(String val) {
    setState(() {
      searchQuery = val;
    });
    _fetchByStatus(isSearch: true);
  }

  void _handleScrollPagination() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchByStatus(isPagination: true);
    }
  }

  Widget buildPaymentList() {
    return Consumer<PaymentManagementViewModel>(
      builder: (_, viewModel, __) {
        final bool isRefund = selectedStatus == PaymentStatus.refunded;
        final apiResp =
            isRefund ? viewModel.getRefundList : viewModel.getTransactionList;

        if (apiResp.status == Status.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: greenColor,
          ));
        }

        if (apiResp.status == Status.error) {
          return Center(
            child: Text(
              apiResp.message?.isNotEmpty == true
                  ? apiResp.message!
                  : "Error loading data. Double-check your filters. If the error persists, contact support.",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        List rawContent = isRefund
            ? (viewModel.getRefundList.data ?? [])
            : (viewModel.getTransactionList.data ?? []);

        if (rawContent.isEmpty) {
          return const Center(child: Text('No payment records found.'));
        }

        return ListView.separated(
          controller: _scrollController,
          separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
          itemCount: rawContent.length + (viewModel.isLastPage ? 0 : 1),
          itemBuilder: (context, index) {
            // Defensive programming: Ensure index is always valid
            if (index >= rawContent.length) {
              // Only show loading indicator when more pages are being loaded
              if (viewModel.isLastPage) {
                // Should not happen, but just in case, return empty
                return const SizedBox.shrink();
              }
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: greenColor,
                  ),
                ),
              );
            }

            // Defensive: Ensure data is accessible for this index
            dynamic refundData;
            dynamic paymentData;
            if (isRefund) {
              if (viewModel.getRefundList.data == null ||
                  viewModel.getRefundList.data!.length <= index) {
                // Safeguard for out of bounds
                return const SizedBox.shrink();
              }
              refundData = viewModel.getRefundList.data![index];
              paymentData = null;
            } else {
              if (viewModel.getTransactionList.data == null ||
                  viewModel.getTransactionList.data!.length <= index) {
                // Safeguard for out of bounds
                return const SizedBox.shrink();
              }
              paymentData = viewModel.getTransactionList.data![index];
              refundData = null;
            }

            var paymentId =
                isRefund ? refundData?.paymentId : paymentData?.paymentId;
            var bookingId = isRefund ? refundData?.id : paymentData?.bookingId;
            var status = isRefund
                ? paymentStatusFromString(refundData?.refundStatus)
                : paymentStatusFromString(paymentData?.transactionStatus);
            var currency = isRefund
                ? refundData?.currency ?? "AED"
                : paymentData?.currency ?? "AED";
            var amount = isRefund
                ? refundData?.refundedAmount ?? 0
                : paymentData?.amountPaid ?? 0;
            var createdAt =
                isRefund ? refundData?.createdAt : paymentData?.createdDate;
            var transactionType =
                isRefund ? refundData.bookingType : paymentData.bookingType;
            return ListTile(
              onTap: () {
                context.push(
                    '/vendor_dashboard/payment_management/payment_details',
                    extra: {
                      "paymentId": paymentId,
                      "isRefunded": isRefund
                    }).then((onValue) {
                  _fetchByStatus(isFilter: true);
                });
              },
              title: Text(
                '$paymentId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bookingId == null || bookingId.toString().isEmpty)
                    SizedBox(height: 5),
                  if (bookingId != null && bookingId.toString().isNotEmpty)
                    Text(
                        '${isRefund ? 'Refund ID' : 'Booking ID'}: $bookingId'),
                  if (createdAt != null && createdAt != 0)
                    Text(
                        '${isRefund ? 'Refund Date' : 'Payment Date'}: ${dateFormat(createdAt)}')
                  else
                    const SizedBox(),
                  Text('Type : $transactionType')
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${currency == "INR" ? "₹" : currency} ${amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (status != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor(status).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: statusColor(status), width: 1.0),
                      ),
                      child: Text(
                        statusToString(status),
                        style: TextStyle(
                          color: statusColor(status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper widgets for PopupMenuButton for Type and Status
  Widget typePopupMenu() {
    return PopupMenuButton<String>(
      color: background,
      position: PopupMenuPosition.under,
      onSelected: _onBookingFilter,
      initialValue: selectedType,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'ALL',
          child: Text("All Types"),
        ),
        const PopupMenuItem(
          value: 'BID_BOOKING',
          child: Text("Bid Booking"),
        ),
        const PopupMenuItem(
          value: 'PACKAGE_BOOKING',
          child: Text("Package Booking"),
        ),
        const PopupMenuItem(
          value: 'RENTAL_BOOKING',
          child: Text("Rental Booking"),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedType == 'ALL'
                    ? "All Types"
                    : selectedType == 'RENTAL_BOOKING'
                        ? "Rental Booking"
                        : selectedType == 'PACKAGE_BOOKING'
                            ? "Package Booking"
                            : selectedType == 'BID_BOOKING'
                                ? "Bid Booking"
                                : selectedType,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget statusPopupMenu() {
    return PopupMenuButton<PaymentStatus?>(
      color: background,
      position: PopupMenuPosition.under,
      onSelected: _onStatusFilter,
      initialValue: selectedStatus ?? PaymentStatus.all,
      itemBuilder: (context) => [
        const PopupMenuItem<PaymentStatus?>(
          value: PaymentStatus.all,
          child: Text("All Status"),
        ),
        ...PaymentStatus.values.where((e) => e != PaymentStatus.all).map(
              (status) => PopupMenuItem<PaymentStatus?>(
                value: status,
                child: Text(statusToString(status)),
              ),
            ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedStatus != null
                    ? statusToString(selectedStatus!)
                    : "All Status",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
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
        title: const Text('Payment Management'),
        backgroundColor: background,
        surfaceTintColor: background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchField(
              focusNode: _searchFocus,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: const Icon(Icons.search),
              ),
              controller: _searchController,
              serchHintText: "Search by Name or ID",
              onChanged: _handleSearch,
            ),
            const SizedBox(height: 12),
            // Filters Row
            Row(
              children: [
                // Type (Rental/Package/All)
                Expanded(
                  child: typePopupMenu(),
                ),
                const SizedBox(width: 10),
                // Status selector, calls refund api on 'Refunded'
                Expanded(
                  child: statusPopupMenu(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // List of Payments / Refunds
            Expanded(
              child: buildPaymentList(),
            ),
          ],
        ),
      ),
    );
  }
}

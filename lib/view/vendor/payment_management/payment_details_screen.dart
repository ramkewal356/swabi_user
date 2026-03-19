// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/payment_management_view_model.dart';
import 'package:provider/provider.dart';
import '../../../data/response/status.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final String paymentId;
  final bool forRefunded;
  const PaymentDetailsScreen(
      {super.key, required this.paymentId, this.forRefunded = false});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch both payment and refund details
    fetchPaymentDetails();
  }

  void fetchPaymentDetails() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.forRefunded) {
        context
            .read<PaymentManagementViewModel>()
            .fetchRefundPaymentDetails(paymentId: widget.paymentId);
      } else {
        context
            .read<PaymentManagementViewModel>()
            .fetchPaymentDetails(paymentId: widget.paymentId);
      }
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'captured':
        return Colors.green;
      case 'pending':
      case 'created':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
      case 'partial':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'captured':
        return Icons.check_circle;
      case 'pending':
      case 'created':
        return Icons.hourglass_top_rounded;
      case 'failed':
        return Icons.cancel;
      case 'refunded':
      case 'partial':
        return Icons.replay_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text("Payment Details"),
        backgroundColor: background,
        surfaceTintColor: background,
      ),
      body: Consumer<PaymentManagementViewModel>(
        builder: (context, value, child) {
          if (value.paymentDetails.status == Status.loading ||
              value.refundPaymentDetails.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.paymentDetails.status == Status.error ||
              value.refundPaymentDetails.status == Status.error) {
            return Center(
              child: Text('No Data'),
            );
          } else {
            var showRefund = widget.forRefunded;
            var paymentData = value.paymentDetails.data?.data;
            var refundData = value.refundPaymentDetails.data?.data;
            var status = showRefund
                ? refundData?.refundStatus ?? ''
                : paymentData?.status ?? '';
            var currency = showRefund
                ? refundData?.currency ?? '_'
                : paymentData?.currency ?? '_';
            var amount = showRefund
                ? refundData?.refundedAmount ?? 0
                : paymentData?.amount ?? 0;

            var paymentId = showRefund
                ? refundData?.paymentId ?? '_'
                : paymentData?.id ?? "_";
            var orderId = showRefund
                ? refundData?.refundId ?? "_"
                : paymentData?.orderId ?? "_";
            var paymentDate = showRefund
                ? dateFormat(refundData?.createdAt)
                : dateFormat(paymentData?.createdAt);
            var paymentTime = showRefund
                ? timeFormate(refundData?.createdAt)
                : timeFormate(paymentData?.createdAt);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    /// STATUS HEADER CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            getStatusColor(status),
                            getStatusColor(status).withOpacity(.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: getStatusColor(status).withOpacity(.35),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                getStatusIcon(status),
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                status == 'created'
                                    ? "PENDING"
                                    : status == "captured"
                                        ? "SUCCESS"
                                        : status.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  currency,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// AMOUNT
                          Text(
                            "$currency $amount",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.white70),
                              const SizedBox(width: 6),
                              Text(
                                paymentDate,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(width: 18),
                              const Icon(Icons.access_time,
                                  size: 16, color: Colors.white70),
                              const SizedBox(width: 6),
                              Text(
                                paymentTime,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// DETAILS CARD
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          DetailRow(
                            title: "Payment ID",
                            value: paymentId,
                            icon: Icons.confirmation_number_outlined,
                          ),
                          const Divider(),
                          DetailRow(
                            title: showRefund ? "Refund ID" : "Order ID",
                            value: orderId,
                            icon: showRefund
                                ? Icons.replay_circle_filled
                                : Icons.shopping_cart_outlined,
                          ),
                          DetailRow(
                            title: showRefund ? "Refund Amount" : "Amount",
                            value: "$currency $amount",
                            icon: showRefund
                                ? Icons.money_off_csred
                                : Icons.payments,
                          ),
                          if (!showRefund) ...[
                            DetailRow(
                              title: "Payment Method",
                              value: paymentData?.method ?? '_',
                              icon: Icons.account_balance_wallet_outlined,
                            ),
                            DetailRow(
                              title: "Bank",
                              value: paymentData?.bank ?? "_",
                              icon: Icons.account_balance,
                            ),
                            DetailRow(
                              title: "Email",
                              value: paymentData?.email ?? "_",
                              icon: Icons.email_outlined,
                            ),
                            DetailRow(
                              title: "Contact",
                              value: paymentData?.contact ?? "_",
                              icon: Icons.phone,
                            ),
                          ],
                          const Divider(),
                          DetailRow(
                            title:
                                showRefund ? "Refund Status" : "Payment Status",
                            value: (status == 'created'
                                ? "Pending"
                                : status == "captured"
                                    ? "Success"
                                    : status),
                            icon: showRefund
                                ? Icons.replay_circle_filled
                                : Icons.verified,
                            valueStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final TextStyle? valueStyle;

  const DetailRow({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          // const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: valueStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          )
        ],
      ),
    );
  }
}

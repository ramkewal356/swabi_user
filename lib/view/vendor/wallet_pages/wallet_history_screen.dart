// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/transaction_model.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:intl/intl.dart';

class WalletHistoryScreen extends StatefulWidget {
  final List<Transaction> transactionList;

  const WalletHistoryScreen({
    super.key,
    required this.transactionList,
  });

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = ['All', 'Credit', 'Debit', 'Pending'];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  List<Transaction> _filterByTab() {
    String selected = tabs[_tabController.index];
    if (selected == 'All') return widget.transactionList;
    if (selected == 'Credit') {
      return widget.transactionList.where((t) => t.type == "CREDIT").toList();
    }
    if (selected == 'Debit') {
      return widget.transactionList.where((t) => t.type == "DEBIT").toList();
    }
    if (selected == 'Pending') {
      return widget.transactionList
          .where((t) => t.status == "PENDING")
          .toList();
    }
    return widget.transactionList;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'SUCCESS':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _transactionIcon(String type) {
    return type == "CREDIT"
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;
  }

  Color _transactionIconColor(String type) {
    return type == "CREDIT" ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _filterByTab();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text('Wallet History',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              indicatorColor: btnColor,
              indicatorWeight: 3,
              labelColor: btnColor,
              unselectedLabelColor: Colors.black54,
              tabs: tabs.map((e) => Tab(text: e)).toList(),
              onTap: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: filteredTransactions.isEmpty
                ? _buildEmptyMessage()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: filteredTransactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) =>
                        _buildTransactionTile(filteredTransactions[idx]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Transaction t) {
    final dateStr = DateFormat('yyyy-MM-dd, hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(t.createdAt ?? 0, isUtc: false));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.7,
      color: background,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: _transactionIconColor(t.type ?? '').withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            _transactionIcon(t.type ?? ''),
            color: _transactionIconColor(t.type ?? ''),
            size: 30,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                t.category ?? '',
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Text(
              "${t.type == "CREDIT" ? '+' : '-'}${t.currency} ${t.amount?.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: _transactionIconColor(t.type ?? ''),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            spacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category_rounded,
                      color: Colors.grey.shade400, size: 18),
                  const SizedBox(width: 4),
                  Text(t.description ?? '',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded,
                      color: Colors.grey.shade400, size: 16),
                  const SizedBox(width: 4),
                  Text(dateStr,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      )),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(t.status ?? '').withOpacity(0.09),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  t.status ?? '',
                  // t.status[0] +
                  //     t.status.substring(1).toLowerCase(), "// pretty print
                  style: TextStyle(
                    color: _statusColor(t.status ?? ''),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        children: const [
          Icon(Icons.receipt_long_rounded, color: Colors.grey, size: 70),
          SizedBox(height: 24),
          Text(
            "No transaction history found.",
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

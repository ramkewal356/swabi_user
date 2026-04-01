// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_cab/widgets/custom_list_tile.dart';

enum UserType { user, vendor }

class HelpAndSupport extends StatefulWidget {
  final UserType userType;
  const HelpAndSupport({super.key, this.userType = UserType.user});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 1;
  final int _perPage = 10;
  String _searchText = '';
  String _filter = 'All';

  // Dummy data, replace with actual fetched data from backend
  List<Map<String, String>> helpListData = List.generate(
    30,
    (index) => {
      'id': '${index + 1}',
      'type': index % 2 == 0 ? 'Rental' : 'Package',
      'title': 'Help Issue #${index + 1}',
      'description': 'Description for help issue #${index + 1}.',
      'status': index % 3 == 0 ? 'Resolved' : 'Pending'
    },
  );

  @override
  void initState() {
    super.initState();
    if (widget.userType == UserType.vendor) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void dispose() {
    if (widget.userType == UserType.vendor) {
      _tabController.dispose();
    }
    super.dispose();
  }

  List<Map<String, String>> getFilteredData() {
    var filtered = helpListData.where((item) {
      if (_filter != 'All' && item['status'] != _filter) return false;
      if (_searchText.isNotEmpty &&
          !item['title']!.toLowerCase().contains(_searchText.toLowerCase())) {
        return false;
      }
      if (widget.userType == UserType.vendor &&
          _tabController.index == 0 &&
          item['type'] != 'Rental') {
        return false;
      }
      if (widget.userType == UserType.vendor &&
          _tabController.index == 1 &&
          item['type'] != 'Package') {
        return false;
      }
      return true;
    }).toList();

    // Pagination
    int start = (_currentPage - 1) * _perPage;
    // int end = start + _perPage;
    return filtered.skip(start).take(_perPage).toList();
  }

  // User Help & Support UI (as per requirement)
  Widget _buildUserHelpSupport(BuildContext context) {
    return PageLayoutPage(
      child: Column(
        children: [
          CustomListTile(
            img: raiseIssue,
            iconColor: btnColor,
            heading: "Raised Issue",
            onTap: () => context.push("/raiseIssueDetail"),
          ),
          CustomListTile(
            disableColor: true,
            img: contact,
            iconColor: btnColor,
            heading: "Contact Us",
            onTap: () {
              // context.push("/contact");
            },
          ),
          CustomListTile(
            disableColor: true,
            img: privacyPolicy,
            iconColor: btnColor,
            heading: "Privacy & Policy",
            onTap: () {},
          ),
          CustomListTile(
            img: tnc,
            iconColor: btnColor,
            heading: "Terms & Condition",
            onTap: () {
              context.push("/termCondition");
            },
          ),
        ],
      ),
    );
  }

  // Vendor Help & Support UI (Tabs for Rental & Package)
  Widget _buildVendorHelpSupport() {
    final filteredData = getFilteredData();
    final currentType = _tabController.index == 0 ? 'Rental' : 'Package';
    final totalCount = helpListData.where((item) {
      if (item['type'] != currentType) return false;
      if (_filter != 'All' && item['status'] != _filter) return false;
      if (_searchText.isNotEmpty &&
          !item['title']!.toLowerCase().contains(_searchText.toLowerCase())) {
        return false;
      }
      return true;
    }).length;

    return PageLayoutPage(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: btnColor,
            labelColor: btnColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Rental'),
              Tab(text: 'Package'),
            ],
            onTap: (_) {
              setState(() {
                _currentPage = 1;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildTopFilterBar(),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                ...filteredData.map((data) => buildHelpCard(data)),
                if (filteredData.isEmpty)
                  const Center(
                      child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text("No help issues found."))),
              ],
            ),
          ),
          _buildPagination(totalCount),
        ],
      ),
    );
  }

  Widget buildHelpCard(Map<String, String> data) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: btnColor.withOpacity(.15),
          child: Icon(Icons.help_outline, color: btnColor),
        ),
        title: Text(data['title'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(data['description'] ?? ''),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: (data['status'] == 'Resolved'
                ? Colors.green[100]
                : Colors.orange[100]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            data['status'] ?? '',
            style: TextStyle(
                color:
                    data['status'] == 'Resolved' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ),
        onTap: () {
          // Navigation or actions
        },
      ),
    );
  }

  Widget _buildTopFilterBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search help issues...",
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (text) {
              setState(() {
                _searchText = text;
                _currentPage = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          borderRadius: BorderRadius.circular(8),
          value: _filter,
          items: ['All', 'Pending', 'Resolved']
              .map<DropdownMenuItem<String>>(
                  (v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _filter = value!;
              _currentPage = 1;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPagination(int totalCount) {
    final pageCount = (totalCount / _perPage).ceil();
    if (pageCount < 2) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        Text('Page $_currentPage of $pageCount'),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_right),
          onPressed: _currentPage < pageCount
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: CustomAppBar(
        heading: "Help & Support",
        // Add further actions here as needed
      ),
      body: widget.userType == UserType.user
          ? _buildUserHelpSupport(context)
          : DefaultTabController(
              length: 2,
              child: _buildVendorHelpSupport(),
            ),
    );
  }
}

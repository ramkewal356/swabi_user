// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/getissue_model.dart' hide Status;
import 'package:flutter_cab/view/customer/raiseIssue_pages/issue_view_details_screen.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/no_data_found_widget.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/widgets/custom_filter_popup_widget.dart';
import 'package:flutter_cab/widgets/custom_search_field.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_cab/widgets/custom_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';

import '../../data/response/status.dart';

enum UserType { user, vendor }

class HelpAndSupport extends StatefulWidget {
  final UserType userType;
  const HelpAndSupport({super.key, this.userType = UserType.user});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  // final int _perPage = 10;
  String _searchText = '';
  String _filter = 'ALL';
  String title = 'ALL';
  final ScrollController _scrollController = ScrollController();
  Map<String, String> packageFilter = {
    "All": 'ALL',
    "Open": 'OPEN',
    "In Progress": 'IN_PROGRESS',
    "Resolved": "RESOLVED"
  };

  @override
  void initState() {
    super.initState();
    if (widget.userType == UserType.vendor) {
      _tabController = TabController(length: 2, vsync: this);
      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) return;
        getHelpAndSupportIssues(
            isSearch: false, isFilter: true, isPagination: false);
      });
      _scrollController.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getHelpAndSupportIssues(
            isSearch: false, isFilter: true, isPagination: false);
      });
    }
  
  }

  void getHelpAndSupportIssues(
      {bool isSearch = false,
      bool isFilter = false,
      bool isPagination = false}) async {
    // If userType is vendor, expect _tabController to exist
    final bookingType = widget.userType == UserType.vendor
        ? (_tabController?.index == 0 ? 'RENTAL_BOOKING' : 'PACKAGE_BOOKING')
        : null;
    context.read<RaiseissueViewModel>().getHelpAndSupportIssues(
          isSearch: isSearch,
          isFilter: isFilter,
          isPagination: isPagination,
          issueStatus: _filter,
          search: _searchText,
          bookingType: bookingType ?? '',
        );
  }

  void _onSearchChanged(String text) {
    setState(() {
      _searchText = text;
    });
    getHelpAndSupportIssues(
        isSearch: true, isFilter: false, isPagination: false);
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _filter = value ?? 'All';
      title = packageFilter.keys
          .firstWhere((k) => packageFilter[k] == _filter, orElse: () => 'All');
    });
    getHelpAndSupportIssues(
        isSearch: false, isFilter: true, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getHelpAndSupportIssues(isPagination: true);
    }
  }

  @override
  void dispose() {
    if (widget.userType == UserType.vendor) {
      _tabController?.dispose();
    }
    super.dispose();
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
    return PageLayoutPage(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.07),
                  blurRadius: 14,
                  spreadRadius: 2,
                )
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: btnColor.withOpacity(0.12),
              ),
              labelColor: btnColor,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
              tabs: const [
                Tab(text: 'Rental'),
                Tab(text: 'Package'),
              ],
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              splashFactory: InkRipple.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => states.contains(MaterialState.pressed)
                    ? btnColor.withOpacity(0.07)
                    : null,
              ),
              // Remove the default underline by setting indicator to BoxDecoration above.
              // No need to do anything else as indicator is not a line.
            ),
          ),
          const SizedBox(height: 12),
          _buildTopFilterBar(),
          const SizedBox(height: 12),
          Expanded(
            child: Consumer<RaiseissueViewModel>(
              builder: (context, value, child) {
                final List<Content> allData =
                    value.helpAndSupportResponse.data ?? [];
                // Filter items according to the selected status
                final List<Content> filteredData = (_filter == 'ALL')
                    ? allData
                    : allData
                        .where((item) =>
                            (item.issueStatus ?? '').toUpperCase() ==
                            _filter.toUpperCase())
                        .toList();
                if (value.helpAndSupportResponse.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (filteredData.isEmpty) {
                  return NoDataFoundWidget(text: 'No Data Found');
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredData.length + (value.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == filteredData.length) {
                      return value.isLoadingMore
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }
                    return buildHelpCard(filteredData[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHelpCard(Content data) {
    // Format date if available (assuming ISO 8601 string), else empty string
    String formattedDate = '';
    if (data.createdDate != null) {
      try {
        final date = data.createdDate;
        formattedDate = "${date?.day}/${date?.month}/${date?.year}";
      } catch (_) {
        formattedDate = data.createdDate as String;
      }
    }

    // Determine status text and color according to issueStatus and selected filter
    String statusText = 'Pending';
    Color? statusColor = Colors.orange;
    Color? statusBg = Colors.orange[100];
    // Match both with filter and actual data status
    String? dataStatus = (data.issueStatus ?? '').toUpperCase();
    if (dataStatus == 'RESOLVED') {
      statusText = 'Resolved';
      statusColor = Colors.green;
      statusBg = Colors.green[100];
    } else if (dataStatus == 'OPEN') {
      statusText = 'Open';
      statusColor = Colors.orange;
      statusBg = Colors.orange[100];
    } else if (dataStatus == 'IN_PROGRESS') {
      statusText = 'In Progress';
      statusColor = Colors.blue;
      statusBg = Colors.blue[100];
    }
    // If filter is applied and not "ALL", show textual status according to filter
    if (_filter != 'ALL') {
      if (_filter == 'RESOLVED') {
        statusText = 'Resolved';
        statusColor = Colors.green;
        statusBg = Colors.green[100];
      } else if (_filter == 'OPEN') {
        statusText = 'Open';
        statusColor = Colors.orange;
        statusBg = Colors.orange[100];
      } else if (_filter == 'IN_PROGRESS') {
        statusText = 'In Progress';
        statusColor = Colors.blue;
        statusBg = Colors.blue[100];
      }
    }

    return Card(
      color: background,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // Icon
        leading: CircleAvatar(
          backgroundColor: btnColor.withOpacity(.15),
          child: Icon(Icons.help_outline, color: btnColor),
        ),
        // Issue type as title, ID and booking id below it
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   data.issueType ?? '',
            //   style: const TextStyle(fontWeight: FontWeight.w600),
            // ),
            // Issue/Booking IDs
            if (data.issueId != null && data.issueId!.toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  "Issue ID: ${data.issueId}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            if (data.bookingId != null && data.bookingId!.toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  "Booking ID: ${data.bookingId}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
          ],
        ),
        // Description + more details (raised by/date)
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((data.raisedByRole ?? '').isNotEmpty ||
                formattedDate.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    if ((data.raisedByRole ?? '').isNotEmpty)
                      Text(
                        "By: ${data.raisedByRole!}",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    if ((data.raisedByRole ?? '').isNotEmpty &&
                        formattedDate.isNotEmpty)
                      const SizedBox(width: 10),
                    if (formattedDate.isNotEmpty)
                      Text(
                        "Date: $formattedDate",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                  ],
                ),
              ),
          ],
        ),
        // Status
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: () {
          // Navigation or actions
          context
              .push('/issueDetailsbyId',
                  extra: IssueViewDetails(
                    issueId: data.issueId.toString(),
                    userType: 'VENDOR',
                  ))
              .then((onValue) {
            getHelpAndSupportIssues(
                isSearch: false, isFilter: true, isPagination: false);
          });
        },
      ),
    );
  }

  Widget _buildTopFilterBar() {
    return Row(
      children: [
        Expanded(
          child: CustomSearchField(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                color: greyColor1,
              ),
            ),
            fillColor: background,
            filled: true,
            controller: _searchController,
            focusNode: _searchFocus,
            serchHintText: 'search.. ',
            onChanged: _onSearchChanged,
          ),
        ),
        const SizedBox(width: 8),
        CustomFilterPopupWidget(
            title: title,
            filterOptions: packageFilter,
            onFilterChanged: _onFilterChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: CustomAppBar(
        heading: "Help & Support",
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

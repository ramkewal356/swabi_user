import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/widgets/custom_filter_popup_widget.dart';
import 'package:flutter_cab/widgets/custom_search_field.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view_model/activity_management_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActivityManagementScreen extends StatefulWidget {
  const ActivityManagementScreen({super.key});

  @override
  State<ActivityManagementScreen> createState() =>
      _ActivityManagementScreenState();
}

class _ActivityManagementScreenState extends State<ActivityManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Map<String, String> packageFilter = {
    "All": 'ALL',
    "Active": 'TRUE',
    "InActive": 'FALSE',
  };
  String title = "All";
  String selectedStatus = 'ALL';
  String searchText = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllActivityList(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllActivityList({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<ActivityManagementViewModel>().getAllActivityListApi(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
        activityStatus: selectedStatus,
        searchText: searchText);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllActivityList(isSearch: true, isFilter: false, isPagination: false);
    });
    // Handle search logic here
    debugPrint("Search value: $value");
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedStatus = value;
      // Handle filter logic here
      debugPrint("Selected bid: $selectedStatus");
    });
    _getAllActivityList(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllActivityList(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuss =
        context.watch<ActivityManagementViewModel>().activeOrDeactive.status;
    return PageLayoutPage(
      appBar: AppBar(
        title: const Text("Acivity Management"),
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
                  filterOptions: packageFilter,
                  onFilterChanged: _onFilterChanged),
              SizedBox(width: 5),
              IconButton.filled(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(btnColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(6)))),
                  onPressed: () {
                    context
                        .push(
                            '/vendor_dashboard/activity_management/add_edit_activity')
                        .then((onValue) {
                      _getAllActivityList(isFilter: true);
                    });
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          SizedBox(height: 5),
          Expanded(child: Consumer<ActivityManagementViewModel>(
            builder: (context, value, child) {
              if (value.getAllActivityListData.status == Status.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: greenColor,
                  ),
                );
              } else {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: (value.getAllActivityListData.data ?? []).length +
                      (value.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == value.getAllActivityListData.data?.length) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: greenColor,
                        ),
                      );
                    }
                    var activityList =
                        value.getAllActivityListData.data?[index];
                    return Card(
                      color: background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Status
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activityList?.activityName ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  // Details
                                  Text(
                                      "Activity Id : ${activityList?.activityId}"),
                                  Text("Country : ${activityList?.country}"),
                                  Text(
                                      "Season : ${activityList?.bestTimeToVisit}"),
                                  Text(
                                      "Time : ${activityList?.startTime} - ${activityList?.endTime}"),
                                  Text(
                                      "Price : ${activityList?.currency} ${activityList?.activityPrice?.toInt()}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: btnColor)),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),

                            // Action buttons
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color:
                                        activityList?.activityStatus == "TRUE"
                                            ? Colors.green
                                            : Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    activityList?.activityStatus == "TRUE"
                                        ? 'ACTIVE'
                                        : "INACTIVE",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                SizedBox(height: 10),
                                PopupMenuButton<String>(
                                  color: background,
                                  onSelected: (value) {
                                    if (value == "View") {
                                      context.push(
                                          '/vendor_dashboard/activity_management/view_activity',
                                          extra: {
                                            "activityId": activityList
                                                ?.activityId
                                                .toString()
                                          }).then((onValue) {
                                        _getAllActivityList(isFilter: true);
                                      });
                                    } else if (value == "Edit") {
                                      context.push(
                                          '/vendor_dashboard/activity_management/add_edit_activity',
                                          extra: {
                                            "isEdit": true,
                                            "activityId": activityList
                                                ?.activityId
                                                .toString()
                                          }).then((onValue) {
                                        _getAllActivityList(isFilter: true);
                                      });
                                    } else if (value == "Deactivate" ||
                                        value == "Activate") {
                                      _showConfirmationDialog(
                                        context: context,
                                        action: value,
                                        loader: statuss == Status.loading,
                                        onTap: () {
                                          Navigator.pop(context);
                                          if (value == "Deactivate") {
                                            context
                                                .read<
                                                    ActivityManagementViewModel>()
                                                .activeDeactiveActivityApi(
                                                    activityId: activityList
                                                            ?.activityId
                                                            .toString() ??
                                                        '')
                                                .then((onValue) {
                                              _getAllActivityList(
                                                  isFilter: true);
                                            });
                                          } else {
                                            context
                                                .read<
                                                    ActivityManagementViewModel>()
                                                .activeDeactiveActivityApi(
                                                    activityId: activityList
                                                            ?.activityId
                                                            .toString() ??
                                                        '',
                                                    isActive: true)
                                                .then((onValue) {
                                              _getAllActivityList(
                                                  isFilter: true);
                                            });
                                          }
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: "View", child: Text("View")),
                                    if (activityList?.activityStatus == 'TRUE')
                                      PopupMenuItem(
                                          value: "Edit", child: Text("Edit")),
                                    PopupMenuItem(
                                        value: activityList?.activityStatus ==
                                                'TRUE'
                                            ? "Deactivate"
                                            : "Activate",
                                        child: Text(
                                            activityList?.activityStatus ==
                                                    'TRUE'
                                                ? "Deactivate"
                                                : "Activate")),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ))
        ],
      ),
    );
  }

  void _showConfirmationDialog(
      {required BuildContext context,
      required String action,
      bool loader = false,
      required void Function()? onTap}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$action Activity"),
        content: Text("Are you sure you want to $action this Activity?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              CustomButtonSmall(
                width: 120,
                height: 40,
                elevation: 4,
                borderRadius: BorderRadius.circular(25),
                loading: loader,
                onTap: onTap,
                btnHeading: action,
              ),
            ],
          )
        ],
      ),
    );
  }
}

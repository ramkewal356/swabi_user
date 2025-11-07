import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/res/custom_filter_popup_widget.dart';
import 'package:flutter_cab/res/custom_search_field.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/vehicle_owner_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class VehicleOwnerManagementScreen extends StatefulWidget {
  const VehicleOwnerManagementScreen({super.key});

  @override
  State<VehicleOwnerManagementScreen> createState() =>
      _VehicleOwnerManagementScreenState();
}

class _VehicleOwnerManagementScreenState
    extends State<VehicleOwnerManagementScreen> {
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
      _getAllVehicleOwnerList(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllVehicleOwnerList({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<VehicleOwnerViewModel>().getVehicleOwnerListApi(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
        filterText: selectedStatus,
        searchText: searchText);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllVehicleOwnerList(
          isSearch: true, isFilter: false, isPagination: false);
    });
    // Handle search logic here
    debugPrint("Search value: $value");
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedStatus = value;
      // Handle filter logic here
      debugPrint("Selected owner: $selectedStatus");
    });
    _getAllVehicleOwnerList(
        isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllVehicleOwnerList(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuss =
        context.watch<VehicleOwnerViewModel>().activeOrDeactive.status;
    return PageLayoutPage(
      appBar: AppBar(
        title: const Text("Vehicle Owner Management"),
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
            ],
          ),
          SizedBox(height: 5),
          Expanded(child: Consumer<VehicleOwnerViewModel>(
            builder: (context, value, child) {
              if (value.getVehicleOwnerList.status == Status.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: greenColor,
                  ),
                );
              } else {
                return (value.getVehicleOwnerList.data ?? []).isEmpty
                    ? Center(
                        child: Text(
                          'No Data Found',
                          style: nodataTextStyle,
                        ),
                      )
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: (value.getVehicleOwnerList.data ?? []).length +
                      (value.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == value.getVehicleOwnerList.data?.length) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: greenColor,
                        ),
                      );
                    }
                    var vehicleOwnerList =
                        value.getVehicleOwnerList.data?[index];

                    return Card(
                      color: background,
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          color: btnColor, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        '${vehicleOwnerList?.firstName} ${vehicleOwnerList?.lastName} (${vehicleOwnerList?.vehicleOwnerId})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.email,
                                          color: btnColor, size: 20),
                                      SizedBox(width: 5),
                                      Text('${vehicleOwnerList?.email}'),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.phone,
                                          color: btnColor, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                          '+${vehicleOwnerList?.countryCode} ${vehicleOwnerList?.mobile}'),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: btnColor, size: 20),
                                      SizedBox(width: 5),
                                      Text('${vehicleOwnerList?.country}'),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.directions_car,
                                          color: btnColor, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                          'Assigned Vehicle : ${vehicleOwnerList?.vehicleList?.length}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: vehicleOwnerList?.status == true
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    vehicleOwnerList?.status == true
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
                                          '/vendor_dashboard/vehicle_owner_management/view_vehicle_owner_details',
                                          extra: {
                                            "ownerId": vehicleOwnerList
                                                ?.vehicleOwnerId
                                                .toString()
                                          }).then((onValue) {
                                        _getAllVehicleOwnerList(isFilter: true);
                                      });
                                    } else if (value == "Edit") {
                                      context.push(
                                          '/vendor_dashboard/vehicle_management/add_edit_vehicle',
                                          extra: {
                                            // "isEdit": true,
                                            "ownerId": vehicleOwnerList
                                                ?.vehicleOwnerId
                                                .toString(),
                                            "actionByOwner": 'edit owner',
                                          }).then((onValue) {
                                        _getAllVehicleOwnerList(isFilter: true);
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
                                                          VehicleOwnerViewModel>()
                                                      .activeDeactiveVehicleOwnerApi(
                                                        ownerId: vehicleOwnerList
                                                                ?.vehicleOwnerId
                                                                .toString() ??
                                                            '',
                                                      )
                                                      .then((onValue) {
                                                    _getAllVehicleOwnerList(
                                                        isFilter: true);
                                                  });
                                          } else {
                                                  context
                                                      .read<
                                                          VehicleOwnerViewModel>()
                                                      .activeDeactiveVehicleOwnerApi(
                                                          ownerId: vehicleOwnerList
                                                                  ?.vehicleOwnerId
                                                                  .toString() ??
                                                              '',
                                                          isActive: true)
                                                      .then((onValue) {
                                                    _getAllVehicleOwnerList(
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
                                    if (vehicleOwnerList?.status == true)
                                      PopupMenuItem(
                                          value: "Edit", child: Text("Edit")),
                                    PopupMenuItem(
                                        value: vehicleOwnerList?.status == true
                                            ? "Deactivate"
                                            : "Activate",
                                        child: Text(
                                            vehicleOwnerList?.status == true
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
        title: Text("$action Vehicle Owner"),
        content: Text("Are you sure you want to $action this Vehicle Owner?"),
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

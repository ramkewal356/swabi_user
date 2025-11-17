import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/res/custom_filter_popup_widget.dart';
import 'package:flutter_cab/res/custom_search_field.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/vehicle_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() =>
      _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
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
      _getAllVehicleList(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllVehicleList({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<VehicleViewModel>().getAllVehicleListApi(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
        filterText: selectedStatus,
        searchText: searchText);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllVehicleList(isSearch: true, isFilter: false, isPagination: false);
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
    _getAllVehicleList(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllVehicleList(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuss =
        context.watch<VehicleViewModel>().activeOrDeactive.status;
    return PageLayoutPage(
      appBar: AppBar(
        title: Text(
          "Vehicle Management",
          style: appBarTitleStyle,
        ),
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
                            '/vendor_dashboard/vehicle_management/add_edit_vehicle')
                        .then((onValue) {
                      _getAllVehicleList(isFilter: true);
                    });
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          SizedBox(height: 5),
          Expanded(child: Consumer<VehicleViewModel>(
            builder: (context, value, child) {
              if (value.getVehicleList.status == Status.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: greenColor,
                  ),
                );
              } else {
                return (value.getVehicleList.data ?? []).isEmpty
                    ? Center(
                        child: Text(
                          'No Data found',
                          style: nodataTextStyle,
                        ),
                      )
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: (value.getVehicleList.data ?? []).length +
                      (value.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == value.getVehicleList.data?.length) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: greenColor,
                        ),
                      );
                    }
                    var vehicleList = value.getVehicleList.data?[index];
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
                                  Text(
                                    vehicleList?.carName ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                      'Vehicle Id : ${vehicleList?.vehicleId.toString()}'),
                                  Text(
                                      'Vehicle Type : ${vehicleList?.carType}'),
                                  Text(
                                      'Vehicle No : ${vehicleList?.vehicleNumber}'),
                                  Text('Model No: ${vehicleList?.modelNo}'),
                                  Text(
                                      'Year : ${vehicleList?.year} - Seats : ${vehicleList?.seats}'),
                                  // Text('Seats : ${vehicleList?.seats}'),
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
                                    color: vehicleList?.vehicleStatus == "TRUE"
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    vehicleList?.vehicleStatus == "TRUE"
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
                                          '/vendor_dashboard/vehicle_management/view_vehicle_details',
                                          extra: {
                                            "vehicleId": vehicleList?.vehicleId
                                                .toString()
                                      }).then((onValue) {
                                        _getAllVehicleList(isFilter: true);
                                      });
                                    } else if (value == "Edit") {
                                      context.push(
                                          '/vendor_dashboard/vehicle_management/add_edit_vehicle',
                                          extra: {
                                            "isEdit": true,
                                            "vehicleId": vehicleList?.vehicleId
                                                .toString()
                                          }).then((onValue) {
                                        _getAllVehicleList(isFilter: true);
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
                                                    VehicleViewModel>()
                                                .activeDeactiveVehicleApi(
                                                    vehicleId: vehicleList
                                                            ?.vehicleId
                                                            .toString() ??
                                                        '')
                                                .then((onValue) {
                                              _getAllVehicleList(
                                                  isFilter: true);
                                            });
                                          } else {
                                            context
                                                .read<
                                                    VehicleViewModel>()
                                                .activeDeactiveVehicleApi(
                                                    vehicleId: vehicleList
                                                            ?.vehicleId
                                                            .toString() ??
                                                        '',
                                                    isActive: true)
                                                .then((onValue) {
                                              _getAllVehicleList(
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
                                    if (vehicleList?.vehicleStatus == 'TRUE')
                                      PopupMenuItem(
                                          value: "Edit", child: Text("Edit")),
                                    PopupMenuItem(
                                        value:
                                            vehicleList?.vehicleStatus == 'TRUE'
                                                ? "Deactivate"
                                                : "Activate",
                                        child: Text(
                                            vehicleList?.vehicleStatus == 'TRUE'
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
        title: Text("$action Vehicle"),
        content: Text("Are you sure you want to $action this vehicle?"),
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

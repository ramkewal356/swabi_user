import 'package:flutter/material.dart';

import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/res/custom_filter_popup_widget.dart';
import 'package:flutter_cab/res/custom_search_field.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/driver_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../model/driver_model.dart' hide Status;

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
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
      _getAllDriverList(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllDriverList({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<DriverViewModel>().fetchAllDrivers(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
        filterText: selectedStatus,
        searchText: searchText);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllDriverList(isSearch: true, isFilter: false, isPagination: false);
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
    _getAllDriverList(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllDriverList(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final statuss = context.watch<DriverViewModel>().activeOrDeactive.status;
    return PageLayoutPage(
      appBar: AppBar(
        title: const Text("Driver Management"),
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
                      _getAllDriverList(isFilter: true);
                    });
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          SizedBox(height: 5),
          Expanded(child: Consumer<DriverViewModel>(
            builder: (context, value, child) {
              if (value.driverList.status == Status.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: greenColor,
                  ),
                );
              } else {
                return (value.driverList.data ?? []).isEmpty
                    ? Center(
                        child: Text(
                          'No Data found',
                          style: nodataTextStyle,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: (value.driverList.data ?? []).length +
                            (value.isLastPage ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == value.driverList.data?.length) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: greenColor,
                              ),
                            );
                          }
                          var driverData = value.driverList.data?[index];
                          return buildDriverCard(
                            driverData: driverData,
                            context: context,
                            onAction: (action) {
                              if (action == "View") {
                                // navigate or handle view
                              } else if (action == "Edit") {
                                // handle edit
                              } else if (action == "Deactivate" ||
                                  action == "Activate") {
                                // handle status change
                                _showConfirmationDialog(
                                  context: context,
                                  action: action,
                                  onTap: () {},
                                );
                              }
                            },
                          );
                          // return Card(
                          //   color: background,
                          //   margin: EdgeInsets.symmetric(
                          //       horizontal: 2, vertical: 6),
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   elevation: 4,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(10.0),
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Expanded(
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               Text(
                          //                 '${driverData?.firstName} ${driverData?.lastName}',
                          //                 style: TextStyle(
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 15),
                          //               ),
                          //               Text(
                          //                   'Driver Id : ${driverData?.driverId.toString()}'),
                          //               Text(
                          //                   'Contact No : +${driverData?.countryCode} ${driverData?.mobile}'),
                          //               Text('Gender : ${driverData?.gender}'),
                          //               Text(
                          //                   'Location: ${driverData?.driverAddress}'),
                          //             ],
                          //           ),
                          //         ),
                          //         Column(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             Container(
                          //               padding: EdgeInsets.symmetric(
                          //                   horizontal: 10, vertical: 6),
                          //               decoration: BoxDecoration(
                          //                 color:
                          //                     driverData?.driverStatus == "TRUE"
                          //                         ? Colors.green
                          //                         : Colors.red,
                          //                 borderRadius:
                          //                     BorderRadius.circular(20),
                          //               ),
                          //               child: Text(
                          //                 driverData?.driverStatus == "TRUE"
                          //                     ? 'ACTIVE'
                          //                     : "INACTIVE",
                          //                 style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontSize: 12),
                          //               ),
                          //             ),
                          //             SizedBox(height: 10),
                          //             PopupMenuButton<String>(
                          //               color: background,
                          //               onSelected: (value) {
                          //                 if (value == "View") {
                          //                   context.push(
                          //                       '/vendor_dashboard/vehicle_management/view_vehicle_details',
                          //                       extra: {
                          //                         "driverId": driverData
                          //                             ?.driverId
                          //                             .toString()
                          //                       }).then((onValue) {
                          //                     _getAllDriverList(isFilter: true);
                          //                   });
                          //                 } else if (value == "Edit") {
                          //                   context.push(
                          //                       '/vendor_dashboard/vehicle_management/add_edit_vehicle',
                          //                       extra: {
                          //                         "isEdit": true,
                          //                         "driverId": driverData
                          //                             ?.driverId
                          //                             .toString()
                          //                       }).then((onValue) {
                          //                     _getAllDriverList(isFilter: true);
                          //                   });
                          //                 } else if (value == "Deactivate" ||
                          //                     value == "Activate") {
                          //                   _showConfirmationDialog(
                          //                     context: context,
                          //                     action: value,
                          //                     // loader: statuss == Status.loading,
                          //                     onTap: () {
                          //                       Navigator.pop(context);
                          //                       if (value == "Deactivate") {
                          //                         // context
                          //                         //     .read<DriverViewModel>()
                          //                         //     .activeDeactiveVehicleApi(
                          //                         //         driverId: driverData
                          //                         //                 ?.driverId
                          //                         //                 .toString() ??
                          //                         //             '')
                          //                         //     .then((onValue) {
                          //                         //   _getAllDriverList(
                          //                         //       isFilter: true);
                          //                         // });
                          //                       } else {
                          //                         // context
                          //                         //     .read<DriverViewModel>()
                          //                         //     .activeDeactiveVehicleApi(
                          //                         //         driverId: driverData
                          //                         //                 ?.driverId
                          //                         //                 .toString() ??
                          //                         //             '',
                          //                         //         isActive: true)
                          //                         //     .then((onValue) {
                          //                         //   _getAllDriverList(
                          //                         //       isFilter: true);
                          //                         // });
                          //                       }
                          //                     },
                          //                   );
                          //                 }
                          //               },
                          //               itemBuilder: (context) => [
                          //                 PopupMenuItem(
                          //                     value: "View",
                          //                     child: Text("View")),
                          //                 if (driverData?.driverStatus ==
                          //                     'TRUE')
                          //                   PopupMenuItem(
                          //                       value: "Edit",
                          //                       child: Text("Edit")),
                          //                 PopupMenuItem(
                          //                     value: driverData?.driverStatus ==
                          //                             'TRUE'
                          //                         ? "Deactivate"
                          //                         : "Activate",
                          //                     child: Text(
                          //                         driverData?.driverStatus ==
                          //                                 'TRUE'
                          //                             ? "Deactivate"
                          //                             : "Activate")),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // );
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
        title: Text("$action Driver"),
        content: Text("Are you sure you want to $action this Driver?"),
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

  Widget buildDriverCard({
    Content? driverData,
    required BuildContext context,
    required Function(String) onAction,
  }) {
    bool isActive = driverData?.driverStatus == "TRUE";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧑 Profile avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              backgroundImage: driverData?.profileImageUrl != null
                  ? NetworkImage(driverData?.profileImageUrl ?? '')
                  : null,
              child: driverData?.profileImageUrl == null
                  ? const Icon(Icons.person, size: 30, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),

            // 🧾 Driver details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${driverData?.firstName ?? ''} ${driverData?.lastName ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isActive ? Icons.check_circle : Icons.cancel,
                        color: isActive ? Colors.green : Colors.redAccent,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.badge, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Driver Id: ${driverData?.driverId ?? ''}',
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                          '+${driverData?.countryCode ?? ''} ${driverData?.mobile ?? ''}',
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          driverData?.driverAddress ?? '',
                          style: const TextStyle(color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ⚙️ Popup menu
            Column(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  color: background,
                  onSelected: (value) => onAction(value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: "View", child: Text("View")),
                    if (isActive)
                      const PopupMenuItem(value: "Edit", child: Text("Edit")),
                    PopupMenuItem(
                      value: isActive ? "Deactivate" : "Activate",
                      child: Text(isActive ? "Deactivate" : "Activate"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

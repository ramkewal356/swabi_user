import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_item_text.dart';
import 'package:flutter_cab/res/custom_filter_popup_widget.dart';
import 'package:flutter_cab/res/custom_search_field.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/view_model/package_management_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PackageManagementScreen extends StatefulWidget {
  const PackageManagementScreen({super.key});

  @override
  State<PackageManagementScreen> createState() =>
      _PackageManagementScreenState();
}

class _PackageManagementScreenState extends State<PackageManagementScreen> {
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
      _getAllPackageList(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllPackageList({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<PackageManagementViewModel>().getPackageListApi(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
        packageStatus: selectedStatus,
        searchText: searchText);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllPackageList(isSearch: true, isFilter: false, isPagination: false);
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
    _getAllPackageList(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllPackageList(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuss =
        context.watch<PackageManagementViewModel>().activeOrDeactive.status;
    return PageLayoutPage(
      appBar: AppBar(
        title: const Text("Package Management"),
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
                            '/vendor_dashboard/package_management/add_edit_package')
                        .then((onValue) {
                      _getAllPackageList(isFilter: true);
                    });
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          SizedBox(height: 5),
          Expanded(child: Consumer<PackageManagementViewModel>(
            builder: (context, value, child) {
              if (value.getPackageLists.status == Status.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: greenColor,
                  ),
                );
              } else {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: (value.getPackageLists.data ?? []).length +
                      (value.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == value.getPackageLists.data?.length) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: greenColor,
                        ),
                      );
                    }
                    var packageList = value.getPackageLists.data?[index];
                    return Card(
                      color: background,
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        title: Text(
                          packageList?.packageName ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomItemText(
                                lable: 'Country',
                                value: '${packageList?.country}'),
                            CustomItemText(
                                lable: 'Activities',
                                value:
                                    '${packageList?.packageActivities?.length}, Days: ${packageList?.noOfDays}'),
                            CustomItemText(
                                lable: 'Price',
                                value: '${packageList?.totalPrice}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: packageList?.packageStatus == "TRUE"
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                packageList?.packageStatus ?? '',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: PopupMenuButton<String>(
                                color: background,
                                onSelected: (value) {
                                  if (value == "View") {
                                    context.push('/package_view', extra: {
                                      "packageId":
                                          packageList?.packageId.toString(),
                                      "userType": 'Vendor',
                                      "userId": '',
                                      "bookingDate": ''
                                    }).then((onValue) {
                                      _getAllPackageList(isFilter: true);
                                    });
                                  } else if (value == "Edit") {
                                    context.push(
                                        '/vendor_dashboard/package_management/add_edit_package',
                                        extra: {
                                          "isEdit": true,
                                          "packageId":
                                              packageList?.packageId.toString()
                                        }).then((onValue) {
                                      _getAllPackageList(isFilter: true);
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
                                                  PackageManagementViewModel>()
                                              .activeDeactiveApi(
                                                  packageId: packageList
                                                          ?.packageId
                                                          .toString() ??
                                                      '')
                                              .then((onValue) {
                                            _getAllPackageList(isFilter: true);
                                          });
                                        } else {
                                          context
                                              .read<
                                                  PackageManagementViewModel>()
                                              .activeDeactiveApi(
                                                  packageId: packageList
                                                          ?.packageId
                                                          .toString() ??
                                                      '',
                                                  isActive: true)
                                              .then((onValue) {
                                            _getAllPackageList(isFilter: true);
                                          });
                                        }
                                      },
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: "View", child: Text("View")),
                                  PopupMenuItem(
                                      value: "Edit", child: Text("Edit")),
                                  PopupMenuItem(
                                      value:
                                          packageList?.packageStatus == 'TRUE'
                                              ? "Deactivate"
                                              : "Activate",
                                      child: Text(
                                          packageList?.packageStatus == 'TRUE'
                                              ? "Deactivate"
                                              : "Activate")),
                                ],
                              ),
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
        title: Text("$action Package"),
        content: Text("Are you sure you want to $action this package?"),
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

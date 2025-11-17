import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_tabbar.dart';
import 'package:flutter_cab/res/custom_search_field.dart';
import 'package:flutter_cab/res/page_history_container.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/package_management_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';


class PackageBookingManagement extends StatefulWidget {
  const PackageBookingManagement({super.key});
 

  @override
  State<PackageBookingManagement> createState() =>
      _PackageBookingManagementState();
}

class _PackageBookingManagementState extends State<PackageBookingManagement>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  // int pageLength = 40;
  ScrollController bookedPkgController = ScrollController();
  List<String> tabList = ['ALL BOOKING', 'UPCOMING', 'COMPLETED', 'CANCELLED'];
  TabController? _tabController;
  int initialIndex = 0;

  bool isVisibleIcon = false;

  final ScrollController _scrollController = ScrollController();

  String packageStatus = 'ALL';
  String sortDirection = 'desc';
  String searchText = '';
  void getAllPackageList(
      {bool isSort = false,
      bool isPagination = false,
      bool isFilter = false,
      bool isSearch = false}) {
    context.read<PackageManagementViewModel>().getAllPackageListApi(
        isFilter: isFilter,
        isSearch: isSearch,
        isPagination: isPagination,
        packageStatus: packageStatus,
        isSort: isSort,
        sortDirection: sortDirection,
        searchText: searchText);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabList.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllPackageList(isSort: true);
    });
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) return;

      if (initialIndex != _tabController!.index) {
        initialIndex = _tabController!.index;
        _onFilter(initialIndex);
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onSort() {
    setState(() {
      isVisibleIcon = !isVisibleIcon;
      sortDirection = isVisibleIcon ? 'asc' : 'desc';
    });
    getAllPackageList(isSort: true);
  }

  void _onFilter(int index) {
    const statusMap = {
      'ALL BOOKING': "ALL",
      'UPCOMING': 'BOOKED',
      'COMPLETED': 'COMPLETED',
      'CANCELLED': 'CANCELLED'
    };

    setState(() {
      packageStatus = statusMap[tabList[index]] ?? 'ALL';
      debugPrint('vvnbvbnvb,,,,,, $packageStatus');
    });
    getAllPackageList(isFilter: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getAllPackageList(isPagination: true);
    }
  }

  void onSearchChanged(String val) {
    setState(() {
      searchText = val;
    });
    getAllPackageList(isSearch: true);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int selectIndex = -1;
  @override
  Widget build(BuildContext context) {
    var status = context
        .watch<GetPackageHistoryDetailByIdViewModel>()
        .getPackageHistoryDetailById
        .status
        .toString();
    debugPrint('status $status');

    return Customtabbar(
        titleHeading: 'Package Management',
        controller: _tabController,
        tabs: tabList,
        onTap: _onFilter,
        titleWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  fillColor: background,
                  filled: true,
                  controller: _searchController,
                  serchHintText: 'Search',
                  onChanged: onSearchChanged,
                ),
              ),
              SizedBox(width: 10),
              const Text(
                'Sort by:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              IconButton(
                  onPressed: _onSort,
                  icon: isVisibleIcon
                      ? const Icon(
                          Icons.arrow_upward,
                          color: greenColor,
                        )
                      : const Icon(
                          Icons.arrow_downward,
                          color: greenColor,
                        ))
            ],
          ),
        ),
        viewchildren: List.generate(tabList.length, (index) {
          return Consumer<PackageManagementViewModel>(
            builder: (context, viewModel, child) {
              final response = viewModel.getPackageDataLists;

              if (response.status == Status.loading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: greenColor,
                ));
              } else if (response.status == Status.error) {
                return Center(
                    child: Text(
                  'No Data Found',
                  style: nodataTextStyle,
                ));
              } else if (response.status == Status.completed) {
                return (response.data ?? []).isEmpty
                    ? Center(
                        child: Container(
                            decoration: const BoxDecoration(),
                            child: Text(
                              'No Data Found',
                              style: nodataTextStyle,
                            )))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: (response.data ?? []).length +
                            (viewModel.isLastPage ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == (response.data ?? []).length) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: greenColor,
                            ));
                          }
                          var data = response.data?[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, right: 10, left: 10),
                            child: PackageHistoryContainer(
                              status: data?.bookingStatus ?? '',
                              pkgID: data?.packageBookingId.toString() ?? '',
                              bookingDate: data?.bookingDate ?? '',
                              customerName:
                                  '${data?.user?.firstName} ${data?.user?.lastName}',
                              price: (data?.totalPayableAmount.toString() ?? '')
                                      .isNotEmpty
                                  ? data?.totalPayableAmount.toString() ?? ''
                                  : data?.packagePrice == 0
                                      ? '0'
                                      : data?.packagePrice.toString() ?? "",
                              pkgName: data?.pkg?.packageName ?? '',
                              location: data?.pkg?.country ?? '',
                              imageList: (data?.pkg?.packageActivities ?? [])
                                  .expand((val) =>
                                      (val.activity?.activityImageUrl ?? [])
                                          .cast<String>())
                                  .toList(),
                              loader: status == 'Status.loading' &&
                                  selectIndex == index,
                              onTap: () {
                                context.push("/package/packageDetailsPageView",
                                    extra: {
                                      "userType": 'VENDOR',
                                      "bookingId":
                                          data?.packageBookingId.toString(),
                                      "paymentId": data?.paymentId ?? '',
                                      "bookingStatus": data?.bookingStatus
                                    }).then((onValue) {
                                  getAllPackageList(isSort: true);
                                });
                              },
                            ),
                          );
                        },
                      );
              }

              return Container();
            },
          );
        }));
    // );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_tabbar.dart';

import 'package:flutter_cab/res/page_history_container.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import '../../../../data/response/status.dart';

class PackageHistoryManagement extends StatefulWidget {
  final String userID;

  const PackageHistoryManagement({super.key, required this.userID});

  @override
  State<PackageHistoryManagement> createState() =>
      _PackageHistoryManagementState();
}

class _PackageHistoryManagementState extends State<PackageHistoryManagement>
    with SingleTickerProviderStateMixin {
  int pageLength = 40;
  ScrollController bookedPkgController = ScrollController();
  List<String> tabList = ['ALL BOOKING', 'UPCOMING', 'COMPLETED', 'CANCELLED'];
  TabController? _tabController;
  int initialIndex = 0;
  int currentPage = 0;
  bool isLoadingMore = false;
  bool isVisibleIcon = false;
  bool lastPage = false; // Assuming true at the start
  final int pageSize = 10; // Set your page size
  final ScrollController _scrollController = ScrollController();
  // List<PackageHistoryContent> bookedHistory = [];
  String status = 'ALL';
  String sortText = 'desc';
  Future<void> getPackageHistoryList(
      {bool isSort = false,
      bool isPagination = false,
      bool isfilter = false}) async {
    try {
      context
          .read<GetPackageHistoryViewModel>()
          .fetchGetPackageHistoryBookedViewModelApi(
            context: context,
            userId: widget.userID,
            isFilter: isfilter,
            filterText: status,
            isPagination: isPagination,
            isSort: isSort,
            sortText: sortText,
          );
    } catch (e) {
      debugPrint('Error fetching data: $e');
      // Handle error, e.g., show a toast or error message
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabList.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPackageHistoryList(isSort: true);
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
      sortText = isVisibleIcon ? 'asc' : 'desc';
    });
    getPackageHistoryList(isSort: true);
  }

  void _onFilter(int index) {
    const statusMap = {
      'ALL BOOKING': "ALL",
      'UPCOMING': 'BOOKED',
      'COMPLETED': 'COMPLETED',
      'CANCELLED': 'CANCELLED'
    };

    setState(() {
      status = statusMap[tabList[index]] ?? 'ALL';
      debugPrint('vvnbvbnvb,,,,,, $status');
    });
    getPackageHistoryList(isfilter: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getPackageHistoryList(isPagination: true);
    }
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
        titleHeading: 'My Packages',
        controller: _tabController,
        tabs: tabList,
        sortVisiblty: true,
        isVisible: isVisibleIcon,
        onTap: _onFilter,
        onTapSort: _onSort,
        viewchildren: List.generate(tabList.length, (index) {
          return Consumer<GetPackageHistoryViewModel>(
            builder: (context, viewModel, child) {
              final response = viewModel.getBookedHistory;

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
                              pkgID: data?.packageBookingId ?? '',
                              bookingDate: data?.bookingDate ?? '',
                              members: data?.numberOfMembers ?? '',
                              price: (data?.totalPayableAmount ?? '').isNotEmpty
                                  ? data?.totalPayableAmount ?? ''
                                  : data?.packagePrice == 'null'
                                      ? '0'
                                      : data?.packagePrice ?? "",
                              pkgName: data?.pkg.packageName ?? '',
                              location: data?.pkg.country ?? '',
                              imageList: data?.pkg.packageActivities
                                      .expand(
                                          (e) => e.activity.activityImageUrl)
                                      .toList() ??
                                  [],
                              loader: status == 'Status.loading' &&
                                  selectIndex == index,
                              onTap: () {
                                context.push("/package/packageDetailsPageView",
                                    extra: {
                                      "userType": 'USER',
                                      "bookingId": data?.packageBookingId,
                                      "paymentId": data?.paymentId,
                                      "bookingStatus": data?.bookingStatus
                                    }).then((onValue) {
                                  getPackageHistoryList(isSort: true);
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

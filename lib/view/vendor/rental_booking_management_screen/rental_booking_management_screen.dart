import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_tabbar.dart';
import 'package:flutter_cab/res/custom_search_field.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view/customer/my_rental/history/rental_listing_container.dart';
import 'package:flutter_cab/view_model/rental_management_view_model.dart';

import 'package:go_router/go_router.dart';

// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class RentalBookingManagementScreen extends StatefulWidget {
  const RentalBookingManagementScreen({super.key});

  @override
  State<RentalBookingManagementScreen> createState() =>
      _RentalBookingManagementScreenState();
}

class _RentalBookingManagementScreenState
    extends State<RentalBookingManagementScreen>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<String> tabList = [
    'All Booking',
    'Upcoming',
    'Ongoing',
    'Completed',
    'Cancelled'
  ];
  TabController? _tabController;
  int initialIndex = 0;
  bool isVisibleIcon = false;
  String sortText = 'desc';
  final ScrollController _scrollController = ScrollController();
  String searchText = '';
  String sortDirection = 'desc';
  String bookingStatus = 'ALL';
  void getAllRentalList(
      {bool isPagination = false,
      bool isfilter = false,
      bool isSort = false,
      bool isSearch = false}) {
    context.read<RentalManagementViewModel>().getAllRentalApi(
        isFilter: isfilter,
        isSearch: isSearch,
        isPagination: isPagination,
        searchText: searchText,
        sortDirection: sortDirection,
        bookingStatus: bookingStatus,
        isSort: isSort);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabList.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllRentalList(isSort: true);
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
    getAllRentalList(isSort: true);
  }

  void _onFilter(int index) {
    const statusMap = {
      'All Booking': 'ALL',
      'Upcoming': 'BOOKED',
      'Ongoing': 'ON_RUNNING',
      'Completed': 'COMPLETED',
      'Cancelled': 'CANCELLED',
    };

    setState(() {
      bookingStatus = statusMap[tabList[index]] ?? 'ALL';
      debugPrint('vvnbvbnvb,,,,,, $bookingStatus');
    });
    getAllRentalList(isfilter: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getAllRentalList(isPagination: true);
    }
  }

  void onSearchChanged(String val) {
    setState(() {
      searchText = val;
    });
    getAllRentalList(isSearch: true);
  }

  int intialloadingIndex = -1;
  bool sortVisiblty = true;
  @override
  Widget build(BuildContext context) {
    return Customtabbar(
        titleHeading: 'Rental Booking Management',
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
          return Consumer<RentalManagementViewModel>(
            builder: (context, viewModel, child) {
              final response = viewModel.getRentalData;

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
                final rentalData = response.data ?? [];

                if (rentalData.isEmpty) {
                  // return const Center(child: Text('No Data Available'));

                  return Center(
                      child: Container(
                          decoration: const BoxDecoration(),
                          child: Text(
                            'No Data Found',
                            style: nodataTextStyle,
                          )));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: rentalData.length + (viewModel.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == rentalData.length) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: greenColor,
                      ));
                    }
                    var data = rentalData[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                      child: RentalCarListingContainer(
                        onTapContainer: () async {
                          context.push('/rental_booking_details', extra: {
                            "bookingId": data.id.toString(),
                            "paymentId": data.paymentId,
                            "status": data.bookingStatus,
                            "userType": "VENDOR"
                          }).then((onValue) {
                            getAllRentalList(isSort: true);
                          });
                          // String? userId =
                          //     await UserViewModel().getUserId() ?? '';
                          // context.push('/rentalForm/rentalBookedPageView',
                          //     extra: {
                          //       "bookedId": data.id,
                          //       "useriD": userId,
                          //       "paymentId": data.paymentId
                          //     }).then((onValue) {
                          //   getAllRentalList(isSort: true);
                          // });
                        },
                        time: data.pickupTime ?? '',
                        bookingID: data.id.toString(),
                        pickUplocation: data.pickupLocation ?? '',
                        carOrCustomerName:
                            '${data.user?.firstName} ${data.user?.lastName}',
                        status: data.bookingStatus ?? '',
                        date: data.date ?? '',
                        chargeOrCarTpe: '${data.carType}',
                      ),
                    );
                  },
                );
              }

              return Center(
                  child: Text(
                'No data found',
                style: nodataTextStyle,
              ));
            },
          );
        }));
  }
}

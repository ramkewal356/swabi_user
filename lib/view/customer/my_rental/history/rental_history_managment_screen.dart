import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_tabbar.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view/customer/my_rental/history/rental_listing_container.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RentalHistoryManagment extends StatefulWidget {
  final String myId;

  const RentalHistoryManagment({super.key, required this.myId});

  @override
  State<RentalHistoryManagment> createState() => _RentalHistoryManagmentState();
}

class _RentalHistoryManagmentState extends State<RentalHistoryManagment>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();
  String status = 'ALL';
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

  Future<void> getRentalHistoryList(
      {bool isPagination = false,
      bool isfilter = false,
      bool isSort = false}) async {
    try {
      context
          .read<RentalBookingListViewModel>()
          .fetchRentalBookingListBookedViewModelApi(
            context: context,
            userId: widget.myId,
            filterText: status,
            isFilter: isfilter,
            isPagination: isPagination,
            isSort: isSort,
            sortText: sortText,
          );
    } catch (e) {
      // Handle error, e.g., show a toast or error message
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabList.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getRentalHistoryList(isSort: true);
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
    getRentalHistoryList(isSort: true);
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
      status = statusMap[tabList[index]] ?? 'ALL';
      debugPrint('vvnbvbnvb,,,,,, $status');
    });
    getRentalHistoryList(isfilter: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getRentalHistoryList(isPagination: true);
    }
  }

  int intialloadingIndex = -1;
  bool sortVisiblty = true;
  @override
  Widget build(BuildContext context) {
    // var status =
    //     context.watch<RentalViewDetailViewModel>().dataList.status.toString();

    return Customtabbar(
        titleHeading: 'My Rental Trips',
        sortVisiblty: sortVisiblty,
        isVisible: isVisibleIcon,
        controller: _tabController,
        tabs: tabList,
        onTap: _onFilter,
        onTapSort: _onSort,
        viewchildren: List.generate(tabList.length, (index) {
          return Consumer<RentalBookingListViewModel>(
            builder: (context, viewModel, child) {
              final response = viewModel.rentalBookingList;

              if (response.status.toString() == "Status.loading") {
                return const Center(
                    child: CircularProgressIndicator(
                  color: greenColor,
                ));
              } else if (response.status.toString() == "Status.error") {
                return Center(
                    child: Text(
                  'No Data Found',
                  style: nodataTextStyle,
                ));
              } else if (response.status.toString() == "Status.completed") {
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
                        onTapContainer: () {
                          context.push('/rental_booking_details', extra: {
                            "bookingId": data.id.toString(),
                            "paymentId": data.paymentId.toString(),
                            "status": data.bookingStatus,
                            "userType": "USER"
                          }).then((onValue) {
                              getRentalHistoryList(isSort: true);
                          });
                         
                         
                        },
                      
                        time: data.pickupTime ?? '',
                        bookingID: data.id.toString(),
                        // images: data.vehicle.images,
                        pickUplocation: data.pickupLocation ?? '',
                        carOrCustomerName: data.carType ?? '',
                        status: data.bookingStatus ?? '',
                        date: data.date ?? '',
                        chargeOrCarTpe: data.totalPayableAmount == 0
                            ? '${data.currency} ${data.rentalCharge}'
                            : '${data.currency} ${data.totalPayableAmount}',
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

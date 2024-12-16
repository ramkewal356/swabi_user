import 'package:flutter/material.dart';
import 'package:flutter_cab/model/rentalbooking_model.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_tabbar.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view/dashboard/rental/history/rental_listing_container.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
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
  List<String> tabList = [
    'All Booking',
    'Upcoming',
    'Ongoing',
    'Completed',
    'Cancelled'
  ];
  TabController? _tabController;
  int initialIndex = 0;
  int currentPage = 0;
  bool isLoadingMore = false;
  bool isVisibleIcon = false;
  bool lastPage = false; // Assuming true at the start
  final int pageSize = 10; // Set your page size
  final ScrollController _scrollController = ScrollController();
  List<Content> bookingList = [];
  Future<void> getPackageHistoryList() async {
    // Avoid fetching data if already loading or reached the last page
    if (isLoadingMore || lastPage) return;

    setState(() {
      isLoadingMore = true;
    });

    // String status = tabList[initialIndex]; // Get current tab status
    String status = '';
    if (tabList[initialIndex] == 'All Booking') {
      setState(() {
        status = 'ALL';
      });
    } else if (tabList[initialIndex] == 'Upcoming') {
      setState(() {
        status = 'BOOKED';
      });
    } else if (tabList[initialIndex] == 'Ongoing') {
      setState(() {
        status = 'ON_RUNNING';
      });
    } else if (tabList[initialIndex] == 'Completed') {
      setState(() {
        status = 'COMPLETED';
      });
    } else if (tabList[initialIndex] == 'Cancelled') {
      setState(() {
        status = 'CANCELLED';
      });
    } else {
      setState(() {
        status = 'ALL';
      });
    }

    try {
      // Fetch data using Provider

      final response =
          await Provider.of<RentalBookingListViewModel>(context, listen: false)
              .fetchRentalBookingListBookedViewModelApi(context, {
        'userId': widget.myId,
        'pageNumber': currentPage,
        'pageSize': pageSize,
        'bookingStatus': status,
        "search": '',
        "sortBy": 'date',
        "sortDirection": isVisibleIcon ? 'asc' : 'desc'
      });

      // Update history with new data
      final data = response?.data.content ?? [];

      debugPrint('Fetched data: $data');

      if (data.isNotEmpty) {
        setState(() {
          bookingList.addAll(data); // Append new data to the existing list
          currentPage++; // Increment page number
          lastPage = data.length < pageSize; // Check if this is the last page
        });
      } else {
        setState(() {
          lastPage = true; // No more data available
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, e.g., show a toast or error message
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: tabList.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPackageHistoryList();
    });
    _tabController?.addListener(() {
      initialIndex = _tabController?.index ?? 0;
      setState(() {
        currentPage = 0; // Reset pagination when tab changes
        bookingList.clear(); // Clear the history
        lastPage = false;
      });
      getPackageHistoryList();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User has reached the end of the list
        if (!isLoadingMore && !lastPage) {
          print('testing......');
          getPackageHistoryList();
        }
      }
    });
  }

  int intialloadingIndex = -1;
  bool sortVisiblty = true;
  @override
  Widget build(BuildContext context) {
    var status =
        context.watch<RentalViewDetailViewModel>().dataList.status.toString();
   
    return Customtabbar(
        titleHeading: 'My Rental Trips',
        sortVisiblty: sortVisiblty,
        isVisible: isVisibleIcon,
        controller: _tabController,
        tabs: tabList,
        onTap: (p0) {
          setState(() {
            currentPage = 0; // Reset pagination when tab changes
            bookingList.clear(); // Clear the history
            lastPage = false;
          });
          getPackageHistoryList();
        },
        onTapSort: () {
          setState(() {
            isVisibleIcon = !isVisibleIcon;
            currentPage = 0; // Reset pagination when tab changes
            bookingList.clear(); // Clear the history
            lastPage = false;
          });

          getPackageHistoryList();
    
        },
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
                  style:
                      nodataTextStyle,
                ));
              } else if (response.status.toString() == "Status.completed") {
                final data = response.data?.data.content ?? [];

                if (data.isEmpty && currentPage == 0) {
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
                  itemCount: bookingList.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == bookingList.length) {
                      return isLoadingMore
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: greenColor,
                            ))
                          : const SizedBox.shrink(); // Hide if not loading
                    }

                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                      child: RentalCarListingContainer(
                        onTapContainer: () async {
                          setState(() {
                            intialloadingIndex = index;
                          });
                          if (bookingList[index].id != index.toString()) {
                            Provider.of<RentalViewDetailViewModel>(context,
                                    listen: false)
                                .fetchRentalBookedViewDetialViewModelApi(
                                    context,
                                    {
                                      "id": bookingList[index].id,
                                    },
                                    bookingList[index].id.toString(),
                                    widget.myId);

                            bookingList[index].bookingStatus == 'CANCELLED'
                                ? await Provider.of<GetPaymentRefundViewModel>(
                                        context,
                                        listen: false)
                                    .getPaymentRefundApi(
                                        context: context,
                                        paymentId: bookingList[index].paymentId)
                                : null;
                          } else {
                            const CircularProgressIndicator(
                                color: Colors.green);
                          }
                        },
                        loader: status == 'Status.loading' &&
                            intialloadingIndex == index,
                        time: bookingList[index].pickupTime,
                        bookingID: bookingList[index].id,
                        images: bookingList[index].vehicle.images,
                        pickUplocation: bookingList[index].pickupLocation,
                        carName: bookingList[index].carType,
                        status: bookingList[index].bookingStatus,
                        date: bookingList[index].date,
                        rentalCharge:
                            bookingList[index].totalPayableAmount.isEmpty
                                ? bookingList[index].rentalCharge
                                : bookingList[index].totalPayableAmount,
                       
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
    // );
  }
}

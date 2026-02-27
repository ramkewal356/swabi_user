// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view/customer/my_package/package_screen.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/reusable_inquiry_card.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/package_models.dart' hide Status;
import '../../data/response/status.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final PageController _pageController = PageController();
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  int currentPage = 0;
  int? selectedIndex;
  String? userId;
  DateTime? selectedDate;
  String? selectedState;
  String? selectedCountry;

  bool _isLoading = true;

  List carouselData = [
    {
      "title": "Travel Bid System",
      "desc":
          "Post your travel requirement and receive best offers from verified vendors. Save money and get customized travel packages.",
      "btnText": "Send Bid Enquiry",
      "type": "bid"
    },
    {
      "title": "Best Packages",
      "desc": "Explore curated travel packages.",
      "btnText": "View Packages",
      "type": "package"
    },
    {
      "title": "Rental Services",
      "desc": "Find best rental vehicles & stays.",
      "btnText": "View Rentals",
      "type": "rental"
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
      getEnquiry();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void getEnquiry({bool isPagination = false}) {
    context.read<EnquiryViewModel>().getMyEnquiryApi(
        isPagination: isPagination, pageNumber: 0, pageSize1: 3);
  }

  Future<void> _loadData() async {
    var vm = context.read<UserProfileViewModel>();

    await vm.fetchUserProfileViewModelApi();
    if (vm.dataList.data != null) {
      userId = vm.dataList.data?.data.userId.toString();
      selectedCountry = vm.dataList.data?.data.country;
      selectedState = vm.dataList.data?.data.state;

      fetchPackageList();
    }
  }

  void fetchPackageList() {
    context.read<GetPackageListViewModel>().fetchGetPackageListViewModelApi(
        date: currentDate,
        country: selectedCountry ?? '',
        state: selectedState ?? '',
        pageNumber: 0,
        pageSize1: 5,
        isPagination: false,
        isSearch: false);
  }

  @override
  Widget build(BuildContext context) {
    final enquiryStatus =
        context.watch<EnquiryViewModel>().myEnquiryResponse.status;
    final packageStatus =
        context.watch<GetPackageListViewModel>().getPackageList.status;
    final profileStatus = context.watch<UserProfileViewModel>().dataList.status;

    final isAnyLoading = _isLoading ||
        enquiryStatus == Status.loading ||
        packageStatus == Status.loading ||
        profileStatus == Status.loading;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: isAnyLoading
          ? Center(
              child: CircularProgressIndicator(
                color: btnColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// 🔥 TOP CAROUSEL
                  _carouselSection(),

                  const SizedBox(height: 20),

                  /// ⭐ CTA SECTION
                  _ctaSection(),
                  const SizedBox(height: 15),

                  /// 💼 BID CARDS
                  _bidSection(),
                  const SizedBox(height: 15),

                  /// 📦 PACKAGE SEARCH + LIST
                  _packageSection(),

                  const SizedBox(height: 15),

                  /// 🚗 RENTAL LIST
                  _rentalSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  // ---------------- CAROUSEL ----------------

  Widget _carouselSection() {
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _pageController,
            itemCount: carouselData.length,
            onPageChanged: (i) {
              setState(() => currentPage = i);
            },
            itemBuilder: (_, index) {
              final item = carouselData[index];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        btnColor,
                        btnColor.withOpacity(0.75),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item["desc"],
                        style: const TextStyle(color: Colors.white),
                      ),

                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: btnColor,
                        ),
                        onPressed: () {
                          if (item["type"] == "bid") {
                            context
                                .push('/enquiry_form')
                                .then((value) => getEnquiry());
                          } else if (item["type"] == "package") {
                            context.push('/package_booking');
                          } else if (item["type"] == "rental") {
                            context.push('/rental_booking');
                          }
                        },
                        child: Text(item["btnText"]),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        /// DOT INDICATOR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            carouselData.length,
            (index) => Container(
              margin: const EdgeInsets.all(4),
              width: currentPage == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index ? btnColor : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }

  // ---------------- CTA ----------------

  Widget _ctaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer, size: 40, color: greenColor),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "Get Best Travel Deals via Bid",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text("Explore"),
            )
          ],
        ),
      ),
    );
  }
  // ---------------- BID ----------------

  Widget _bidSection() {
    final model = context.watch<EnquiryViewModel>();
    var enquiryData = model.myEnquiryResponse.data;
    if (model.myEnquiryResponse.status == Status.loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(
            color: btnColor,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Bid Requests"),
        (enquiryData ?? []).isEmpty
            ? Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                    color: background, borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text('No data found')),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: enquiryData?.length ?? 0,
                itemBuilder: (_, i) {
                  final item = enquiryData?[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ReusableInquiryCard(
                      inquiry: item?.travelInquiry,
                      bidCount: item?.bids?.length ?? 0,
                      onTap: () {
                        context.push('/my_enquiry/view_bid', extra: {
                          "enquiryId": enquiryData?[i].travelInquiry?.id
                        }).then((onValue) => getEnquiry());
                      },
                      onEditTap: () {
                        context.push('/my_enquiry/update_enquiry', extra: {
                          "enquiryId": enquiryData?[i].travelInquiry?.id
                        }).then((onValue) {
                          getEnquiry();
                        });
                      },
                      onConfirmClose: () {
                        getEnquiry();
                      },
                    ),
                  );
                })
      ],
    );
  }

  // ---------------- PACKAGE SECTION ----------------

  Widget _packageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Packages"),
        SizedBox(
          height: 455,
          child: Consumer<GetPackageListViewModel>(
            builder: (context, value, child) {
              if (value.getPackageList.status == Status.loading) {
                return Center(
                  child: CircularProgressIndicator(color: btnColor),
                );
              }
              if (value.getPackageList.status == Status.completed) {
                var getPackageList = value.getPackageList.data ?? [];
                return (value.getPackageList.data ?? []).isEmpty
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: greyColor1.withOpacity(0.1),
                        ),
                        child: Center(
                          child: const Text('No Package Available',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: redColor)),
                        ))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        itemCount: getPackageList.length,
                        itemBuilder: (context, index) {
                          List<PackageActivity> activityData =
                              getPackageList[index].packageActivities;
                          return Padding(
                            padding: EdgeInsets.only(
                                right: index == getPackageList.length - 1
                                    ? 5.0
                                    : 10.0),
                            child: SizedBox(
                              width: 350,
                              child: PackageContainer(
                                isHorizontal: true,
                                packageImg: getPackageList[index]
                                    .packageActivities
                                    .expand((e) => e.activity.activityImageUrl)
                                    .toList(),
                                packageName: getPackageList[index].packageName,
                                noOfDays: getPackageList[index].noOfDays,
                                country: getPackageList[index].country,
                                state: getPackageList[index].state,
                                location: getPackageList[index].location,
                                total: getPackageList[index].totalPrice,
                                activityList: List.generate(activityData.length,
                                    (index) => activityData[index].activity),
                                activity: getPackageList[index]
                                    .packageActivities
                                    .length
                                    .toString(),
                                discountPrice: getPackageList[index]
                                    .packageDiscountedAmount,
                                loader: selectedIndex == index,
                                currency: getPackageList[index].currency,
                                ontap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                  debugPrint('onclickpage.....');
                                  context.push('/package_view', extra: {
                                    "packageId":
                                        getPackageList[index].packageId,
                                    "userType": 'Customer',
                                    "userId": userId ?? '',
                                    "bookingDate": currentDate,
                                  }).then((onValue) {
                                    fetchPackageList();
                                    setState(() {
                                      selectedIndex = null;
                                    });
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
              } else {
                return const SizedBox(height: 10);
              }
            },
          ),
        ),
      ],
    );
  }

  // ---------------- RENTAL ----------------

  Widget _rentalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Rentals"),
        _rentalCard(context)
      ],
    );
  }

  Widget _rentalCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            btnColor.withOpacity(0.9),
            btnColor.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: btnColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon + Title
          Row(
            children: const [
              Icon(Icons.car_rental, color: Colors.white, size: 26),
              SizedBox(width: 10),
              Text(
                "Rent Vehicles & Stays",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Description
          const Text(
            "Find cars, bikes, villas and homestays\nat best local prices.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          /// CTA Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: btnColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.search),
              label: const Text(
                "Search Rentals",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                // 🔥 Navigate to Rental Search Page
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- COMMON ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

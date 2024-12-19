import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/model/get_activity_category_list_model.dart';
import 'package:flutter_cab/model/get_all_activity_list_model.dart';
import 'package:flutter_cab/model/get_state_with_image_list_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view/consts.dart';
import 'package:flutter_cab/view_model/home_page_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
  List<Content> getTopPackageList = [];
  List<Content> getBottomPackageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getActivityCategory();
      getAllActivity();
    });
  }

  Future<void> getActivityCategory() async {
    try {
      Provider.of<GetActivityCategoryListViewModel>(context, listen: false)
          .getActivityCategoryListApi(context);
      // Fetch top package list
      final topResponse =
          await Provider.of<GetAllPackageListViewModel>(context, listen: false)
              .getAllPackageListApi(context, {
        "pageNumber": 0,
        "pageSize": 5,
        "packageStatus": "TRUE",
        "search": "",
      });

      if (topResponse?.status.httpCode == '200') {
        setState(() {
          getTopPackageList = topResponse?.data.content ?? [];
        });
      } else {
        debugPrint(
            'Failed to fetch top packages: ${topResponse?.status.message}');
      }

      // Fetch bottom package list
      final bottomResponse =
          await Provider.of<GetAllPackageListViewModel>(context, listen: false)
              .getAllPackageListApi(context, {
        "pageNumber": 1,
        "pageSize": 5,
        "packageStatus": "TRUE",
        "search": "",
      });

      if (bottomResponse?.status.httpCode == '200') {
        setState(() {
          getBottomPackageList = bottomResponse?.data.content ?? [];
        });
      } else {
        debugPrint(
            'Failed to fetch bottom packages: ${bottomResponse?.status.message}');
      }
    } catch (e) {
      debugPrint('Error while fetching package lists: $e');
    }
  }

  void getAllActivity() {
    Provider.of<GetAllActivityViewModel>(context, listen: false)
        .getAllActivityApi(context, {
      "pageNumber": 0,
      "pageSize": 10,
      "activityStatus": "TRUE",
      "search": ""
    });
    Provider.of<GetStateWithImageListViewModel>(context, listen: false)
        .getStateWithImageApi(context);
  }

  /// Function to move the scroll view to the previous item
  void _scrollToPrevious() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Scroll back by 100 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Function to move the scroll view to the next item
  void _scrollToNext() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Scroll forward by 100 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  GetActivityCategoryModel? getActivityCategoryList;
  GetAllActivityListModel? getAllActivityList;
  GetStateWithImageListModel? getStateWithImageList;
  @override
  Widget build(BuildContext context) {
    getActivityCategoryList =
        context.watch<GetActivityCategoryListViewModel>().getActivityList.data;
    getAllActivityList =
        context.watch<GetAllActivityViewModel>().getAllActivityList.data;
    getStateWithImageList = context
        .watch<GetStateWithImageListViewModel>()
        .getStateWithImageList
        .data;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: background,
        title: Image.asset(
          appLogo1,
          height: 24,
          fit: BoxFit.cover,
        ),
      ),
      drawer: Drawer(
        backgroundColor: background,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: const BoxDecoration(color: btnColor),
                accountName: Text(
                  'SWABI',
                  style: landingtitleStyle,
                ),
                accountEmail: const Text('Explore UAE tour & Rentals Cars')),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  context.push('/login');
                },
                selectedTileColor: btnColor,
                // tileColor: btnColor,
                selected: true,
                iconColor: background,
                selectedColor: background,
                titleTextStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 10,
                horizontalTitleGap: 10,
                shape: RoundedRectangleBorder(
                    // side: BorderSide(),
                    borderRadius: BorderRadius.circular(10)),
                leading: Image.asset(
                  user,
                  width: 24,
                  height: 24,
                  color: background,
                ),
                title: const Text('Login for booking'),
                trailing: Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 10,
                horizontalTitleGap: 10,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: greyColor1.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10)),
                leading: Image.asset(
                  holidays,
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'Holiday Package',
                  style: titleText,
                ),
                trailing: Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                minVerticalPadding: 10,
                horizontalTitleGap: 10,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: greyColor1.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10)),
                leading: Image.asset(
                  rentalbooking,
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'Rentals Vehicle',
                  style: titleText,
                ),
                trailing: Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Where to ? \n Anywhere,anytime',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: greyColor1),
                              borderRadius: BorderRadius.circular(5)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10)),
                    ),
                  )),
                  const SizedBox(width: 10),
                  InkWell(
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: greyColor1),
                          borderRadius: BorderRadius.circular(5)),
                      child: Image.asset(
                        filtericon,
                        color: greyColor1,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      // height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: background,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Image.asset(
                            holidays,
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            'Holiday package',
                            style: titleTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      // height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: background,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Image.asset(
                            rentalbooking,
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            'Rental Vehicle',
                            style: titleTextStyle,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(topiamge),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _scrollToPrevious,
                    child: const Icon(Icons.keyboard_arrow_left_outlined),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: getActivityCategoryList?.data?.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = getActivityCategoryList?.data?[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.network(
                                  data?.activityCategoryIcon ??
                                      'https://img.icons8.com/?size=100&id=72696&format=png&color=000000',
                                  height: 24,
                                  width: 24,
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                    child: Text(
                                        data?.activityCategoryName ?? 'xyz'))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       IconButton(
                  //         onPressed: _scrollToPrevious,
                  //         icon: Icon(Icons.keyboard_arrow_left_outlined),
                  //       ),
                  //       IconButton(
                  //         onPressed: _scrollToNext,
                  //         icon: Icon(Icons.keyboard_arrow_right_outlined),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  InkWell(
                    onTap: _scrollToNext,
                    child: const Icon(Icons.keyboard_arrow_right_outlined),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                'UAE Tour Packages',
                style: landingText,
              ),
            ),
            SizedBox(
              height: 165,
              child: ListView.builder(
                itemCount: getTopPackageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var data = getTopPackageList[index];
                  var packageImage = data.packageActivities
                      .expand((e) => e.activity.activityImageUrl)
                      .toList();
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    clipBehavior: Clip.antiAlias,
                    surfaceTintColor: Colors.transparent,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 165,
                          width: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: (packageImage ?? []).isEmpty
                              ? Image.asset(
                                  tour,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  packageImage[0] ?? '',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 10,
                          child: Text(
                            data.packageName ?? '',
                            style: subtitleTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset(
                  rectanglebgimage,
                  fit: BoxFit.cover,
                ).image),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Top Cities in UAE',
                          style: topcityTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 115,
                      child: ListView.builder(
                        itemCount: getStateWithImageList?.data?.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = getStateWithImageList?.data?[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            surfaceTintColor: Colors.transparent,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: background),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 115,
                                  width: 115,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: (data?.stateImage ?? "").isEmpty
                                      ? Image.asset(
                                          stateDetail[index]['image'],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          data?.stateImage ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 10,
                                    child: Text(
                                      data?.state ?? '',
                                      style: landingtitleStyle,
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'see all',
                            style: landingtitleStyle,
                          )),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Car Rentals',
                style: landingText,
              ),
            ),
            Container(
              height: 240,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                  color: background, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                            width: 166,
                            height: 190,
                            child: Image.asset(
                              rentalBackimage,
                              fit: BoxFit.fill,
                            )),
                        Positioned(
                            top: 20,
                            bottom: 20,
                            left: 85,
                            child: SizedBox(
                                width: 125,
                                height: 140,
                                child: Image.asset(
                                  rentalFrontimage,
                                  fit: BoxFit.fill,
                                )))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Explore at Your Own Pace: Premium Car Rentals',
                            style: exploreText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          ReadMoreText(
                            'Enjoy the freedom of exploring the UAE at your own pace with our fleet of modern and well-maintained rental cars. Choose from a range of vehicles to suit your needs and budget. Key Features Wide selection of vehicles (sedans, SUVs, luxury cars) Competitive pricing Convenient pick-up and drop-off locations 24/7 customer support',
                            trimCollapsedText: ' show more',
                            trimExpandedText: ' show less',
                            trimLength: 120,
                            style: rentalDescriptionStyle,
                            moreStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: greenColor,
                                fontSize: 12),
                            lessStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: greenColor,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset(
                  explorebgimage,
                  fit: BoxFit.fill,
                ).image),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Explore by Interest',
                          style: topcityTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 148,
                      child: ListView.builder(
                        itemCount: getAllActivityList?.data?.content?.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = getAllActivityList?.data?.content?[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              // margin: EdgeInsets.symmetric(horizontal: 8),
                              surfaceTintColor: Colors.transparent,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: background),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 148,
                                    width: 103,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: (data?.activityImageUrl ?? [])
                                            .isEmpty
                                        ? Image.asset(
                                            tour,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            data?.activityImageUrl?[0] ?? '',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 10,
                                      child: Text(
                                        data?.activityName ?? '',
                                        style: landingtitleStyle,
                                        textAlign: TextAlign.center,
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'see all',
                            style: landingtitleStyle,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      whychooseUsgimage,
                    ).image,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'WHY CHOOSE US',
                            style: exploreText,
                          ),
                          Text('Your Trusted Partner for Swabi Tour & Travels'),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: chooseUs(
                                    icon: bigValueIcon,
                                    title: 'Big Value for \nRental Bookings'),
                              ),
                              Expanded(
                                child: chooseUs(
                                    icon: tourPackageIcon,
                                    title: 'Customized \nTour Package'),
                              ),
                              Expanded(
                                child: chooseUs(
                                    icon: insantBookingIcon,
                                    title: 'Instant \nBooking'),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: chooseUs(
                                    icon: easyPaymentIcon,
                                    title: 'Easy \nPayments'),
                              ),
                              Expanded(
                                child: chooseUs(
                                    icon: serviceAndSupportIcon,
                                    title: 'Amazing Service \n& Support'),
                              ),
                              Expanded(
                                child: chooseUs(
                                    icon: advanceBookingIcon,
                                    title: 'Advance \nBooking'),
                              )
                            ],
                          )
                        ]))),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Our Recomandation',
                style: landingText,
              ),
            ),
            SizedBox(
              height: 220,
              width: double.infinity,
              child: CarouselSlider.builder(
                  itemCount: getBottomPackageList.length,
                  itemBuilder: (context, index, realIndex) {
                    var data = getBottomPackageList[index];
                    var packageImage = data.packageActivities
                        .expand((e) => e.activity.activityImageUrl)
                        .toList();
                    return Stack(
                      // clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0), // 10px total gap (5px + 5px)
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: getBottomPackageList.isEmpty
                              ? Image.asset(
                                  explorebgimage, // Replace with your images
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  packageImage[0],
                                  fit: BoxFit.cover,
                                ),
                        ),
                        // Positioned(
                        //     left: 0,
                        //     right: 0,
                        //     bottom: 0,
                        //     top: 0,
                        //     child: Center(
                        //       child: Text(
                        //         data.packageName,
                        //         textAlign: TextAlign.center,
                        //         style: btnTextStyle,
                        //       ),
                        //     ))
                      ],
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    viewportFraction: .6,
                    enlargeFactor: 0.3,
                    enlargeCenterPage: true,
                    // aspectRatio: 0.35
                  )),
            )
          ],
        ),
      ),
    );
  }

  chooseUs({required String icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                title,
                style: chooseUsTextStyle,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

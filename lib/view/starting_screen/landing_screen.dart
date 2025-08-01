import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/model/get_activity_category_list_model.dart';
import 'package:flutter_cab/model/get_all_activity_list_model.dart';
import 'package:flutter_cab/model/get_state_with_image_list_model.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/home_page_view_model.dart';
import 'package:go_router/go_router.dart';
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
  List<Map<String, String>> defaultCityData = [
    {
      "state": "Dubai Marina",
      "stateImage": dubaiMarina,
    },
    {"state": "Burj Khalifa", "stateImage": burjKhalifa},
    {
      "state": "Palm Jumeirah",
      "stateImage": palmJumeirah,
    },
    {
      "state": "Jumeirah Beach",
      "stateImage": jumeirahBeach,
    },
    {"state": "Deira", "stateImage": deira},
    {"state": "Al Fahidi", "stateImage": alFahidi},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getActivityCategory();
      getAllActivity();
    });
  }

  Future<void> getActivityCategory() async {
    try {
      context
          .read<GetActivityCategoryListViewModel>()
          .getActivityCategoryListApi();
      // Fetch top package list
      final topResponse = await context
          .read<GetAllPackageListViewModel>()
          .getAllPackageListApi({
        "pageNumber": 0,
        "pageSize": 5,
        "packageStatus": "true",
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
          // ignore: use_build_context_synchronously
          await context
              .read<GetAllPackageListViewModel>()
              .getAllPackageListApi({
        "pageNumber": 1,
        "pageSize": 5,
        "packageStatus": "true",
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
      "activityStatus": "true",
      "search": ""
    });
    context.read<GetStateWithImageListViewModel>().getStateWithImageApi();
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
    // Convert API list
    final apiList = getStateWithImageList?.data
            ?.map((e) =>
                CityData(state: e.state ?? '', stateImage: e.stateImage ?? ''))
            .toList() ??
        [];

// Convert default list
    final defaultList = defaultCityData
        .map((e) => CityData(state: e['state']!, stateImage: e['stateImage']!))
        .toList();

// Choose source
    final cityList = apiList.isNotEmpty ? apiList : defaultList;
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
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined))
        ],
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
                  context.pop();
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
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  context.pop();

                  context.push('/login');
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  context.pop();
                  context.push('/login');
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
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
                      readOnly: true,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Where to ? \n Anywhere,anytime',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: greyColor1),
                              borderRadius: BorderRadius.circular(5)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10)),
                    ),
                  )),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      context.push('/login');
                    },
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
                    child: GestureDetector(
                      onTap: () {
                        context.push('/login');
                      },
                      child: Container(
                        // height: 60,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: btnColor),
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
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push('/login');
                      },
                      child: Container(
                        // height: 60,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: btnColor),
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
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(topiamge),
            const SizedBox(height: 8),
            (getActivityCategoryList?.data ?? []).isEmpty
                ? const SizedBox.shrink()
                : Padding(
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
                                var data =
                                    getActivityCategoryList?.data?[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push('/login');
                                    },
                                    child: Column(
                                      children: [
                                        (data?.activityCategoryIcon ?? '')
                                                .isEmpty
                                            ? Image.asset(
                                                rentalbooking,
                                                height: 24,
                                                width: 24,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                data?.activityCategoryIcon ??
                                                    'https://img.icons8.com/?size=100&id=72696&format=png&color=000000',
                                                height: 24,
                                                width: 24,
                                                fit: BoxFit.cover,
                                              ),
                                        Expanded(
                                            child: Text(
                                                data?.activityCategoryName ??
                                                    'xyz'))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _scrollToNext,
                          child:
                              const Icon(Icons.keyboard_arrow_right_outlined),
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
                  return GestureDetector(
                    onTap: () {
                      context.push('/login');
                    },
                    child: Card(
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
                            child: (packageImage).isEmpty
                                ? Image.asset(
                                    tour,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    packageImage[0],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 10,
                            child: Text(
                              data.packageName,
                              style: subtitleTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 280,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: Image.asset(
                    rectanglebgimage,
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
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
                      itemCount: cityList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var city = cityList[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          surfaceTintColor: Colors.transparent,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: background),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 115,
                                width: 115,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: city.stateImage.startsWith('http')
                                    ? Image.network(city.stateImage,
                                        fit: BoxFit.cover)
                                    : Image.asset(city.stateImage,
                                        fit: BoxFit.cover),
                              ),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 10,
                                  child: Text(
                                    city.state,
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
                        child: InkWell(
                          onTap: () {
                            context.push('/login');
                          },
                          child: Text(
                            'see all',
                            style: landingtitleStyle,
                          ),
                        )),
                  )
                ],
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
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
            const SizedBox(height: 10),
            Container(
              height: 280,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: Image.asset(
                      explorebgimage,
                      // fit: BoxFit.fill,
                    ).image,
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
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
                          return Card(
                            clipBehavior: Clip.none,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            surfaceTintColor: Colors.transparent,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side:
                                  const BorderSide(width: 1, color: background),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 148,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: (data?.activityImageUrl ?? []).isEmpty
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
                                      style: subtitleTextStyle,
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              context.push('/login');
                            },
                            child: Text(
                              'see all',
                              style: landingtitleStyle,
                            ),
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
                          const Text(
                              'Your Trusted Partner for Swabi Tour & Travels'),
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
            getBottomPackageList.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Our Recomandation',
                      style: landingText,
                    ),
                  ),
            getBottomPackageList.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
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
                                    horizontal:
                                        0), // 10px total gap (5px + 5px)
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
                                child: packageImage.isEmpty
                                    ? Image.asset(
                                        explorebgimage, // Replace with your images
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        packageImage[0],
                                        fit: BoxFit.cover,
                                      ),
                              ),
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
                  ),
            Stack(
              children: [
                SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.asset(
                      subcribeimage,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Haven’t decided yet? \nLet us inspire you even more.',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: background,
                              shadows: [
                                Shadow(
                                    color: blackColor.withOpacity(0.5),
                                    offset: const Offset(1, 1))
                              ]),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(5)),
                        child: Customtextformfield(
                            readOnly: true,
                            fillColor: background,
                            prefixIcon: const Icon(Icons.email_outlined),
                            suffixIcons: Container(
                                width: 100,
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: const BoxDecoration(
                                    color: greyColor1,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Center(
                                  child: Text(
                                    'Subscribe',
                                    style: landingTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            controller: TextEditingController(),
                            hintText: 'Enter your email'),
                      )
                    ],
                  ),
                )
              ],
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
class CityData {
  final String state;
  final String stateImage;

  CityData({required this.state, required this.stateImage});
}

// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/data/models/package_models.dart' hide Status;
import 'package:flutter_cab/res/Common%20Widgets/common_offer_container.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Packages extends StatefulWidget {
  final String? userSate;
  const Packages({super.key, this.userSate});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  TextEditingController controller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  UserViewModel userViewModel = UserViewModel();

  DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final ScrollController _scrollController = ScrollController();

  bool isLastPage = false;
  String? userId;
  String countryName = 'United Arab Emirates';
  String selectedStateName = 'Dubai';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: _dateFormat.format(tomorrow));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getCountry();
      var userData =
          // ignore: use_build_context_synchronously
          await Provider.of<UserProfileViewModel>(context, listen: false)
              .fetchUserProfileViewModelApi();
      if (userData != null && userData.data.userId != '') {
        fetchState();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void fetchState() async {
    try {
      final String userState = await userViewModel.getState();
      userId = await userViewModel.getUserId();
      if (userState.isNotEmpty) {
        setState(() {
          selectedStateName = userState; // Update local state
          debugPrint('Fetched state: $selectedStateName');
          statecontroller.text = selectedStateName;
        });
        // Update the text controller
      } else {
        final fallbackState =
            // ignore: use_build_context_synchronously
            Provider.of<UserProfileViewModel>(context, listen: false)
                .userStateName;

        setState(() {
          selectedStateName = fallbackState;
          statecontroller.text = fallbackState; // Update the controller
          debugPrint('Fetched fallback state: $fallbackState');
        });

        debugPrint(
            'Fetched state:,,,,..,,,....,,..,,.,,.,,.,.. $selectedStateName');
      }
      fetchPackageList();
    } catch (e) {
      debugPrint('Error fetching state: $e');
    }
  }

  void fetchPackageList({bool isPagination = false, bool isSearch = false}) {
    context.read<GetPackageListViewModel>().fetchGetPackageListViewModelApi(
        date: controller.text,
        country: countryName,
        state: statecontroller.text.isEmpty
            ? selectedStateName
            : statecontroller.text,
        isPagination: isPagination,
        isSearch: isSearch);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      fetchPackageList(isPagination: true);
    }
  }

  String accessToken = '';
  void getCountry() async {
    try {
      Provider.of<GetCountryStateListViewModel>(context, listen: false)
          .getStateList(context: context, country: countryName);
    } catch (e) {
      debugPrint('error $e');
    }
  }

  List<Content> getPackageList = [];
  @override
  void dispose() {
    statecontroller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool loader = false;
  int selectedIndex = -1;
  bool isLoadingData = false;
  // List<Content> imgList = [];
  @override
  Widget build(BuildContext context) {
    final status =
        context.watch<GetPackageListViewModel>().getPackageList.status;
    final statusDetails = context
        .watch<GetPackageActivityByIdViewModel>()
        .getPackageActivityById
        .status;

    isLoadingData = context.watch<OfferViewModel>().isLoading1;
    var state = context.watch<GetCountryStateListViewModel>().getStateNameModel;
    isLastPage = context.watch<GetPackageListViewModel>().isLastPage;
    getPackageList =
        context.watch<GetPackageListViewModel>().getPackageList.data ?? [];
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Customtextformfield(
                  fillColor: background,
                  readOnly: true,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  controller: TextEditingController(text: countryName),
                  hintText: 'Select country'),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomDropdownButton(
                      controller: statecontroller,
                      // focusNode: focusNode3,
                      itemsList: state
                              ?.map((stateName) => stateName)
                              .toSet()
                              .toList() ??
                          [],

                      onChanged: (value) {
                        setState(() {
                          selectedStateName = value ?? '';
                        });
                      },
                      hintText: 'Select State',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: bgGreyColor,
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: 0,
                        child: Container(
                          // width: AppDimension.getWidth(context) * .92,
                          // height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: naturalGreyColor.withOpacity(0.3),
                            ),
                            color: background,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            onTap: () async {
                              // await _selectDate(context);
                              final selectedDate = await showCustomDatePicker(
                                context,
                                initialDate: _dateFormat.parse(controller.text),
                                firstDate: tomorrow,
                                lastDate: DateTime(tomorrow.year + 1),
                              );
                              if (selectedDate != null &&
                                  _dateFormat.format(selectedDate) !=
                                      controller.text) {
                                setState(() {
                                  controller.text =
                                      _dateFormat.format(selectedDate);
                                });
                              }
                            },
                            style: titleTextStyle,
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              prefixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: naturalGreyColor,
                              ),
                              suffixIcon: Container(
                                  height: 50,
                                  margin: const EdgeInsets.all(0.5),
                                  width: 50,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                      color: btnColor),
                                  child: InkWell(
                                    onTap: () {
                                      fetchPackageList(isSearch: true);
                                      userViewModel
                                          .setSate(statecontroller.text);
                                    },
                                    child: const Icon(
                                      Icons.search,
                                      color: background,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const CommonOfferContainer(
                      bookingType: 'PACKAGE_BOOKING',
                    ),
                    status == Status.completed
                        ? getPackageList.isNotEmpty
                            ? ListView.builder(
                                // controller: _scrollController,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                itemCount: getPackageList.length +
                                    (isLastPage ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index == getPackageList.length) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                      color: greenColor,
                                    ));

                                    // Hide if not loading
                                  }
                                  List<PackageActivity> activityData =
                                      getPackageList[index].packageActivities;
                                  return PackageContainer(
                                    packageImg: getPackageList[index]
                                        .packageActivities
                                        .expand(
                                            (e) => e.activity.activityImageUrl)
                                        .toList(),
                                    packageName:
                                        getPackageList[index].packageName,
                                    noOfDays: getPackageList[index].noOfDays,
                                    // noOfNights: "0",
                                    country: getPackageList[index].country,
                                    state: getPackageList[index].state,
                                    location: getPackageList[index].location,
                                    total: getPackageList[index].totalPrice,
                                    activityList: List.generate(
                                        activityData.length,
                                        (index) =>
                                            activityData[index].activity),
                                    activity: getPackageList[index]
                                        .packageActivities
                                        .length
                                        .toString(),
                                    discountPrice: getPackageList[index]
                                        .packageDiscountedAmount,
                                    loader: statusDetails == Status.loading &&

                                        selectedIndex == index,
                               
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
                                        "bookingDate": controller.text
                                      }).then((onValue) {
                                        fetchPackageList(isPagination: true);
                                      });
                                    },
                                    // ontap: () {
                                    //   setState(() {
                                    //     selectedIndex = index;
                                    //     loader = true;
                                    //   });
                                    //   Provider.of<GetPackageActivityByIdViewModel>(
                                    //           context,
                                    //           listen: false)
                                    //       .fetchGetPackageActivityByIdViewModelApi(
                                    //           context,
                                    //           {
                                    //             "packageId":
                                    //                 getPackageList[index]
                                    //                     .packageId
                                    //           },
                                    //           getPackageList[index].packageId,
                                    //           controller.text);
                                    // }
                                    // ()=> context.push("/package/packageDetails"),
                                  );
                                },
                              )
                            : Center(
                                child: Container(
                                    decoration: const BoxDecoration(),
                                    child: const Text(
                                      'No Data',
                                      style: TextStyle(color: redColor),
                                    )))
                        : Container()
                  ],
                ),
              ),
            )
          ],
        ),
        (status == Status.loading || isLoadingData == true)
            ? const SpinKitFadingCube(
                size: 50,
                duration: Duration(milliseconds: 1200),
                color: Colors.red,
              )
            : Container()
      ],
    );
  }
}

class PackageContainer extends StatefulWidget {
  final List<String> packageImg;
  final String noOfDays;
  // final String noOfNights;
  final String country;
  final String state;
  final String activity;
  final List<Activity> activityList;
  final String location;
  final String total;
  final String packageName;
  final bool loader;
  final VoidCallback ontap;
  final double? discountPrice;
  const PackageContainer(
      {super.key,
      required this.packageImg,
      required this.packageName,
      required this.noOfDays,
      // required this.noOfNights,
      required this.country,
      required this.activity,
      required this.activityList,
      required this.state,
      required this.total,
      required this.location,
      required this.loader,
      required this.ontap,
      this.discountPrice});

  @override
  State<PackageContainer> createState() => _PackageContainerState();
}

class _PackageContainerState extends State<PackageContainer> {
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (widget.packageImg.isNotEmpty) {
      timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.packageImg.length;
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CommonContainer(
        elevation: 0,
        borderReq: true,
        borderColor: naturalGreyColor.withOpacity(0.3),
        child: Material(
          elevation: 0,
          color: background,
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: [
                widget.packageImg.isNotEmpty
                    ? SizedBox(
                        width: double.infinity,
                        height: 220,
                        child: MultiImageSlider(images: widget.packageImg),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                        child: Container(
                            margin: const EdgeInsets.all(2),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                            ),
                            child: Image.asset(
                              tour,
                              height: 200,
                              fit: BoxFit.cover,
                            )),
                      ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: AppDimension.getWidth(context) * .65,
                            child: CustomText(
                                content: widget.packageName,
                                align: TextAlign.start,
                                fontSize: 17,
                                maxline: 1,
                                fontWeight: FontWeight.w600,
                                textColor: textColor),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 5),
                            decoration: BoxDecoration(
                                color: greyColor1.withOpacity(.1),
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              "${int.tryParse(widget.noOfDays) != null ? (int.parse(widget.noOfDays) - 1).toString() : '0'}N / ${widget.noOfDays}D",
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: btnColor),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.only(right: 5),
                              child: const Card(
                                shape: CircleBorder(),
                                elevation: 0,
                                color: greyColor1,
                              ),
                            ),
                            Expanded(
                              child: CustomText(
                                content: "${widget.activity} Activity",
                                fontSize: 15,
                                maxline: 2,
                                align: TextAlign.start,
                                textColor: greyColor1,
                              ),
                            ),
                            // const Spacer(),

                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.only(right: 5),
                              child: const Card(
                                shape: CircleBorder(),
                                elevation: 0,
                                color: greyColor1,
                              ),
                            ),
                            Expanded(
                              child: CustomText(
                                content: widget.country,
                                fontSize: 15,
                                maxline: 2,
                                align: TextAlign.start,
                                textColor: greyColor1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: List.generate(
                            widget.activityList.take(3).length,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Icon(
                                          Icons.check,
                                          color: greenColor,
                                          size: 13,
                                        ),
                                      ),
                                      Container(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          width:
                                              AppDimension.getWidth(context) *
                                                  .8,
                                          // color: Colors.cyan,
                                          child: CustomText(
                                            content:
                                                '${widget.activityList[index].activityName} ( ${widget.activityList[index].state} )',
                                            textColor: greenColor,
                                            fontSize: 15,
                                            maxline: 2,
                                            align: TextAlign.start,
                                          ))
                                    ],
                                  ),
                                )),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: greyColor1.withOpacity(.1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              (widget.total == widget.discountPrice.toString())
                                  ? const TextSpan()
                                  : TextSpan(
                                      text:
                                          "AED ${double.tryParse(widget.total)?.round()}"
                                              .toUpperCase(),
                                      style: GoogleFonts.nunito(
                                          color: Colors.black,
                                          fontSize:
                                              (widget.discountPrice == null ||
                                                      widget.discountPrice == 0)
                                                  ? 15
                                                  : 12,
                                          decoration:
                                              (widget.discountPrice == null ||
                                                      widget.discountPrice == 0)
                                                  ? null
                                                  : TextDecoration.lineThrough,
                                          decorationColor: btnColor,
                                          decorationThickness: 3,
                                          fontWeight: FontWeight.w700)),
                              (widget.total == widget.discountPrice.toString())
                                  ? const TextSpan()
                                  : (widget.discountPrice == null ||
                                          widget.discountPrice == 0)
                                      ? const TextSpan()
                                      : const TextSpan(text: '\n'),
                              (widget.discountPrice == null ||
                                      widget.discountPrice == 0)
                                  ? const TextSpan()
                                  : TextSpan(
                                      text:
                                          'AED ${widget.discountPrice?.round()}',
                                      style: GoogleFonts.nunito(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text: " / Person",
                                  style: GoogleFonts.nunito(
                                      color: greyColor1,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ])),
                            CustomButtonSmall(
                              width: 120,
                              height: 40,
                              loading: widget.loader,
                              btnHeading: "View Details",
                              onTap: widget.ontap,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/res/Common%20Widgets/common_offer_container.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Packages extends StatefulWidget {
  final String ursID;

  const Packages({super.key, required this.ursID});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  TextEditingController controller = TextEditingController();
  late final ValueNotifier<DateTime> _selectedDateNotifier;
  DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  int pageSize = 10;
  bool isLastPage = false;
  bool isLoadingMore = false;
  List<Content> getPackageList = [];
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _selectedDateNotifier =
        ValueNotifier(DateTime.now().add(const Duration(days: 1)));
    controller = TextEditingController(text: _dateFormat.format(tomorrow));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPackageList();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User has reached the end of the list
        if (!isLoadingMore && !isLastPage) {
          print('testing......');
          fetchPackageList();
        }
      }
    });
    // controller.text = _selectedDate.day.toString();
  }

  Future<void> fetchPackageList() async {
    if (isLoadingMore || isLastPage) return;
    setState(() {
      isLoadingMore = true;
    });

    try {
      var resp =
          await Provider.of<GetPackageListViewModel>(context, listen: false)
              .fetchGetPackageListViewModelApi(context, {
        "pageNumber": currentPage,
        "pageSize": pageSize,
        "date": controller.text,
        "search": "",
        "days": "",
        "price": ""
        // "packageStatus": "TRUE",
      });
      var data = resp?.data.content ?? [];
      if (data.isNotEmpty) {
        setState(() {
          getPackageList.addAll(data);
          currentPage++;
          isLastPage = data.length < pageSize;
          debugPrint('currentpage$currentPage');
        });
      } else {
        setState(() {
          isLastPage = true;
        });
      }
    } catch (e) {
      debugPrint('error$e');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime tomorrow = currentDate.add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateFormat.parse(controller.text),
      firstDate: tomorrow,
      lastDate: DateTime(tomorrow.year + 1),
      // lastDate: DateTime(tomorrow.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: btnColor,
            ),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(btnColor), // Button background
              foregroundColor:
                  MaterialStateProperty.all(background), // Button text color
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: Dialog(
              insetPadding: const EdgeInsets.all(20),
              backgroundColor: background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Border radius here
              ),
              child: SingleChildScrollView(
                  padding: EdgeInsets.zero, child: child!)),
        );
      },
    );
    if (picked != null && _dateFormat.format(picked) != controller.text) {
      setState(() {
        controller.text = _dateFormat.format(picked);
      });
      // _fetchPackageList();
    }
  }

  // List<Content> packageList = [];
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  bool loader = false;
  int selectedIndex = -1;
  bool isLoadingData = false;
  // List<Content> imgList = [];
  @override
  Widget build(BuildContext context) {
    String status = context
        .watch<GetPackageListViewModel>()
        .getPackageList
        .status
        .toString();
    String statusDetails = context
        .watch<GetPackageActivityByIdViewModel>()
        .getPackageActivityById
        .status
        .toString();
  
    isLoadingData = context.watch<OfferViewModel>().isLoading1;

   
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      await _selectDate(context);
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
                            margin: const EdgeInsets.all(0.5),
                            width: 50,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                color: btnColor),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  currentPage =
                                      0; // Reset pagination when tab changes
                                  getPackageList.clear(); // Clear the history
                                  isLastPage = false;
                                });
                                fetchPackageList();
                              },
                              child: const Icon(
                                Icons.search,
                                color: background,
                              ),
                            ))),
                  ),
                ),
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

                    status == "Status.completed"
                        ? getPackageList.isNotEmpty
                            ? ListView.builder(
                                // controller: _scrollController,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                itemCount: getPackageList.length +
                                    (isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == getPackageList.length) {
                                    return isLoadingMore
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                            color: greenColor,
                                          ))
                                        : const SizedBox
                                            .shrink(); // Hide if not loading
                                  }
                                  List<PackageActivity> activityData =
                                      getPackageList[index].packageActivities;
                                  return PackageContainer(
                                      packageImg: getPackageList[index]
                                          .packageActivities
                                          .expand((e) =>
                                              e.activity.activityImageUrl)
                                          .toList(),
                                      //     .map((url) {
                                      //   return url;
                                      // }).toList(),
                                      packageName:
                                          getPackageList[index].packageName,
                                      noOfDays: getPackageList[index].noOfDays,
                                      // noOfNights: "0",
                                      country: getPackageList[index].country,
                                      state: getPackageList[index].state,
                                      location: getPackageList[index].location,
                                      total: getPackageList[index].totalPrice,
                                      activityName: List.generate(
                                          activityData.length,
                                          (index) => activityData[index]
                                              .activity
                                              .activityName),
                                      activity: getPackageList[index]
                                          .packageActivities
                                          .length
                                          .toString(),
                                      discountPrice: getPackageList[index]
                                          .packageDiscountedAmount,
                                      loader:
                                          statusDetails == "Status.loading" &&
                                              loader &&
                                              selectedIndex == index,
                                      ontap: () {
                                        setState(() {
                                          selectedIndex = index;
                                          loader = true;
                                        });
                                        Provider.of<GetPackageActivityByIdViewModel>(
                                                context,
                                                listen: false)
                                            .fetchGetPackageActivityByIdViewModelApi(
                                                context,
                                                {
                                                  "packageId":
                                                      getPackageList[index]
                                                          .packageId
                                                },
                                                getPackageList[index].packageId,
                                                widget.ursID,
                                                controller.text);
                                      }
                                      // ()=> context.push("/package/packageDetails"),
                                      );
                                },
                                // PackageContainer(
                                //   packageImg: List.generate(packageList[index].packageImageUrl.length, (ind) =>),
                                // ),
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
        status == "Status.completed" && isLoadingData == false
            ? Container()
            : const SpinKitFadingCube(
                size: 50,
                duration: Duration(milliseconds: 1200),
                color: Colors.red,
              )
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
  final List<String> activityName;
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
      required this.activityName,
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
                              "${int.tryParse(widget.noOfDays ?? '1') != null ? (int.parse(widget.noOfDays) - 1).toString() : '0'}N / ${widget.noOfDays ?? '0'}D",
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
                                widget.activityName.take(3).length,
                                (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                              padding: const EdgeInsets.only(
                                                  left: 2),
                                              width: AppDimension.getWidth(
                                                      context) *
                                                  .8,
                                              // color: Colors.cyan,
                                              child: CustomText(
                                                content:
                                                    widget.activityName[index],
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

// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/data/models/package_models.dart' hide Status;
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/widgets/custom_container.dart';
import 'package:flutter_cab/widgets/custom_text_widget.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  final _formKey = GlobalKey<FormState>();
  var stateDropdownKey = UniqueKey();
  TextEditingController controller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  // UserViewModel userViewModel = UserViewModel();
  DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final ScrollController _scrollController = ScrollController();
  String? userId;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: _dateFormat.format(tomorrow));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadData();
    });
    _scrollController.addListener(_onScroll);
  }


  void _loadData() async {
    var vm = context.read<UserProfileViewModel>();

    await vm.fetchUserProfileViewModelApi();
    if (vm.dataList.data != null) {
      setState(() {
        userId = vm.dataList.data?.data.userId;
        countrycontroller.text = vm.dataList.data?.data.country ?? '';
        statecontroller.text = vm.dataList.data?.data.state ?? '';
      });
    }
    getCountry();
    getStateListApi(countrycontroller.text);
    fetchPackageList();
  }

  void fetchPackageList({bool isPagination = false, bool isSearch = false}) {
    context.read<GetPackageListViewModel>().fetchGetPackageListViewModelApi(
        date: controller.text,
        country: countrycontroller.text,
        state: statecontroller.text,
        isPagination: isPagination,
        isSearch: isSearch);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      fetchPackageList(isPagination: true);
    }
  }

  void getCountry() {
    context.read<ThirdPartyViewModel>().getCountryList();
  }

  void getStateListApi(String country) {
    context
        .read<ThirdPartyViewModel>()
        .getStateList(country: countrycontroller.text);
  }

  @override
  void dispose() {
    statecontroller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    var countryList =
        context.watch<ThirdPartyViewModel>().getCountryListResponse.data;
    var userStatus = context.watch<UserProfileViewModel>().dataList.status;
    var stateList = context.watch<ThirdPartyViewModel>().stateList.data;
    // var status = context.watch<GetPackageListViewModel>().getPackageList.status;
    return Column(
      children: [
        const SizedBox(height: 10),
        Card(
          color: background,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomDropdownButton(
                      itemsList: countryList ?? [],
                      hintText: 'Select Country',
                      controller: countrycontroller,
                      onChanged: (value) {
                        countrycontroller.text = value ?? '';
                        setState(() {
                          statecontroller.clear();
                          stateList = [];
                          stateDropdownKey = UniqueKey();
                        });
                        getStateListApi(value!);

                        setState(() {});
                      },
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Please select country';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomDropdownButton(
                            key: stateDropdownKey,
                            controller: statecontroller,
                            itemsList: stateList
                                    ?.map((stateName) => stateName)
                                    .toSet()
                                    .toList() ??
                                [],

                            onChanged: (value) {
                              setState(() {
                                statecontroller.text = value ?? '';
                              });
                            },
                            hintText: 'Select State',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please select state';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            onTap: () async {
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
                            decoration: InputDecoration(
                              hintText: 'Select Date',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: naturalGreyColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: naturalGreyColor)),
                              prefixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: naturalGreyColor,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomButtonSmall(  
                      // loading: status == Status.loading,                    
                      btnHeading: 'Search',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          fetchPackageList(isSearch: true);
                          // userViewModel.setSate(statecontroller.text);
                        }
                      },
                    )
                  ],
                )),
          ),
        ),
        const SizedBox(height: 10),
        Consumer<GetPackageListViewModel>(
          builder: (context, value, child) {
            if (value.getPackageList.status == Status.loading ||
                userStatus == Status.loading) {
              return Expanded(
                child: Center(
                  child: SpinKitFadingCube(
                    size: 50,
                    duration: const Duration(milliseconds: 1200),
                    color: Colors.red,
                  ),
                ),
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
                  : Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        itemCount:
                            getPackageList.length + (value.isLastPage ? 0 : 1),
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
                                .expand((e) => e.activity.activityImageUrl)
                                .toList(),
                            packageName: getPackageList[index].packageName,
                            noOfDays: getPackageList[index].noOfDays,
                            // noOfNights: "0",
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
                            discountPrice:
                                getPackageList[index].packageDiscountedAmount,
                            loader: selectedIndex == index,
                            currency: getPackageList[index].currency,
                            ontap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              debugPrint('onclickpage.....');
                              context.push('/package_view', extra: {
                                "packageId": getPackageList[index].packageId,
                                "userType": 'Customer',
                                "userId": userId ?? '',
                                "bookingDate": controller.text
                              }).then((onValue) {
                                fetchPackageList(isPagination: true);
                                setState(() {
                                  selectedIndex = null;
                                });
                              });
                            },
                          );
                        },
                      ),
                    );
            } else {
              return Expanded(
                child: SizedBox(height: 10),
              );
            }
          },
        ),
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
  final String? currency;
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
      this.discountPrice,
      this.currency});

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
                                          "${widget.currency} ${double.tryParse(widget.total)?.round()}"
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
                                          '${widget.currency} ${widget.discountPrice?.round()}',
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

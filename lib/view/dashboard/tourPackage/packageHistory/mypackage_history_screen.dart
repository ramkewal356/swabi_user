import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_tabbar.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_slider_container_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

              if (response.status.toString() == "Status.loading") {
                return const Center(
                    child: CircularProgressIndicator(
                  color: greenColor,
                ));
              } else if (response.status.toString() == "Status.error") {
                return Center(
                    child: Text(
                  'No Data',
                  style: nodataTextStyle,
                ));
              } else if (response.status.toString() == "Status.completed") {
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
                                      "user": widget.userID,
                                      "book": data?.packageBookingId,
                                      "paymentId": data?.paymentId
                                    }).then((onValue) {
                                  getPackageHistoryList(isSort: true);
                                });
                                // setState(() {
                                //   selectIndex = index;
                                // });
                                // Provider.of<GetPackageHistoryDetailByIdViewModel>(
                                //         context,
                                //         listen: false)
                                //     .fetchGetPackageHistoryDetailByIdViewModelApi(
                                //         context,
                                //         {
                                //           "packageBookingId":
                                //               data?.packageBookingId
                                //         },
                                //         widget.userID,
                                //         data?.packageBookingId ?? '');
                                // data?.bookingStatus == 'CANCELLED'
                                //     ? Provider.of<GetPaymentRefundViewModel>(
                                //             context,
                                //             listen: false)
                                //         .getPaymentRefundApi(
                                //             context: context,
                                //             paymentId: data?.paymentId ?? "")
                                //     : null;
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

class PackageHistoryContainer extends StatelessWidget {
  final String status;
  final String pkgID;
  final String bookingDate;
  final String members;
  final String price;
  final String pkgName;
  final String location;
  final List<String> imageList;
  final VoidCallback onTap;
  final bool loader;
  const PackageHistoryContainer(
      {super.key,
      required this.status,
      required this.pkgID,
      required this.bookingDate,
      required this.members,
      required this.pkgName,
      required this.location,
      required this.imageList,
      required this.onTap,
      required this.loader,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      borderRadius: BorderRadius.circular(5),
      elevation: 0,
      borderColor: naturalGreyColor.withOpacity(0.3),
      borderReq: true,
      child: Material(
        color: background,
        child: Column(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: MultiImageSlider(
                images: List.generate(
                    imageList.length, (index) => imageList[index]),
              ),
              // child: Image.asset(tour,width: double.infinity,fit: BoxFit.fill,),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(bottom: 5, top: 10),
              child: Row(
                children: [
                  const CustomTextWidget(
                    content: "Package Name : ",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    textColor: textColor,
                  ),
                  SizedBox(
                    width: AppDimension.getWidth(context) * .55,
                    child: CustomText(
                      content: pkgName,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      align: TextAlign.start,
                      textEllipsis: true,
                      maxline: 1,
                      textColor: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(bottom: 5),

              child: textTile(
                  lable1: 'Booking Id',
                  value1: pkgID,
                  lable2: 'Status',
                  value2: status),
            ),
            Container(
                // height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.only(bottom: 5),
                child: textTile(
                    lable1: 'Date',
                    value1: bookingDate,
                    lable2: "Member's",
                    value2: members)),
            Container(
                // height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.only(bottom: 5),
                // decoration: const BoxDecoration(
                //     border:
                //         Border(bottom: BorderSide(color: naturalGreyColor))),
                child: Center(
                  child: _builtText(lable: 'Location', value: location),
                )),
            Container(
              // height: 50,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: greyColor1.withOpacity(.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Price :",
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: " AED $price".toUpperCase(),
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ])),
                  CustomButtonSmall(
                      loading: loader,
                      height: 40,
                      width: 120,
                      btnHeading: 'View Details',
                      onTap: onTap),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  textTile({
    required String lable1,
    required String value1,
    required String lable2,
    required String value2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _builtText(lable: lable1, value: value1)),
        Expanded(flex: 2, child: _builtText(lable: lable2, value: value2))
      ],
    );
  }

  _builtText({required String lable, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: titleTextStyle,
        ),
        const SizedBox(width: 5),
        Text(
          ':',
          style: titleTextStyle,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: titleTextStyle1,
          ),
        )
      ],
    );
  }
}

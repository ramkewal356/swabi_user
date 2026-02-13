import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
// import 'package:flutter_cab/widgets/Custom%20%20Button/gradient_button.dart';
import 'package:flutter_cab/widgets/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/reusable_inquiry_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyEnquiryScreen extends StatefulWidget {
  const MyEnquiryScreen({super.key});

  @override
  State<MyEnquiryScreen> createState() => _MyEnquiryScreenState();
}

class _MyEnquiryScreenState extends State<MyEnquiryScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getEnquiry();
    _scrollController.addListener(_onScroll);
  }

  void getEnquiry({bool isPagination = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<EnquiryViewModel>()
          .getMyEnquiryApi(isPagination: isPagination);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getEnquiry(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayoutPage(
        bgColor: bgGreyColor,
        appBar: AppBar(
          title: const Text('My Enquiry'),
          backgroundColor: background,
        ),
        onRefresh: () async {},
        child: Consumer<EnquiryViewModel>(
          builder: (context, value, child) {
            if (value.myEnquiryResponse.status == Status.loading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: greenColor,
              ));
            } else {
              return (value.myEnquiryResponse.data ?? []).isEmpty
                  ? Center(
                      child: Text(
                        'No Data Found',
                        style: nodataTextStyle,
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: (value.myEnquiryResponse.data ?? []).length +
                          (value.isLastPage ? 0 : 1),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (index == value.myEnquiryResponse.data?.length) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                        var enquiryData = value.myEnquiryResponse.data?[index];
                        return ReusableInquiryCard(
                          inquiry: enquiryData?.travelInquiry,
                          bidCount: enquiryData?.bids?.length ?? 0,
                          onTap: () {
                            context.push('/my_enquiry/view_bid', extra: {
                              "enquiryId": enquiryData?.travelInquiry?.id
                            }).then((onValue) {
                              getEnquiry();
                            });
                          },
                        );
                      },
                    );
            }
          },
        ));
  }
}

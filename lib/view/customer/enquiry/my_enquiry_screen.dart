import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/res/Custom%20%20Button/gradient_button.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
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
              return ListView.builder(
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
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: index == 0 ? 5 : 10),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        dense: true,
                        onExpansionChanged: (value) {},
                        childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        visualDensity: const VisualDensity(
                            vertical: VisualDensity.maximumDensity),
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        leading: const CircleAvatar(
                          radius: 28,
                          backgroundColor: btnColor,
                          child: Icon(
                            Icons.business_center,
                            color: background,
                          ),
                        ),
                        title: Text(
                            '${enquiryData?.travelInquiry?.name} [${enquiryData?.travelInquiry?.id}]',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Budget : AED ${enquiryData?.travelInquiry?.budget ?? 'NA'}",
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                            Text(enquiryData?.travelInquiry?.country ?? 'NA',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Enquiry Details',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              GradientButton(
                                  icon: Icons.remove_red_eye,
                                  onPressed: () {
                                    context.push('/my_enquiry/view_bid',
                                        extra: {
                                          "enquiryId":
                                              enquiryData?.travelInquiry?.id
                                        });
                                  },
                                  label: 'View Bid')
                            ],
                          ),
                          const SizedBox(height: 10),
                          (enquiryData?.travelInquiry?.travelDates ?? '')
                                  .isEmpty
                              ? const SizedBox.shrink()
                              : textItem(
                                  label: "Travel Date",
                              value: enquiryData?.travelInquiry?.travelDates ??
                                  'NA'),
                          (enquiryData?.travelInquiry?.tentativeDays ?? '')
                                  .isEmpty
                              ? const SizedBox.shrink()
                              : textItem(
                                  label: "Tantative Days",
                              value:
                                      enquiryData
                                          ?.travelInquiry?.tentativeDays ??
                                      'NA'),
                          textItem(
                              label: "Accommodation",
                              value: enquiryData?.travelInquiry
                                      ?.accommodationPreferences ??
                                  'NA'),
                          textItem(
                              label: "Special Request",
                              value:
                                  enquiryData?.travelInquiry?.specialRequests ??
                                      'NA'),
                          textItem(
                              label: "Destinations",
                              value:
                                  "${enquiryData?.travelInquiry?.destinations?.join(', ')}"),
                          textItem(
                              label: "Meals",
                              value: enquiryData?.travelInquiry?.meals ?? 'NA'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }

Widget textItem({String label = 'Label', String value = 'Value'}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: titleText,
          ),
        ),
        const SizedBox(width: 10),
        const Text(':'),
        const SizedBox(width: 10),
        Expanded(flex: 3, child: Text(value))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPageLayout.dart';
import 'package:flutter_cab/res/custom_filter_popup_widget.dart';
import 'package:flutter_cab/res/custom_search_field.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class EnquiryManagementScreen extends StatefulWidget {
  const EnquiryManagementScreen({super.key});

  @override
  State<EnquiryManagementScreen> createState() =>
      _EnquiryManagementScreenState();
}

class _EnquiryManagementScreenState extends State<EnquiryManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Map<String, String> bidFilter = {
    "All Status": '',
    "Sent Bid": 'true',
    "Not Sent Bid": 'false',
  };
  String title = "All Status";
  String? _selectedbidding;
  String searchText = '';
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllEnquirys(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllEnquirys({
    bool isFilter = false,
    bool isSearch = false,
    bool isPagination = false,
  }) {
    context.read<EnquiryViewModel>().getAllEnquiryApi(
          isFilter: isFilter,
          isSearch: isSearch,
          isPagination: isPagination,
          searchText: searchText,
          filterText: _selectedbidding ?? '',
        );
    debugPrint("Fetching all bids");
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
      _getAllEnquirys(isSearch: true, isFilter: false, isPagination: false);
    });
    // Handle search logic here
    debugPrint("Search value: $value");
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _selectedbidding = value;
      // Handle filter logic here
      debugPrint("Selected urgency: $_selectedbidding");
    });
    _getAllEnquirys(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllEnquirys(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayoutPage(
      bgColor: bgGreyColor,
      appBar: AppBar(
        title: const Text("Enquiry Management"),
        backgroundColor: background,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  filled: true,
                  fillColor: Colors.white,
                  focusNode: _searchFocus,
                  controller: _searchController,
                  serchHintText: 'Search by name or email',
                  // prefixIcon: const Icon(Icons.search),
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(width: 10),
              CustomFilterPopupWidget(
                  title: title,
                  filterOptions: bidFilter,
                  onFilterChanged: _onFilterChanged),
            ],
          ),
          Expanded(
            child: Consumer<EnquiryViewModel>(
              builder: (context, vm, state) {
                if (vm.bidData.status == Status.loading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: btnColor,
                  ));
                } else if (vm.bidData.status == Status.error) {
                  return Center(
                    child: Text(
                      vm.bidData.message ?? 'Error fetching bids',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (vm.bidData.data == null ||
                    vm.bidData.data!.isEmpty) {
                  return Center(
                      child: Text(
                    'No bids found',
                    style: nodataTextStyle,
                  ));
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: (vm.bidData.data ?? []).length +
                        (vm.isLastPage
                            ? 0
                            : 1), // Replace with your data length
                    itemBuilder: (context, index) {
                      if (index == vm.bidData.data?.length) {
                        // Show loading indicator at the end if more data is being loaded
                        if (vm.isLoadingMore) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                      var enquiryData = vm.bidData.data?[index];
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: index == 0 ? 10 : 10),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            dense: true,
                            onExpansionChanged: (value) {
                              setState(() {
                                isExpanded = value;
                              });
                            },
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
                              // child: bidData?.user?.profileImageUrl == null
                              //     ? const Icon(Icons.business_center)
                              //     : ClipOval(
                              //         child: Image.network(
                              //           // imageAssets.bidManagement!,
                              //           '${bidData?.user?.profileImageUrl}',
                              //           // width: double.infinity,
                              //           height: double.infinity,
                              //           fit: BoxFit.cover,
                              //         ),
                              //       ),
                            ),
                            title: Text('${enquiryData?.name} ',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Budget : AED ${enquiryData?.budget ?? 'NA'}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                                Text(enquiryData?.country ?? 'NA',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                            trailing: Column(children: [
                              enquiryData?.bidPlacedByVendor == true
                                  ? actionButton(
                                      title: 'Sent Bid', color: greenColor)
                                  : actionButton(
                                      title: 'Bid Now',
                                    ),
                              const SizedBox(height: 10),
                              Icon(Icons.expand_circle_down_outlined,
                                  color: Colors.grey.shade600)
                            ]),
                            children: [
                              const Text('Enquiry Details',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              textItem(
                                  label: "Travel Start Date",
                                  value: enquiryData?.travelDates ?? 'NA'),
                              textItem(
                                  label: "Travel End Date",
                                  value:
                                      "${enquiryData?.tentativeDates ?? 'NA'}"),
                              textItem(
                                  label: "Accommodation",
                                  value:
                                      enquiryData?.accommodationPreferences ??
                                          'NA'),
                              textItem(
                                  label: "Special Request",
                                  value: enquiryData?.specialRequests ?? 'NA'),
                              textItem(
                                  label: "Destinations",
                                  value:
                                      "${enquiryData?.destinations?.join(', ')}"),
                              textItem(
                                  label: "Meals",
                                  value: enquiryData?.meals ?? 'NA'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  textItem({String label = 'Label', String value = 'Value'}) {
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

  Widget actionButton(
      {void Function()? onTap,
      Color? color,
      required String title,
      IconData icon = Icons.check}) {
    if (title.isEmpty) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: onTap ??
          () {
            // Handle bid action
            debugPrint("Bid action tapped");
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color ?? btnColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

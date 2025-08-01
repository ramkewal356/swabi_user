import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:provider/provider.dart';

import '../../../res/Custom Page Layout/commonPageLayout.dart';
import '../../../res/custom_filter_popup_widget.dart';
import '../../../res/custom_search_field.dart';

class BidManagementScreen extends StatefulWidget {
  const BidManagementScreen({super.key});

  @override
  State<BidManagementScreen> createState() => _BidManagementScreenState();
}

class _BidManagementScreenState extends State<BidManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Map<String, String> bidFilter = {
    "All Status": '',
    "Submitted": 'true',
    "Not Submitted": 'false',
  };
  String title = "All Status";
  String? _selectedbidding;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllBids(
        isFilter: true,
        isSearch: false,
        isPagination: false,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _getAllBids({
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
      _getAllBids(isSearch: true, isFilter: false, isPagination: false);
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
    _getAllBids(isFilter: true, isSearch: false, isPagination: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getAllBids(
        isFilter: false,
        isSearch: false,
        isPagination: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageLayoutPage(
      appBar: AppBar(title: const Text("Bid Management")),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 2),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

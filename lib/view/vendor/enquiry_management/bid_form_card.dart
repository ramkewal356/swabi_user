// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/core/constants/bid_form_constant.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/models/get_all_bid_model.dart' as bid_model;
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/bid_view_model.dart';
// import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/app_group_radio_button.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_multiselect_dropdown.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import '../../../data/models/bid_special_request_model.dart';
import '../../../data/models/get_all_enquiry_model.dart';

/// Self-contained bid form card: create or update bid with full API integration.
class VendorBidFormCard extends StatefulWidget {
  final EnquiryContent? enquiryData;
  final bid_model.BidContent? bidData;
  final bool viewPage;

  const VendorBidFormCard({
    super.key,
    this.enquiryData,
    this.bidData,
    this.viewPage = false,
  });

  @override
  State<VendorBidFormCard> createState() => _VendorBidFormCardState();
}

class _VendorBidFormCardState extends State<VendorBidFormCard> {
  final _formKey = GlobalKey<FormState>();

  // Bid fields
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mealsController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _extrasController = TextEditingController();
  final TextEditingController _accommodationController =
      TextEditingController();
  final TextEditingController _itineraryController = TextEditingController();
  final TextEditingController _mealsPerDayController = TextEditingController();
  final TextEditingController _sharedTypeController = TextEditingController();

  // Trip basics & travel
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _tentativeDateController =
      TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  CountryType? _selectedCountryType;
  int _selectedToggle = 0;
  int _selectedDuration = 2;
  // bool _hasSpecialRequest = false;
  List<BidSpecialRequestModel> _specialRequestList = [];
  String selectedCurrency = 'INR';
  String? _selectedCountry;
  List<String> _selectedCountries = [];
  List<String> _selectedStates = [];

  // For multi-select "select all" checkboxes
  bool _selectAllRequests = false;

  EnquiryContent? get _enquiry {
    if (widget.enquiryData != null) return widget.enquiryData;
    return widget.bidData?.travelInquiry;
  }

  // String? startDate;
  // String? endDate;
  String? _startDate, _endDate;
  bid_model.BidContent? get _bid => widget.bidData;

  bool get _isClosed => _enquiry?.status == false;
  String get _currency => _bid?.currency ?? _enquiry?.currency ?? '';

  @override
  void initState() {
    super.initState();
    if (_specialRequestList.isEmpty) {
      _specialRequestList.add(BidSpecialRequestModel());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_bid != null) {
        _prefillFromBid();
      } else if (_bid == null) {
        _prefillFromEnquiry();
      }
    });
  }

  void _prefillFromBid() {
    final bid = _bid;
    if (bid == null) return;

    _regionController.text = bid.region ?? '';
    _priceController.text = bid.price ?? '';
    selectedCurrency = bid.currency ?? _currency;
    _mealsController.text = bid.mealType ?? '';
    _mealsPerDayController.text = bid.mealsPerDay ?? '';
    _transportController.text = bid.transportation ?? '';
    _extrasController.text = bid.extras ?? '';
    _accommodationController.text = bid.accommodation ?? '';
    _itineraryController.text = bid.itinerary ?? '';
    _sharedTypeController.text = (bid.shareCount ?? '');
    _remarkController.text = bid.remarks ?? '';
    if (bid.countryType == "SINGLE") {
      _selectedCountryType = CountryType.single;
      _countryController.text =
          (bid.countries != null && bid.countries!.isNotEmpty)
              ? bid.countries!.first
              : '';
      _selectedCountry = _countryController.text;
      _selectedCountries = [];
      _selectedStates = bid.destinations ?? [];
    } else if (bid.countryType == "MULTI") {
      _selectedCountryType = CountryType.multi;
      _selectedCountry = null;
      _selectedCountries = bid.countries ?? [];
      _selectedStates = [];
      _countryController.clear();
    } else {
      _selectedCountryType = null;
      _selectedCountry = null;
      _selectedCountries = [];
      _selectedStates = [];
    }

    if ((bid.travelDates ?? '').toString().isNotEmpty) {
      _selectedToggle = 0;
      _dateController.text = bid.travelDates ?? '';
      final range = bid.travelDates!.split(' - ');
      if (range.length == 2) {
        _startDate = range[0].trim();
        _endDate = range[1].trim();
      } else if (range.length == 1) {
        _startDate = range[0].trim();
      }
      _tentativeDateController.clear();
      _selectedDuration = 2;
    } else if ((bid.tentativeDates ?? '').toString().isNotEmpty) {
      _selectedToggle = 1;
      _tentativeDateController.text = bid.tentativeDates?.toString() ?? '';
      final days = int.tryParse(bid.tentativeDays?.toString() ?? '');
      if (days != null && BidFormConstants.durationOptions.contains(days)) {
        _selectedDuration = days;
      }
      _dateController.clear();
    } else {
      _selectedToggle = 0;
      _dateController.clear();
      _tentativeDateController.clear();
      _selectedDuration = 2;
    }

    if (bid.specialRequestsResponse != null &&
        bid.specialRequestsResponse!.isNotEmpty) {
      _specialRequestList = bid.specialRequestsResponse!
          .map((e) => BidSpecialRequestModel(
                id: e.id,
                request: e.request?.toString(),
                status: e.status ?? 'PENDING',
                specialRejectionReason: e.specialRejectionReason ?? '',
              ))
          .toList();
    } else {
      _specialRequestList = [BidSpecialRequestModel()];
    }

    if (_regionController.text.isNotEmpty) {
      context
          .read<ThirdPartyViewModel>()
          .getCountryListByRegionApi(region: _regionController.text);
    }
    if (_countryController.text.isNotEmpty) {
      context
          .read<ThirdPartyViewModel>()
          .getStateList(country: _countryController.text);
    }
    context.read<ThirdPartyViewModel>().getAllCurrency();
    if (mounted) setState(() {});
  }

  void _prefillFromEnquiry() {
    final enquiry = _enquiry;
    if (enquiry == null) {
      if (mounted) setState(() {});
      return;
    }
    _priceController.text = enquiry.budget ?? '';
    selectedCurrency = enquiry.currency ?? '';
    _mealsController.text = enquiry.mealType ?? '';

    if ((enquiry.mealsPerDay ?? '').isNotEmpty &&
        _mealsPerDayController.text.isEmpty) {
      _mealsPerDayController.text = enquiry.mealsPerDay ?? '';
    }
    _transportController.text = enquiry.transportation ?? '';
    if ((enquiry.transportation ?? '').toLowerCase() == 'sheared') {
      _sharedTypeController.text = enquiry.shareCount.toString();
    }
    _accommodationController.text = enquiry.accommodationPreferences ?? '';
    _regionController.text = enquiry.region ?? '';
    final firstCountry =
        (enquiry.countries != null && enquiry.countries!.isNotEmpty)
            ? enquiry.countries!.first
            : '';
    _countryController.text = firstCountry;
    _selectedCountry = firstCountry;
    _selectedCountries =
        enquiry.countryType == 'MULTI' ? (enquiry.countries ?? []) : [];
    _selectedStates =
        enquiry.countryType == 'SINGLE' ? (enquiry.destinations ?? []) : [];
    _selectedCountryType = enquiry.countryType == 'SINGLE'
        ? CountryType.single
        : CountryType.multi;
    if ((enquiry.travelDates ?? '').isNotEmpty) {
      _selectedToggle = 0;
      _dateController.text = enquiry.travelDates ?? '';
      final range = enquiry.travelDates!.split(' - ');
      if (range.length == 2) {
        _startDate = range[0].trim();
        _endDate = range[1].trim();
      } else if (range.length == 1) {
        _startDate = range[0].trim();
      }
    } else if ((enquiry.tentativeDates ?? '').toString().isNotEmpty) {
      _selectedToggle = 1;
      _tentativeDateController.text = enquiry.tentativeDates?.toString() ?? '';
      final days = int.tryParse(enquiry.tentativeDays?.toString() ?? '');
      if (days != null && BidFormConstants.durationOptions.contains(days)) {
        _selectedDuration = days;
      }
    }

    if (enquiry.specialRequests != null &&
        enquiry.specialRequests!.isNotEmpty) {
      _specialRequestList = enquiry.specialRequests!
          .map((e) => BidSpecialRequestModel(
              id: e.id,
              request: e.request?.toString(),
              status: e.status ?? 'PENDING',
              specialRejectionReason: e.specialRejectionReason ?? ''))
          .toList();
    }
    if (_regionController.text.isNotEmpty) {
      context
          .read<ThirdPartyViewModel>()
          .getCountryListByRegionApi(region: _regionController.text);
    }
    if (_countryController.text.isNotEmpty) {
      context
          .read<ThirdPartyViewModel>()
          .getStateList(country: _countryController.text);
    }
    context.read<ThirdPartyViewModel>().getAllCurrency();
    if (mounted) setState(() {});
  }

  void _getCountryListByRegion() {
    context
        .read<ThirdPartyViewModel>()
        .getCountryListByRegionApi(region: _regionController.text);
  }

  void _onCountryChanged(String value) {
    _countryController.text = value;
    _stateController.clear();
    _selectedStates = [];
    _selectedCountry = value;
    context.read<ThirdPartyViewModel>().clearStateList();
    context.read<ThirdPartyViewModel>().getStateList(country: value);
    context.read<ThirdPartyViewModel>().getAllCurrency();
    setState(() {});
  }

  Future<void> _submitBid() async {
    FocusScope.of(context).unfocus();
    if (_isClosed) {
      Utils.toastMessage(
          'This enquiry is closed. You cannot submit or update a bid.');
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Show toast if not select any request or not reject any request in list
    if (_specialRequestList.isNotEmpty) {
      // Check if ALL requests are still PENDING (not accepted nor rejected)
      final anyPending =
          _specialRequestList.any((test) => test.status == 'PENDING');

      final anyRejectionReasonMissing = _specialRequestList.any((test) =>
          test.status == 'REJECTED' &&
          (test.specialRejectionReason == null ||
              test.specialRejectionReason!.isEmpty));

      if (anyPending) {
        Utils.toastMessage('Please accept or reject at all request.');
        return;
      }
      if (anyRejectionReasonMissing) {
        Utils.toastMessage(
            'Please provide a rejection reason for all rejected requests.');
        return;
      }
    }
    // Start: Set correct API body for submit
    final isSingle = _selectedCountryType == CountryType.single;
    final isMulti = _selectedCountryType == CountryType.multi;

    // Build special requests
    List<Map<String, dynamic>> specialRequests = [];
    for (final req in _specialRequestList) {
      final reqValue = req.controller.text.trim();
      if (reqValue.isNotEmpty) {
        specialRequests.add({
          "id": req.id,
          "request": reqValue,
          "status": req.status,
          "specialRejectionReason": req.specialRejectionReason
        });
      }
    }

    // Determine dates
    String? travelDates;
    String? tentativeDates;
    int? tentativeDays;
    if (_selectedToggle == 0) {
      travelDates = _dateController.text.trim().isNotEmpty
          ? _dateController.text.trim()
          : null;
      tentativeDates = null;
      tentativeDays = null;
    } else {
      travelDates = null;
      tentativeDates = _tentativeDateController.text.trim().isNotEmpty
          ? _tentativeDateController.text.trim()
          : null;
      tentativeDays = _selectedDuration;
    }

    // Enquiry id
    final travelInquiryId =
        _enquiry?.id?.toString() ?? widget.enquiryData?.id?.toString();

    Map<String, dynamic> body = {
      "region": _regionController.text.trim(),
      "countryType": isSingle
          ? "SINGLE"
          : isMulti
              ? "MULTI"
              : null,
      "countries": isSingle
          ? (_countryController.text.trim().isEmpty
              ? []
              : [_countryController.text.trim()])
          : _selectedCountries,
      "destinations": isSingle ? _selectedStates : [],
      "travelDates": travelDates,
      "tentativeDates": tentativeDates,
      "tentativeDays": tentativeDays,
      "accommodation": _accommodationController.text.trim(),
      "transportation": _transportController.text.trim(),
      "shareCount": _transportController.text.trim() == 'Sheared'
          ? int.tryParse(_sharedTypeController.text.trim())
          : null,
      "mealType": _mealsController.text.trim(),
      "mealsPerDay": _mealsPerDayController.text.trim(),
      "price": _priceController.text.trim(),
      "currency": selectedCurrency,
      "extras": _extrasController.text.trim(),
      "itinerary": _itineraryController.text.trim(),
      "remarks": _remarkController.text.trim(),
      "specialRequests": specialRequests,
      "travelInquiryId": travelInquiryId,
    };
    // Filter out null-valued fields according to API spec
    body.removeWhere(
        (key, value) => (value == null) || (value is List && value.isEmpty));

    if (_bid == null) {
      await _createBid(body: body);
    } else {
      await _updateBid(body: body);
    }
  }

  Future<void> _createBid({required Map<String, dynamic> body}) async {
    final vm = context.read<BidViewModel>();
    await vm.createBidApi(body: body);
    if (!mounted) return;
    if (vm.createBid.status == Status.completed) {
      context.pop();
    }
  }

  Future<void> _updateBid({required Map<String, dynamic> body}) async {
    final vm = context.read<BidViewModel>();
    final bidId = _bid?.id ?? 0;
    await vm.updateBidApi(body: body, bidId: bidId);
    if (!mounted) return;
    if (vm.updateBid.status == Status.completed) {
      context.pop();
    }
  }

  void _handleSelectAll(bool? value) {
    setState(() {
      _selectAllRequests = value ?? false;
      for (final req in _specialRequestList) {
        req.status = _selectAllRequests ? "ACCEPTED" : "PENDING";
      }
    });
  }

  // Individual reject handler with modal for special rejection reason, returns whether rejected
  Future<bool> _handleRejectRequest(int index) async {
    final formKey1 = GlobalKey<FormState>();
    final req = _specialRequestList[index];
    final reasonController =
        TextEditingController(text: req.specialRejectionReason ?? '');

    final confirm = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Form(
          key: formKey1,
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 38,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Text(
                    'Confirm Reject',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      'Are you sure you want to reject this special request?'),
                  const SizedBox(height: 14),
                  const Text(
                    'Reason (required):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Customtextformfield(
                    controller: reasonController,
                    hintText: 'Enter reason for rejection',
                    minLines: 2,
                    maxLines: 2,
                    textLength: 150,
                    validator: (p0) {
                      if (p0 == null || p0.trim().isEmpty) {
                        return 'Please enter reason';
                      }
                      final lines = p0.split('\n');
                      if (lines.length > 2) {
                        return 'Maximum 2 lines allowed';
                      }
                      if (p0.trim().length > 150) {
                        return 'Maximum 150 characters allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx, false);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: btnColor),
                          onPressed: () {
                            if (formKey1.currentState!.validate()) {
                              Navigator.pop(ctx, true);
                            }
                          },
                          child: const Text(
                            'Reject',
                            style: TextStyle(color: background),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirm == true) {
      setState(() {
        req.status = "REJECTED";
        req.specialRejectionReason = reasonController.text.trim();
      });
    }
    return confirm == true;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _mealsController.dispose();
    _transportController.dispose();
    _extrasController.dispose();
    _accommodationController.dispose();
    _itineraryController.dispose();
    _mealsPerDayController.dispose();
    _sharedTypeController.dispose();
    _regionController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _dateController.dispose();
    _tentativeDateController.dispose();
    for (final item in _specialRequestList) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status =
        context.watch<BidViewModel>().createBid.status ?? Status.initial;
    final bidStatus =
        context.watch<BidViewModel>().updateBid.status ?? Status.initial;
    final currencyList = context
            .watch<ThirdPartyViewModel>()
            .currencyList
            .data
            ?.map((e) => e.code ?? '')
            .toList() ??
        [];
    return Card(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _bid == null
                    ? 'Submit Your Bid'
                    : widget.viewPage
                        ? 'View Your Bid Details'
                        : 'Update Your Bid',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 10),
              if (!widget.viewPage && _isClosed) _buildClosedBanner(),
              if (!widget.viewPage && _isClosed) const SizedBox(height: 12),
              _buildSectionTitle('Trip Basics'),
              const SizedBox(height: 8),
              ..._buildTripBasicsSection(),
              const SizedBox(height: 16),
              _buildSectionTitle('Travel Selection'),
              const SizedBox(height: 10),
              ..._buildTravelSelectionSection(),
              const SizedBox(height: 16),
              _buildSectionTitle('Preferences'),
              const SizedBox(height: 10),
              Customtextformfield(
                prefixIcon: IntrinsicWidth(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      widget.viewPage
                          ? Text(
                              selectedCurrency,
                              style: TextStyle(
                                color: greyColor1,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text(
                                  selectedCurrency,
                                  style: TextStyle(
                                    color: greyColor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: currencyList.contains(selectedCurrency)
                                    ? selectedCurrency
                                    : null,
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    size: 18),
                                style: TextStyle(
                                  color: greyColor1,
                                  fontWeight: FontWeight.bold,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCurrency = value!;
                                  });
                                },
                                items: currencyList.toSet().map((currency) {
                                  return DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                              ),
                            ),
                      const SizedBox(width: 8),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _priceController,
                readOnly: widget.viewPage,
                hintText: 'Budget (in $selectedCurrency)',
                lable: 'Budget (in $selectedCurrency) *',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter budget( in $selectedCurrency)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ..._buildPreferencesSection(),
              if (_specialRequestList.isNotEmpty) const SizedBox(height: 16),
              if (_specialRequestList.isNotEmpty)
                _buildSectionTitle('Special Requests'),
              if (_specialRequestList.isNotEmpty) _buildSpecialRequestFields(),
              const SizedBox(height: 22),
              if (!widget.viewPage) _buildSubmitButton(status, bidStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClosedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: btnColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: btnColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This enquiry is closed. You can view bid details, but you cannot submit or update a bid.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xff7B1E34),
      ),
    );
  }

  List<Widget> _buildTripBasicsSection() {
    final isView = widget.viewPage;
    return [
      CustomDropdownButton(
        hintText: 'Select Region',
        itemsList: List.from(BidFormConstants.regionList),
        controller: _regionController,
        isEditable: !isView,
        onChanged: (value) {
          setState(() {
            _selectedCountryType = null;
            _selectedCountry = '';
            _selectedStates = [];
            _selectedCountries = [];
          });
          if (value != null && value.isNotEmpty && !isView) {
            _getCountryListByRegion();
          }
        },
        validator: (v) => (v == null || v.toString().trim().isEmpty)
            ? 'Please select region'
            : null,
      ),
      const SizedBox(height: 12),
      if (_regionController.text.isNotEmpty) _buildPersonTypeSelector(),
      if (_regionController.text.isNotEmpty) const SizedBox(height: 12),
      if (_selectedCountryType == CountryType.single &&
          _regionController.text.isNotEmpty)
        _buildSingleCountryFields(),
      if (_selectedCountryType == CountryType.multi &&
          _regionController.text.isNotEmpty)
        _buildMultiCountryFields(),
    ];
  }

  Widget _buildPersonTypeSelector() {
    return AppRadioGroup<CountryType>(
      groupValue: _selectedCountryType,
      isEnabled: !widget.viewPage,
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedCountryType = value;
          _selectedCountries = [];
          _selectedStates = [];
        });

        _getCountryListByRegion();
      },
      items: [
        AppRadioItem(
          title: 'Single Country',
          value: CountryType.single,
        ),
        AppRadioItem(
          title: 'Multi Country',
          value: CountryType.multi,
        ),
      ],
    );
  }

  Widget _buildSingleCountryFields() {
    final thirdPartyVM = context.watch<ThirdPartyViewModel>();
    final countryListLoading =
        thirdPartyVM.getCountryListByRegion.status == Status.loading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdownButton(
          hintText: 'Select Country',
          isLoading: countryListLoading,
          itemsList: thirdPartyVM.getCountryListByRegion.data ?? [],
          controller: _countryController,
          isEditable: !widget.viewPage,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCountry = value;
                _selectedStates = [];
              });
              _onCountryChanged(value);
            }
          },
          validator: (v) => (v == null || v.toString().trim().isEmpty)
              ? 'Please select country'
              : null,
        ),
        const SizedBox(height: 12),
        CustomMultiselectDropdown(
          key: ValueKey(_selectedCountry),
          hintText: 'Select States / Cities',
          isLoading: thirdPartyVM.stateList.status == Status.loading,
          title: 'Destinations',
          items: thirdPartyVM.stateList.data ?? [],
          isDisabled: widget.viewPage ||
              _countryController.text.isEmpty ||
              (thirdPartyVM.stateList.data ?? []).isEmpty,
          selectedItems: _selectedStates,
          onChanged: (val) => setState(() => _selectedStates = val),
          validator: (v) => (v == null || v.isEmpty)
              ? 'Please select at least one destination'
              : null,
        ),
      ],
    );
  }

  Widget _buildMultiCountryFields() {
    final thirdPartyVM = context.watch<ThirdPartyViewModel>();
    final countryListLoading =
        thirdPartyVM.getCountryListByRegion.status == Status.loading;
    return CustomMultiselectDropdown(
      hintText: 'Select Countries',
      title: 'Countries',
      isDisabled: widget.viewPage,
      isLoading: countryListLoading,
      items: thirdPartyVM.getCountryListByRegion.data ?? [],
      selectedItems: _selectedCountries,
      onChanged: (val) => setState(() => _selectedCountries = val),
      validator: (v) => (v == null || v.isEmpty)
          ? 'Please select at least one country'
          : null,
    );
  }

  List<Widget> _buildTravelSelectionSection() {
    return [
      AppRadioGroup<int>(
        groupValue: _selectedToggle,
        isEnabled: !widget.viewPage,
        onChanged: (value) {
          setState(() => _selectedToggle = value ?? 0);
        },
        items: [
          AppRadioItem(title: 'Exact Dates', value: 0),
          AppRadioItem(title: 'Tentative Dates', value: 1),
        ],
      ),
      const SizedBox(height: 12),
      if (_selectedToggle == 0) _buildExactDateField(),
      if (_selectedToggle == 1) _buildTentativeDateSection(),
    ];
  }

  Widget _buildExactDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select Your Travel Dates',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: greyColor1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        prefixIcon: const Icon(Icons.date_range, color: Colors.grey),
      ),
      onTap: widget.viewPage
          ? null
          : () async {
              // final selectedDate = await pickSfDateRange(context, '', '');
              // if (selectedDate != null) {
              //   _dateController.text = selectedDate;
              //   setState(() {});
              // }
              final selectedDate =
                  await pickSfDateRange(context, _startDate, _endDate);
              if (selectedDate != null) {
                _dateController.text = selectedDate;

                final split = selectedDate.split(' - ');
                if (split.length == 2) {
                  setState(() {
                    _startDate = split[0].trim();
                    _endDate = split[1].trim();
                  });
                } else if (split.length == 1) {
                  setState(() {
                    _startDate = split[0].trim();
                    // _endDate = null;
                  });
                }
              }
              Future.delayed(Duration(milliseconds: 50), () {
                if (_formKey.currentState != null) {
                  _formKey.currentState!.validate();
                }
              });
            },
      validator: (value) {
        return Validation.validateTravelDates(
          value,
          countryType: _selectedCountryType,
          selectedCountries: _selectedCountries,
          minDaysPerCountry: 2,
          useStartEndDates: true,
          startDate: _startDate,
          endDate: _endDate,
        );
      },
    );
  }

  Widget _buildTentativeDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please Select Your Tentative Dates and Days',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        TextFormField(
          readOnly: true,
          controller: _tentativeDateController,
          decoration: InputDecoration(
            hintText: 'Select Duration',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: greyColor1)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            prefixIcon: const Icon(Icons.timer, color: Colors.grey),
          ),
          onTap: widget.viewPage
              ? null
              : () async {
                  final selectedDate = await showCustomDatePicker(
                    context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (selectedDate != null) {
                    _tentativeDateController.text =
                        DateFormat('dd-MM-yyyy').format(selectedDate);
                    setState(() {});
                  }
                },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select tentative date';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: BidFormConstants.durationOptions.map((days) {
            final isSelected = _selectedDuration == days;
            return ChoiceChip(
              label: Text('± $days days'),
              checkmarkColor: background,
              selected: isSelected,
              onSelected: widget.viewPage
                  ? null
                  : (_) => setState(() => _selectedDuration = days),
              selectedColor: const Color(0xff7B1E34),
              backgroundColor: Colors.transparent,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xff7B1E34)
                      : Colors.grey.shade400,
                ),
              ),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xff7B1E34),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          'Travel Date Flexibility: $_selectedDuration day${_selectedDuration > 1 ? 's' : ''}',
          style: const TextStyle(
            // color: Color(0xff7B1E34),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPreferencesSection() {
    final isView = widget.viewPage;
    return [
      CustomDropdownButton(
        hintText: 'Select Meals Type',
        itemsList: List.from(BidFormConstants.mealTypeOptions),
        controller: _mealsController,
        isEditable: !isView,
        onChanged: (_) => setState(() {}),
        validator: (v) => (v == null || v.toString().trim().isEmpty)
            ? 'Please select meals type'
            : null,
      ),
      const SizedBox(height: 10),
      CustomDropdownButton(
        hintText: 'Select Meals per day',
        itemsList: List.from(BidFormConstants.mealsPerDayOptions),
        controller: _mealsPerDayController,
        isEditable: !isView,
        onChanged: (_) => setState(() {}),
        validator: (v) => (v == null || v.toString().trim().isEmpty)
            ? 'Please select meals per day'
            : null,
      ),
      const SizedBox(height: 10),
      CustomDropdownButton(
        hintText: 'Select Transportation',
        itemsList: List.from(BidFormConstants.transportOptions),
        controller: _transportController,
        isEditable: !isView,
        onChanged: (v) {
          setState(() {
            if (v != 'Sheared') _sharedTypeController.clear();
          });
        },
        validator: (v) => (v == null || v.toString().trim().isEmpty)
            ? 'Please select transportation'
            : null,
      ),
      if (_transportController.text == 'Sheared') ...[
        const SizedBox(height: 10),
        CustomDropdownButton(
          hintText: 'Select Shared Type',
          itemsList: List.generate(11, (index) => index.toString()),
          controller: _sharedTypeController,
          isEditable: !isView,
          onChanged: (_) => setState(() {}),
          validator: (v) => (v == null || v.toString().trim().isEmpty)
              ? 'Please select shared type'
              : null,
        ),
      ],
      const SizedBox(height: 10),
      _buildBidField(
        controller: _extrasController,
        label: 'Extras *',
        icon: Icons.card_giftcard,
        hintText: 'What is included/excluded (permits, etc.)',
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Please enter extras' : null,
      ),
      const SizedBox(height: 10),
      CustomDropdownButton(
        hintText: 'Select Accommodation Preferences',
        itemsList: List.from(BidFormConstants.accommodationOptions),
        controller: _accommodationController,
        isEditable: !isView,
        onChanged: (_) => setState(() {}),
        validator: (v) => (v == null || v.toString().trim().isEmpty)
            ? 'Please select accommodation'
            : null,
      ),
      const SizedBox(height: 10),
      _buildBidField(
        controller: _itineraryController,
        label: 'Itinerary *',
        icon: Icons.list,
        maxLines: 3,
        hintText: 'Day-wise plan (high level is ok)',
        validator: (v) => (v == null || v.trim().isEmpty)
            ? 'Please enter itinerary details'
            : null,
      ),
      const SizedBox(height: 10),
      _buildBidField(
        controller: _remarkController,
        label: 'Remark(optional)',
        icon: Icons.mark_as_unread,
        maxLines: 3,
        hintText: 'Enter remark',
      ),
    ];
  }

  Widget _buildBidField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
    String hintText = '',
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Customtextformfield(
      controller: controller,
      lable: label,
      hintText: hintText,
      prefixIcon: Icon(icon, color: btnColor),
      readOnly: readOnly || widget.viewPage,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildSpecialRequestFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Checkbox(
                value: _specialRequestList
                    .every((req) => req.status == "ACCEPTED"),
                onChanged:
                    (widget.viewPage) ? null : (val) => _handleSelectAll(val),
                activeColor: Colors.green[400],
              ),
              const Text("Accept All Requests"),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _specialRequestList.length,
          itemBuilder: (context, i) {
            final req = _specialRequestList[i];
            final isRejected = req.status == "REJECTED";
            final isAccepted = req.status == "ACCEPTED";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // The main text form field, always present
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Customtextformfield(
                              controller: req.controller,
                              hintText: 'Enter a special request or note...',
                              minLines: 1,
                              // maxLines: 2,
                              readOnly: widget.viewPage || isRejected,
                              validator: (s) {
                                if (s == null || s.trim().isEmpty) {
                                  return 'Please enter request';
                                }
                                return null;
                              },
                            ),
                            if (isRejected &&
                                ((req.specialRejectionReason ?? '').isNotEmpty))
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2, left: 4, right: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.info_outline,
                                            color: Colors.red, size: 16),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            "Rejected: ${req.specialRejectionReason}",
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // if (!widget.viewPage)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isAccepted,
                          onChanged: (widget.viewPage)
                              ? (val) {}
                              : (val) {
                                  // Accept/Unaccept: "mark as accepted" or "pending"
                                  setState(() {
                                    req.status =
                                        val == true ? "ACCEPTED" : "PENDING";
                                    req.specialRejectionReason = "";
                                  });
                                },
                          activeColor: Colors.green[400],
                        ),
                        IconButton(
                          icon: Icon(Icons.highlight_remove_outlined,
                              color: Colors.red[400]), // NEW ICON for reject
                          tooltip: isRejected ? 'Rejected' : 'Reject',
                          onPressed: isRejected || widget.viewPage
                              ? () {}
                              : () async {
                                  await _handleRejectRequest(i);
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(Status status, Status bidStatus) {
    return Row(
      children: [
        Expanded(
          child: CustomButtonSmall(
            loading: status == Status.loading || bidStatus == Status.loading,
            btnHeading: _bid == null ? 'Submit Bid' : 'Update Bid',
            onTap: _submitBid,
          ),
        ),
      ],
    );
  }
}

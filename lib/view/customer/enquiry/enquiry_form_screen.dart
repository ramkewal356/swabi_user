// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/constants/bid_form_constant.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/data/models/bid_special_request_model.dart';
import 'package:flutter_cab/data/models/get_enquiry_by_id_model.dart'
    hide Status;
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/app_group_radio_button.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_multiselect_dropdown.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EnquiryFormScreen extends StatefulWidget {
  final int? enquiryId;

  const EnquiryFormScreen({super.key, this.enquiryId});

  bool get isUpdateMode => enquiryId != null;

  @override
  State<EnquiryFormScreen> createState() => _EnquiryFormScreenState();
}

class _EnquiryFormScreenState extends State<EnquiryFormScreen> {
  CountryType? selectedCountryType;
  int selectedToggle = 0;
  int selectedDuration = 2;
  bool hasSpecialRequest = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _formKeyStep0 = GlobalKey<FormState>();
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final TextEditingController fullNametController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController tentetiveDateController = TextEditingController();
  final TextEditingController accommodationController = TextEditingController();
  final TextEditingController mealsController = TextEditingController();
  final TextEditingController mealsPerDayController = TextEditingController();
  final TextEditingController transpotationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController sharedTypeController = TextEditingController();

  // Now manages list of SpecialRequestModel
  List<BidSpecialRequestModel> specialRequestList = [];

  int adults = 0;
  int seniors = 0;
  int children = 0;
  int infants = 0;
  int totalTravellers = 0;
  int currentStep = 0;
  final PageController _pageController = PageController();
  final List<int> travellerCount = List.generate(21, (index) => index);
  List<String> selectedCountries = [];
  String? selectedRegion;
  String selectedCurrency = 'INR';
  String? selectedCountry;
  List<String> selectedStates = [];
  bool _isDataLoaded = false;

  String? _startDate, _endDate;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserDetails();
      if (widget.isUpdateMode) _loadEnquiry();
    });
    if (specialRequestList.isEmpty) {
      specialRequestList.add(BidSpecialRequestModel());
    }
  }

  void _loadEnquiry() {
    context
        .read<EnquiryViewModel>()
        .getEnquiryByIdApi(enquiryId: widget.enquiryId!);
  }

  void _prePopulateFromEnquiry(Data? data) {
    if (data == null) return;
    regionController.text = data.region ?? '';
    selectedRegion = regionController.text;
    accommodationController.text = data.accommodationPreferences ?? '';
    mealsController.text = data.mealType ?? '';
    mealsPerDayController.text = data.mealsPerDay ?? '';
    transpotationController.text = data.transportation ?? '';
    budgetController.text = data.budget ?? '';
    selectedCurrency = data.currency ?? 'INR';
    if ((data.transportation ?? '').toLowerCase() == "sheared") {
      sharedTypeController.text = data.shareCount ?? '';
    } else {
      sharedTypeController.clear();
    }
    if (data.specialRequests != null && data.specialRequests!.isNotEmpty) {
      hasSpecialRequest = true;
      specialRequestList = data.specialRequests!
          .map((e) => BidSpecialRequestModel(
              id: e.id, request: e.request, status: e.status ?? "PENDING"))
          .toList();
    } else {
      hasSpecialRequest = false;
      specialRequestList = [BidSpecialRequestModel()];
    }
    // ---- Modified here for start/end date support ----
    if (data.travelDates != null && data.travelDates.toString().isNotEmpty) {
      selectedToggle = 0;
      dateController.text = data.travelDates!;
      // Split travelDates from API into start/end for validation.dart
      final range = data.travelDates!.split(' - ');
      if (range.length == 2) {
        // startDate = range[0].trim();
        // endDate = range[1].trim();
        _startDate = range[0].trim();
        _endDate = range[1].trim();
      } else if (range.length == 1) {
        // startDate = range[0].trim();
        // endDate = null;
        _startDate = range[0].trim();
      }
    } else if (data.tentativeDates != null &&
        data.tentativeDates.toString().isNotEmpty) {
      selectedToggle = 1;
      tentetiveDateController.text = data.tentativeDates.toString();
      try {
        selectedDuration = int.tryParse(data.tentativeDates.toString()) ?? 2;
      } catch (_) {}
    }
    _parseCountryAndDestinations(data);
    adults = data.participantType?.adult ?? 0;
    seniors = data.participantType?.senior ?? 0;
    children = data.participantType?.child ?? 0;
    infants = data.participantType?.infant ?? 0;
    totalTravellers = data.participantType?.guests ?? 0;
    setState(() => _isDataLoaded = true);
  }

  // int _getTravelDayCount() {
  //   if (selectedToggle == 0) {
  //     // Parse dateController.text as range (expect format '01-01-2024 - 07-01-2024')
  //     if (dateController.text.trim().isNotEmpty) {
  //       final range = dateController.text.split(' - ');
  //       // If only one date is selected (i.e. no end date), then this is an error (show 0)
  //       if (range.length == 1) {
  //         // Only one date (no range)
  //         return 0;
  //       } else if (range.length == 2) {
  //         try {
  //           final d1 = DateFormat('dd-MM-yyyy').parse(range[0].trim());
  //           final d2 = DateFormat('dd-MM-yyyy').parse(range[1].trim());
  //           final diff = d2.difference(d1).inDays + 1;
  //           if (diff > 0) return diff;
  //         } catch (e) {
  //           return 0;
  //         }
  //       }
  //     }
  //     return 0;
  //   } else {
  //     return selectedDuration;
  //   }
  // }

  void _parseCountryAndDestinations(Data data) {
    selectedCountryType =
        data.countryType == 'SINGLE' ? CountryType.single : CountryType.multi;
    selectedCountry = selectedCountryType == CountryType.single
        ? data.countries?.first.toString() ?? ''
        : '';
    selectedCountries =
        selectedCountryType == CountryType.multi ? data.countries ?? [] : [];
    selectedStates = selectedCountryType == CountryType.single
        ? data.destinations ?? []
        : [];
  }

  void getUserDetails() {
    var vm = context.read<UserProfileViewModel>();
    if (vm.dataList.status == Status.completed) {
      var userData = vm.dataList.data?.data;
      if (userData != null && fullNametController.text.isEmpty) {
        fullNametController.text = "${userData.firstName} ${userData.lastName}";
      }
    }
  }

  void getCountryListByRegion() {
    context
        .read<ThirdPartyViewModel>()
        .getCountryListByRegionApi(region: regionController.text);
  }

  void getStateListApi(String country) {
    context.read<ThirdPartyViewModel>().getStateList(country: country);
  }

  void getCurrencyListApi() {
    context.read<ThirdPartyViewModel>().getAllCurrency();
  }

  void _onCountryChanged(String value) {
    countryController.text = value;
    stateController.clear();
    selectedStates.clear();
    context.read<ThirdPartyViewModel>().clearStateList();
    getStateListApi(value);
    getCurrencyListApi();
    setState(() {});
  }

  @override
  void dispose() {
    fullNametController.dispose();
    countryController.dispose();
    stateController.dispose();
    regionController.dispose();
    for (final item in specialRequestList) {
      item.controller.dispose();
    }
    dateController.dispose();
    tentetiveDateController.dispose();
    accommodationController.dispose();
    mealsController.dispose();
    transpotationController.dispose();
    budgetController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enquiryVm = context.watch<EnquiryViewModel>();
    if (widget.isUpdateMode &&
        enquiryVm.getEnquiryById.status == Status.completed &&
        !_isDataLoaded &&
        enquiryVm.getEnquiryById.data?.data != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _prePopulateFromEnquiry(enquiryVm.getEnquiryById.data?.data);
      });
    }

    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          widget.isUpdateMode ? 'Update Bid Enquiry' : 'Send Bid Enquiry',
          style: appBarTitleStyle,
        ),
        backgroundColor: background,
        elevation: 0,
      ),
      body: Column(
        children: [
          _bidInfoHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _stepHeader(),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => currentStep = index),
              children: [
                Form(
                  key: _formKeyStep0,
                  autovalidateMode: _autoValidateMode,
                  child: _step1TripBasics(),
                ),
                Form(
                  key: _formKeyStep1,
                  autovalidateMode: _autoValidateMode,
                  child: _step2Travellers(),
                ),
                Form(
                  key: _formKeyStep2,
                  autovalidateMode: _autoValidateMode,
                  child: _step3Preferences(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _step1TripBasics() {
    final thirdPartyVM = context.read<ThirdPartyViewModel>();
    final stateLoading = thirdPartyVM.stateList.status == Status.loading;
    final countryListLoading =
        thirdPartyVM.getCountryListByRegion.status == Status.loading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard(
            "Trip Basics",
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdownButton(
                  hintText: "Select Region",
                  itemsList: BidFormConstants.regionList,
                  controller: regionController,
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value;
                      selectedCountryType = null;
                      selectedCountry = '';
                      selectedStates.clear();
                      selectedCountries.clear();
                    });
                  },
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) return 'Please select region';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (regionController.text.isNotEmpty) _personTypeSelector(),
                const SizedBox(height: 16),
                if (selectedCountryType == CountryType.single) ...[
                  CustomDropdownButton(
                    hintText: "Select Country",
                    isLoading: countryListLoading,
                    itemsList: thirdPartyVM.getCountryListByRegion.data ?? [],
                    controller: TextEditingController(text: selectedCountry),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCountry = value;
                          selectedStates.clear();
                        });
                        _onCountryChanged(value);
                      }
                    },
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Please select country';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomMultiselectDropdown(
                    key: ValueKey(selectedCountry),
                    hintText: "Select States / Cities",
                    isLoading: stateLoading,
                    title: "Destinations",
                    items: thirdPartyVM.stateList.data ?? [],
                    isDisabled: countryController.text.isEmpty ||
                        stateLoading ||
                        (thirdPartyVM.stateList.data ?? []).isEmpty,
                    selectedItems: selectedStates,
                    onChanged: (val) => setState(() => selectedStates = val),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Please select at least one destination';
                      }
                      return null;
                    },
                  ),
                ],
                if (selectedCountryType == CountryType.multi)
                  CustomMultiselectDropdown(
                    hintText: "Select Countries",
                    title: "Countries",
                    isLoading: countryListLoading,
                    items: thirdPartyVM.getCountryListByRegion.data ?? [],
                    selectedItems: selectedCountries,
                    onChanged: (val) => setState(() => selectedCountries = val),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Please select at least one country';
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _nextButton(),
        ],
      ),
    );
  }

  Widget _step2Travellers() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _sectionCard(
            "Travellers",
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTravellerCounter(
                        label: "Seniors",
                        value: seniors,
                        onChanged: (val) => setState(() => seniors = val),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildTravellerCounter(
                        label: "Adults *",
                        value: adults,
                        onChanged: (val) => setState(() => adults = val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTravellerCounter(
                        label: "Children",
                        value: children,
                        onChanged: (val) => setState(() => children = val),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildTravellerCounter(
                        label: "Infants",
                        value: infants,
                        onChanged: (val) => setState(() => infants = val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    totalTravellers =
                        (adults) + (seniors) + (children) + (infants);
                    String? errorText;
                    if (adults == 0) {
                      errorText = "At least one adult is required";
                    } else if (totalTravellers == 0) {
                      errorText = "At least one traveller must be selected";
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Total Travellers: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                            Text(
                              "$totalTravellers",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: totalTravellers > 0
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                        ),
                        if (errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              errorText,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            "Travel Selection",
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppRadioGroup<int>(
                    groupValue: selectedToggle,
                    isEnabled: true,
                    onChanged: (value) {
                      setState(() => selectedToggle = value ?? 0);
                    },
                    items: [
                      AppRadioItem(title: 'Exact Dates', value: 0),
                      AppRadioItem(title: 'Tentative Dates', value: 1),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (selectedToggle == 0)
                    TextFormField(
                      autovalidateMode: _autoValidateMode,
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: 'Select Your Travel Dates',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: greyColor1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          prefixIcon:
                              const Icon(Icons.date_range, color: Colors.grey),
                          errorMaxLines: 2),
                      onTap: () async {
                        final selectedDate = await pickSfDateRange(
                            context, _startDate, _endDate);
                        if (selectedDate != null) {
                          dateController.text = selectedDate;

                          final split = selectedDate.split(' - ');
                          if (split.length == 2) {
                            setState(() {
                              _startDate = split[0].trim();
                              _endDate = split[1].trim();
                            });
                          } else if (split.length == 1) {
                            setState(() {
                              _startDate = split[0].trim();
                              //  _endDate = null;
                            });
                          }
                          // Instantly trigger validation after date selection
                          Future.delayed(Duration(milliseconds: 50), () {
                            if (_formKeyStep1.currentState != null) {
                              _formKeyStep1.currentState!.validate();
                            }
                          });
                        }
                      },
                      validator: (value) {
                        // ---- Use validation.dart function for date range, e.g. ----
                        return Validation.validateTravelDates(
                          value,
                          countryType: selectedCountryType,
                          selectedCountries: selectedCountries,
                          minDaysPerCountry: 2,
                          useStartEndDates: true,
                          startDate: _startDate,
                          endDate: _endDate,
                        );
                      },
                    ),
                  if (selectedToggle == 1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Please Select Your Tentative Dates and Days",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          controller: tentetiveDateController,
                          decoration: InputDecoration(
                            hintText: 'Select Duration',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            prefixIcon:
                                const Icon(Icons.timer, color: Colors.grey),
                          ),
                          onTap: () async {
                            final selectedDate = await showCustomDatePicker(
                              context,
                              initialDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 90)),
                            );
                            if (selectedDate != null) {
                              tentetiveDateController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
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
                          children:
                              BidFormConstants.durationOptions.map((days) {
                            final isSelected = selectedDuration == days;
                            return ChoiceChip(
                              label: Text("± $days days"),
                              checkmarkColor: background,
                              selected: isSelected,
                              onSelected: (_) =>
                                  setState(() => selectedDuration = days),
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
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xff7B1E34),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Travel Date Flexibility: $selectedDuration day${selectedDuration > 1 ? 's' : ''}",
                          style: const TextStyle(
                            color: Color(0xff7B1E34),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _stepNavigation(),
        ],
      ),
    );
  }

  Widget _step3Preferences() {
    final currencyList = context
            .watch<ThirdPartyViewModel>()
            .currencyList
            .data
            ?.map((e) => e.code ?? '')
            .toList() ??
        [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sectionCard(
            "Preferences",
            Column(
              children: [
                CustomDropdownButton(
                  hintText: "Select Accommodation Preferences",
                  itemsList: BidFormConstants.accommodationOptions,
                  controller:
                      TextEditingController(text: accommodationController.text),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        accommodationController.text = value;
                      });
                    }
                  },
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please select accommodation preferences';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomDropdownButton(
                  hintText: "Select Meals Type",
                  itemsList: BidFormConstants.mealTypeOptions,
                  controller: mealsController,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        mealsController.text = value;
                      });
                    }
                  },
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please select meals type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomDropdownButton(
                  hintText: "Select Meals per day",
                  itemsList: BidFormConstants.mealsPerDayOptions,
                  controller: mealsPerDayController,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        mealsPerDayController.text = value;
                      });
                    }
                  },
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please select meals per day';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomDropdownButton(
                  hintText: "Select Transportation",
                  itemsList: BidFormConstants.transportOptions,
                  controller:
                      TextEditingController(text: transpotationController.text),
                  onChanged: (value) {
                    setState(() {
                      transpotationController.text = value ?? '';
                      if (transpotationController.text != "Sheared") {
                        sharedTypeController.text = '';
                      }
                    });
                  },
                  validator: (p0) => p0 == null || p0.isEmpty
                      ? 'Please select transportation'
                      : null,
                ),
                if (transpotationController.text == "Sheared") ...[
                  const SizedBox(height: 10),
                  CustomDropdownButton(
                    hintText: "Select Shared Type",
                    itemsList: List.generate(
                      11,
                      (index) => index.toString(),
                    ),
                    controller:
                        TextEditingController(text: sharedTypeController.text),
                    onChanged: (value) {
                      setState(() {
                        sharedTypeController.text = value ?? '';
                      });
                    },
                    validator: (p0) => p0 == null || p0.isEmpty
                        ? 'Please select shared type'
                        : null,
                  ),
                ],
                const SizedBox(height: 16),
                Customtextformfield(
                  autovalidateMode: _autoValidateMode,
                  prefixIcon: IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text(
                              "INR",
                              style: TextStyle(
                                color: greyColor1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: currencyList.contains(selectedCurrency)
                                ? selectedCurrency
                                : null,
                            icon:
                                const Icon(Icons.keyboard_arrow_down, size: 18),
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
                        const SizedBox(width: 5),
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
                  controller: budgetController,
                  hintText: 'Budget (in $selectedCurrency)',
                  lable: 'Budget (in $selectedCurrency) *',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter budget( in $selectedCurrency)';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            "Special Requests",
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      activeColor: btnColor,
                      value: hasSpecialRequest,
                      onChanged: (val) {
                        setState(() {
                          hasSpecialRequest = val ?? false;
                          if (hasSpecialRequest && specialRequestList.isEmpty) {
                            specialRequestList.add(BidSpecialRequestModel());
                          }
                          if (!hasSpecialRequest) {
                            for (final item in specialRequestList) {
                              item.controller.dispose();
                            }
                            specialRequestList = [BidSpecialRequestModel()];
                          }
                        });
                      },
                    ),
                    const Text("Do you have any special requests?"),
                  ],
                ),
                if (hasSpecialRequest)
                  _dynamicSpecialRequestFields(
                    requests: specialRequestList,
                    autoValidateMode: _autoValidateMode,
                    onAddField: () {
                      setState(() {
                        specialRequestList.add(BidSpecialRequestModel());
                      });
                    },
                    onRemoveField: (index) {
                      setState(() {
                        if (specialRequestList.length > 1) {
                          specialRequestList[index].controller.dispose();
                          specialRequestList.removeAt(index);
                        }
                      });
                    },
                    onEdit: (index, value) {
                      setState(() {
                        specialRequestList[index].controller.text = value;
                        specialRequestList[index].status = "PENDING";
                      });
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _stepNavigation(),
        ],
      ),
    );
  }

  Widget _personTypeSelector() {
    return AppRadioGroup<CountryType>(
      groupValue: selectedCountryType,
      isEnabled: true,
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedCountryType = value;
          selectedCountries.clear();
          selectedStates.clear();
        });
        getCountryListByRegion();
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

  Widget _buildTravellerCounter({
    required String label,
    required int value,
    required Function(int) onChanged,
    int min = 0,
    int max = 20,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: value <= min ? null : () => onChanged(value - 1),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.remove,
                    size: 18,
                    color: value <= min ? Colors.grey.shade400 : btnColor,
                  ),
                ),
              ),
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: value >= max ? null : () => onChanged(value + 1),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: value >= max ? Colors.grey.shade400 : btnColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dynamicSpecialRequestFields({
    required List<BidSpecialRequestModel> requests,
    required AutovalidateMode autoValidateMode,
    required VoidCallback onAddField,
    required Function(int) onRemoveField,
    required Function(int, String) onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, i) {
            final req = requests[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Customtextformfield(
                      autovalidateMode: autoValidateMode,
                      controller: req.controller,
                      hintText: "Enter a special request or note...",
                      maxLines: 2,
                      validator: (s) {
                        if (s == null || s.trim().isEmpty) {
                          return 'Please enter request';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (req.status != "PENDING" && req.status.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: req.status == "ACCEPTED"
                              ? Colors.green[100]
                              : Colors.red[100],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Text(
                          req.status,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: req.status == "ACCEPTED"
                                  ? Colors.green[900]
                                  : Colors.red[900],
                              fontSize: 11),
                        ),
                      ),
                    ),
                  if (requests.length > 1)
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline,
                          color: Colors.red[400]),
                      tooltip: "Remove",
                      onPressed: () => onRemoveField(i),
                    ),
                ],
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: Icon(Icons.add, color: btnColor),
            label: Text("Add another", style: TextStyle(color: btnColor)),
            onPressed: onAddField,
          ),
        ),
      ],
    );
  }

  Widget _nextButton({double? buttonRadius}) {
    final status = widget.isUpdateMode
        ? context.watch<EnquiryViewModel>().updateEnquiryResponse.status
        : context.watch<EnquiryViewModel>().sendEnquiryResponse.status;

    return CustomButtonSmall(
      loading: status == Status.loading,
      btnHeading: currentStep == 2
          ? widget.isUpdateMode
              ? "Update Enquiry"
              : "Send Enquiry"
          : "Next",
      height: 45,
      borderRadius: BorderRadius.circular(buttonRadius ?? 5),
      onTap: () {
        if (currentStep == 0) {
          if (_formKeyStep0.currentState!.validate()) {
            if (selectedCountryType == null) {
              Utils.toastMessage("Please select Single or Multi Country");
              return;
            }
            _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          }
        } else if (currentStep == 1) {
          setState(() {
            _autoValidateMode = AutovalidateMode.onUserInteraction;
          });
          if (_formKeyStep1.currentState!.validate()) {
            if (adults == 0) {
              Utils.toastMessage("At least 1 adult is required");
              return;
            }
            // Also check multi-country days/country rule before proceeding
            // if (selectedCountryType == CountryType.multi) {
            //   int countryCount = selectedCountries.length;
            //   int minDays = countryCount * 2;
            //   int travelDays = _getTravelDayCount();
            //   if (countryCount > 0 && travelDays > 0 && travelDays < minDays) {
            //     Utils.toastMessage(
            //         'For $countryCount countries, you must select at least $minDays travel days.');
            //     return;
            //   }
            // }
            _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          }
        } else if (currentStep == 2) {
          if (_formKeyStep2.currentState!.validate()) {
            final specialRequests = hasSpecialRequest
                ? specialRequestList
                    .where((req) => req.controller.text.trim().isNotEmpty)
                    .map((req) => req.toMap())
                    .toList()
                : [];
            debugPrint('selected request $specialRequests');
            final body = <String, dynamic>{
              "name": fullNametController.text,
              "region": regionController.text,
              "countryType": selectedCountryType == CountryType.single
                  ? "SINGLE"
                  : "MULTI",
              "countries": selectedCountryType == CountryType.single
                  ? [selectedCountry]
                  : selectedCountries,
              if (selectedCountryType == CountryType.single)
                "destinations": selectedStates,
              "participantType": {
                "ADULT": adults,
                "SENIOR": seniors,
                "CHILD": children,
                "INFANT": infants
              },
              "currency": selectedCurrency,
              "budget": budgetController.text,
              "accommodationPreferences": accommodationController.text,
              "mealType": mealsController.text,
              "mealsPerDay": mealsPerDayController.text,
              "transportation": transpotationController.text,
              if (transpotationController.text == 'Sheared')
                "shareCount": sharedTypeController.text,
              if (hasSpecialRequest && specialRequests.isNotEmpty)
                "specialRequests": specialRequests,
              "travelDates": selectedToggle == 0 ? dateController.text : "",
              "tentativeDates":
                  selectedToggle == 1 ? tentetiveDateController.text : "",
              "tentativeDays":
                  selectedToggle == 1 ? selectedDuration.toString() : "",
            };
            if (widget.isUpdateMode) {
              body["inquireId"] = widget.enquiryId;
              context
                  .read<EnquiryViewModel>()
                  .updateEnquiryApi(body: body)
                  .then((success) {
                if (success) {
                  Utils.toastSuccessMessage("Enquiry updated successfully");
                  context.pop();
                }
              });
            } else {
              context
                  .read<EnquiryViewModel>()
                  .sendEnquiryApi(body: body)
                  .then((success) {
                if (success) {
                  Utils.toastSuccessMessage("Enquiry sent successfully");
                  context.pop();
                }
              });
            }
          }
        }
      },
    );
  }

  Widget _stepNavigation() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Text("Back"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: _nextButton(buttonRadius: 35)),
      ],
    );
  }

  Widget _stepHeader() {
    List<String> titles = ["Basics", "Travellers", "Submit"];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              children: List.generate(2, (index) {
                final isCompleted = currentStep > index;
                return Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isCompleted ? btnColor : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) {
              final isActive = currentStep == index;
              final isCompleted = currentStep > index;
              return Column(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? btnColor
                          : isActive
                              ? btnColor
                              : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.2))
                            ]
                          : [],
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 20)
                          : Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _bidInfoHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [btnColor.withOpacity(0.9), btnColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: btnColor.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.isUpdateMode ? Icons.edit : Icons.gavel,
                  color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                widget.isUpdateMode ? "Update Bid Enquiry" : "Send Bid Enquiry",
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.isUpdateMode
                ? "Modify your travel enquiry and preferences."
                : "Get multiple customized travel offers from verified experts.",
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          if (!widget.isUpdateMode) ...[
            const SizedBox(height: 14),
            _bidBenefit("Competitive prices from multiple agents"),
            _bidBenefit("Customized itinerary as per your needs"),
            _bidBenefit("Compare bids & choose the best offer"),
            _bidBenefit("No obligation to book"),
          ],
        ],
      ),
    );
  }

  Widget _bidBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 11, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, Widget child) {
    return Card(
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff7B1E34)),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

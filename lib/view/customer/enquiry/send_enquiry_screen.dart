import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/utils.dart';
// import 'package:flutter_cab/data/models/currency_model.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
// import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_multiselect_dropdown.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SendEnquiryScreen extends StatefulWidget {
  const SendEnquiryScreen({super.key});

  @override
  State<SendEnquiryScreen> createState() => _SendEnquiryScreenState();
}

enum PersonType { single, multi }

class _SendEnquiryScreenState extends State<SendEnquiryScreen> {
  PersonType? selectedPerson;
  int selectedToggle = 0; // 0 = Exact, 1 = Tentative
  int selectedDuration = 2;
  List<int> durationOptions = [1, 2, 3, 5, 7];
  bool hasSpecialRequest = false;
  // Key _destinationKey = UniqueKey();
  // Key _countriesKey = UniqueKey();
  final AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNametController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController countriesController = TextEditingController();

  TextEditingController specialRequestController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController tentetiveDateController = TextEditingController();

  TextEditingController accommodationController = TextEditingController();
  TextEditingController mealsController = TextEditingController();
  TextEditingController transpotationController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  int totalTravellers = 0;
  int adults = 0;
  int seniors = 0;
  int children = 0;
  int infants = 0;
  int currentStep = 0;
  final PageController _pageController = PageController();

  final List<int> travellerCount = List.generate(21, (index) => index); // 0–10

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCountry();
      getUserDeatails();
    });
  }

  void getUserDeatails() {
    var vm = context.read<UserProfileViewModel>();
    if (vm.dataList.status == Status.completed) {
      var userData = vm.dataList.data?.data;
      if (userData != null) {
        fullNametController.text = "${userData.firstName} ${userData.lastName}";
      }
    }
  }

  void getCountry() {
    context.read<ThirdPartyViewModel>().getCountryList();
  }

  void getCountryListByRegion() {
    context
        .read<ThirdPartyViewModel>()
        .getCountryListByRegionApi(region: regionController.text);
  }

  void getStateListApi(String country) {
    context.read<ThirdPartyViewModel>().getStateList(country: country);
  }

  void getCurrencyListApi(String countryName) {
    context
        .read<ThirdPartyViewModel>()
        .getAllCurrency(countryName: countryName);
  }

  List<String> selectedDestinations = [];
  List<String> selectedCountries = [];
  String? selectedRegion;
  String selectedCurrency = 'INR';
  String? selectedCountry;
  List<String> selectedStates = [];

  void _onCountryChanged(String value) {
    // Clear country text
    countryController.text = value;

    // Clear state & destination
    stateController.clear();
    selectedDestinations.clear();
    // _destinationKey = UniqueKey();
    // Reset state list from Bloc (important)
    context.read<ThirdPartyViewModel>().clearStateList();

    // Fetch new data
    getStateListApi(value);
    getCurrencyListApi(value);

    setState(() {});
  }

  List<String> regionCountryList = [
    "Asia",
    "Europe",
    "Africa",
    "North America",
    "South America",
    "Oceania",
    "Caribbean"
  ];
  String _validateTravellers() {
    if (adults == 0) {
      return 'At least 1 adult is required';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          "Send Bid Enquiry",
          style: appBarTitleStyle,
        ),
        backgroundColor: background,
        elevation: 0,
      ),
      body: Column(
        children: [
          _bidInfoHeader(),
          // const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            // child: _stepIndicator(),
            child: _stepHeader(),
          ),
          // const SizedBox(height: 10),
          Expanded(
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => currentStep = index);
                },
                children: [
                  _step1TripBasics(),
                  _step2Travellers(),
                  _step3Preferences(),
                ],
              ),
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
                /// 🌍 Region
                CustomDropdownButton(
                  hintText: "Select Region",
                  itemsList: regionCountryList,
                  controller: regionController,
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value;
                      selectedPerson = null;
                      selectedCountry = null;
                      selectedStates.clear();
                      selectedCountries.clear();
                    });
                  },
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please select region';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// 🔘 Single / Multi Country
                if (selectedRegion != null) _personTypeSelector(),

                const SizedBox(height: 16),

                /// 🇮🇳 Single Country Flow
                if (selectedPerson == PersonType.single) ...[
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
                    onChanged: (val) {
                      setState(() {
                        selectedStates = val;
                      });
                    },
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Please select at least one destination';
                      }
                      return null;
                    },
                  ),
                ],

                /// 🌎 Multi Country Flow
                if (selectedPerson == PersonType.multi)
                  CustomMultiselectDropdown(
                    hintText: "Select Countries",
                    title: "Countries",
                    isLoading: countryListLoading,
                    items: thirdPartyVM.getCountryListByRegion.data ?? [],
                    selectedItems: selectedCountries,
                    onChanged: (val) {
                      setState(() => selectedCountries = val);
                    },
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
                      child: _travellerDropdown(
                        label: "Senior",
                        value: seniors,
                        onChanged: (val) {
                          setState(() {
                            seniors = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _travellerDropdown(
                        label: "Adults *",
                        value: adults,
                        onChanged: (val) {
                          setState(() {
                            adults = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _travellerDropdown(
                        label: "Children",
                        value: children,
                        onChanged: (val) {
                          setState(() {
                            children = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _travellerDropdown(
                        label: "Infants",
                        value: infants,
                        onChanged: (val) {
                          setState(() {
                            infants = val!;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
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
                  Container(
                    decoration: BoxDecoration(
                      color: curvePageColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                selectedToggle = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selectedToggle == 0
                                    ? btnColor
                                    : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Exact Dates',
                                style: TextStyle(
                                  color: selectedToggle == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                selectedToggle = 1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selectedToggle == 1
                                    ? btnColor
                                    : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Tentative Duration',
                                style: TextStyle(
                                  color: selectedToggle == 1
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // If user selected Exact Dates
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
                      ),
                      onTap: () async {
                        final selectedDate = await pickSfDateRange(context);
                        debugPrint('selected date $selectedDate');
                        if (selectedDate != null) {
                        
                          dateController.text = selectedDate;
                         
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select date';
                        }
                        return null;
                      },
                    ),

                  // If user selected Tentative Duration
                  if (selectedToggle == 1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Please Select Your Tantative Dates and Days",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
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
                                  DateTime.now().add(Duration(days: 1)),
                              firstDate: DateTime.now().add(Duration(days: 1)),
                              lastDate: DateTime.now().add(
                                const Duration(days: 90),
                              ),
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
                          children: durationOptions.map((days) {
                            final isSelected = selectedDuration == days;
                            return ChoiceChip(
                              label: Text("± $days days"),
                              checkmarkColor: background,
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  selectedDuration = days;
                                });
                              },
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
                          "Selected Duration: $selectedDuration day${selectedDuration > 1 ? 's' : ''}",
                          style: const TextStyle(
                              color: Color(0xff7B1E34),
                              fontWeight: FontWeight.bold),
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
    final status = context.watch<EnquiryViewModel>().sendEnquiryResponse.status;
    List<String> currencyList = context
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
                Customtextformfield(
                  autovalidateMode: _autoValidateMode,
                  prefixIcon: const Icon(
                    Icons.hotel,
                    color: greyColor1,
                  ),
                  controller: accommodationController,
                  hintText: 'Accommodation Preferences',
                  lable: 'Accommodation Preferences *',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter accommodation preferences';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Customtextformfield(
                  autovalidateMode: _autoValidateMode,
                  prefixIcon: const Icon(
                    Icons.restaurant,
                    color: greyColor1,
                  ),
                  controller: mealsController,
                  hintText: 'Meals',
                  lable: 'Meals*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter meals';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Customtextformfield(
                  autovalidateMode: _autoValidateMode,
                  prefixIcon: const Icon(
                    Icons.directions_car,
                    color: greyColor1,
                  ),
                  controller: transpotationController,
                  hintText: 'Transportation',
                  lable: 'Transportation*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter transportation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // CustomDropdownButton(itemsList: itemsList, hintText: hintText, controller: controller),
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
                        });
                      },
                    ),
                    const Text("Do you have any special requests?"),
                  ],
                ),
                if (hasSpecialRequest)
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Customtextformfield(
                        autovalidateMode: _autoValidateMode,
                        maxLines: 3,
                        minLines: 3,
                        controller: specialRequestController,
                        hintText: 'Special Request',
                        validator: hasSpecialRequest
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter special request';
                                }
                                return null;
                              }
                            : null,
                      )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomButtonSmall(
            btnHeading: "Send Enquiry",
            loading: status == Status.loading,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                final travellerError = _validateTravellers();
                if (travellerError.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(travellerError)),
                  );
                  return;
                }
                Map<String, dynamic> body = {
                  "name": fullNametController.text,
                  "region": selectedRegion,
                  "countryType":
                      selectedPerson == PersonType.single ? "SINGLE" : "MULTI",
                  "countries": selectedPerson == PersonType.single
                      ? [selectedCountry]
                      : selectedCountries,
                  if (selectedPerson == PersonType.single)
                    "destinations": selectedPerson == PersonType.single
                        ? selectedStates
                        : '',
                  "participantType": {
                    "ADULT": adults,
                    "SENIOR": seniors,
                    "CHILD": children,
                    "INFANT": infants,
                  },
                  "currency": selectedCurrency,
                  "budget": budgetController.text,
                  "accommodationPreferences": accommodationController.text,
                  "meals": mealsController.text,
                  "transportation": transpotationController.text,
                  if (hasSpecialRequest)
                    "specialRequests":
                        hasSpecialRequest ? specialRequestController.text : "",
                  "travelDates": selectedToggle == 0 ? dateController.text : "",
                  "tentativeDates":
                      selectedToggle == 1 ? tentetiveDateController.text : "",
                  "tentativeDays":
                      selectedToggle == 1 ? selectedDuration.toString() : "",
                };
                context
                    .read<EnquiryViewModel>()
                    .sendEnquiryApi(body: body)
                    .then((success) {
                  if (success) {
                    Utils.toastSuccessMessage("Enquiry sent successfully");
                    context.pop();
                  } else {
                    // Utils.toastMessage("Failed to send enquiry");
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Row _personTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<PersonType>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            activeColor: btnColor,
            title: Text(
              "Single Country",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black),
            ),
            selected: selectedPerson == PersonType.single,
            value: PersonType.single,
            groupValue: selectedPerson,
            onChanged: (value) {
              setState(() {
                selectedPerson = PersonType.single;
                selectedCountries.clear();
              });
              getCountryListByRegion();
            },
          ),
        ),
        Expanded(
          child: RadioListTile<PersonType>(
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            activeColor: btnColor,
            title: Text(
              "Multi Country",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black),
            ),
            selected: selectedPerson == PersonType.multi,
            value: PersonType.multi,
            groupValue: selectedPerson,
            onChanged: (value) {
              setState(() {
                selectedPerson = PersonType.multi;
                selectedCountry = null;
                selectedStates.clear();
              });
              getCountryListByRegion();
            },
          ),
        ),
      ],
    );
  }

  Widget _travellerDropdown(
      {required String label,
      required int value,
      required Function(int?) onChanged}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        DropdownButton<int>(
          value: value,
          items: travellerCount
              .map((count) =>
                  DropdownMenuItem(value: count, child: Text(count.toString())))
              .toList(),
          onChanged: (v) => setState(() => onChanged(v)),
        ),
      ],
    );
  }

  Widget _nextButton({double? buttonRadius}) {
    return CustomButtonSmall(
      btnHeading: "Next",
      height: 45,
      borderRadius: BorderRadius.circular(buttonRadius ?? 5),
      onTap: () {
        if (_formKey.currentState!.validate()) {
          if (selectedPerson == null) {
            Utils.toastMessage("Please select Single or Multi Country");

            return;
          }
          if (currentStep == 1 && adults == 0) {
            Utils.toastMessage("At least 1 adult is required");
            return;
          }

          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
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

  Widget _bidInfoHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            btnColor.withOpacity(0.9),
            btnColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: btnColor.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Row(
            children: const [
              Icon(Icons.gavel, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                "Send Bid Enquiry",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Subtitle
          const Text(
            "Get multiple customized travel offers from verified experts.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 14),

          /// Benefits
          _bidBenefit("Competitive prices from multiple agents"),
          _bidBenefit("Customized itinerary as per your needs"),
          _bidBenefit("Compare bids & choose the best offer"),
          _bidBenefit("No obligation to book"),
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
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepHeader() {
    List<String> titles = ["Basics", "Travellers", "Confirm"];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🔹 Connecting Line
          Positioned(
            top: 20, // center of circle (40 / 2)
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
                      color: isCompleted ? Colors.green : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // 🔵 Step Circles + Titles
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
                          ? Colors.green
                          : isActive
                              ? btnColor
                              : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.2),
                              )
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

  /// 📌 Section Wrapper
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
            Text(title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff7B1E34),
                )),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
  // @override
  // Widget build(BuildContext context) {
  //   final status = context.watch<EnquiryViewModel>().sendEnquiryResponse.status;
  //   var countryList =
  //       context.watch<ThirdPartyViewModel>().getCountryListResponse.data;
  //   var stateList = context.watch<ThirdPartyViewModel>().stateList.data;
  //   var stateLoading =
  //       context.watch<ThirdPartyViewModel>().stateList.status == Status.loading;
  //   var currencyText =
  //       context.watch<ThirdPartyViewModel>().currencyList.data ?? '';
  //   var countriesLoading =
  //       context.read<ThirdPartyViewModel>().getCountryListResponse.status ==
  //           Status.loading;
  //   var regionCountryListByRegion =
  //       context.read<ThirdPartyViewModel>().getCountryListByRegion.data;
  //   return Scaffold(
  //     backgroundColor: bgGreyColor,
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(10),
  //       child: Form(
  //         key: _formKey,
  //         autovalidateMode: _autoValidateMode,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 Expanded(
  //                   // flex: 3,
  //                   child: RadioListTile<PersonType>(
  //                     dense: true,
  //                     visualDensity:
  //                         VisualDensity(horizontal: -4, vertical: -4),
  //                     title: Text(
  //                       "Single Country",
  //                       style: GoogleFonts.poppins(
  //                           fontWeight: FontWeight.w700, fontSize: 12),
  //                     ),
  //                     value: PersonType.single,
  //                     groupValue: selectedPerson,
  //                     onChanged: (value) => _onPersonTypeChanged(value!),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   // flex: 3,
  //                   child: RadioListTile<PersonType>(
  //                     dense: true,
  //                     visualDensity:
  //                         VisualDensity(horizontal: -4, vertical: -4),
  //                     title: Text(
  //                       "Multi Country",
  //                       style: GoogleFonts.poppins(
  //                           fontWeight: FontWeight.w700, fontSize: 12),
  //                     ),
  //                     value: PersonType.multi,
  //                     groupValue: selectedPerson,
  //                     onChanged: (value) => _onPersonTypeChanged(value!),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             _sectionCard(
  //               "Personal Info",
  //               Column(
  //                 children: [
  //                   Customtextformfield(
  //                     autovalidateMode: _autoValidateMode,
  //                     prefixIcon: const Icon(
  //                       Icons.person,
  //                       color: greyColor1,
  //                     ),
  //                     controller: fullNametController,
  //                     hintText: 'Full Name',
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter full name';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const SizedBox(height: 10),
  //                   if (selectedPerson == PersonType.single)
  //                     CustomDropdownButton(
  //                       itemsList: countryList ?? [],
  //                       hintText: 'Select Country',
  //                       controller: countryController,
  //                       onChanged: (value) {
  //                         if (value != null && value.isNotEmpty) {
  //                           _onCountryChanged(value);
  //                         }
  //                       },
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please select country';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   if (selectedPerson == PersonType.single)
  //                     const SizedBox(height: 10),
  //                   if (selectedPerson == PersonType.single)
  //                     CustomMultiselectDropdown(
  //                       key: _destinationKey,
  //                       autovalidateMode: _autoValidateMode,
  //                       title: 'Destination',
  //                       hintText: 'Select destintaion',
  //                       icon: Icons.location_on,
  //                       // items: destinations,
  //                       items: stateList ?? [],
  //                       isDisabled: countryController.text.isEmpty ||
  //                           stateLoading ||
  //                           (stateList ?? []).isEmpty,
  //                       onChanged: (p0) {
  //                         setState(() {
  //                           selectedDestinations = p0;
  //                         });
  //                       },
  //                       selectedItems: selectedDestinations,
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please select destination';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   if (selectedPerson == PersonType.multi)
  //                     CustomDropdownButton(
  //                       itemsList: regionCountryList,
  //                       hintText: 'Select Region',
  //                       controller: regionController,
  //                       onChanged: (value) {
  //                         if (value != null && value.isNotEmpty) {
  //                           _onCountryiesChanged(value);
  //                           // getCountryListByRegion();
  //                         }
  //                       },
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please select region';
  //                         }
  //                         return null;
  //                       },
  //                     ),
  //                   const SizedBox(height: 10),
  //                   if (selectedPerson == PersonType.multi)
  //                     CustomMultiselectDropdown(
  //                       key: _countriesKey,
  //                       autovalidateMode: _autoValidateMode,
  //                       title: 'Countries',
  //                       hintText: 'Select countries',
  //                       icon: Icons.location_on,
  //                       items: regionCountryListByRegion ?? [],
  //                       isDisabled: regionController.text.isEmpty ||
  //                           countriesLoading ||
  //                           (regionCountryListByRegion ?? []).isEmpty,
  //                       onChanged: (p0) {
  //                         setState(() {
  //                           selectedCountries = p0;
  //                         });
  //                       },
  //                       selectedItems: selectedCountries,
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please select countries';
  //                         }
  //                         return null;
  //                       },
  //                     )
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             _sectionCard(
  //               "Preferences",
  //               Column(
  //                 children: [
  //                   Customtextformfield(
  //                     autovalidateMode: _autoValidateMode,
  //                     prefixIcon: const Icon(
  //                       Icons.hotel,
  //                       color: greyColor1,
  //                     ),
  //                     controller: accommodationController,
  //                     hintText: 'Accommodation Preferences',
  //                     lable: 'Accommodation Preferences *',
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter accommodation preferences';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Customtextformfield(
  //                     autovalidateMode: _autoValidateMode,
  //                     prefixIcon: const Icon(
  //                       Icons.restaurant,
  //                       color: greyColor1,
  //                     ),
  //                     controller: mealsController,
  //                     hintText: 'Meals',
  //                     lable: 'Meals*',
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter meals';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Customtextformfield(
  //                     autovalidateMode: _autoValidateMode,
  //                     prefixIcon: const Icon(
  //                       Icons.directions_car,
  //                       color: greyColor1,
  //                     ),
  //                     controller: transpotationController,
  //                     hintText: 'Transportation',
  //                     lable: 'Transportation*',
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter transportation';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   const SizedBox(height: 10),
  //                   // CustomDropdownButton(itemsList: itemsList, hintText: hintText, controller: controller),
  //                   Customtextformfield(
  //                     autovalidateMode: _autoValidateMode,
  //                     // prefixIcon: const Icon(
  //                     //   Icons.attach_money,
  //                     //   color: greyColor1,
  //                     // ),
  //                     prefixIcon: Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 12, vertical: 14),
  //                       child: Text(
  //                         currencyText.isEmpty ? '' : currencyText,
  //                         style: TextStyle(
  //                             color: greyColor1, fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                     controller: budgetController,
  //                     hintText: 'Budget (in $currencyText)',
  //                     lable: 'Budget (in $currencyText) *',
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter budget( in $currencyText)';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             _sectionCard(
  //               "Travellers",
  //               Column(
  //                 children: [
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Expanded(
  //                         child: _travellerDropdown(
  //                           label: "Total Travelers *",
  //                           value: totalTravellers,
  //                           onChanged: (val) {
  //                             setState(() {
  //                               totalTravellers = val!;
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                       const SizedBox(width: 10),
  //                       Expanded(
  //                         child: _travellerDropdown(
  //                           label: "Adults *",
  //                           value: adults,
  //                           onChanged: (val) {
  //                             setState(() {
  //                               adults = val!;
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: _travellerDropdown(
  //                           label: "Senior",
  //                           value: seniors,
  //                           onChanged: (val) {
  //                             setState(() {
  //                               seniors = val!;
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                       const SizedBox(width: 10),
  //                       Expanded(
  //                         child: _travellerDropdown(
  //                           label: "Children",
  //                           value: children,
  //                           onChanged: (val) {
  //                             setState(() {
  //                               children = val!;
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 10),
  //                   _travellerDropdown(
  //                     label: "Infants",
  //                     value: infants,
  //                     onChanged: (val) {
  //                       setState(() {
  //                         infants = val!;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             _sectionCard(
  //               "Special Requests",
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Checkbox(
  //                         activeColor: btnColor,
  //                         value: hasSpecialRequest,
  //                         onChanged: (val) {
  //                           setState(() {
  //                             hasSpecialRequest = val ?? false;
  //                           });
  //                         },
  //                       ),
  //                       const Text("Do you have any special requests?"),
  //                     ],
  //                   ),
  //                   if (hasSpecialRequest)
  //                     Padding(
  //                         padding: const EdgeInsets.only(top: 8),
  //                         child: Customtextformfield(
  //                           autovalidateMode: _autoValidateMode,
  //                           maxLines: 3,
  //                           minLines: 3,
  //                           controller: specialRequestController,
  //                           hintText: 'Special Request',
  //                           validator: hasSpecialRequest
  //                               ? (value) {
  //                                   if (value == null || value.isEmpty) {
  //                                     return 'Please enter special request';
  //                                   }
  //                                   return null;
  //                                 }
  //                               : null,
  //                         )),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             _sectionCard(
  //               "Travel Selection",
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         color: curvePageColor,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Expanded(
  //                             child: InkWell(
  //                               borderRadius: BorderRadius.circular(20),
  //                               onTap: () {
  //                                 setState(() {
  //                                   selectedToggle = 0;
  //                                 });
  //                               },
  //                               child: Container(
  //                                 padding:
  //                                     const EdgeInsets.symmetric(vertical: 12),
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(20),
  //                                   color: selectedToggle == 0
  //                                       ? btnColor
  //                                       : Colors.transparent,
  //                                 ),
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   'Exact Dates',
  //                                   style: TextStyle(
  //                                     color: selectedToggle == 0
  //                                         ? Colors.white
  //                                         : Colors.black,
  //                                     fontWeight: FontWeight.w600,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: InkWell(
  //                               borderRadius: BorderRadius.circular(20),
  //                               onTap: () {
  //                                 setState(() {
  //                                   selectedToggle = 1;
  //                                 });
  //                               },
  //                               child: Container(
  //                                 padding:
  //                                     const EdgeInsets.symmetric(vertical: 12),
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(20),
  //                                   color: selectedToggle == 1
  //                                       ? btnColor
  //                                       : Colors.transparent,
  //                                 ),
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   'Tentative Duration',
  //                                   style: TextStyle(
  //                                     color: selectedToggle == 1
  //                                         ? Colors.white
  //                                         : Colors.black,
  //                                     fontWeight: FontWeight.w600,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),

  //                     const SizedBox(height: 16),

  //                     // If user selected Exact Dates
  //                     if (selectedToggle == 0)
  //                       TextFormField(
  //                         autovalidateMode: _autoValidateMode,
  //                         controller: dateController,
  //                         readOnly: true,
  //                         decoration: InputDecoration(
  //                           hintText: 'Select Your Travel Dates',
  //                           contentPadding: const EdgeInsets.symmetric(
  //                               horizontal: 10, vertical: 10),
  //                           focusedBorder: const OutlineInputBorder(
  //                               borderSide: BorderSide(color: greyColor1)),
  //                           border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(5)),
  //                           prefixIcon: const Icon(Icons.date_range,
  //                               color: Colors.grey),
  //                         ),
  //                         onTap: () async {
  //                           final selectedDate = await pickSfDateRange(context);
  //                           debugPrint('selected date $selectedDate');
  //                           if (selectedDate != null) {
  //                             dateController.text = selectedDate;
  //                           }
  //                         },
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Please select date';
  //                           }
  //                           return null;
  //                         },
  //                       ),

  //                     // If user selected Tentative Duration
  //                     if (selectedToggle == 1)
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           const Text(
  //                             "Please Select Your Tantative Dates and Days",
  //                             style: TextStyle(fontWeight: FontWeight.w500),
  //                           ),
  //                           SizedBox(height: 10),
  //                           TextField(
  //                             readOnly: true,
  //                             controller: tentetiveDateController,
  //                             decoration: InputDecoration(
  //                               hintText: 'Select Duration',
  //                               contentPadding: const EdgeInsets.symmetric(
  //                                   horizontal: 10, vertical: 10),
  //                               focusedBorder: const OutlineInputBorder(
  //                                   borderSide: BorderSide(color: greyColor1)),
  //                               border: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(5)),
  //                               prefixIcon:
  //                                   const Icon(Icons.timer, color: Colors.grey),
  //                             ),
  //                             onTap: () async {
  //                               final selectedDate = await showCustomDatePicker(
  //                                 context,
  //                                 initialDate:
  //                                     DateTime.now().add(Duration(days: 1)),
  //                                 firstDate:
  //                                     DateTime.now().add(Duration(days: 1)),
  //                                 lastDate: DateTime.now().add(
  //                                   const Duration(days: 90),
  //                                 ),
  //                               );
  //                               if (selectedDate != null) {
  //                                 tentetiveDateController.text =
  //                                     DateFormat('dd-MM-yyyy')
  //                                         .format(selectedDate);
  //                               }
  //                             },
  //                           ),
  //                           const SizedBox(height: 10),
  //                           Wrap(
  //                             spacing: 10,
  //                             children: durationOptions.map((days) {
  //                               final isSelected = selectedDuration == days;
  //                               return ChoiceChip(
  //                                 label: Text("± $days days"),
  //                                 checkmarkColor: background,
  //                                 selected: isSelected,
  //                                 onSelected: (_) {
  //                                   setState(() {
  //                                     selectedDuration = days;
  //                                   });
  //                                 },
  //                                 selectedColor: const Color(0xff7B1E34),
  //                                 backgroundColor: Colors.transparent,
  //                                 shape: StadiumBorder(
  //                                   side: BorderSide(
  //                                     color: isSelected
  //                                         ? const Color(0xff7B1E34)
  //                                         : Colors.grey.shade400,
  //                                   ),
  //                                 ),
  //                                 labelStyle: TextStyle(
  //                                   color: isSelected
  //                                       ? Colors.white
  //                                       : const Color(0xff7B1E34),
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                           const SizedBox(height: 10),
  //                           Text(
  //                             "Selected Duration: $selectedDuration day${selectedDuration > 1 ? 's' : ''}",
  //                             style: const TextStyle(
  //                                 color: Color(0xff7B1E34),
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             CustomButtonSmall(
  //               btnHeading: 'Send Now',
  //               loading: status == Status.loading,
  //               onTap: () {
  //                 setState(() {
  //                   _autoValidateMode = AutovalidateMode.onUserInteraction;
  //                 });
  //                 if (_formKey.currentState!.validate()) {
  //                   context
  //                       .read<EnquiryViewModel>()
  //                       .sendEnquiryApi(
  //                           fullName: fullNametController.text,
  //                           country: countryController.text,
  //                           currency: currencyText,
  //                           budget: budgetController.text,
  //                           destination: selectedDestinations,
  //                           accommodation: accommodationController.text,
  //                           meals: mealsController.text,
  //                           transportation: transpotationController.text,
  //                           specialRequest: hasSpecialRequest
  //                               ? specialRequestController.text
  //                               : "",
  //                           travelDate:
  //                               selectedToggle == 0 ? dateController.text : "",
  //                           tentativeDates: selectedToggle == 1
  //                               ? tentetiveDateController.text
  //                               : "",
  //                           tentativeDays: selectedToggle == 1
  //                               ? selectedDuration.toString()
  //                               : "")
  //                       .then((onValue) {
  //                     // _resetForm();

  //                     if (onValue == true) {
  //                       // ignore: use_build_context_synchronously
  //                       context.push('/my_enquiry').then((val) {
  //                         _resetForm();
  //                       });
  //                     }
  //                   });
  //                 }
  //               },
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _travellerDropdown({
  //   required String label,
  //   required int value,
  //   required ValueChanged<int?> onChanged,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       const SizedBox(height: 5),
  //       DropdownButtonFormField<int>(
  //         value: value,
  //         items: travellerCount
  //             .map(
  //               (e) => DropdownMenuItem<int>(
  //                 value: e,
  //                 child: Text(e.toString()),
  //               ),
  //             )
  //             .toList(),
  //         onChanged: onChanged,
  //         decoration: InputDecoration(
  //           contentPadding:
  //               const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //         ),
  //         validator: label.contains('*')
  //             ? (val) {
  //                 if (val == null || val == 0) {
  //                   return 'Required';
  //                 } else if (label == 'Total Travelers *') {
  //                   String travellerError = _validateTravellers();
  //                   if (travellerError.isNotEmpty) {
  //                     return travellerError;
  //                   }
  //                 }
  //                 return null;
  //               }
  //             : null,
  //       ),
  //     ],
  //   );
  // }
//   Widget _stepHeader() {
//     List<String> titles = ["Basics", "Preferences", "Confirm"];

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // 🔹 Connecting Line
//           Positioned(
//             top: 20, // center of circle (40 / 2)
//             left: 20,
//             right: 20,
//             child: Row(
//               children: List.generate(2, (index) {
//                 final isCompleted = currentStep > index;

//                 return Expanded(
//                   child: Container(
//                     height: 3,
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     decoration: BoxDecoration(
//                       color: isCompleted ? Colors.green : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),

//           // 🔵 Step Circles + Titles
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: List.generate(3, (index) {
//               final isActive = currentStep == index;
//               final isCompleted = currentStep > index;

//               return Column(
//                 children: [
//                   Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       color: isCompleted
//                           ? Colors.green
//                           : isActive
//                               ? btnColor
//                               : Colors.grey.shade300,
//                       shape: BoxShape.circle,
//                       boxShadow: isActive
//                           ? [
//                               BoxShadow(
//                                 blurRadius: 10,
//                                 color: Colors.black.withOpacity(0.2),
//                               )
//                             ]
//                           : [],
//                     ),
//                     child: Center(
//                       child: isCompleted
//                           ? const Icon(Icons.check,
//                               color: Colors.white, size: 20)
//                           : Text(
//                               "${index + 1}",
//                               style: TextStyle(
//                                 color: isActive
//                                     ? Colors.white
//                                     : Colors.grey.shade700,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     titles[index],
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight:
//                           isActive ? FontWeight.bold : FontWeight.normal,
//                       color: isActive ? Colors.black : Colors.grey,
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 📌 Section Wrapper
//   Widget _sectionCard(String title, Widget child) {
//     return Card(
//       color: background,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff7B1E34),
//                 )),
//             const SizedBox(height: 10),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
// }

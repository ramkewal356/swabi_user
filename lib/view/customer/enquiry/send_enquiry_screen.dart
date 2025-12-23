import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
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

enum PersonType { self, other }

PersonType selectedPerson = PersonType.self;

class _SendEnquiryScreenState extends State<SendEnquiryScreen> {
  int selectedToggle = 0; // 0 = Exact, 1 = Tentative
  int selectedDuration = 2;
  List<int> durationOptions = [1, 2, 3, 5, 7];
  bool hasSpecialRequest = false;
  Key _destinationKey = UniqueKey();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNametController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController specialRequestController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController tentetiveDateController = TextEditingController();

  TextEditingController accommodationController = TextEditingController();
  TextEditingController mealsController = TextEditingController();
  TextEditingController transpotationController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  // final GlobalKey<FormFieldState> _multiSelectKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefillSelfData();
      getCountry();
    });
  }

  void getCountry() {
    context.read<ThirdPartyViewModel>().getCountryList();
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

  void _onPersonTypeChanged(PersonType type) {
    setState(() {
      selectedPerson = type;

      if (type == PersonType.self) {
        _prefillSelfData();
      } else {
        fullNametController.clear();
        countryController.clear();
        selectedDestinations.clear();
      }
    });
  }

  void _prefillSelfData() {
    final data = context.read<UserProfileViewModel>().dataList.data?.data;
    if (data != null) {
      fullNametController.text = '${data.firstName} ${data.lastName}';
      countryController.text = data.country;
      stateController.text = data.state;
    }
    getCurrencyListApi(countryController.text);
  }

  void _resetForm() {
    _formKey.currentState!.reset();

    fullNametController.clear();
    specialRequestController.clear();
    dateController.clear();
    accommodationController.clear();
    mealsController.clear();
    transpotationController.clear();
    budgetController.clear();

    setState(() {
      selectedDestinations = [];
      selectedToggle = 0;
      selectedDuration = 2;
      hasSpecialRequest = false;
      _autoValidateMode = AutovalidateMode.disabled;
    });
    FocusScope.of(context).unfocus();
  }

  void _onCountryChanged(String value) {
    // Clear country text
    countryController.text = value;

    // Clear state & destination
    stateController.clear();
    selectedDestinations.clear();
    _destinationKey = UniqueKey();
    // Reset state list from Bloc (important)
    context.read<ThirdPartyViewModel>().clearStateList();

    // Fetch new data
    getStateListApi(value);
    getCurrencyListApi(value);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<EnquiryViewModel>().sendEnquiryResponse.status;
    var countryList =
        context.watch<ThirdPartyViewModel>().getCountryListResponse.data;
    var stateList = context.watch<ThirdPartyViewModel>().stateList.data;
    var stateLoading =
        context.watch<ThirdPartyViewModel>().stateList.status == Status.loading;
    var currencyText =
        context.watch<ThirdPartyViewModel>().currencyList.data ?? '';
    return Scaffold(
      backgroundColor: bgGreyColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child: RadioListTile<PersonType>(
                      dense: true,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      title: Text(
                        "Self",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      value: PersonType.self,
                      groupValue: selectedPerson,
                      onChanged: (value) => _onPersonTypeChanged(value!),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: RadioListTile<PersonType>(
                      dense: true,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      title: Text(
                        "Someone Else",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      value: PersonType.other,
                      groupValue: selectedPerson,
                      onChanged: (value) => _onPersonTypeChanged(value!),
                    ),
                  ),
                ],
              ),
              _sectionCard(
                "Personal Info",
                Column(
                  children: [
                    Customtextformfield(
                      autovalidateMode: _autoValidateMode,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: greyColor1,
                      ),
                      controller: fullNametController,
                      hintText: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownButton(
                      itemsList: countryList ?? [],
                      hintText: 'Select Country',
                      controller: countryController,
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty) {
                          _onCountryChanged(value);
                        }
                      },
                    ),
                    // Customtextformfield(
                    //     readOnly: true,
                    //     fillColor: background,
                    //     prefixIcon: const Icon(
                    //       Icons.flag,
                    //       color: Colors.grey,
                    //     ),
                    //     controller:
                    //         TextEditingController(text: 'United Arab Emirates'),
                    //     hintText: 'Select Country'),
                    const SizedBox(height: 10),
                    CustomMultiselectDropdown(
                      key: _destinationKey,
                      autovalidateMode: _autoValidateMode,
                      title: 'Destination',
                      hintText: 'Select destintaion',
                      icon: Icons.location_on,
                      // items: destinations,
                      items: stateList ?? [],
                      isDisabled: countryController.text.isEmpty ||
                          stateLoading ||
                          (stateList ?? []).isEmpty,
                      onChanged: (p0) {
                        setState(() {
                          selectedDestinations = p0;
                        });
                      },
                      selectedItems: selectedDestinations,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter destination';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                      // prefixIcon: const Icon(
                      //   Icons.attach_money,
                      //   color: greyColor1,
                      // ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        child: Text(
                          currencyText.isEmpty ? 'AED' : currencyText,
                          style: TextStyle(
                              color: greyColor1, fontWeight: FontWeight.bold),
                        ),
                      ),
                      controller: budgetController,
                      hintText: 'Budget (in $currencyText)',
                      lable: 'Budget (in $currencyText) *',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter budget( in AED)';
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                            prefixIcon: const Icon(Icons.date_range,
                                color: Colors.grey),
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
                            TextField(
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
                                  firstDate:
                                      DateTime.now().add(Duration(days: 1)),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 90),
                                  ),
                                );
                                if (selectedDate != null) {
                                  tentetiveDateController.text =
                                      DateFormat('dd-MM-yyyy')
                                          .format(selectedDate);
                                }
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
              const SizedBox(height: 15),
              CustomButtonSmall(
                btnHeading: 'Send Now',
                loading: status == Status.loading,
                onTap: () {
                  setState(() {
                    _autoValidateMode = AutovalidateMode.onUserInteraction;
                  });
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<EnquiryViewModel>()
                        .sendEnquiryApi(
                            fullName: fullNametController.text,
                            country: countryController.text,
                            currency: currencyText,
                            budget: budgetController.text,
                            destination: selectedDestinations,
                            accommodation: accommodationController.text,
                            meals: mealsController.text,
                            transportation: transpotationController.text,
                            specialRequest: hasSpecialRequest
                                ? specialRequestController.text
                                : "",
                            travelDate:
                                selectedToggle == 0 ? dateController.text : "",
                            tentativeDates: selectedToggle == 1
                                ? tentetiveDateController.text
                                : "",
                            tentativeDays: selectedToggle == 1
                                ? selectedDuration.toString()
                                : "")
                        .then((onValue) {
                      // _resetForm();

                      if (onValue == true) {
                        // ignore: use_build_context_synchronously
                        context.push('/my_enquiry').then((val) {
                          _resetForm();
                        });
                      }
                    });
                  }
                },
              )
            ],
          ),
        ),
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

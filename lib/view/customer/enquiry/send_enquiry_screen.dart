import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_multiselect_dropdown.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:provider/provider.dart';

class SendEnquiryScreen extends StatefulWidget {
  const SendEnquiryScreen({super.key});

  @override
  State<SendEnquiryScreen> createState() => _SendEnquiryScreenState();
}

class _SendEnquiryScreenState extends State<SendEnquiryScreen> {
  int selectedToggle = 0; // 0 = Exact, 1 = Tentative
  int selectedDuration = 2;
  List<int> durationOptions = [1, 2, 3, 5, 7];
  bool hasSpecialRequest = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNametController = TextEditingController();
  TextEditingController specialRequestController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController accommodationController = TextEditingController();
  TextEditingController mealsController = TextEditingController();
  TextEditingController transpotationController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  // final GlobalKey<FormFieldState> _multiSelectKey = GlobalKey();

  List<String> selectedDestinations = [];
  List<String> destinations = [
    'Abu Dhabi',
    'Ajman',
    'Dubai',
    'Fujairah',
    'Ras al-Khaimah',
    'Sharjah',
    'Umm al-Quwain',
  ];
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final viewModel = context.watch<EnquiryViewModel>();

  //   if (viewModel.sendEnquiryResponse.status == Status.completed) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _resetForm();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<EnquiryViewModel>().sendEnquiryResponse.status;
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
                    Customtextformfield(
                        readOnly: true,
                        fillColor: background,
                        prefixIcon: const Icon(
                          Icons.flag,
                          color: Colors.grey,
                        ),
                        controller:
                            TextEditingController(text: 'United Arab Emirates'),
                        hintText: 'Select Country'),
                    const SizedBox(height: 10),
                    CustomMultiselectDropdown(
                      autovalidateMode: _autoValidateMode,
                      title: 'Destination',
                      hintText: 'Select destintaion',
                      icon: Icons.location_on,
                      items: destinations,
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
                    Customtextformfield(
                      autovalidateMode: _autoValidateMode,
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: greyColor1,
                      ),
                      controller: budgetController,
                      hintText: 'Budget (in AED)',
                      lable: 'Budget (in AED) *',
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
                              dateController.text =
                                  selectedDate;
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
                              "How Long Do You Plan to Stay?",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: durationOptions.map((days) {
                                final isSelected = selectedDuration == days;
                                return ChoiceChip(
                                  label: Text("+$days days"),
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
                            country: 'United Arab Emirates',
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
                            tentativeDays: selectedToggle == 1
                                ? selectedDuration.toString()
                                : "")
                        .then((onValue) {
                      _resetForm();
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

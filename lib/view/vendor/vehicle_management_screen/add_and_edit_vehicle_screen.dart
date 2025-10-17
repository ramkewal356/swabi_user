import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:provider/provider.dart';

class AddAndEditVehicleScreen extends StatefulWidget {
  final bool isEdit;
  final String? vehicleId;
  const AddAndEditVehicleScreen(
      {super.key, this.isEdit = false, this.vehicleId});

  @override
  State<AddAndEditVehicleScreen> createState() =>
      _AddAndEditVehicleScreenState();
}

class _AddAndEditVehicleScreenState extends State<AddAndEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _existingOwnerController =
      TextEditingController();

  String _selectedOption = 'New Owner';
  String countryCode = '971';
  String country = 'United Arab Emirates';
  // 'India';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCountry();
    });
    _countryController.text = country;
  }

  String accessToken = '';
  void getCountry() async {
    try {
      context
          .read<GetCountryStateListViewModel>()
          .getStateList(context: context, country: country);
    } catch (e) {
      debugPrint('error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GetCountryStateListViewModel>().getStateNameModel;
    bool isLoadingState =
        context.watch<GetCountryStateListViewModel>().isLoading;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        backgroundColor: background,
        title:
            Text(widget.isEdit ? 'Edit Vehicle' : "Add New Owner And Vehicle"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      activeColor: btnColor,
                      value: 'New Owner',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                      title: Text(
                        'New Owner',
                        style: titleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      dense: true,
                      activeColor: btnColor,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      value: 'Existing Owner',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                      title: Text(
                        'Existing Owner',
                        style: titleTextStyle,
                      ),
                    ),
                  )
                ],
              ),
              _selectedOption == 'New Owner'
                  ? Card(
                      color: background,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Owner Details'),
                            lableText('First Name'),
                            Customtextformfield(
                              controller: _firstNameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^[\u0000-\u007F]*$'),
                                ),
                              ],
                              keyboardType: TextInputType.name,
                              fillColor: background,
                              hintText: 'Enter your first name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter first name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            lableText('Last Name'),
                            Customtextformfield(
                              controller: _lastNameController,
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^[\u0000-\u007F]*$'),
                                ),
                              ],
                              fillColor: background,
                              hintText: 'Enter your last name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            lableText('Email'),
                            Customtextformfield(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              fillColor: background,
                              hintText: 'xyz@gmail.com',
                            ),
                            const SizedBox(height: 10),
                            lableText('Country'),
                            Material(
                              child: Customtextformfield(
                                controller: _countryController,
                                readOnly: true,
                                enableInteractiveSelection: false,
                                // prefixiconvisible: true,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                // ],
                                fillColor: background,

                                hintText: 'Country',
                              ),
                            ),
                            const SizedBox(height: 10),
                            lableText('State'),
                            CustomDropdownButton(
                              controller: _stateController,

                              itemsList: state
                                      ?.map((stateName) => stateName)
                                      .toList() ??
                                  [],

                              // itemsList: [],
                              onChanged: isLoadingState
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _stateController.text = value ?? '';
                                        _locationController.clear();
                                      });
                                    },
                              hintText: 'Select State',

                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Please select state';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            lableText('Location'),
                            const SizedBox(height: 5),
                            CustomSearchLocation(
                                fillColor: background,
                                controller: _locationController,
                                state: _stateController.text,
                                // stateValidation: true,
                                hintText: 'Search your location'),
                            const SizedBox(height: 10),
                            lableText('Contact No'),
                            const SizedBox(height: 5),
                            CustomMobilenumber(
                                controller: _phoneController,
                                fillColor: background,
                                textLength: 9,
                                hintText: 'Enter phone number',
                                countryCode: countryCode),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )
                  : CustomDropdownButton(
                      itemsList: [],
                      controller: _existingOwnerController,
                      hintText: 'Select Owner',
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget lableText(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: title, style: titleTextStyle),
        const TextSpan(text: ' *', style: TextStyle(color: redColor))
      ])),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/validatorclass.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_phonefield.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
// import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/res/image_picker_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/utils/validation.dart';
import 'package:flutter_cab/view_model/driver_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class AddAndEditDriverScreen extends StatefulWidget {
  final bool isEdit;
  final String? driverId;
  const AddAndEditDriverScreen(
      {super.key, required this.isEdit, this.driverId});

  @override
  State<AddAndEditDriverScreen> createState() => _AddAndEditDriverScreenState();
}

class _AddAndEditDriverScreenState extends State<AddAndEditDriverScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emiratesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _licenceController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String countryCode = '971';
  // String countryCode = 'AE';
  List<String>? selectedDate;

  File? imagePath;
  String initialImage = '';
  String country = 'United Arab Emirates';
  @override
  void initState() {
    getDriverDetails();
    getCountry();
    super.initState();
    _countryController.text = country;
  }

  void getCountry() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GetCountryStateListViewModel>()
          .getStateList(context: context, country: country);
    });
  }

  void getDriverDetails() {
    if (widget.isEdit && widget.driverId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var vm = context.read<DriverViewModel>();
        // vm.getDriverByIdApi(driverId: widget.driverId!);
        vm.getDriverByIdApi(driverId: widget.driverId!).then((value) {
          var driverData = vm.getDriverById.data?.data;
          initialImage = driverData?.profileImageUrl ?? '';
          _firstNameController.text = driverData?.firstName ?? '';
          _lastNameController.text = driverData?.lastName ?? '';
          _emailController.text = driverData?.email ?? '';
          _emiratesController.text = driverData?.emiratesId ?? '';
          _stateController.text = driverData?.state ?? '';
          _locationController.text = driverData?.driverAddress ?? '';
          _licenceController.text = driverData?.licenceNumber ?? '';
          _statusController.text =
              (driverData?.driverStatus == 'TRUE') ? 'Active' : 'Inactive';
          _genderController.text = driverData?.gender ?? '';
          _phoneController.text = driverData?.mobile ?? '';
          countryCode = driverData?.countryCode ?? '971';
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var status = context.watch<DriverViewModel>().getDriverById.status;
    var state = context.watch<GetCountryStateListViewModel>().getStateNameModel;
    var addStatus = context.watch<DriverViewModel>().addEditDriver.status;

    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Driver' : 'Add Driver',
          style: appBarTitleStyle,
        ),
        backgroundColor: background,
      ),
      body: (status == Status.loading)
          ? const Center(
              child: CircularProgressIndicator(
                color: btnColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ImagePickerWidget(
                          initialImageUrl: initialImage,
                          isEditable: true,
                          onImageSelected: (file) {
                            setState(() {
                              imagePath = file;
                              debugPrint('Image Path: $imagePath');
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        height: 20,
                      ),
                      lableText('First Name'),
                      Customtextformfield(
                        controller: _firstNameController,
                        inputFormatters: [
                          // FilteringTextInputFormatter.allow(
                          //   RegExp(r'^[\u0000-\u007F]*$'),
                          // ),
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
                          // FilteringTextInputFormatter.allow(
                          //   RegExp(r'^[\u0000-\u007F]*$'),
                          // ),
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
                        validator: (p0) {
                          return Validatorclass.validateEmail(p0);
                        },
                      ),
                      const SizedBox(height: 10),
                      lableText('Emirates id'),
                      Customtextformfield(
                        controller: _emiratesController,
                        fillColor: background,
                        hintText: '784-YYYY-NNNNNNN-C',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Emirates ID';
                          } else if (!Validation().isValidEmiratesId(value)) {
                            return 'Enter a valid Emirates ID (e.g., 784-2000-9876543-2)';
                          }

                          return null; // valid
                        },
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

                        itemsList:
                            state?.map((stateName) => stateName).toList() ?? [],

                        // itemsList: [],
                        onChanged: (value) {
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
                      CustomSearchLocation(
                          fillColor: background,
                          controller: _locationController,
                          state: _stateController.text,
                          // stateValidation: true,
                          hintText: 'Search your location'),
                      const SizedBox(height: 10),
                      lableText('Licence No'),
                      Customtextformfield(
                        controller: _licenceController,
                        fillColor: background,
                        hintText: 'Enter licence number',
                        validator: (value) {
                          return Validatorclass().validateUaeLicence(value);
                        },
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter licence number';
                        //   }
                        //   return null;
                        // },
                      ),
                      const SizedBox(height: 10),
                      lableText('Status'),
                      CustomDropdownButton(
                        controller: _statusController,
                        itemsList: ['Active', 'Inactive'],
                        onChanged: (value) {},
                        hintText: 'Select Status',
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please select status';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      lableText('Gender'),
                      CustomDropdownButton(
                        controller: _genderController,
                        itemsList: ['Male', 'Female'],
                        onChanged: (value) {},
                        hintText: 'Select Gender',
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please select gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      lableText('Contact No'),
                      // CustomMobilenumber(
                      //     controller: _phoneController,
                      //     fillColor: background,
                      //     textLength: 9,
                      //     hintText: 'Enter phone number',
                      //     countryCode: countryCode),\
                      Customphonefield(
                        initalCountryCode: countryCode,
                        controller: _phoneController,
                        onChanged: (number) => {
                          debugPrint(
                              'Country Code: $countryCode, Number: ${number.number}')
                        },
                      ),
                      Visibility(
                        visible: widget.isEdit,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              'Select Unavailable Dates',
                              style: titleTextStyle,
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Please Select Unavailable Dates',
                                fillColor: background,
                                filled: true,
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
                                selectedDate =
                                    await selectMultipleSfDate(context);
                                debugPrint('selected date $selectedDate');
                                if (selectedDate != null) {
                                  _dateController.text =
                                      selectedDate?.join(',') ?? '';
                                }
                              },
                            ),
                            Row(
                              children: [
                                Text('● Unavailable dates |'),
                                Text(' ● Upcoming booking dates')
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButtonSmall(
                        loading: addStatus == Status.loading,
                        btnHeading:
                            widget.isEdit ? 'Update Driver' : 'Add Driver',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<DriverViewModel>()
                                .addEditDriverApi(
                                    isEdit: widget.isEdit,
                                    driverRequest: {
                                      if (widget.isEdit)
                                        "driverId": widget.driverId,
                                      "firstName": _firstNameController.text,
                                      "lastName": _lastNameController.text,
                                      "email": _emailController.text,
                                      "emiratesId": _emiratesController.text,
                                      "country": _countryController.text,
                                      "state": _stateController.text,
                                      "driverAddress": _locationController.text,
                                      "licenceNumber": _licenceController.text,
                                      "driverStatus":
                                          _statusController.text == 'Active'
                                              ? 'TRUE'
                                              : 'FALSE',
                                      "gender": _genderController.text,
                                      "countryCode": countryCode,
                                      "mobile": _phoneController.text,
                                      // "imagePath": imagePath,
                                      "notAvailableDates": selectedDate ?? []
                                    },
                                    selectedImageFile: imagePath)
                                .then((onValue) {
                              if (widget.isEdit) {
                                Utils.toastSuccessMessage(
                                    'Driver updated successfully');
                              } else {
                                Utils.toastSuccessMessage(
                                    'Driver added successfully');
                              }

                              // ignore: use_build_context_synchronously
                              Navigator.pop(context, true);
                            });
                          }
                        },
                      )
                    ],
                  ),
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

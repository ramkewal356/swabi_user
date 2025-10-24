import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/data/validatorclass.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_upload_widget.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/res/single_image_picker.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/vehicle_view_model.dart';
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
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carTypeController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _modelNoController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _vahicleNoController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  List<String> initialImages = [];
  List<File> selectedImages = [];
  String? selectedDocumentImage;
  String? selectedOwnerImage;

  String _selectedOption = 'New Owner';
  String countryCode = '971';
  String country = 'United Arab Emirates';
  String ownerId = '';
  String ownerName = '';
  String ownerEmail = '';
  String ownerImage = '';
  // 'India';
  final List<String> yearsList = List.generate(
    DateTime.now().year - 1990 + 1,
    (index) => (DateTime.now().year - index).toString(),
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCountry();
      if (widget.isEdit) {
        getVehicleById();
      }
      getColors();
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

  void getColors() {
    context.read<ThirdPartyViewModel>().getColors();
    context.read<VehicleViewModel>().getVehicleTypeApi();
    context.read<VehicleViewModel>().getVehicleBrandNameApi();
  }

  Future<void> getVehicleById() async {
    var vm = context.read<VehicleViewModel>();
    await vm.getVehicleByIdApi(vehicleId: widget.vehicleId ?? '');
    var data = vm.getVehicleDetails.data?.data;
    ownerId = data?.vehicleOwnerInfo?.vehicleOwnerId.toString() ?? '';
    ownerName =
        '${data?.vehicleOwnerInfo?.firstName} ${data?.vehicleOwnerInfo?.lastName}';
    ownerEmail = data?.vehicleOwnerInfo?.email ?? '';
    ownerImage = data?.vehicleOwnerInfo?.vehicleOwnerImageUrl ?? '';
    _carNameController.text = data?.carName ?? '';
    _carTypeController.text = data?.carType ?? '';
    _fuelTypeController.text = data?.fuelType ?? '';
    _modelNoController.text = data?.modelNo ?? '';
    _seatController.text = data?.seats.toString() ?? '';
    _yearController.text = data?.year.toString() ?? '';
    _colorController.text = data?.color ?? '';
    _brandNameController.text = data?.brandName ?? '';
    _vahicleNoController.text = data?.vehicleNumber ?? '';
    _statusController.text =
        data?.vehicleStatus == 'TRUE' ? 'Active' : 'Inactive';
    initialImages = data?.images ?? [];
    selectedDocumentImage = data?.vehicleDocUrl;
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GetCountryStateListViewModel>().getStateNameModel;
    bool isLoadingState =
        context.watch<GetCountryStateListViewModel>().isLoading;
    var colors = context.watch<ThirdPartyViewModel>().colors.data?.colors;
    var vehicleTypeList =
        context.watch<VehicleViewModel>().getAllVehicleType.data?.data;
    var vehicleBrandName =
        context.read<VehicleViewModel>().getVehicleBrandName.data?.data?.data;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
            widget.isEdit ? 'Update Vehicle' : "Add New Owner And Vehicle"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.isEdit
                    ? Card(
                        color: background,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Owner Details',
                                style: landingText,
                              ),
                              SizedBox(height: 10),
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 35,
                                  child: ownerImage.isEmpty
                                      ? Icon(Icons.person)
                                      : Image.network(ownerImage),
                                ),
                                horizontalTitleGap: 10,
                                contentPadding: EdgeInsets.zero,
                                title: Text('$ownerName ($ownerId)'),
                                subtitle: Text(ownerEmail),
                              )
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Owner Details',
                                          style: landingText,
                                        ),
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
                                            if (value == null ||
                                                value.isEmpty) {
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter last name';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        lableText('Email'),
                                        Customtextformfield(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: _emailController,
                                          fillColor: background,
                                          hintText: 'xyz@gmail.com',
                                          validator: (p0) {
                                            return Validatorclass.validateEmail(
                                                p0);
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

                                          itemsList: state
                                                  ?.map(
                                                      (stateName) => stateName)
                                                  .toList() ??
                                              [],

                                          // itemsList: [],
                                          onChanged: isLoadingState
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    _stateController.text =
                                                        value ?? '';
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
                                        lableText('Contact No'),
                                        CustomMobilenumber(
                                            controller: _phoneController,
                                            fillColor: background,
                                            textLength: 9,
                                            hintText: 'Enter phone number',
                                            countryCode: countryCode),
                                        const SizedBox(height: 10),
                                        lableText('Upload Owner Image'),
                                        FormField<File>(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          builder: (field) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SingleImagePicker(
                                                  initialImageUrl:
                                                      selectedOwnerImage,
                                                  noteText:
                                                      '* For the best viewing experience, please upload an image with a resolution of 1080x1350 pixels.',
                                                  onImageSelected: (file) {
                                                    setState(() {
                                                      selectedOwnerImage =
                                                          file?.path;
                                                    });
                                                    field.didChange(file);
                                                    debugPrint(
                                                        'Selected image: ${file?.path}');
                                                  },
                                                ),
                                                if (field.hasError)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5, left: 10),
                                                    child: Text(
                                                      field.errorText ?? '',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.red[700],
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select image';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Card(
                                  color: background,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        lableText('Select Existing Owner'),
                                        SizedBox(height: 5),
                                        CustomDropdownButton(
                                          itemsList: ['vnbvnv', 'hggjhhj'],
                                          controller: _existingOwnerController,
                                          hintText: 'Select Owner',
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                SizedBox(height: 10),
                Card(
                  color: background,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Details',
                          style: landingText,
                        ),
                        SizedBox(height: 10),
                        lableText('Car Name'),
                        Customtextformfield(
                          controller: _carNameController,
                          fillColor: background,
                          hintText: 'Enter car name',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter car name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Car Type'),
                        CustomDropdownButton(
                          itemsList: vehicleTypeList
                                  ?.map((toElement) => toElement)
                                  .toList() ??
                              [],
                          controller: _carTypeController,
                          hintText: 'Select Car Type',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select car type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Fuel Type'),
                        CustomDropdownButton(
                          itemsList: ['Diesel', 'Petrol', 'CNG', "EV"],
                          controller: _fuelTypeController,
                          hintText: 'Select Fuel Type',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select fuel type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Model No'),
                        Customtextformfield(
                          controller: _modelNoController,
                          fillColor: background,
                          hintText: 'Enter Model No',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter model no';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Seats'),
                        CustomDropdownButton(
                          itemsList: List.generate(
                            8,
                            (index) {
                              return (index + 2).toString();
                            },
                          ),
                          controller: _seatController,
                          hintText: 'Select Seats',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select seats';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Years'),
                        CustomDropdownButton(
                          itemsList: yearsList,
                          controller: _yearController,
                          hintText: 'Select Years',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select year';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Colors'),
                        CustomDropdownButton(
                          itemsList: colors
                                  ?.map(
                                      (toElement) => toElement.name.toString())
                                  .toList() ??
                              [],
                          controller: _colorController,
                          hintText: 'Select Color',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select color';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Brand Name'),
                        CustomDropdownButton(
                          itemsList: vehicleBrandName
                                  ?.map(
                                      (toElement) => toElement.name.toString())
                                  .toList() ??
                              [],
                          controller: _brandNameController,
                          hintText: 'Select Brand Name',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select brand name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        lableText('Vehicle No'),
                        Customtextformfield(
                          controller: _vahicleNoController,
                          fillColor: background,
                          hintText: 'Enter Vehicle No',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter vehicle no';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Status'),
                        CustomDropdownButton(
                          itemsList: ['Active', 'Inactive'],
                          controller: _statusController,
                          hintText: 'Select status',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select status';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Upload Vehicle Document Image'),
                        FormField<File>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder: (field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleImagePicker(
                                  initialImageUrl: selectedDocumentImage,
                                  noteText:
                                      '* For the best viewing experience, please upload an image with a resolution of 1080x1350 pixels.',
                                  onImageSelected: (file) {
                                    setState(() {
                                      selectedDocumentImage = file?.path;
                                    });
                                    field.didChange(file);
                                    debugPrint(
                                        'Selected image: $selectedDocumentImage');
                                  },
                                ),
                                if (field.hasError)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 10),
                                    child: Text(
                                      field.errorText ?? '',
                                      style: TextStyle(
                                          color: Colors.red[700], fontSize: 12),
                                    ),
                                  ),
                              ],
                            );
                          },
                          validator: (value) {
                            if (value == null ||
                                (selectedDocumentImage ?? '').isEmpty) {
                              return 'Please select image';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        lableText('Upload Vehicle Images'),
                        FormField<List<File>>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder: (field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MultiImageUploadWidget(
                                  initialImageUrls: initialImages,
                                  onImagesSelected: (images) {
                                    setState(() {
                                      selectedImages = images;
                                    });
                                    field.didChange(images);
                                  },
                                ),
                                if (field.hasError)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 10),
                                    child: Text(
                                      field.errorText ?? '',
                                      style: TextStyle(
                                          color: Colors.red[700], fontSize: 12),
                                    ),
                                  ),
                              ],
                            );
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                initialImages.isEmpty) {
                              return 'Please select images';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "* File should be less than 1 MB\n* For the best viewing experience, please upload an image with a resolution of 1280x720 pixels.",
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomButtonSmall(
                  btnHeading: widget.isEdit ? 'Update Vehicle' : "Add Vehicle",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
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

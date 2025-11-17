// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/core/utils/validatorclass.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/Custom%20Widgets/multi_image_upload_widget.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/res/single_image_picker.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:flutter_cab/view_model/vehicle_owner_view_model.dart';
import 'package:flutter_cab/view_model/vehicle_view_model.dart';
import 'package:provider/provider.dart';

class AddAndEditVehicleScreen extends StatefulWidget {
  final bool isEdit;
  final String? vehicleId;
  final String? ownerId;
  final String? actionByOwner;
  const AddAndEditVehicleScreen(
      {super.key,
      this.isEdit = false,
      this.vehicleId,
      this.ownerId,
      this.actionByOwner});

  @override
  State<AddAndEditVehicleScreen> createState() =>
      _AddAndEditVehicleScreenState();
}

class _AddAndEditVehicleScreenState extends State<AddAndEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emiratesController = TextEditingController();

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
  String? initialDocumentImage;

  String? selectedDocumentImage;
  String? initialOwnerImage;
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
      } else {
        if (widget.actionByOwner == 'edit owner') {
          getVehicleOwnerById();
          // _selectedOption = 'Existing Owner';
        }
      }
      getColors();
    });
    ownerId = widget.ownerId ?? '';
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

  void getVehicleOwnerList() {
    context.read<VehicleOwnerViewModel>().getVehicleOwnerListApi(
        isFilter: true,
        filterText: 'true',
        isSearch: true,
        searchText: '',
        isPagination: false,
        pageNumber1: -1,
        pageSize1: -1);
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
    _statusController.text = data?.vehicleStatus == 'TRUE'
        ? 'Active'
        : data?.vehicleStatus == 'FALSE'
            ? 'Inactive'
            : "";
    initialImages = data?.images ?? [];
    initialDocumentImage = data?.vehicleDocUrl ?? '';
  }

  Future<void> getVehicleOwnerById() async {
    if (ownerId.isEmpty) return;
    var vom = context.read<VehicleOwnerViewModel>();
    await vom.getVehicleOwnerByIdApi(ownerId: ownerId);
    var data = vom.vehicleOwnerById.data?.data;

    _firstNameController.text = data?.firstName ?? '';
    _lastNameController.text = data?.lastName ?? '';
    _emailController.text = data?.email ?? '';
    _emiratesController.text = data?.emiratesId ?? '';
    _countryController.text = data?.country ?? '';
    _stateController.text = data?.state ?? '';
    _locationController.text = data?.address ?? '';
    _phoneController.text = data?.mobile ?? '';
    initialOwnerImage = data?.vehicleOwnerImageUrl ?? '';
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
        context.watch<VehicleViewModel>().getVehicleBrandName.data?.data?.data;
    var vehicleOwnerList =
        context.watch<VehicleOwnerViewModel>().getVehicleOwnerList.data;
    var status = context.watch<VehicleViewModel>().addOrUpdateVehicle.status;
    var loadingStatus =
        context.watch<VehicleViewModel>().getVehicleDetails.status;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(widget.isEdit
            ? 'Update Vehicle'
            : widget.actionByOwner == 'edit owner'
                ? 'Edit Owner'
                : widget.actionByOwner == 'add vehicle'
                    ? 'Add Vehicle'
                      : "Add New Owner And Vehicle",
          style: appBarTitleStyle,
        ),
      ),
      body: loadingStatus == Status.loading
          ? Center(
              child: CircularProgressIndicator(
              color: greenColor,
            ))
          : Form(
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
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: ownerImage.isNotEmpty
                                            ? NetworkImage(ownerImage)
                                            : null,
                                        child: ownerImage.isEmpty
                                            ? const Icon(Icons.person,
                                                size: 35, color: Colors.grey)
                                            : null,
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
                                (widget.actionByOwner == 'edit owner' ||
                                        widget.actionByOwner == 'add vehicle')
                                    ? SizedBox()
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: RadioListTile(
                                              dense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 0),
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
                                                  EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              value: 'Existing Owner',
                                              groupValue: _selectedOption,
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedOption = value!;
                                                  selectedOwnerImage = null;
                                                });
                                                getVehicleOwnerList();
                                              },
                                              title: Text(
                                                'Existing Owner',
                                                style: titleTextStyle,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                (widget.actionByOwner == 'add vehicle')
                                    ? SizedBox()
                                    : _selectedOption == 'New Owner'
                                        ? Card(
                                            color: background,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                    controller:
                                                        _firstNameController,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                        RegExp(
                                                            r'^[\u0000-\u007F]*$'),
                                                      ),
                                                    ],
                                                    keyboardType:
                                                        TextInputType.name,
                                                    fillColor: background,
                                                    hintText:
                                                        'Enter your first name',
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
                                                    controller:
                                                        _lastNameController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                        RegExp(
                                                            r'^[\u0000-\u007F]*$'),
                                                      ),
                                                    ],
                                                    fillColor: background,
                                                    hintText:
                                                        'Enter your last name',
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
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    controller:
                                                        _emailController,
                                                    fillColor: background,
                                                    hintText: 'xyz@gmail.com',
                                                    validator: (p0) {
                                                      return Validatorclass
                                                          .validateEmail(p0);
                                                    },
                                                  ),
                                                  const SizedBox(height: 10),
                                                  lableText('Emirates id'),
                                                  Customtextformfield(
                                                    controller:
                                                        _emiratesController,
                                                    fillColor: background,
                                                    hintText:
                                                        '784-YYYY-NNNNNNN-C',
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter Emirates ID';
                                                      } else if (!Validation()
                                                          .isValidEmiratesId(
                                                              value)) {
                                                        return 'Enter a valid Emirates ID (e.g., 784-2000-9876543-2)';
                                                      }

                                                      return null; // valid
                                                    },
                                                  ),
                                                  const SizedBox(height: 10),
                                                  lableText('Country'),
                                                  Material(
                                                    child: Customtextformfield(
                                                      controller:
                                                          _countryController,
                                                      readOnly: true,
                                                      enableInteractiveSelection:
                                                          false,
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
                                                    controller:
                                                        _stateController,

                                                    itemsList: state
                                                            ?.map((stateName) =>
                                                                stateName)
                                                            .toList() ??
                                                        [],

                                                    // itemsList: [],
                                                    onChanged: isLoadingState
                                                        ? null
                                                        : (value) {
                                                            setState(() {
                                                              _stateController
                                                                      .text =
                                                                  value ?? '';
                                                              _locationController
                                                                  .clear();
                                                            });
                                                          },
                                                    hintText: 'Select State',

                                                    validator: (p0) {
                                                      if (p0 == null ||
                                                          p0.isEmpty) {
                                                        return 'Please select state';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const SizedBox(height: 10),
                                                  lableText('Location'),
                                                  CustomSearchLocation(
                                                      fillColor: background,
                                                      controller:
                                                          _locationController,
                                                      state:
                                                          _stateController.text,
                                                      // stateValidation: true,
                                                      hintText:
                                                          'Search your location'),
                                                  const SizedBox(height: 10),
                                                  lableText('Contact No'),
                                                  CustomMobilenumber(
                                                      controller:
                                                          _phoneController,
                                                      fillColor: background,
                                                      textLength: 9,
                                                      hintText:
                                                          'Enter phone number',
                                                      countryCode: countryCode),
                                                  const SizedBox(height: 10),
                                                  lableText(
                                                      'Upload Owner Image'),
                                                  FormField<String>(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    initialValue:
                                                        initialOwnerImage,
                                                    builder: (field) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SingleImagePicker(
                                                            initialImageUrl:
                                                                initialOwnerImage,
                                                            noteText:
                                                                '* For the best viewing experience, please upload an image with a resolution of 1080x1350 pixels.',
                                                            onImageSelected:
                                                                (file) {
                                                              setState(() {
                                                                selectedOwnerImage =
                                                                    file?.path;
                                                              });
                                                              field.didChange(
                                                                  file?.path);
                                                              debugPrint(
                                                                  'Selected image: ${file?.path}');
                                                            },
                                                          ),
                                                          if (field.hasError)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 5,
                                                                      left: 10),
                                                              child: Text(
                                                                field.errorText ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .red[
                                                                        700],
                                                                    fontSize:
                                                                        12),
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
                                            ))
                                        : Card(
                                            color: background,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  lableText(
                                                      'Select Existing Owner'),
                                                  SizedBox(height: 5),
                                                  CustomDropdownButton(
                                                    itemsList: vehicleOwnerList
                                                            ?.map((toElement) =>
                                                                '${toElement.firstName} ${toElement.lastName}')
                                                            .toList() ??
                                                        [],
                                                    controller:
                                                        _existingOwnerController,
                                                    hintText: 'Select Owner',
                                                    onChanged: (p0) {
                                                      setState(() {
                                                        // Find the matching owner object safely
                                                        final matching =
                                                            vehicleOwnerList
                                                                ?.where((owner) =>
                                                                    '${owner.firstName} ${owner.lastName}' ==
                                                                    p0);
                                                        final selectedOwner =
                                                            (matching != null &&
                                                                    matching
                                                                        .isNotEmpty)
                                                                ? matching.first
                                                                : null;

                                                        // Set the ownerId safely
                                                        ownerId = selectedOwner
                                                                ?.vehicleOwnerId
                                                                ?.toString() ??
                                                            '';
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                              ],
                            ),
                      SizedBox(height: 10),
                      widget.actionByOwner == 'edit owner'
                          ? SizedBox()
                          : Card(
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
                                      itemsList: [
                                        'Diesel',
                                        'Petrol',
                                        'CNG',
                                        "EV"
                                      ],
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
                                        } else if (!Validation()
                                            .isValidVehicleModelNo(p0)) {
                                          return 'Invalid model number (e.g. CAMRY2023)';
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
                                              ?.map((toElement) =>
                                                  toElement.name.toString())
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
                                              ?.map((toElement) =>
                                                  toElement.name.toString())
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
                                        } else if (!Validation()
                                            .isValidUaeVehicleNumber(p0)) {
                                          return 'Invalid UAE vehicle number (e.g. A 12345)';
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
                                    FormField<String>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      initialValue: initialDocumentImage,
                                      builder: (field) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SingleImagePicker(
                                              initialImageUrl:
                                                  initialDocumentImage,
                                              noteText:
                                                  '* For the best viewing experience, please upload an image with a resolution of 1080x1350 pixels.',
                                              onImageSelected: (file) {
                                                setState(() {
                                                  selectedDocumentImage =
                                                      file?.path;
                                                });
                                                field.didChange(file?.path);
                                                debugPrint(
                                                    'Selected image: $selectedDocumentImage');
                                              },
                                            ),
                                            if (field.hasError)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, left: 10),
                                                child: Text(
                                                  field.errorText ?? '',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 12),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select image';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    lableText('Upload Vehicle Images'),
                                    FormField<List<File>>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      builder: (field) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                padding: const EdgeInsets.only(
                                                    top: 5, left: 10),
                                                child: Text(
                                                  field.errorText ?? '',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 12),
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
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      SizedBox(height: 10),
                      CustomButtonSmall(
                        loading: status == Status.loading,
                        btnHeading: widget.isEdit
                            ? 'Update Vehicle'
                            : widget.actionByOwner == 'edit owner'
                                ? 'Update Owner'
                                : widget.actionByOwner == 'add vehicle'
                                    ? 'Add Vehicle'
                                    : _selectedOption == 'New Owner'
                                        ? "Add New Owner And Vehicle"
                                        : "Add Vehicle",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            final payload = await buildVehiclePayload(
                              isEdit: widget.isEdit,
                              actionByOwner: widget.actionByOwner ?? '',
                              selectedOption: _selectedOption,
                              selectedImages: selectedImages,
                              initialImages: initialImages,
                              initialOwnerImage: initialOwnerImage,
                              selectedOwnerImage: selectedOwnerImage,
                              selectedDocumentImage: selectedDocumentImage,
                              ownerId: ownerId,
                              countryCode: countryCode,
                              c: {
                                'vehicleId': TextEditingController(
                                    text: widget.vehicleId?.toString()),
                                'carType': _carTypeController,
                                'brandName': _brandNameController,
                                'fuelType': _fuelTypeController,
                                'seats': _seatController,
                                'color': _colorController,
                                'carName': _carNameController,
                                'vehicleNumber': _vahicleNoController,
                                'modelNo': _modelNoController,
                                'year': _yearController,
                                'status': _statusController,
                                'firstName': _firstNameController,
                                'lastName': _lastNameController,
                                'country': _countryController,
                                'state': _stateController,
                                'address': _locationController,
                                'emiratesId': _emiratesController,
                                'email': _emailController,
                                'mobile': _phoneController,
                              },
                            );

                            debugPrint('🚀 Payload: $payload');
                            if (widget.actionByOwner == 'edit owner' &&
                                !widget.isEdit) {
                              context
                                  .read<VehicleOwnerViewModel>()
                                  .updateVehicleOwnerApi(
                                    context: context,
                                    body: payload,
                                  );
                            } else {
                              context
                                  .read<VehicleViewModel>()
                                  .addOrUpdateVehicleApi(
                                    context: context,
                                    body: payload,
                                    isEdit: widget.isEdit,
                                  );
                            }
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

  Future<Map<String, dynamic>> buildVehiclePayload({
    required bool isEdit,
    required String actionByOwner,
    required String selectedOption,
    required List<File> selectedImages,
    required List initialImages,
    required String? initialOwnerImage,
    required String? selectedOwnerImage,
    required String? selectedDocumentImage,
    required String ownerId,
    required String countryCode,
    required Map<String, TextEditingController> c,
  }) async {
    final vendorId = await UserViewModel().getUserId();

    // Convert images to multipart
    final images = await Future.wait(selectedImages
        .where((img) => img.existsSync())
        .map((img) async => await MultipartFile.fromFile(
              img.path,
              filename: img.path.split('/').last,
            )));
    // If editing owner only (not vehicle)
    if (actionByOwner == 'edit owner') {
      final req = {
        "firstName": c['firstName']?.text.trim(),
        "lastName": c['lastName']?.text.trim(),
        "country": c['country']?.text.trim(),
        "state": c['state']?.text.trim(),
        "city": "",
        "address": c['address']?.text.trim(),
        "mobile": c['mobile']?.text.trim(),
        "email": c['email']?.text.trim(),
        "emiratesId": c['emiratesId']?.text.trim(),
        "vehicleOwnerId": int.tryParse(ownerId),
        "countryCode": countryCode,
        "vehicleOwnerImageUrl": initialOwnerImage,
      };

      final Map<String, dynamic> payload = {
        "vehicleRequest": jsonEncode(req),
      };

      if (selectedOwnerImage != null) {
        payload["image"] = await MultipartFile.fromFile(
          selectedOwnerImage,
          filename: selectedOwnerImage.split('/').last,
        );
      }

      return payload;
    }

    // Base request
    final req = {
      if (isEdit) "vehicleId": c['vehicleId']?.text,
      "carType": c['carType']?.text.trim(),
      "brandName": c['brandName']?.text.trim(),
      "fuelType": c['fuelType']?.text.trim(),
      "seats": int.tryParse(c['seats']?.text.trim() ?? '') ?? 0,
      "color": c['color']?.text.trim(),
      "carName": c['carName']?.text.trim(),
      "vehicleNumber": c['vehicleNumber']?.text.trim(),
      "modelNo": c['modelNo']?.text.trim(),
      "year": int.tryParse(c['year']?.text.trim() ?? '') ?? 0,
      "vendorId": vendorId,
      "vehicleStatus": c['status']?.text == 'Active' ? "TRUE" : "FALSE",
    };

    // Conditional fields
    if (isEdit) {
      req.addAll({
        "images": initialImages,
        "vehicleUnavailableReason": null,
        "notAvailableDates": [],
        "vehicleOwnerId": int.tryParse(ownerId),
      });
    } else if (selectedOption == 'New Owner' &&
        actionByOwner != 'add vehicle') {
      req.addAll({
        "firstName": c['firstName']?.text.trim(),
        "lastName": c['lastName']?.text.trim(),
        "country": c['country']?.text.trim(),
        "state": c['state']?.text.trim(),
        "city": "",
        "address": c['address']?.text.trim(),
        "emiratesId": c['emiratesId']?.text.trim(),
        "email": c['email']?.text.trim(),
        "mobile": c['mobile']?.text.trim(),
        "countryCode": countryCode,
      });
    } else {
      req["vehicleOwnerId"] = int.tryParse(ownerId);
    }

    // Final payload
    final Map<String, dynamic> payload = {
      "vehicleRequest": jsonEncode(req),
      "images": images,
    };

    if (selectedOwnerImage != null && selectedOwnerImage.isNotEmpty) {
      payload["vehicleOwnerImage"] = await MultipartFile.fromFile(
        selectedOwnerImage,
        filename: selectedOwnerImage.split('/').last,
      );
    }
    if (selectedDocumentImage != null && selectedDocumentImage.isNotEmpty) {
      payload["vehicleDocument"] = await MultipartFile.fromFile(
        selectedDocumentImage,
        filename: selectedDocumentImage.split('/').last,
      );
    }

    return payload;
  }
}

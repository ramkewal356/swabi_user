// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/response/status.dart';

import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_multiselect_dropdown.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_lable_text.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/multi_image_upload_widget.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:flutter_cab/view_model/activity_management_view_model.dart';
import 'package:flutter_cab/view_model/home_page_view_model.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class AddAndEditActivityScreen extends StatefulWidget {
  final bool isEdit;
  final String? activityId;
  const AddAndEditActivityScreen(
      {super.key, this.isEdit = false, this.activityId});

  @override
  State<AddAndEditActivityScreen> createState() =>
      _AddAndEditActivityScreenState();
}

class _AddAndEditActivityScreenState extends State<AddAndEditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _seniorDiscountController =
      TextEditingController();
  final TextEditingController _childDiscountController =
      TextEditingController();
  final TextEditingController _infantDiscountController =
      TextEditingController();
  final TextEditingController _visitfromHoursController =
      TextEditingController();
  final TextEditingController _visitfromminsController =
      TextEditingController();
  final TextEditingController _visitToHoursController = TextEditingController();
  final TextEditingController _visitToMinsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _activityHourController = TextEditingController();
  final TextEditingController _activityPriceController =
      TextEditingController();
  final TextEditingController _bestTimeToVisitController =
      TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _activityCategoryController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String countryName = 'United Arab Emirates';
  List<String> selectedSuitableFor = [];

  List<String>? selectedDate = [];
  List<String>? selectedWeeklyOff = [];
  List<String> initialImages = [];
  List<File> selectedImages = [];
  String offerId = '';
  List<String> destinations = [
    'SENIOR',
    'ADULT',
    'CHILD',
    'INFANT',
  ];
  List<String> weeklyOffList = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final activityHours = [
    "1 hours",
    "2 hours",
    "3 hours",
    "4 hours",
    "5 hours",
    "6 hours"
  ];
  final bestTimeToVisitList = [
    "Spring",
    "Summer",
    "Monsoon",
    "Autumn",
    "Pre-Winter",
    "Winter"
  ];
  final discountOptions = [
    "No discount",
    "Free",
    "5 %",
    "10 %",
    "15 %",
    "20 %",
    "25 %",
    "30 %",
    "35 %",
    "40 %",
    "45 %",
    "50 %",
    "55 %",
    "60 %",
    "65 %",
    "70 %",
    "75 %",
    "80 %"
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      getData();
      if (widget.isEdit) {
        getActivityById();
      }
    });
  }

  void getData() {
    context
        .read<GetCountryStateListViewModel>()
        .getStateList(context: context, country: countryName);
    context
        .read<GetActivityCategoryListViewModel>()
        .getActivityCategoryListApi();
    context.read<OfferViewModel>().getActivityOfferApi();
  }

  void getActivityById() async {
    var vm = context.read<ActivityManagementViewModel>();
    await vm.getActivityByIdApi(activityId: widget.activityId ?? '');
    final activity = vm.getActivityById.data?.data;
    if (activity != null) {
      final startParts = activity.startTime?.split(":"); // ["01", "00"]
      final endParts = activity.endTime?.split(":"); // ["23", "00"]
      _stateController.text = activity.state ?? '';
      _locationNameController.text = activity.address ?? '';
      _activityNameController.text = activity.activityName ?? '';
      _activityHourController.text =
          mapApiHoursToDropdown(activity.activityHours.toString());
      _activityPriceController.text = activity.activityPrice.toString();
      selectedSuitableFor = activity.participantType ?? [];
      _bestTimeToVisitController.text = activity.bestTimeToVisit ?? '';
      _visitfromHoursController.text = startParts?[0] ?? '';
      _visitfromminsController.text = startParts?[1] ?? '';
      _visitToHoursController.text = endParts?[0] ?? '';
      _visitToMinsController.text = endParts?[1] ?? '';
      selectedDate = activity.activityReligiousOffDates
              ?.map((e) => e.religiousOffDate.toString())
              .toList() ??
          [];
      dateController.text = selectedDate?.join(', ') ?? '';
      _offerController.text =
          activity.activityOfferMapping?.offer?.offerName ?? '';
      selectedWeeklyOff = activity.weeklyOff ?? [];
      _activityCategoryController.text = activity.activityCategory ?? '';
      _descriptionController.text = activity.description ?? '';
      initialImages = activity.activityImageUrl ?? [];
      _childDiscountController.text =
          mapDoubleToDiscount(activity.ageGroupDiscountPercent?.child)
              .toString();

      _infantDiscountController.text =
          mapDoubleToDiscount(activity.ageGroupDiscountPercent?.infant)
              .toString();
      _seniorDiscountController.text =
          mapDoubleToDiscount(activity.ageGroupDiscountPercent?.senior)
              .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GetCountryStateListViewModel>().getStateNameModel;
    var activityCategoryList = context
        .watch<GetActivityCategoryListViewModel>()
        .getActivityList
        .data
        ?.data;
    var activityOffer =
        context.watch<OfferViewModel>().getActivityOffer.data?.data;
    final statusById =
        context.watch<ActivityManagementViewModel>().getActivityById.status;
    final isLoading =
        context.watch<ActivityManagementViewModel>().addEditActivity.status ==
            Status.loading;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(widget.isEdit ? 'Edit Activity' : "Add New Activity"),
      ),
      body: statusById == Status.loading
          ? Center(
              child: CircularProgressIndicator(color: greenColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomLableText(lable: 'Country'),
                      Customtextformfield(
                          readOnly: true,
                          fillColor: background,
                          controller: TextEditingController(text: countryName),
                          hintText: 'Country'),
                      const SizedBox(height: 10),
                      CustomLableText(lable: 'State'),
                      CustomDropdownButton(
                        isEditable: true,
                        controller: _stateController,
                        itemsList:
                            state?.map((stateName) => stateName).toList() ?? [],
                        onChanged: (value) {
                          setState(() {
                            _stateController.text = value ?? '';
                            _locationNameController.clear();
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
                      CustomLableText(lable: 'Location'),
                      CustomSearchLocation(
                        fillColor: background,
                        controller: _locationNameController,
                        state: _stateController.text,
                        // stateValidation: true,
                        hintText: 'Search location',
                      ),
                      const SizedBox(height: 10),
                      CustomLableText(lable: 'Suitable'),
                      CustomMultiselectDropdown(
                        title: 'Suitable For',
                        hintText: 'Select suitable for',
                        bgColor: background,
                        items: destinations,
                        onChanged: (p0) {
                          setState(() {
                            selectedSuitableFor = p0;
                          });
                        },
                        selectedItems: selectedSuitableFor,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please select suitable for';
                          }
                          return null;
                        },
                      ),
                      Visibility(
                          visible: selectedSuitableFor.any(
                            (d) =>
                                d == 'INFANT' || d == 'CHILD' || d == 'SENIOR',
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ticket Discount',
                                style: titleTextStyle,
                              ),
                              Divider(
                                color: btnColor,
                              ),
                              if (selectedSuitableFor.contains('INFANT'))
                                CustomLableText(lable: 'Infant'),
                              if (selectedSuitableFor.contains('INFANT'))
                                CustomDropdownButton(
                                  isEditable: true,
                                  controller: _infantDiscountController,
                                  itemsList: discountOptions,
                                  onChanged: (value) {
                                    setState(() {
                                      _infantDiscountController.text =
                                          value ?? '';
                                    });
                                  },
                                  hintText: 'Select infant discount',
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Please select infant discount';
                                    }
                                    return null;
                                  },
                                ),
                              if (selectedSuitableFor.contains('CHILD'))
                                SizedBox(height: 10),
                              if (selectedSuitableFor.contains('CHILD'))
                                CustomLableText(lable: 'Child'),
                              if (selectedSuitableFor.contains('CHILD'))
                                CustomDropdownButton(
                                  isEditable: true,
                                  controller: _childDiscountController,
                                  itemsList: discountOptions,
                                  onChanged: (value) {
                                    setState(() {
                                      _childDiscountController.text =
                                          value ?? '';
                                    });
                                  },
                                  hintText: 'Select child discount',
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Please select child discount';
                                    }
                                    return null;
                                  },
                                ),
                              if (selectedSuitableFor.contains('SENIOR'))
                                SizedBox(height: 10),
                              if (selectedSuitableFor.contains('SENIOR'))
                                CustomLableText(lable: 'Senior'),
                              if (selectedSuitableFor.contains('SENIOR'))
                                CustomDropdownButton(
                                  isEditable: true,
                                  controller: _seniorDiscountController,
                                  itemsList: discountOptions,
                                  onChanged: (value) {
                                    setState(() {
                                      _seniorDiscountController.text =
                                          value ?? '';
                                    });
                                  },
                                  hintText: 'Select senoir discount',
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Please select senior discount';
                                    }
                                    return null;
                                  },
                                )
                            ],
                          )),
                      SizedBox(height: 10),
                      Divider(color: btnColor),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Activity Name'),
                      Customtextformfield(
                        fillColor: background,
                        controller: _activityNameController,
                        hintText: 'Enter activity name',
                        textLength: 50,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter activity name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Activity Hours'),
                      CustomDropdownButton(
                        isEditable: true,
                        controller: _activityHourController,
                        itemsList: activityHours,
                        onChanged: (value) {
                          setState(() {
                            _activityHourController.text = value ?? '';
                          });
                        },
                        hintText: 'Select activity hours',
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please select activity price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Activity Price'),
                      Customtextformfield(
                        prefix: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'AED',
                            style: titleTextStyle,
                          ),
                        ),
                        fillColor: background,
                        controller: _activityPriceController,
                        hintText: 'Enter activity price',
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter activity price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Best Time To Visit'),
                      CustomDropdownButton(
                        isEditable: true,
                        controller: _bestTimeToVisitController,
                        itemsList: bestTimeToVisitList,
                        onChanged: (value) {
                          setState(() {
                            _bestTimeToVisitController.text = value ?? '';
                          });
                        },
                        hintText: 'Select best time to visit',
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please select best time to visit';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Local Visit Time From'),
                      selectTime(
                        hoursController: _visitfromHoursController,
                        onHoursChanged: (val) => setState(() {}),
                        minsController: _visitfromminsController,
                        onMinsChanged: (val) => setState(() {}),
                       
                      ),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Local Visit Time To'),
                      selectTime(
                        hoursController: _visitToHoursController,
                        onHoursChanged: (val) => setState(() {}),
                        minsController: _visitToMinsController,
                        onMinsChanged: (val) => setState(() {}),
                        extraValidator: () {
                          if (_activityHourController.text.isNotEmpty &&
                              _visitfromHoursController.text.isNotEmpty &&
                              _visitfromminsController.text.isNotEmpty &&
                              _visitToHoursController.text.isNotEmpty &&
                              _visitToMinsController.text.isNotEmpty) {
                            final diffMinutes = calculateMinutesDiff(
                              fromHour: _visitfromHoursController.text,
                              fromMin: _visitfromminsController.text,
                              toHour: _visitToHoursController.text,
                              toMin: _visitToMinsController.text,
                            );

                            final activityHours = int.tryParse(
                                    _activityHourController.text
                                        .split(" ")
                                        .first) ??
                                0;
                            debugPrint('diffMinutes $diffMinutes');
                            debugPrint('activityHours $activityHours');
                            debugPrint(
                                'entered hours ${_activityHourController.text.split(" ").first}');
                            if (diffMinutes < activityHours * 60) {
                              return 'Visit duration must be at least $activityHours hours';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Religious Off',
                        style: titleTextStyle,
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select Your Travel Dates',
                          fillColor: background,
                          filled: true,
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
                          selectedDate = await selectMultipleSfDate(context);
                          debugPrint('selected date $selectedDate');
                          if (selectedDate != null) {
                            dateController.text = selectedDate?.join(',') ?? '';
                          }
                        },
                       
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Apply Offer',
                        style: titleTextStyle,
                      ),
                      SizedBox(height: 5),
                      CustomDropdownButton(
                        isEditable: true,
                        controller: _offerController,
                        itemsList: activityOffer
                                ?.map((toElement) =>
                                    toElement.offerName.toString())
                                .toList() ??
                            [],
                        onChanged: (value) {
                          setState(() {
                            _offerController.text = value ?? '';
                            offerId = activityOffer
                                    ?.firstWhere(
                                        (element) => element.offerName == value)
                                    .offerId
                                    .toString() ??
                                '';
                          });
                        },
                        hintText: 'Select offer',
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Weekly Off',
                        style: titleTextStyle,
                      ),
                      SizedBox(height: 5),
                      CustomMultiselectDropdown(
                        title: 'Weekly Off',
                        hintText: 'Select weekly off',
                        bgColor: background,
                        items: weeklyOffList,
                        onChanged: (p0) {
                          setState(() {
                            selectedWeeklyOff = p0;
                          });
                        },
                        selectedItems: selectedWeeklyOff ?? [],
                      ),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Activity Category'),
                      CustomDropdownButton(
                        isEditable: true,
                        controller: _activityCategoryController,
                        itemsList: activityCategoryList
                                ?.map((val) =>
                                    val.activityCategoryName.toString())
                                .toList() ??
                            [],
                        onChanged: (value) {
                          setState(() {
                            _activityCategoryController.text = value ?? '';
                          });
                        },
                        hintText: 'Select activity category',
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please select activity category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustomLableText(lable: 'Description'),
                      Customtextformfield(
                        fillColor: background,
                        maxLines: 4,
                        minLines: 4,
                        textLength: 300,
                        controller: _descriptionController,
                        hintText: 'Enter description',
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      CustomLableText(lable: 'Upload Activity Image'),
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
                      SizedBox(height: 15),
                      CustomButtonSmall(
                        loading: isLoading,
                        btnHeading: widget.isEdit
                            ? 'Update Activity'
                            : 'Create Activity',
                        onTap: () async {
                          
                          String? vendorId =
                              await UserViewModel().getUserId() ?? '';
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<ActivityManagementViewModel>()
                                .addEditActivityApi(
                                    context: context,
                                    activityRequest: {
                                      "country": countryName,
                                      if (widget.isEdit)
                                        "activityId": widget.activityId ?? '',
                                      "state": _stateController.text,
                                      "city": "",
                                      "address": _locationNameController.text,
                                      "activityName":
                                          _activityNameController.text,
                                      "activityHours": mapDropdownToApi(
                                          _activityHourController.text),
                                      "activityPrice":
                                          _activityPriceController.text,
                                      "participantType": selectedSuitableFor,
                                      "bestTimeToVisit":
                                          _bestTimeToVisitController.text,
                                      "startTime":
                                          '${_visitfromHoursController.text}:${_visitfromminsController.text}',
                                      "endTime":
                                          '${_visitToHoursController.text}:${_visitToMinsController.text}',
                                      "religiousOffDates": selectedDate ?? [],
                                      "offerId": offerId,
                                      if (widget.isEdit)
                                        "activityImageUrl":
                                            statusById == Status.completed
                                                ? initialImages
                                                : [],
                                      "weeklyOff": selectedWeeklyOff ?? [],
                                      "activityCategory":
                                          _activityCategoryController.text,
                                      "description":
                                          _descriptionController.text,
                                      "ageGroupDiscountPercent": {
                                        "INFANT":
                                            mapDiscountToDouble(
                                            _infantDiscountController.text),
                                        "CHILD": mapDiscountToDouble(
                                            _childDiscountController.text),
                                        "SENIOR":
                                            mapDiscountToDouble(
                                            _seniorDiscountController.text),
                                      },
                                      "vendorId": vendorId,
                                     
                                    },
                                    images: selectedImages,
                                    isEdit: widget.isEdit);
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

  Widget selectTime(
      {required TextEditingController hoursController,
      dynamic Function(String?)? onHoursChanged,
      required TextEditingController minsController,
    dynamic Function(String?)? onMinsChanged,
    String? Function()? extraValidator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CustomDropdownButton(
              controller: hoursController,
              itemsList: List.generate(
                24,
                (index) => index.toString().padLeft(2, "0"),
              ),
              onChanged: onHoursChanged,
              hintText: 'Select Hours',
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Please select hours';
                }
                // return null;
                return extraValidator?.call(); 
              },
            ),
          ),
        ),
        const Text(
          ':',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.w700, fontSize: 24, height: 2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CustomDropdownButton(
              controller: minsController,
              itemsList: List.generate(
                60,
                (index) => index.toString().padLeft(2, "0"),
              ),
              onChanged: onMinsChanged,
              hintText: 'Select Mins',
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Please select mins';
                }
                // return null;
                return extraValidator?.call(); 
              },
            ),
          ),
        )
      ],
    );
  }
}

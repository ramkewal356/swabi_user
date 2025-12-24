import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/data/models/rental_booking_model.dart' hide Status;
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/custom_datePicker/common_textfield.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:provider/provider.dart';

class RentalForm extends StatefulWidget {
  const RentalForm({
    super.key,
  });

  @override
  State<RentalForm> createState() => _RentalFormState();
}

class _RentalFormState extends State<RentalForm> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  var stateDropdownKey = UniqueKey();
  final pickuplocationController = TextEditingController();
  final pickupdateController = TextEditingController();
  final seatController = TextEditingController();
  final rentalController = TextEditingController();
  final hoursController = TextEditingController();
  final minsController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final FocusNode locationFocusNode = FocusNode();
  String selectHour = '';
  String selectMin = '';

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List<String> mins = ['00', '15', '30', '45'];
  String sourceLocation = "Source Location";
  String? logitude1;
  String? latitude1;
  double logi = 0.0;
  double lati = 0.0;
  String country = 'United Arab Emirates';
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getRentalRengeList();
      rentalController.addListener(_onRentalControllerChanged);
      pickupdateController.addListener(_onRentalControllerChanged);
      seatController.addListener(_onRentalControllerChanged);
      countryController.text = country;

      getCountry();
      getStateListApi(_countryController.text);
    });
  }

  void getRentalRengeList() {
    context
        .read<GetRentalRangeListViewModel>()
        .fetchGetRentalRangeListViewModelApi();
  }

  void _unfocusLocationField() {
    if (locationFocusNode.hasFocus) {
      locationFocusNode.unfocus();
    }
  }

  Dio? dio;
  String accessToken = '';
  void getCountry() {
    context.read<ThirdPartyViewModel>().getCountryList();
  }

  void getStateListApi(String country) {
    context.read<ThirdPartyViewModel>().getStateList(country: country);
  }

  @override
  void didPopNext() {
    // Reset the time when coming back to this page
  }
  @override
  void dispose() {
    rentalController.removeListener(_onRentalControllerChanged);
    pickupdateController.removeListener(_onRentalControllerChanged);
    seatController.removeListener(_onRentalControllerChanged);

    rentalController.dispose();
    pickupdateController.dispose();
    seatController.dispose();
    super.dispose();
  }

  void _onRentalControllerChanged() {
    // Trigger validation manually on every change
    setState(() {});
  }

  void _searchRide() {
    context.read<RentalViewModel>().fetchRentalViewModelApi(
        context,
        {
          "date": pickupdateController.text,
          "pickupTime": '$selectHour:$selectMin',
          "seat": seatController.text,
          "hours": rentalController.text.split(' ')[0],
          "kilometers": rentalController.text.split(' ')[2],
          "pickUpLocation": pickuplocationController.text,
          "latitude": lati.toString(),
          "longitude": logi.toString(),
        },
        logi,
        lati);
  }

  bool onTap = false;
  String? selectValue;
  String? vehicle;
  String? vehicleStatus;
  List<GetRentalRangeListDatum> rangeData = [];

  @override
  Widget build(BuildContext context) {
    vehicleStatus = context.watch<RentalViewModel>().dataList.status.toString();
    rangeData = context
            .watch<GetRentalRangeListViewModel>()
            .getRentalRangeList
            .data
            ?.data ??
        [];
    var countryList =
        context.watch<ThirdPartyViewModel>().getCountryListResponse.data;
    var stateList = context.watch<ThirdPartyViewModel>().stateList.data;
    String status = context.watch<RentalViewModel>().dataList.status.toString();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            lableText('Country'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomDropdownButton(
                itemsList: countryList ?? [],
                hintText: 'Select Country',
                controller: _countryController,
                onChanged: (value) {
                  _countryController.text = value ?? '';
                  setState(() {
                    stateController.clear();
                    stateList = [];
                    stateDropdownKey = UniqueKey();
                  });

                  getStateListApi(value!);
                  setState(() {});
                },
                validator: (p0) =>
                    (p0 == null || p0.isEmpty) ? 'Please select country' : null,
              ),
            ),

            const SizedBox(height: 10),

            lableText('State'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomDropdownButton(
                key: stateDropdownKey,
                controller: stateController,
                // focusNode: focusNode3,
                itemsList:
                    stateList?.map((stateName) => stateName).toList() ?? [],

                onChanged: (value) {
                  setState(() {
                    stateController.text = value ?? '';
                    pickuplocationController.clear();
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
            ),
            const SizedBox(height: 10),

            lableText('Pickup Location'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomSearchLocation(
                  focusNode: locationFocusNode,
                  controller: pickuplocationController,
                  state: stateController.text,
                  // stateValidation: true,
                  fillColor: background,
                  hintText: 'Search your location'),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (pickupdateController.text.isEmpty) {
                      return 'Please select pickup date';
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormDatePickerExpense(
                          width: double.infinity,
                          title: "Pickup Date",
                          controller: pickupdateController,
                          hint: "PickUp Date",
                          onfocusTap: _unfocusLocationField,
                        ),
                        if (field.hasError)
                          pickupdateController.text.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    field.errorText!,
                                    style: const TextStyle(color: redColor),
                                  ),
                                )
                              : Container(),
                      ],
                    );
                  }),
            ),
            const SizedBox(height: 10),

            lableText('Pickup Time'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CustomDropdownButton(
                      // selecteValue: selectHour,

                      controller: hoursController,
                      itemsList: List.generate(
                          24, (index) => index.toString().padLeft(2, '0')),
                      onChanged: (p0) {
                        setState(() {
                          selectHour = p0 ?? '';
                        });
                      },
                      hintText: 'Select Hours',
                      validator: (p0) {
                        if (p0 == null || hoursController.text.isEmpty) {
                          return 'Please select hours';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Text(
                  ':',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24, height: 2),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CustomDropdownButton(
                      // selecteValue: selectMin,

                      controller: minsController,
                      itemsList: mins,
                      onChanged: (p0) {
                        setState(() {
                          selectMin = p0 ?? '';
                        });
                      },
                      hintText: 'Select Mins',
                      validator: (p0) {
                        if (p0 == null || minsController.text.isEmpty) {
                          return 'Please select mins';
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),
            lableText('Select seats'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomDropdownButton(
                // selecteValue: selectMin,

                controller: seatController,
                itemsList: items,
                onChanged: (p0) {
                  setState(() {
                    seatController.text = p0 ?? '';
                  });
                },
                hintText: 'Select Seats',
                validator: (p0) {
                  if (p0 == null || seatController.text.isEmpty) {
                    return 'Please select seats';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),

            lableText('Select Rental Package'),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomDropdownButton(
                // selecteValue: selectMin,

                controller: rentalController,
                itemsList: List.generate(
                    rangeData.length,
                    (index) =>
                        "${rangeData[index].hours} Hr ${rangeData[index].kilometer} Km"),
                onChanged: (p0) {
                  setState(() {
                    rentalController.text = p0 ?? '';
                  });
                },
                hintText: 'Select Rental Package',
                validator: (p0) {
                  if (p0 == null || rentalController.text.isEmpty) {
                    return 'Please select rental package';
                  }
                  return null;
                },
              ),
            ),

            // const Spacer(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButtonSmall(
                width: double.infinity,
                btnHeading: "SEARCH",
                // loading: _rentalViewModel.loading,
                loading: status == "Status.loading" && onTap,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    onTap = true;
                   
                    _searchRide();
                    debugPrint("${status}Status Hai Ye");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget lableText(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 10, right: 10),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: title, style: titleTextStyle),
        const TextSpan(text: ' *', style: TextStyle(color: redColor))
      ])),
    );
  }
}

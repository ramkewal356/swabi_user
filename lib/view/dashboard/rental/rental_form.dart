import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Common%20Widgets/common_offer_container.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/model/rentalbooking_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/custom_datePicker/common_textfield.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/view_model/rental_view_model.dart';
import 'package:provider/provider.dart';

class RentalForm extends StatefulWidget {
  final String userId;

  const RentalForm({super.key, required this.userId});

  @override
  State<RentalForm> createState() => _RentalFormState();
}

class _RentalFormState extends State<RentalForm> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  final pickuplocationController = TextEditingController();
  final pickupdateController = TextEditingController();
  final seatController = TextEditingController();
  final rentalController = TextEditingController();
  final hoursController = TextEditingController();
  final minsController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  final FocusNode locationFocusNode = FocusNode();
  String selectHour = '';
  String selectMin = '';

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
  List<String> mins = ['00', '15', '30', '45'];
  List<String> hours = [
    "00",
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
  ];
  String apiKey = 'AIzaSyADRdiTbSYUR8oc6-ryM1F1NDNjkHDr0Yo';
  String sourceLocation = "Source Location";
  String? logitude1;
  String? latitude1;
  // double logitude1 = 0.0;
  // double latitude1 = 0.0;
  double logi = 0.0;
  double lati = 0.0;
  String country = 'United Arab Emirates';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GetRentalRangeListViewModel>(context, listen: false)
          .fetchGetRentalRangeListViewModelApi(context);
      rentalController.addListener(_onRentalControllerChanged);
      pickupdateController.addListener(_onRentalControllerChanged);
      seatController.addListener(_onRentalControllerChanged);
      countryController.text = country;

      getCountry();
    });

    // controllers[0].addListener(() {
    //   onChange();
    // });
  }

  void _unfocusLocationField() {
    print('jcmzxcmnzxbcmnxzbcnxz..,,..,..............');
    if (locationFocusNode.hasFocus) {
      locationFocusNode.unfocus();
    }
  }

  Dio? dio;
  String accessToken = '';
  void getCountry() async {
    try {
      var countryProvider =
          Provider.of<GetCountryStateListViewModel>(context, listen: false);
      countryProvider.getAccessToken(context: context).then((onValue) {
        debugPrint('token,.....c//.c.... $onValue');
        setState(() {
          accessToken = onValue['auth_token'].toString();
        });
        // countryProvider.getCountryList(context: context, token: accessToken);
        Provider.of<GetCountryStateListViewModel>(context, listen: false)
            .getStateList(
                context: context,
                token: accessToken,
                country: countryController.text);
      });
    } catch (e) {
      debugPrint('error $e');
    }
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

  bool onTap = false;
  String? selectValue;
  String? vehicle;
  String? vehicleStatus;
  List<GetRentalRangeListDatum> rangeData = [];

  @override
  Widget build(BuildContext context) {
    vehicleStatus = context.watch<RentalViewModel>().DataList.status.toString();
    rangeData = context
            .watch<GetRentalRangeListViewModel>()
            .getRentalRangeList
            .data
            ?.data ??
        [];
    String status = context.watch<RentalViewModel>().DataList.status.toString();
    List state =
        context.watch<GetCountryStateListViewModel>().getStateListModel;
    bool isLoadingState =
        context.watch<GetCountryStateListViewModel>().isLoading;


    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 10),
            const CommonOfferContainer(
              bookingType: 'RENTAL_BOOKING',
            ),
            // const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Country', style: titleTextStyle),
                  // const TextSpan(text: ' *', style: TextStyle(color: redColor))
                ]))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                child: Customtextformfield(
                  // focusNode: focusNode2,
                  controller: countryController,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  // prefixiconvisible: true,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  // ],
                  fillColor: background,
                  img: user,
                  hintText: 'Country',
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'State', style: titleTextStyle),
                  const TextSpan(text: ' *', style: TextStyle(color: redColor))
                ]))),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomDropdownButton(
                controller: stateController,
                // focusNode: focusNode3,
                itemsList: state.map((state) {
                  return state['state_name'].toString();
                }).toList(),

                // itemsList: [],
                onChanged: isLoadingState
                    ? null
                    : (value) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: 'Pickup Location', style: titleTextStyle),
                const TextSpan(text: ' *', style: TextStyle(color: redColor))
              ])),
              // child: Text("Pickup Location", style: titleTextStyle),
            ),
            const SizedBox(height: 5),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Pickup Time', style: titleTextStyle),
                  const TextSpan(text: ' *', style: TextStyle(color: redColor))
                ])),
              ),
            ),
            const SizedBox(height: 5),

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
                      itemsList: hours,
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
            // TimePickerDropdown(
            //   hrcontroller: controllers[2],
            //   mincontroller: controllers[3],
            // ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: 'Select seats', style: titleTextStyle),
                const TextSpan(text: ' *', style: TextStyle(color: redColor))
              ])),
              // child: Text("Pickup Location", style: titleTextStyle),
            ),
            const SizedBox(height: 5),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: 'Select Rental Package', style: titleTextStyle),
                const TextSpan(text: ' *', style: TextStyle(color: redColor))
              ])),
              // child: Text("Pickup Location", style: titleTextStyle),
            ),
            const SizedBox(height: 5),
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
                    // print(pickupTime);
                    Provider.of<RentalViewModel>(context, listen: false)
                        .fetchRentalViewModelApi(
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
                            widget.userId,
                            logi,
                            lati);
                    debugPrint("${status}Status Hai Ye");
                  
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
    // );
  }
}

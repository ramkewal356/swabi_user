import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/model/calculate_price_model.dart';
import 'package:flutter_cab/model/get_package_details_by_id_model.dart';
// import 'package:flutter_cab/model/package_models.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_phonefield.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/custom_container.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/string_extenstion.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/payment_gateway_view_model.dart';
import 'package:flutter_cab/view_model/services/payment_service.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:marqueer/marqueer.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PackageBookingMemberPage extends StatefulWidget {
  final String userID;
  final double amt;
  final String bookingDate;
  final String packageID;
  final List<String> participantTypes;
  final List<PackageActivity> packageActivityList;
  const PackageBookingMemberPage(
      {super.key,
      required this.userID,
      required this.packageID,
      required this.amt,
      required this.bookingDate,
      required this.participantTypes,
      required this.packageActivityList});

  @override
  State<PackageBookingMemberPage> createState() =>
      _PackageBookingMemberPageState();
}

class _PackageBookingMemberPageState extends State<PackageBookingMemberPage> {
  List<TextEditingController> controller =
      List.generate(2, (index) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  final _formCouponKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController primaryNoController = TextEditingController();
  TextEditingController secondaryNoController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode couponFocus = FocusNode();
  GlobalKey _phoneKey = GlobalKey();
  bool tableIcon = false;

  // String ageUnit = '';
  List<Map<String, dynamic>> members = [];
  double sumAmount = 0.0;
  double payAbleAmount = 0.0;
  bool loader = false;
  bool isAddAdultDisabled = false;
  bool isAddChildDisabled = false;
  bool isAddInfentDisabled = false;
  String validationMessage = '';
  String primaryCountryCode = '';
  String secondaryCountryCode = '971';
  String initialCountryCode = 'AE';
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // updateButtonStates();
    controller[0].text = widget.bookingDate;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProfileViewModel>(context, listen: false)
          .fetchUserProfileViewModelApi(context, {'userId': widget.userID});
      getData();
    });
    _phoneKey = GlobalKey();
    checkParticipantTypes(widget.participantTypes);
  }

  getData() async {
    await Future.delayed(Duration(seconds: 2));
    final userProfile =
        Provider.of<UserProfileViewModel>(context, listen: false)
            .DataList
            .data
            ?.data;

    // Set the primary country code and primary number
    setState(() {
      primaryCountryCode = userProfile?.countryCode ?? '';
      primaryNoController.text = userProfile?.mobile ?? '';
      var list = countries
          .where((code) => code.dialCode == primaryCountryCode)
          .toList();
      if (list.isNotEmpty) {
        // controllers[4].text = list.first.dialCode;
        initialCountryCode = list.first.code;
        _phoneKey = GlobalKey();
        //  = list.first.code;
        print('isocode.................... ${list.first.code}');
      }
    });
  }

  bool adultType = false;
  bool childType = false;
  bool infantType = false;

  void checkParticipantTypes(List<String> normalizedTypes) {
    adultType = normalizedTypes.contains('ADULT');
    childType = normalizedTypes.contains('CHILD');
    infantType = normalizedTypes.contains('INFANT');

    // Debug prints
    debugPrint('Normalized Types: $normalizedTypes');
    debugPrint('Adult Type: $adultType');
    debugPrint('Child Type: $childType');
    debugPrint('Infant Type: $infantType');
  }

  double taxPercentage = 5;
  double taxAmount = 0;
  double taxamount() {
    return (taxPercentage / 100) * sumAmount;
    // return sumAmount + taxamt;
  }

  void _addAmount() {
    setState(() {
      sumAmount = members.fold(0.0, (previousValue, member) {
        return previousValue + (member['price'] ?? 0.0);
      });
      // sumAmount += bookingAmount;
      taxAmount = taxamount();
      // amount += double.parse(widget.amt);
      payAbleAmount = sumAmount + taxAmount;
      debugPrint('taxamount....$taxAmount');
      debugPrint('totalPayableAmount....$payAbleAmount');
      discountAmount == 0 ? null : discountAmount = getPercentage();
    });
  }

  void _subAmount() {
    setState(() {
      // sumAmount -= double.parse(widget.amt);
      sumAmount -= widget.amt;

      taxAmount = taxamount();

      // amount += double.parse(widget.amt);
      payAbleAmount = sumAmount + taxAmount;
      debugPrint('taxamount....$taxAmount');
      debugPrint('totalPayableAmount....$payAbleAmount');
      discountAmount == 0 ? null : discountAmount = getPercentage();
    });
  }

  bool _shouldDisableButton() {
    bool noAdultsPresent = !members.any((member) {
      int age = (int.tryParse(member['age'].toString())?.toInt() ?? 0);
      if (member['type'] == 'Adult' || member['type'] == 'Senior') {
        return age >= 18 && age < 60;
      } else {
        return false;
      }
    });
    return payAbleAmount == 0.0 || noAdultsPresent;
  }

  Future<CalculatePriceModel?> getCalculatePrice(
      {required String participantType}) async {
    var resp = await Provider.of<GetCalculatePackagePriceViewModel>(context,
            listen: false)
        .getPackageCalculateBookingPrice(
            context: context,
            packageId: widget.packageID,
            participantType: participantType);
    return resp;
  }

  void showBottomModal(
      {required String title,
      required Widget child,
      required String btnHeading,
      required void Function()? onTap}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setstate) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjust modal size when keyboard opens
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: buttonText,
                        ),
                        IconButton(
                            padding: const EdgeInsets.only(left: 15),
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: btnColor,
                            ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    child,
                    const SizedBox(height: 15),
                    CustomButtonSmall(btnHeading: btnHeading, onTap: onTap)
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  /// Add memeber
  void _addMember(
      {required String title, required String ageUnit, required String type}) {
    nameController.text = '';
    ageController.text = '';
    genderController.text = '';
    int age = 0;
    showBottomModal(
        title: title,
        child: Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Name', style: titleTextStyle),
                  const TextSpan(text: ' *', style: TextStyle(color: redColor))
                ])),
              ),
              Customtextformfield(
                focusNode: focusNode1,
                controller: nameController,
                hintText: 'Enter Name',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[\u0000-\u007F]*$'),
                  ),
                ],
                // errorText:
                //     validationMessage.isEmpty ? '' : validationMessage,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                // onChanged: (p0) {
                //   if (p0 != '') {
                //     setstate(() {
                //       validationMessage = 'return error';
                //     });
                //   } else {
                //     validationMessage = '';
                //   }
                // },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: 'Age', style: titleTextStyle),
                            const TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                                text: type == 'Infant' ? '(Month)' : '(Year)',
                                style: titleTextStyle),
                            const TextSpan(
                                text: ' *', style: TextStyle(color: redColor))
                          ])),
                        ),
                        Customtextformfield(
                          focusNode: focusNode2,
                          controller: ageController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          hintText: 'Enter Age',
                          validator: (value) {
                            age = int.tryParse(value ?? '')?.toInt() ?? 0;

                            if (value == null || value.isEmpty) {
                              return 'Please enter age';
                            } else if (type == 'Adult') {
                              debugPrint('type of member1$type');
                              if (age < 18 || age >= 100) {
                                return 'Age must be between 18 to 99 years';
                              }
                            } else if (type == 'Child') {
                              debugPrint('type of member2$type');
                              if (age < 1 || age <= 2 || age >= 18) {
                                return 'Age must be between 3 to 18 years';
                              }
                            } else if (type == 'Infant') {
                              debugPrint('type of member3$type');
                              if (age < 1 || age >= 24) {
                                return 'Age must be between 1 to 24 months';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: 'Gender', style: titleTextStyle),
                            const TextSpan(
                                text: ' *', style: TextStyle(color: redColor))
                          ])),
                        ),
                        CustomDropdownButton(
                          controller: genderController,
                          focusNode: focusNode3,
                          itemsList: const ['Male', 'Female'],
                          onChanged: (value) {
                            setState(() {
                              genderController.text = value ?? '';
                              debugPrint(
                                  'validate gender ${genderController.text}');
                            });
                          },
                          hintText: 'Select Gender',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select gender';
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        btnHeading: 'ADD',
        onTap: () {
          if (_formKey.currentState!.validate()) {
            debugPrint('succes');

            // type == 'Infant' ? null : _addAmount();
            if (type == 'Adult') {
              if (age > 59) {
                getCalculatePrice(participantType: 'SENIOR').then((value) {
                  setState(() {
                    members.add({
                      'name': nameController.text,
                      'age': ageController.text,
                      'gender': genderController.text,
                      'ageUnit': ageUnit,
                      'price': value?.data?.calculatedPrice ?? 0,
                      'type': 'Senior'
                    });
                  });
                  _addAmount();
                });
              } else {
                getCalculatePrice(participantType: 'ADULT').then((value) {
                  setState(() {
                    members.add({
                      'name': nameController.text,
                      'age': ageController.text,
                      'gender': genderController.text,
                      'ageUnit': ageUnit,
                      'price': value?.data?.calculatedPrice ?? 0,
                      'type': type
                    });
                  });
                  _addAmount();
                });
              }
            } else if (type == 'Child') {
              getCalculatePrice(participantType: 'CHILD').then((value) {
                setState(() {
                  members.add({
                    'name': nameController.text,
                    'age': ageController.text,
                    'gender': genderController.text,
                    'ageUnit': ageUnit,
                    'price': value?.data?.calculatedPrice ?? 0,
                    'type': type
                  });
                });
                _addAmount();
              });
            } else if (type == 'Infant') {
              getCalculatePrice(participantType: 'INFANT').then((value) {
                setState(() {
                  members.add({
                    'name': nameController.text,
                    'age': ageController.text,
                    'gender': genderController.text,
                    'ageUnit': ageUnit,
                    'price': value?.data?.calculatedPrice ?? 0,
                    'type': type
                  });
                });
                _addAmount();
              });
            }
            // ageUnit = '';
            // type = '';
            // nameController.text = '';
            // ageController.text = '';
            // genderController.text = '';
            setState(() {
              _shouldDisableButton();
            });
            Navigator.of(context).pop();
          } else {
            debugPrint('jhhjhjcgnxbcnbxcnxbcxjc');
          }
        });
  }

  /// Update memeber
  void _editMember(
      {required String title,
      required int index,
      required String ageUnit,
      required String type}) {
    nameController.text = members[index]['name'];
    ageController.text = members[index]['age'];
    genderController.text = members[index]['gender'];
    double price = members[index]['price'];
    int age = 0;
    showBottomModal(
        title: title,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Name', style: titleTextStyle),
                  const TextSpan(text: ' *', style: TextStyle(color: redColor))
                ])),
              ),
              Customtextformfield(
                focusNode: focusNode1,
                controller: nameController,
                hintText: 'Enter Name',
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[\u0000-\u007F]*$'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: 'Age', style: titleTextStyle),
                            const TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                                text: type == 'Infant' ? '(Month)' : '(Year)',
                                style: titleTextStyle),
                            const TextSpan(
                                text: ' *', style: TextStyle(color: redColor))
                          ])),
                        ),
                        Customtextformfield(
                          focusNode: focusNode2,
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          hintText: 'Enter Age',
                          validator: (value) {
                            age = int.tryParse(value ?? '')?.toInt() ?? 0;

                            if (value == null || value.isEmpty) {
                              return 'Please enter age';
                            } else if (type == 'Adult') {
                              debugPrint('type of member1$type');
                              if (age <= 18 || age >= 100) {
                                return 'Age must be between 18 to 99 years';
                              }
                            } else if (type == 'Child') {
                              debugPrint('type of member2$type');
                              if (age < 1 || age <= 2 || age >= 18) {
                                return 'Age must be between 3 to 18 years';
                              }
                            } else if (type == 'Infant') {
                              debugPrint('type of member3$type');
                              if (age < 1 || age >= 24) {
                                return 'Age must be between 1 to 24 months';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: 'Gender', style: titleTextStyle),
                            const TextSpan(
                                text: ' *', style: TextStyle(color: redColor))
                          ])),
                        ),
                        CustomDropdownButton(
                          controller: genderController,
                          focusNode: focusNode3,
                          itemsList: const ['Male', 'Female'],
                          onChanged: (value) {
                            setState(() {
                              genderController.text = value ?? '';
                            });
                          },
                          hintText: 'Select Gender',
                          // validator: (p0) {
                          //   if (p0 == null || p0.isEmpty) {
                          //     return 'Please select gender';
                          //   }
                          //   return null;
                          // },
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        btnHeading: "EDIT",
        onTap: () {
          if (_formKey.currentState!.validate()) {
            debugPrint('succes');

            if (type == 'Adult') {
              if (age > 59) {
                getCalculatePrice(participantType: 'SENIOR').then((value) {
                  setState(() {
                    members[index] = {
                      'name': nameController.text,
                      'age': ageController.text,
                      'gender': genderController.text,
                      'ageUnit': ageUnit,
                      'price': value?.data?.calculatedPrice ?? 0,
                      'type': 'Senior'
                    };
                  });
                  _addAmount();
                });
              } else {
                getCalculatePrice(participantType: 'ADULT').then((value) {
                  setState(() {
                    members[index] = {
                      'name': nameController.text,
                      'age': ageController.text,
                      'gender': genderController.text,
                      'ageUnit': ageUnit,
                      'price': value?.data?.calculatedPrice ?? 0,
                      'type': type
                    };
                  });
                  _addAmount();
                });
              }
            } else {
              setState(() {
                members[index] = {
                  'name': nameController.text,
                  'age': ageController.text,
                  'gender': genderController.text,
                  'ageUnit': ageUnit,
                  'price': price,
                  'type': type
                };
              });
            }
            setState(() {
              _shouldDisableButton();
            });
            // type == 'Infant' ? null : _subAmount();
            Navigator.of(context).pop();
          }
        });
  }

  double marqueeVelocity = 100.0; // Default scrolling speed
  bool visibleSecondaryContact = false;
  bool offerVisible = false;
  bool isHovering = false;
  double disCountPer = 0;
  double maxDisAmount = 0;
  String? offerCode;
  double discountAmount = 0;
  double disAmount = 0;
  double getPercentage() {
    double amt = (disCountPer / 100) * payAbleAmount;
    disAmount = amt > maxDisAmount ? maxDisAmount : amt;
    return payAbleAmount - disAmount;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    primaryNoController.dispose();
    secondaryNoController.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
  }

  // bool tableIcon = false;
  var profileUser;
  @override
  Widget build(BuildContext context) {
    bool status = context.watch<ConfirmPackageBookingViewModel>().isLoading;

    bool bookingStatus =
        context.watch<GetPackageBookingByIdViewModel>().isLoading;
    profileUser = context.watch<UserProfileViewModel>().DataList.data?.data;

    debugPrint("${widget.userID}User");
    debugPrint("${widget.packageID}package");
    debugPrint("${widget.amt}amount");
    debugPrint('${primaryCountryCode}countrycode,,,,');
    debugPrint('${primaryNoController.text}primary number,,,,');
    debugPrint('${status}status      \\\\\\,,,,');

    // final marqueeController = MarqueerController();
    return Scaffold(
      backgroundColor: bgGreyColor,
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        heading: "Package Booking",
      ),
      body: PageLayout_Page(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // SizedBox(
                              //   height: 20,
                              //   child: Marqueer(
                              //     pps: 50,
                              //     controller: marqueeController,
                              //     direction: MarqueerDirection.rtl,
                              //     restartAfterInteractionDuration:
                              //         const Duration(seconds: 0),
                              //     restartAfterInteraction: true,
                              //     onChangeItemInViewPort: (index) {
                              //       debugPrint('item index: $index');
                              //     },
                              //     onInteraction: () {
                              //       debugPrint('on interaction callback');
                              //     },
                              //     onStarted: () {
                              //       debugPrint('on started callback');
                              //     },
                              //     onStopped: () {
                              //       debugPrint('on stopped callback');
                              //     },
                              //     child: Padding(
                              //       padding: EdgeInsets.symmetric(
                              //           horizontal:
                              //               MediaQuery.of(context).size.width /
                              //                   2),
                              //       child: const Text(
                              //         '*Children under 2 years old can be booked for free.Certain activities are not recommended for senior citizens due to potential health risks.*',
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           color: btnColor,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                margin:
                                    const EdgeInsets.only(bottom: 0, top: 5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Travel Date",
                                        overflow: TextOverflow.ellipsis,
                                        style: titleTextStyle,
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: titleTextStyle,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        widget.bookingDate,
                                        style: titleTextStyle1,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 5),
                              primaryNoController.text.isEmpty
                                  ? const SizedBox.shrink()
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Primary Contact",
                                            overflow: TextOverflow.ellipsis,
                                            style: titleTextStyle,
                                          ),
                                        ),
                                        Text(
                                          ':',
                                          style: titleTextStyle,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '+971 ${primaryNoController.text}',
                                            style: titleTextStyle1,
                                          ),
                                        )
                                      ],
                                    ),

                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('Secondary Contact ',
                                      textAlign: TextAlign.start,
                                      style: titleTextStyle),
                                  Text('(Optional)',
                                      textAlign: TextAlign.start,
                                      style: titleTextStyle1),
                                ],
                              ),
                              const SizedBox(height: 5),
                              CustomMobilenumber(
                                  textLength: 9,
                                  focusNode: focusNode5,
                                  fillColor: background,
                                  controller: secondaryNoController,
                                  hintText: 'Enter number',
                                  countryCode: secondaryCountryCode)
                              
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: background,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: naturalGreyColor.withOpacity(.3))),
                            child: Form(
                              key: _formCouponKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Customtextformfield(
                                          focusNode: couponFocus,
                                          controller: couponController,
                                          hintText: 'Coupon code',
                                          readOnly: offerVisible ? true : false,
                                          validator: (p0) {
                                            if (members.isEmpty) {
                                              return 'Please add members first';
                                            } else if (p0 == null ||
                                                p0.isEmpty) {
                                              return "Please enter offer coupon";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      offerVisible
                                          ? CustomButtonSmall(
                                              height: 45,
                                              width: 80,
                                              btnHeading: 'Remove',
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                // Optionally, unfocus specific fields
                                                couponFocus.unfocus();
                                                setState(() {
                                                  offerVisible = false;
                                                  discountAmount = 0;
                                                  disAmount = 0;
                                                });
                                              },
                                            )
                                          : CustomButtonSmall(
                                              height: 45,
                                              width: 80,
                                              btnHeading: 'Apply',
                                              onTap: () {
                                                if (_formCouponKey.currentState!
                                                    .validate()) {
                                                  Provider.of<OfferViewModel>(
                                                          context,
                                                          listen: false)
                                                      .validateOffer(
                                                          context: context,
                                                          offerCode:
                                                              couponController
                                                                  .text,
                                                          bookingType:
                                                              'PACKAGE_BOOKING',
                                                          bookigAmount:
                                                              payAbleAmount)
                                                      .then((onValue) {
                                                    if (onValue?.status
                                                            ?.httpCode ==
                                                        '200') {
                                                      Utils.toastSuccessMessage(
                                                          onValue?.status
                                                                  ?.message ??
                                                              '');
                                                      offerCode = onValue
                                                          ?.data?.offerCode;
                                                      disCountPer = onValue
                                                              ?.data
                                                              ?.discountPercentage ??
                                                          0;
                                                      maxDisAmount = onValue
                                                              ?.data
                                                              ?.maxDiscountAmount ??
                                                          0;
                                                      setState(() {
                                                        offerVisible = true;
                                                        discountAmount =
                                                            getPercentage();
                                                        debugPrint(
                                                            'discountpercentage.....,..,.,$discountAmount');
                                                      });
                                                    } else {
                                                      setState(() {
                                                        discountAmount = 0;
                                                      });
                                                    }
                                                  });
                                                }
                                              },
                                            )
                                    ],
                                  ),
                                  offerVisible
                                      ? Text(
                                          'Congrats!  You have availed discount of AED ${disAmount.toStringAsFixed(2)}.',
                                          style: TextStyle(color: greenColor),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Travellers Details',
                                style: TextStyle(
                                    color: btnColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: adultType
                                      ? () {
                                          FocusScope.of(context).unfocus();

                                          // Optionally, unfocus specific fields
                                          focusNode4.unfocus();
                                          focusNode5.unfocus();
                                          couponFocus.unfocus();
                                          _addMember(
                                              title: 'Add Adult',
                                              ageUnit: 'Year',
                                              type: 'Adult');
                                        }
                                      : null,
                                  child: Material(
                                    elevation: 4,
                                    color: adultType ? bgGreyColor : greyColor1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(color: btnColor)),
                                      padding: const EdgeInsets.all(2),
                                      child: Image.asset(
                                        adultIcon,
                                        width: 24,
                                        height: 24,
                                        color: btnColor,
                                      ),
                                    ),
                                  )),
                              const SizedBox(width: 20),
                              InkWell(
                                  onTap: childType
                                      ? () {
                                          FocusScope.of(context).unfocus();

                                          // Optionally, unfocus specific fields
                                          focusNode4.unfocus();
                                          focusNode5.unfocus();
                                          couponFocus.unfocus();
                                          _addMember(
                                              title: 'Add Child',
                                              ageUnit: 'Year',
                                              type: 'Child');
                                        }
                                      : null,
                                  child: Material(
                                    elevation: 4,
                                    color: childType ? bgGreyColor : greyColor1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(color: btnColor)),
                                      padding: const EdgeInsets.all(2),
                                      child: Image.asset(
                                        childIcon,
                                        width: 26,
                                        height: 26,
                                        color: btnColor,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )),
                              const SizedBox(width: 20),
                              InkWell(
                                  onTap: infantType
                                      ? () {
                                          FocusScope.of(context).unfocus();

                                          // Optionally, unfocus specific fields
                                          focusNode4.unfocus();
                                          focusNode5.unfocus();
                                          couponFocus.unfocus();
                                          _addMember(
                                              title: 'Add Infant',
                                              ageUnit: 'Month',
                                              type: 'Infant');
                                        }
                                      : null,
                                  child: Material(
                                    elevation: 4,
                                    color:
                                        infantType ? bgGreyColor : greyColor1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          // boxShadow: [
                                          //   BoxShadow(offset: Offset(-2, 3))
                                          // ],
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(color: btnColor)),
                                      padding: const EdgeInsets.all(3),
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            infantIcon,
                                            width: 24,
                                            height: 24,
                                            color: btnColor,
                                          ),
                                          const Positioned(
                                            right: -4,
                                            bottom: 0,
                                            child: Icon(
                                              Icons.add_circle_outline_sharp,
                                              color: btnColor,
                                              size: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Scrollbar(
                      controller: _scrollController,
                      // trackVisibility: true,
                      thumbVisibility: members.isEmpty ? false : true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FixedColumnWidth(120),
                                1: FixedColumnWidth(80),
                                2: FixedColumnWidth(70),
                                3: FixedColumnWidth(70),
                                4: FixedColumnWidth(80),
                                5: FixedColumnWidth(70),
                              },
                              // defaultColumnWidth: FixedColumnWidth(100),
                              children: [
                                TableRow(
                                    decoration: const BoxDecoration(
                                      color: btnColor,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, bottom: 10, top: 10),
                                        child: Text(
                                          'Name',
                                          style: tableheaderStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10, right: 5),
                                        child: Text(
                                          'Age',
                                          style: tableheaderStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                          'Gender',
                                          style: tableheaderStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 10, bottom: 10),
                                        child: Text(
                                          'Type',
                                          style: tableheaderStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 10, bottom: 10),
                                        child: Text(
                                          'Price',
                                          style: tableheaderStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                          'Action',
                                          style: tableheaderStyle,
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                            members.isEmpty
                                ? const Center(
                                    child: Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Text(
                                      'No Travellers Added',
                                      style: TextStyle(
                                          color: redColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                : Table(
                                    border: const TableBorder(
                                      horizontalInside: BorderSide(
                                        width: 1, // Width of the row separator
                                        color: Colors
                                            .grey, // Color of the row separator
                                      ),
                                      top: BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey, // Bottom border of the table
                                      ),
                                    ),

                                    columnWidths: const {
                                      0: FixedColumnWidth(120),
                                      1: FixedColumnWidth(80),
                                      2: FixedColumnWidth(70),
                                      3: FixedColumnWidth(70),
                                      4: FixedColumnWidth(80),
                                      5: FixedColumnWidth(70),
                                    },
                                    // defaultColumnWidth: FixedColumnWidth(100),
                                    children: members.map((member) {
                                      int index = members.indexOf(member);
                                      debugPrint('objectindex$index');
                                      return TableRow(
                                          // decoration:
                                          //     BoxDecoration(color: background),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  bottom: 10,
                                                  top: 10,
                                                  right: 10),
                                              child: Text(
                                                '${member['name'].toString().capitalizeFirstOfEach}',
                                                style: titleTextStyle1,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: Text(
                                                '${member['age']} ${member['ageUnit']}',
                                                style: titleTextStyle1,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(
                                                member['gender'],
                                                style: titleTextStyle1,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 10, bottom: 10),
                                              child: Text(
                                             
                                                member['type'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: member['type'] ==
                                                            'Senior'
                                                        ? redColor
                                                        : blackColor),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(
                                                member['price'] == 0
                                                    ? 'Free'
                                                    : member['price']
                                                        .toStringAsFixed(2),
                                                style: titleTextStyle1,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    child: const Icon(
                                                        Icons.edit,
                                                        color: greenColor),
                                                    onTap: () {
                                                      int age = int.parse(
                                                          member['age']
                                                              .toString());
                                                      String ageunit =
                                                          member['ageUnit']
                                                              .toString();
                                                      if (ageunit == 'Month') {
                                                        // _editInfantdMember(index);
                                                        _editMember(
                                                            title:
                                                                'Edit Infant',
                                                            index: index,
                                                            ageUnit: 'Month',
                                                            type: 'Infant');
                                                      } else {
                                                        if (age >= 18) {
                                                          // _editAdultMember(index);
                                                          _editMember(
                                                              title:
                                                                  'Edit Adult',
                                                              index: index,
                                                              ageUnit: 'Year',
                                                              type: 'Adult');
                                                        } else {
                                                          // _editChildMember(index);
                                                          _editMember(
                                                              title:
                                                                  'Edit Child',
                                                              index: index,
                                                              ageUnit: 'Year',
                                                              type: 'Child');
                                                          // addedChildCount++;
                                                        }
                                                      }
                                                      setState(() {
                                                        tableIcon = false;
                                                        // updateButtonStates();
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: redColor),
                                                    onTap: () {
                                                     
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                background,
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        top: 20,
                                                                        bottom:
                                                                            5),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Are you sure you want to delete this traveler ?',
                                                                      // textAlign:
                                                                      //     TextAlign
                                                                      //         .center,
                                                                      style:
                                                                          titleTextStyle,
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                    const Divider(
                                                                        height:
                                                                            0),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        IconButton(
                                                                            padding: EdgeInsets
                                                                                .zero,
                                                                            onPressed:
                                                                                () {
                                                                              context.pop();
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.close,
                                                                              color: redColor,
                                                                              size: 24,
                                                                            )),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        IconButton(
                                                                            padding: EdgeInsets
                                                                                .zero,
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                members.removeAt(index);
                                                                                // addAmount(members);
                                                                                // member['ageUnit'].toString() == 'Month' ? null : _subAmount();
                                                                                _shouldDisableButton();
                                                                                _addAmount();
                                                                                tableIcon = false;
                                                                              });
                                                                              context.pop();
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.check,
                                                                              color: greenColor,
                                                                              size: 30,
                                                                            ))
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]);
                                    }).toList(),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80)
                  ],
                ),
              ),
              status
                  ? Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitCircle(
                              size: 60,
                              color: btnColor,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Please wait.....',
                              style: TextStyle(color: greenColor),
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    discountAmount == 0
                        ? "AED ${payAbleAmount.ceil()}"
                        : "AED ${discountAmount.ceil()}",
                    style: const TextStyle(
                        color: blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                // const Flexible(
                //   child: Text('(Inclusive of taxes)',
                //       style: TextStyle(color: blackColor)),
                // ),

                InkWell(
                  onTap: _showPaymentDailog,
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        // decorationColor: greenColor,
                        fontWeight: FontWeight.w600,
                        color: greenColor),
                  ),
                )
              ],
            ),
            CustomButtonSmall(
                width: 120,
                borderRadius: BorderRadius.circular(5),
                btnHeading: "BOOK NOW",
                elevation: 5,
                loading: bookingStatus,
                elevationReq: true,
                buttonColor: btnColor,
                disable: _shouldDisableButton(),
                // disable: amount == 0.0 ?  true : false,
                onTap: () {
                  debugPrint('ghjkjhjkj$primaryCountryCode');
                  if (members.isEmpty) {
                    Utils.toastMessage('Please add Members First');
                  } else if (controller[0].text.isEmpty) {
                    Utils.toastMessage('Please select date');
                    // Utils.flushBarErrorMessage("Please select date", context);
                  } else {
                    setState(() {
                      loader = true;
                    });
                    String razorpayId = '';
                    String bookingId = '';
                    Provider.of<PaymentCreateOrderIdViewModel>(context,
                            listen: false)
                        .paymentCreateOrderIdViewModelApi(
                      context: context,
                      amount: sumAmount,
                      userId: widget.userID,
                      taxAmount: taxAmount,
                      taxPercentage: taxPercentage,
                      discountAmount: disAmount,
                      totalPayableAmount:
                          discountAmount == 0 ? payAbleAmount : discountAmount,
                    )
                        .then((onValue) {
                      if (onValue?.status.httpCode == '200') {
                        setState(() {
                          razorpayId = onValue?.data.razorpayOrderId ?? '';
                        });
                        Provider.of<GetPackageBookingByIdViewModel>(
                                listen: false, context)
                            .fetchGetPackageBookingByIdViewModelApi(
                                context,
                                {
                                  "userId": widget.userID.toString(),
                                  "packageId": widget.packageID.toString(),
                                  "bookingDate": controller[0].text,
                                  "orderId": onValue?.data.orderId,
                                  "countryCode": primaryCountryCode
                                      .replaceAll("+", '')
                                      .trim(),
                                  "mobile": primaryNoController.text,
                                  "alternateMobileCountryCode":
                                      secondaryCountryCode,
                                  "alternateMobile": secondaryNoController.text,
                                  "offerCode": offerCode,
                                  "discountAmount":
                                      disAmount.toStringAsFixed(2),
                                  "numberOfMembers": members.length.toString(),
                                  "memberList": members,
                                  "packagePrice": sumAmount.toStringAsFixed(2),
                                  "taxAmount": taxAmount.toStringAsFixed(2),
                                  "taxPercentage": taxPercentage,
                                  "totalPayableAmount": discountAmount == 0
                                      ? payAbleAmount.ceil()
                                      : discountAmount.ceil()
                                },
                                widget.userID)
                            .then((onValue) {
                          setState(() {
                            bookingId = onValue?.data.packageBookingId ?? '';
                            print(',,,,,,,,,,,,,,,,,,,,,,,,,,,$bookingId');
                          });
                          if (onValue?.status.httpCode == '200') {
                            setState(() {
                              bookingId = onValue?.data.packageBookingId ?? '';
                            });
                            PaymentService paymentService = PaymentService(
                              context: context,
                              onPaymentError:
                                  (PaymentFailureResponse response) {
                                setState(() {
                                  loader = false;
                                  debugPrint(
                                      'onpaymentfail status  ,,,,,,,,,,${response.message}${response.code}');
                                });
                              },
                              onPaymentSuccess:
                                  (PaymentSuccessResponse response) {
                                debugPrint(
                                    'paymentResponse#${response.orderId}');
                                Provider.of<PaymentVerifyViewModel>(context,
                                        listen: false)
                                    .paymentVerifyViewModelApi(
                                        context: context,
                                        userId: widget.userID.toString(),
                                        paymentId: response.paymentId,
                                        razorpayOrderId: response.orderId,
                                        razorpaySignature: response.signature)
                                    .then(
                                  (value) {
                                    if (value?.status.httpCode == '200') {
                                      debugPrint(
                                          'payment verification is successfull${value?.data.transactionId}');
                                      debugPrint(response.orderId);
                                      debugPrint(
                                        response.paymentId,
                                      );
                                      debugPrint(response.signature);
                                      Provider.of<ConfirmPackageBookingViewModel>(
                                              context,
                                              listen: false)
                                          .confirmBooking(
                                              context: context,
                                              packageBookingId: bookingId,
                                              transactionId:
                                                  value?.data.transactionId ??
                                                      '',
                                              userId: widget.userID);
                                      // context.pop();
                                    }
                                  },
                                );
                                // Call verify payment function after successful payment
                                // _verifyPayment(context, response);
                              },
                            );
                            paymentService.openCheckout(
                                payableAmount: discountAmount == 0
                                    ? payAbleAmount
                                    : discountAmount,
                                razorpayOrderId: razorpayId,
                                coutryCode: profileUser?.countryCode,
                                mobileNo: profileUser?.mobile,
                                email: profileUser?.email);
                          }
                        });
                      }
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }

  void _showPaymentDailog() {
    bool isVisible = false;
    int selectedIndex = -1;
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: background,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Details',
                        style: buttonText,
                      ),
                      IconButton(
                          padding: const EdgeInsets.only(left: 15),
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: btnColor,
                          ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.packageActivityList.length,
                    itemBuilder: (context, index) {
                      var data = widget.packageActivityList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            minVerticalPadding: 0,
                            minTileHeight: 5,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              data.activity?.activityName ?? '',
                              style: selectedIndex == index
                                  ? buttonText
                                  : titleTextStyle,
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  setstate(() {
                                    // isVisible = !isVisible;
                                    selectedIndex = index;
                                  });
                                },
                                icon: Icon(
                                  isVisible
                                      // ignore: dead_code
                                      ? Icons.keyboard_arrow_up_outlined
                                      : Icons.keyboard_arrow_down_outlined,
                                  color: selectedIndex == index
                                      ? btnColor
                                      : blackColor,
                                )),
                          ),
                          Visibility(
                            visible: selectedIndex == index,
                            child: Column(
                              children: [
                                data.activity?.participantType
                                            ?.contains('INFANT') ==
                                        true
                                    ? discountTile(
                                        lable: 'Infant Discount',
                                        value: data
                                                    .activity
                                                    ?.ageGroupDiscountPercent
                                                    ?.infant ==
                                                100
                                            ? 'Free'
                                            : data
                                                        .activity
                                                        ?.ageGroupDiscountPercent
                                                        ?.infant ==
                                                    0
                                                ? 'No Discount'
                                                : '${data.activity?.ageGroupDiscountPercent?.infant ?? 0} %',
                                      )
                                    : const SizedBox.shrink(),
                                data.activity?.participantType
                                            ?.contains('CHILD') ==
                                        true
                                    ? discountTile(
                                        lable: 'Child Discount',
                                        value: data
                                                    .activity
                                                    ?.ageGroupDiscountPercent
                                                    ?.child ==
                                                100
                                            ? 'Free'
                                            : data
                                                        .activity
                                                        ?.ageGroupDiscountPercent
                                                        ?.child ==
                                                    0
                                                ? 'No Discount'
                                                : '${data.activity?.ageGroupDiscountPercent?.child ?? 0} %')
                                    : const SizedBox.shrink(),
                                data.activity?.participantType
                                            ?.contains('SENIOR') ==
                                        true
                                    ? discountTile(
                                        lable: 'Senior Discount',
                                        value: data
                                                    .activity
                                                    ?.ageGroupDiscountPercent
                                                    ?.senior ==
                                                100
                                            ? 'Free'
                                            : data
                                                        .activity
                                                        ?.ageGroupDiscountPercent
                                                        ?.senior ==
                                                    0
                                                ? 'No Discount'
                                                : '${data.activity?.ageGroupDiscountPercent?.senior ?? 0} %')
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                  const Divider(),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Package Amount',
                        style: titleTextStyle,
                      ),
                      Text(
                        'AED ${sumAmount.toStringAsFixed(2)}',
                        style: titleTextStyle1,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax Amount (5 %)',
                        style: titleTextStyle,
                      ),
                      Text(
                        '+ AED ${taxAmount.toStringAsFixed(2)}',
                        style: titleTextStyle1,
                      )
                    ],
                  ),
                  discountAmount == 0
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discount Amount',
                              style: titleTextStyle,
                            ),
                            Text(
                              discountAmount == 0
                                  ? '- AED ${discountAmount.toStringAsFixed(2)}'
                                  : '- AED ${disAmount.toStringAsFixed(2)}',
                              style: titleTextStyle1,
                            )
                          ],
                        ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payable Amount',
                        style: pageHeadingTextStyle,
                      ),
                      Column(
                        children: [
                          Text(
                            discountAmount == 0
                                ? 'AED ${payAbleAmount.ceil()}'
                                : 'AED ${discountAmount.ceil()}',
                            style: pageHeadingTextStyle,
                          ),
                          const Text('(Inclusive of Taxes)',
                              style: TextStyle(color: blackColor))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ));
          });
        });
  }

  discountTile({required String lable, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lable,
          style: titleTextStyle1,
        ),
        Text(
          value,
          style: titleTextStyle1,
        )
      ],
    );
  }
}

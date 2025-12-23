// ignore_for_file: use_build_context_synchronously, strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/calculate_price_model.dart' hide Status;
import 'package:flutter_cab/data/models/get_package_details_by_id_model.dart'
    hide Status;
import 'package:flutter_cab/data/models/traveller_model.dart';
import 'package:flutter_cab/view/customer/my_package/booking_payment_screen.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/add_traveller_icon_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_phonefield.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/view_model/package_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PackageBookingMemberPage extends StatefulWidget {
  final String userID;
  final double amt;
  final String bookingDate;
  final String packageID;
  final String venderId;
  final List<String> participantTypes;
  final List<PackageActivity> packageActivityList;
  final String currency;
  const PackageBookingMemberPage(
      {super.key,
      required this.userID,
      required this.packageID,
      required this.amt,
      required this.bookingDate,
      required this.venderId,
      required this.participantTypes,
      required this.packageActivityList,
      required this.currency});

  @override
  State<PackageBookingMemberPage> createState() =>
      _PackageBookingMemberPageState();
}

class _PackageBookingMemberPageState extends State<PackageBookingMemberPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController primaryNoController = TextEditingController();
  TextEditingController secondaryNoController = TextEditingController();
  List<Traveller> members = [];

  bool visibleSecondaryContact = false;
  String primaryCountryCode = '';
  String secondaryCountryCode = '971';
  double sumAmount = 0.0;
  bool isAddAdultDisabled = false;
  bool isAddChildDisabled = false;
  bool isAddInfentDisabled = false;
  bool get isProceedDisabled =>
      members.isEmpty || !members.any((m) => m.type == TravellerType.adult);

  Future<CalculatePriceModel?> getCalculatePrice(
      {required String participantType}) async {
    var resp = await context
        .read<GetCalculatePackagePriceViewModel>()
        .getPackageCalculateBookingPrice(
            context: context,
            packageId: widget.packageID,
            participantType: participantType);
    return resp;
  }

  String? _validateAge(TravellerType type, String? value) {
    if (value == null || value.isEmpty) return 'Enter age';
    final age = int.parse(value);

    switch (type) {
      case TravellerType.adult:
        return age < 18 || age > 99 ? '18–99 only' : null;

      case TravellerType.child:
        return age < 3 || age >= 18 ? '3–17 only' : null;
      case TravellerType.infant:
        return age < 1 || age > 24 ? '1–24 months only' : null;
      default:
        return null;
    }
  }

  TravellerType _resolveType(TravellerType base, int age) {
    if (base == TravellerType.adult && age >= 60) {
      return TravellerType.senior;
    }
    return base;
  }

  Future<double> _calculatePrice(TravellerType type) async {
    final apiType = {
      TravellerType.adult: 'ADULT',
      TravellerType.senior: 'SENIOR',
      TravellerType.child: 'CHILD',
      TravellerType.infant: 'INFANT',
    }[type]!;

    final resp = await getCalculatePrice(participantType: apiType);
    return resp?.data?.calculatedPrice ?? 0;
  }

  void _recalculateAmount() {
    sumAmount = members.fold(0, (sum, m) => sum + m.price);

    // taxAmount = sumAmount * 0.05;
    // payAbleAmount = sumAmount + taxAmount;
  }

  bool adultType = false;
  bool childType = false;
  bool infantType = false;
  bool seniorType = false;
  void checkParticipantTypes(List<String> normalizedTypes) {
    adultType = normalizedTypes.contains('ADULT');
    childType = normalizedTypes.contains('CHILD');
    infantType = normalizedTypes.contains('INFANT');
    seniorType = normalizedTypes.contains('SENIOR');
  }

  @override
  void initState() {
    super.initState();
    checkParticipantTypes(widget.participantTypes);
    _loadPrimaryContact();
  }

  Future<void> _loadPrimaryContact() async {
    final profile = Provider.of<UserProfileViewModel>(context, listen: false)
        .dataList
        .data
        ?.data;

    if (profile != null) {
      setState(() {
        primaryCountryCode = profile.countryCode;
        primaryNoController.text = profile.mobile;
        secondaryCountryCode = profile.countryCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus(); // 👈 unfocus when tapping outside
      },
      child: Scaffold(
          backgroundColor: bgGreyColor,
          appBar: AppBar(
            title: const Text('Package Booking Member'),
            backgroundColor: background,
          ),
          body: Column(
            children: [
              SizedBox(height: 10),
              //  Travel Info
              Card(
                color: background,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.date_range, color: btnColor),
                  title: const Text("Travel Date"),
                  subtitle: Text(widget.bookingDate),
                ),
              ),

              // Primary Contact
              Card(
                color: background,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.phone_android, color: Colors.green),
                  title: const Text("Primary Contact"),
                  subtitle:
                      Text('+$primaryCountryCode ${primaryNoController.text}'),
                  trailing: IconButton(
                    icon: Icon(
                      visibleSecondaryContact
                          ? Icons.remove_circle_outline
                          : Icons.add_circle_outline,
                      color:
                          visibleSecondaryContact ? Colors.red : Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        visibleSecondaryContact = !visibleSecondaryContact;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Visibility(
                visible: visibleSecondaryContact,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text('Secondary Contact ',
                              textAlign: TextAlign.start,
                              style: titleTextStyle),
                          Text('(Optional)',
                              textAlign: TextAlign.start,
                              style: titleTextStyle1),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Customphonefield(
                        initalCountryCode: secondaryCountryCode,
                        controller: secondaryNoController,
                        hintText: 'Enter phone number',
                        fillColor: background,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Text(
                      'Travellers Details',
                      style: TextStyle(
                        color: btnColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),

                    /// Adult
                    AddTravellerIconButton(
                      enabled: adultType,
                      icon: adultIcon,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        openTravellerSheet(baseType: TravellerType.adult);
                      },
                    ),

                    const SizedBox(width: 16),

                    /// Child
                    AddTravellerIconButton(
                      enabled: childType,
                      icon: childIcon,
                      size: 26,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        openTravellerSheet(baseType: TravellerType.child);
                      },
                    ),

                    const SizedBox(width: 16),

                    /// Infant
                    AddTravellerIconButton(
                      enabled: infantType,
                      icon: infantIcon,
                      showPlus: true,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        openTravellerSheet(baseType: TravellerType.infant);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                color: btnColor,
                thickness: 2,
                endIndent: 10,
                indent: 10,
              ),
              // Traveller List
              members.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text('Not yet added travellers',
                            style: TextStyle(
                                color: redColor, fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: members.length,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final t = members[index];
                          return Card(
                            color: background,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              horizontalTitleGap: 10,
                              leading: const CircleAvatar(
                                backgroundColor: btnColor,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text("${t.name} (${t.type.name})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "Age: ${t.age} ${t.type == TravellerType.infant ? 'M' : "Y"}  • Gender: ${t.gender}"),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${widget.currency} ${t.price}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Spacer(),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            openTravellerSheet(
                                              traveller: members[index],
                                              index: index,
                                              baseType: members[index].type,
                                            );
                                          },
                                          child: Icon(
                                            Icons.edit_square,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 22,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: background,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 20,
                                                                bottom: 5),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              'Are you sure you want to delete this traveler ?',
                                                              style:
                                                                  titleTextStyle,
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            const Divider(
                                                                height: 0),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                IconButton(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    onPressed:
                                                                        () {
                                                                      context
                                                                          .pop();
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color:
                                                                          redColor,
                                                                      size: 24,
                                                                    )),
                                                                const SizedBox(
                                                                    width: 10),
                                                                IconButton(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        members.removeAt(
                                                                            index);
                                                                        _recalculateAmount();
                                                                      });
                                                                      context
                                                                          .pop();
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .check,
                                                                      color:
                                                                          greenColor,
                                                                      size: 30,
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: redColor,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomButtonSmall(
                  btnHeading: 'Proceed',
                  disable: isProceedDisabled,
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    context.push('/package/pay_now',
                        extra: BookingPaymentScreen(
                            venderId: widget.venderId,
                            bookingId: widget.packageID,
                            bookingDate: widget.bookingDate,
                            primaryCountryCode: primaryCountryCode,
                            primaryNumber: primaryNoController.text,
                            secondaryCountryCode: secondaryCountryCode,
                            secondaryNumber: secondaryNoController.text,
                            sumAmount: sumAmount,
                            // taxAmount: taxAmount,
                            // payableAmount: payAbleAmount,
                            packageAmount: widget.amt,
                            memberDetails: members,
                            packageActivityList: widget.packageActivityList,
                            currency: widget.currency));
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  void openTravellerSheet({
    Traveller? traveller,
    int? index,
    required TravellerType baseType,
  }) {
    final isEdit = traveller != null;

    nameController.text = traveller?.name ?? '';
    ageController.text = traveller?.age.toString() ?? '';
    genderController.text = traveller?.gender ?? '';

    showBottomModal(
      title: isEdit ? 'Edit Traveller' : 'Add Traveller',
      btnHeading: isEdit ? 'UPDATE' : 'ADD',
      child: travellerForm(baseType),
      onTap: () async {
        if (!_formKey.currentState!.validate()) return;

        final age = int.parse(ageController.text);

        final finalType = _resolveType(baseType, age);
        if (finalType == TravellerType.senior && !seniorType) {
          Utils.toastMessage(
            'Senior travellers are not allowed for this package',
          );
          return;
        }

        final price = await _calculatePrice(finalType);

        final newTraveller = Traveller(
          name: nameController.text,
          age: age,
          gender: genderController.text,
          type: finalType,
          price: price,
          // activities: traveller?.activities ?? []
        );

        setState(() {
          if (isEdit) {
            members[index!] = newTraveller;
            Utils.toastSuccessMessage('Traveller Edit Successfully');
          } else {
            members.add(newTraveller);
            Utils.toastSuccessMessage('Traveller Added Successfully');
          }
          _recalculateAmount();
          debugPrint('total payable amount $sumAmount');
        });

        Navigator.pop(context);
      },
    );
  }

  Widget travellerForm(TravellerType type) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Customtextformfield(
            controller: nameController,
            hintText: 'Name',
            validator: (v) => v!.isEmpty ? 'Enter name' : null,
          ),
          const SizedBox(height: 10),
          Customtextformfield(
            controller: ageController,
            keyboardType: TextInputType.number,
            hintText:
                type == TravellerType.infant ? 'Age (Month)' : 'Age (Year)',
            validator: (v) => _validateAge(type, v),
          ),
          const SizedBox(height: 10),
          CustomDropdownButton(
            controller: genderController,
            itemsList: const ['Male', 'Female'],
            hintText: 'Gender',
            validator: (v) => v!.isEmpty ? 'Select gender' : null,
          ),
        ],
      ),
    );
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
}

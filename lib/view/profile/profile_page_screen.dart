import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/data/network/network_apiservice.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/data/models/get_vendor_by_id_model.dart'
    hide Status;
import 'package:flutter_cab/data/models/user_profile_model.dart' hide Status;
import 'package:flutter_cab/view_model/third_party_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_phonefield.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
// import 'package:flutter_cab/widgets/custom_mobile_number.dart';
import 'package:flutter_cab/widgets/custom_modal_bottom_sheet.dart';
import 'package:flutter_cab/widgets/image_picker_widget.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
// import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/view/auth_screens/change_password.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/vendor_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String user;
  final String userType;
  const ProfilePage({super.key, required this.user, required this.userType});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfileViewModel userProfileViewModel = UserProfileViewModel();

  NetworkApiService networkApiService = NetworkApiService();
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  String gender = '';
  String countryCode = '971';
  ProfileData userdata = ProfileData();
  late GetVendorByIdModel vendorData;
  late Status? status;
  var stateDropdownKey = UniqueKey();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  Future<void> _uploadImage(File file) async {
    try {
      String idKey = widget.userType == 'USER' ? 'userId' : 'vendorId';

      context.read<ProfileImageViewModel>().postProfileImageApi({
        idKey: widget.user,
        "image": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      }, widget.userType).then((onValue) {
        _getUser();
      });
    } catch (e) {
      debugPrint('error $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUser();
    });
  }

  void _getUser() async {
    if (widget.userType == 'USER') {
      await context.read<UserProfileViewModel>().fetchUserProfileViewModelApi();
      _setUserData();
    } else if (widget.userType == 'VENDOR') {
      await context.read<VendorViewModel>().getVendorByIdApi();
      _setUserData();
    }
  }

  void _setUserData() {
    if (widget.userType == 'USER') {
      final data = context.read<UserProfileViewModel>().dataList.data?.data;
      if (data != null) {
        firstNameController.text = data.firstName;
        lastNameController.text = data.lastName;
        genderController.text = data.gender;
        emailController.text = data.email;
        contactController.text = data.mobile;
        stateController.text = data.state;
        locationController.text = data.address;
        _countryController.text = data.country;
        countryCode = data.countryCode;
      }
    } else {
      final data = context.read<VendorViewModel>().vendorData.data?.data;
      if (data != null) {
        firstNameController.text = data.firstName ?? '';
        lastNameController.text = data.lastName ?? '';
        genderController.text = data.gender ?? '';
        emailController.text = data.email ?? '';
        contactController.text = data.mobile ?? '';
        stateController.text = data.state ?? '';
        locationController.text = data.address ?? '';
        _countryController.text = data.country ?? '';
        countryCode = data.countryCode ?? "";
      }
    }
    getCountry();
    getStateListApi(_countryController.text);
    setState(() {});
  }

  void getCountry() async {
    context.read<ThirdPartyViewModel>().getCountryList();
  }

  void getStateListApi(String country) async {
    try {
      context.read<ThirdPartyViewModel>().getStateList(country: country);
    } catch (e) {
      debugPrint('error $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    if (widget.userType == 'USER') {
      userdata = context.watch<UserProfileViewModel>().dataList.data?.data ??
          ProfileData();
      status = context.watch<UserProfileViewModel>().dataList.status;
    } else {
      vendorData = context.watch<VendorViewModel>().vendorData.data ??
          GetVendorByIdModel();
      status = context.watch<VendorViewModel>().vendorData.status;
    }
    var stateList = context.watch<ThirdPartyViewModel>().stateList.data;
    var countryList =
        context.watch<ThirdPartyViewModel>().getCountryListResponse.data;
    var isLoadingCountry =
        context.watch<ThirdPartyViewModel>().getCountryListResponse.status ==
            Status.loading;
    bool isLoadingState =
        context.watch<ThirdPartyViewModel>().stateList.status == Status.loading;
    final updateStatus =
        context.watch<UserProfileUpdateViewModel>().dataList.status;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: CustomAppBar(
        heading: "My Profile",
        rightIconOnTapReq: true,
        rightIconImage: edit,
        trailingIcon: false,
        rightIconOnTapOnTap: () => context.push("/profilePage/editProfilePage",
            extra: {'uId': userdata.userId}),
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
                    children: [
                      SizedBox(
                        height: 190,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                  // color: btnColor,
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                        profilebgImage,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            Positioned(
                              top: 75,
                              left: 0,
                              right: 0,
                              child: Center(
                                  child: Container(
                                height: 125,
                                width: 125,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(width: 4, color: btnColor)),
                                child: ImagePickerWidget(
                                  
                                  initialImageUrl: widget.userType == 'USER'
                                      ? userdata.profileImageUrl
                                      : vendorData
                                              .data?.vendorProfileImageUrl ??
                                          '',
                                  isEditable: true,
                                  onImageSelected: _uploadImage,
                                ),
                              )),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomModalbottomsheet(
                              title: 'Change Password',
                              isChangePassword: true,
                              child: ChangePassword(
                                  userId: widget.user,
                                  userType: widget.userType)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  isEditing ? Colors.grey : btnColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: isEditing ? 0 : 4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              side: BorderSide(
                                color:
                                    isEditing ? Colors.grey.shade400 : btnColor,
                                width: 1.5,
                              ),
                            ),
                            onPressed: isEditing
                                ? null
                                : () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            label: Text(
                              isEditing ? 'Editing...' : 'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 20,
                      ),
                      DetailItem(
                        readOnly: true,
                        icon: Icons.account_balance,
                        title: widget.userType == 'USER'
                            ? "Customer Id"
                            : 'Vendor Id',
                        controller: TextEditingController(text: widget.user),
                      ),
                      DetailItem(
                        readOnly: !isEditing,
                        icon: Icons.person,
                        title: 'First Name',
                        controller: firstNameController,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                      ),
                      DetailItem(
                        readOnly: !isEditing,
                        icon: Icons.person,
                        title: 'Last Name',
                        controller: lastNameController,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                      ),
                      DetailItem(
                        icon: Icons.male,
                        title: 'Gender',
                        readOnly: true,
                        controller: TextEditingController(text: gender),
                        child: CustomDropdownButton(
                          isEditable: isEditing,
                          withoutBorder: true,
                          controller: genderController,
                          // focusNode: focusNode3,
                          itemsList: const ['Male', 'Female'],
                          onChanged: (value) {
                            setState(() {
                              genderController.text = value ?? '';
                            });
                          },
                          hintText: 'Select Gender',
                        ),
                      ),
                      DetailItem(
                        readOnly: !isEditing,
                        icon: Icons.phone,
                        title: 'Contact No',
                        controller: contactController,
                        child: Customphonefield(
                            readOnly: !isEditing,
                            withoutBorder: true,
                            hintText: 'Enter phone number',
                            fillColor: background,
                            initalCountryCode: countryCode,
                            controller: contactController),
                        
                      ),
                      DetailItem(
                        readOnly: true,
                        icon: Icons.email,
                        title: 'Email',
                        controller: emailController,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please enter email address';
                          }
                          return null;
                        },
                      ),
                      DetailItem(
                        readOnly: true,
                        icon: Icons.public,
                        title: 'Country',
                        controller: _countryController.text.isNotEmpty
                            ? _countryController
                            : TextEditingController(text: ''),
                        child: CustomDropdownButton(
                          isEditable: isEditing,
                          withoutBorder: true,
                          isLoading: isLoadingCountry,
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
                          validator: (p0) => (p0 == null || p0.isEmpty)
                              ? 'Please select country'
                              : null,
                        ),
                      ),
                      DetailItem(
                        readOnly: !isEditing,
                        icon: Icons.location_city,
                        title: 'State',
                        controller: stateController,
                        child: CustomDropdownButton(
                          withoutBorder: true,
                          key: stateDropdownKey,
                          isEditable: isEditing,
                          controller: stateController,
                          // focusNode: focusNode3,
                          isLoading: isLoadingState,
                          itemsList:
                              stateList
                                  ?.map((stateName) => stateName)
                                  .toList() ??
                                  [],

                          onChanged: isLoadingState
                              ? null
                              : (value) {
                                  setState(() {
                                    stateController.text = value ?? '';
                                    locationController.clear();
                                  });
                                },
                          hintText: 'Select State',
                          validator: (p0) => (p0 == null || p0.isEmpty)
                              ? 'Please select state'
                              : null,
                        ),
                      ),
                      DetailItem(
                        readOnly: !isEditing,
                        icon: Icons.location_on,
                        title: 'Location',
                        controller: locationController,
                        child: CustomSearchLocation(
                          // focusNode: focusNode3,
                          isEditable: isEditing,
                          withoutBorder: true,
                          fillColor: background,
                          controller: locationController,
                          state: stateController.text,
                          // stateValidation: true,

                          hintText: 'Search location',
                        ),
                      ),
                      const SizedBox(height: 20),
                      isEditing
                          ? CustomButtonSmall(
                              height: 45,
                              loading: updateStatus == Status.loading,
                              btnHeading: 'Update',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  debugPrint('form validated');
                                  final String idKey = widget.userType == 'USER'
                                      ? 'userId'
                                      : 'vendorId';
                                  Map<String, dynamic> data = {
                                    "userType": widget.userType,
                                    idKey: widget.user,
                                    "firstName": firstNameController.text,
                                    "lastName": lastNameController.text,
                                    "address": locationController.text,
                                    "gender": genderController.text,
                                    "countryCode": countryCode,
                                    "mobile": contactController.text,
                                    "country": _countryController.text,
                                    "state": stateController.text
                                  };
                                  debugPrint('edit data.........$data');
                                  final success = await context
                                      .read<UserProfileUpdateViewModel>()
                                      .profileUpdateViewModelApi(
                                          body: data,
                                          userType: widget.userType);
                                  if (success) {
                                    setState(() {
                                      isEditing = false;
                                    });
                                    _getUser();
                                    Utils.toastSuccessMessage(
                                        'Profile Updated Successfully');
                                  }
                                }
                              },
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? child;
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const DetailItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.readOnly,
      required this.controller,
      this.child,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: btnColor),
              const SizedBox(width: 10),
              Text(title, style: titleTextStyle),
            ],
          ),
          // const SizedBox(height: 4),
          child ??
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: readOnly,
                controller: controller,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54))),
                validator: validator,
              ),
        ],
      ),
    );
  }
}

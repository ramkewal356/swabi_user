import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/model/user_profile_model.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:provider/provider.dart';

class EditProfiePage extends StatefulWidget {
  final String usrId;

  const EditProfiePage({super.key, required this.usrId});

  @override
  State<EditProfiePage> createState() => _EditProfiePageState();
}

class _EditProfiePageState extends State<EditProfiePage> {
  List<TextEditingController> controllers =
      List.generate(8, (index) => TextEditingController());
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();

  // GlobalKey _phoneFieldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  // String? cuntryCode;
  // String? cuntryCodeISO;
  String countryCode1 = 'AE';
  // String? mobileNumber;

  @override
  void initState() {
    // TODO: implement initState
    // fetchUserData();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        controllers[0].text = userData?.firstName ?? '';
        controllers[1].text = userData?.lastName ?? '';
        controllers[2].text = userData?.address ?? '';
        controllers[3].text = userData?.gender ?? '';
        controllers[4].text = userData?.countryCode ?? '971';
        controllers[5].text = userData?.mobile ?? '';
        controllers[6].text = userData?.country ?? 'United Arab Emirates';
        controllers[7].text = userData?.state ?? '';
        emailcontroller.text = userData?.email ?? '';
        var list = countries
            .where((code) =>
                code.dialCode == controllers[4].text.replaceAll('+', '').trim())
            .toList();
        if (list.isNotEmpty) {
          // controllers[4].text = list.first.dialCode;
          countryCode1 = list.first.code;
          print('isocode.................... ${list.first.code}');
        }
       
      });
      getCountry();
    });
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
                country: controllers[6].text);
      });
    } catch (e) {
      debugPrint('error $e');
    }
  }

 
  bool load = false;
  int visible = 0;

  ProfileData? userData;
  @override
  Widget build(BuildContext context) {
    userData = context.watch<UserProfileViewModel>().DataList.data?.data;
    debugPrint(userData.toString());
    debugPrint(widget.usrId.toString());
    bool status = context.watch<UserProfileUpdateViewModel>().isLoading;
    // List country =
    //     context.watch<GetCountryStateListViewModel>().getCountryListModel;
    List state =
        context.watch<GetCountryStateListViewModel>().getStateListModel;
    bool isLoadingState =
        context.watch<GetCountryStateListViewModel>().isLoading;
    return Scaffold(
      backgroundColor: bgGreyColor,
      // resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        heading: "Edit Profile",
      ),
      body: PageLayout_Page(
          child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text.rich(TextSpan(children: [
                TextSpan(text: 'First Name', style: titleTextStyle),
                const TextSpan(text: ' *', style: TextStyle(color: redColor))
              ])),
              const SizedBox(height: 5),
              Customtextformfield(
                focusNode: focusNode1,
                controller: controllers[0],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[\u0000-\u007F]*$'),
                  ),
                ],
                // prefixiconvisible: true,
                fillColor: background,
                img: user,
                hintText: 'First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              Text.rich(TextSpan(children: [
                TextSpan(text: 'Last Name', style: titleTextStyle),
                const TextSpan(text: ' *', style: TextStyle(color: redColor))
              ])),

              const SizedBox(height: 5),

              Customtextformfield(
                focusNode: focusNode2,
                controller: controllers[1],
                // prefixiconvisible: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^[\u0000-\u007F]*$'),
                  ),
                ],
                fillColor: background,
                img: user,
                hintText: 'Last Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: 'Gender', style: titleTextStyle),
                    const TextSpan(
                        text: ' *', style: TextStyle(color: redColor))
                  ]))),
              CustomDropdownButton(
                controller: controllers[3],
                // focusNode: focusNode3,
                itemsList: const ['Male', 'Female'],
                onChanged: (value) {
                  setState(() {
                    controllers[3].text = value ?? '';
                  });
                },
                hintText: 'Select Gender',
              ),
              const SizedBox(height: 10),

              Text.rich(TextSpan(children: [
                TextSpan(text: 'Email', style: titleTextStyle),
                const TextSpan(text: ' *', style: TextStyle(color: redColor))
              ])),
              const SizedBox(height: 5),

              Material(
                child: Customtextformfield(
                  // focusNode: focusNode2,
                  controller: emailcontroller,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  // prefixiconvisible: true,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  // ],
                  fillColor: background,
                  img: user,
                  hintText: 'Email',
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'Contact No', style: titleTextStyle),
                    const TextSpan(
                        text: ' *', style: TextStyle(color: redColor))
                  ])),
                ],
              ),
              const SizedBox(height: 5),
              CustomMobilenumber(
                  // width: AppDimension.getWidth(context) * .9,
                  fillColor: background,
                  textLength: 9,
                  keyboardType: TextInputType.phone,
                  countryCode: controllers[4].text,
                  controller: controllers[5],
                  hintText: 'Enter mobile number'),
              const SizedBox(height: 10),

              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: 'Country', style: titleTextStyle),
                    const TextSpan(
                        text: ' *', style: TextStyle(color: redColor))
                  ]))),
              Material(
                child: Customtextformfield(
                  // focusNode: focusNode2,
                  controller: controllers[6],
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
            
              const SizedBox(height: 10),

              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: 'State', style: titleTextStyle),
                    const TextSpan(
                        text: ' *', style: TextStyle(color: redColor))
                  ]))),

              CustomDropdownButton(
                controller: controllers[7],
                // focusNode: focusNode3,
                itemsList: state.map((state) {
                  return state['state_name'].toString();
                }).toList(),

                // itemsList: [],
                onChanged: isLoadingState
                    ? null
                    : (value) {
                        setState(() {
                          controllers[7].text = value ?? '';
                          controllers[2].clear();
                        });
                      },
                hintText: 'Select State',

                // validator: (p0) {
                //   if (p0 == null || p0.isEmpty) {
                //     return 'Please select gender';
                //   }
                //   return null;
                // },
              ),

              const SizedBox(height: 10),

              Text.rich(TextSpan(children: [
                TextSpan(text: 'Location', style: titleTextStyle),
                const TextSpan(text: ' *', style: TextStyle(color: redColor))
              ])),
              const SizedBox(height: 5),
            

              CustomSearchLocation(
                focusNode: focusNode3,
                fillColor: background,
                controller: controllers[2],
                state: controllers[7].text,
                // stateValidation: true,
                hintText: 'Search location',
              ),
              const SizedBox(height: 20),
            

              CustomButtonSmall(
                  btnHeading: "UPDATE",
                  loading: status,
                  onTap: () {
                    // load = true;
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> data = {
                        "userId": widget.usrId.toString(),
                        "firstName": controllers[0].text,
                        "lastName": controllers[1].text,
                        "address": controllers[2].text,
                        "gender": controllers[3].text,
                        "countryCode": controllers[4].text,
                        "mobile": controllers[5].text,
                        "country": controllers[6].text,

                        "state": controllers[7].text
                        // "country": 'United Arab Emirates',
                        // "state": 'Abu Zabi',
                      };
                      debugPrint('edit data.........$data');
                      setState(() {
                        debugPrint(data.toString());
                        debugPrint(data.toString());
                        debugPrint(widget.usrId.toString());
                      });
                      Provider.of<UserProfileUpdateViewModel>(context,
                              listen: false)
                          .fetchUserProfileUpdateViewModelApi(
                              context, data, widget.usrId);
                    }
                  }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      )),
    );
  }
}

// ignore_for_file: camel_case_types, depend_on_referenced_packages, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_cab/core/utils/validation.dart';
// import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/core/utils/validatorclass.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_phonefield.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/widgets/custom_text_widget.dart';
// import 'package:flutter_cab/widgets/custom_mobile_number.dart';
import 'package:flutter_cab/core/constants/assets.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/auth_view_model.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class registration_screen extends StatefulWidget {
  const registration_screen({super.key});

  @override
  State<registration_screen> createState() => _registration_screenState();
}

class _registration_screenState extends State<registration_screen> {
  List<TextEditingController> controller =
      List.generate(10, (index) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final addressFocus = FocusNode();
  final genderFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confPassFocus = FocusNode();

  bool load = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  // String? countryCode;
  String countryCode = '971';

  String? mobileNumber;
  String? _emailValidation(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter email';
      // return 'Please enter a valid email address';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String country = 'United Arab Emirates';
  // 'India';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCountry();
    });
    controller[8].text = country;
  }

  Dio? dio;
  String accessToken = '';
  void getCountry() async {
    try {
      Provider.of<GetCountryStateListViewModel>(context, listen: false)
          .getStateList(context: context, country: country);
    } catch (e) {
      debugPrint('error $e');
    }
  }

  @override
  void dispose() {
    controller[0].dispose();
    controller[1].dispose();
    controller[2].dispose();
    controller[3].dispose();
    controller[4].dispose();
    controller[5].dispose();
    controller[6].dispose();
    controller[7].dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    emailFocus.dispose();
    addressFocus.dispose();
    genderFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    confPassFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var status = context.watch<AuthViewModel>().signUpResponse.status;
    var state = context.watch<GetCountryStateListViewModel>().getStateNameModel;
    var sendOtpStatus = context.watch<AuthViewModel>().sendOtpResponse.status;
    bool isLoadingState =
        context.watch<GetCountryStateListViewModel>().isLoading;
    return Scaffold(
        backgroundColor: bgGreyColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(child: Image.asset(appLogo1)),
                    const SizedBox(height: 30),
                    const CustomTextWidget(
                        content: "Sign Up",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        maxline: 2,
                        align: TextAlign.start,
                        textColor: textColor),
                    Text(
                      'Create Your Account.',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        // color: Color.fromRGBO(0, 0, 0, 0.5)
                      ),
                    ),
                    const SizedBox(height: 10),
                    lableText('First Name'),
                    Customtextformfield(
                      focusNode: firstNameFocus,
                      controller: controller[0],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[\u0000-\u007F]*$'),
                        ),
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
                      focusNode: lastNameFocus,
                      controller: controller[1],
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[\u0000-\u007F]*$'),
                        ),
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
                        focusNode: emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        controller: controller[2],
                        fillColor: background,
                        hintText: 'xyz@gmail.com',
                        validator: _emailValidation),
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
                        controller: controller[8],
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
                      controller: controller[9],
                      // focusNode: focusNode3,
                      itemsList:
                          state?.map((stateName) => stateName).toList() ?? [],

                      onChanged: isLoadingState
                          ? null
                          : (value) {
                              setState(() {
                                controller[9].text = value ?? '';
                                controller[3].clear();
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
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Location', style: titleTextStyle),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: redColor))
                    ])),
                    const SizedBox(height: 5),
                    CustomSearchLocation(
                        focusNode: addressFocus,
                        fillColor: background,
                        controller: controller[3],
                        state: controller[9].text,
                        // stateValidation: true,
                        hintText: 'Search your location'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: 'Gender', style: titleTextStyle),
                        const TextSpan(
                            text: ' *', style: TextStyle(color: redColor))
                      ])),
                    ),
                    CustomDropdownButton(
                      controller: controller[4],
                      focusNode: genderFocus,
                      itemsList: const ['Male', 'Female'],
                      onChanged: (value) {
                        setState(() {
                          // controller[4].text = value ?? '';
                          debugPrint('cgghhh${controller[4].text}');
                        });
                      },
                      hintText: 'Select gender',
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Please select gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                            content: "Contact No",
                            textColor: blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        Text(
                          ' *',
                          style: TextStyle(color: redColor),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Customphonefield(
                      initalCountryCode: countryCode,
                      controller: controller[5],
                      hintText: 'Enter phone number',
                      fillColor: background,
                    ),
                    // CustomMobilenumber(
                    //     controller: controller[5],
                    //     fillColor: background,
                    //     textLength: 9,
                    //     hintText: 'Enter phone number',
                    //     countryCode: countryCode),
                    const SizedBox(height: 10),
                    lableText('Password'),
                    Customtextformfield(
                      focusNode: passwordFocus,
                      obscureText: !obscurePassword,
                      enableInteractiveSelection: obscurePassword,
                      controller: controller[6],
                      fillColor: background,
                      hintText: 'Enter your password',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[\u0000-\u007F]*$'),
                        ),
                      ],
                      suffixIcons: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        } else {
                          return Validatorclass.validatePassword(value);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    lableText('Confirm Password'),
                    Customtextformfield(
                      focusNode: confPassFocus,
                      obscureText: !obscureConfirmPassword,
                      enableInteractiveSelection: obscureConfirmPassword,
                      controller: controller[7],
                      fillColor: background,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[\u0000-\u007F]*$'),
                        ),
                      ],
                      suffixIcons: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                      hintText: 'Enter your confirm password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter confirm password';
                        } else if (value != controller[6].text) {
                          return 'Password do not match';
                        } else {
                          return Validatorclass.validatePassword(value);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomButtonBig(
                      btnHeading: "Sign Up",
                      loading: status == Status.loading ||
                          sendOtpStatus == Status.loading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, String> body = {
                            "firstName": controller[0].text,
                            "lastName": controller[1].text,
                            "countryCode": countryCode.toString(),
                            "mobile": controller[5].text,
                            "address": controller[3].text,
                            "gender": controller[4].text,
                            "email": controller[2].text,
                            "password": controller[6].text,
                            "country": controller[8].text,
                            "state": controller[9].text
                          };
                          context
                              .read<AuthViewModel>()
                              .fetchPostSingUp(context: context, body: body)
                              .then((value) {
                            if (value?.status?.httpCode == '200') {
                              final userPreference =
                                  context.read<UserViewModel>();

                              userPreference.clearRememberMe();
                              userPreference.allClear(context);
                              // Utils.toastSuccessMessage("SignUp Successfully");
                              context
                                  .read<AuthViewModel>()
                                  .sendOtp(
                                      context: context,
                                      emailId: controller[2].text.trim())
                                  .then((onValue) {
                                if (onValue?.status?.httpCode == '200') {
                                  context.push('/verifyOtp', extra: {
                                    "email": controller[2].text.trim(),
                                    "forVerify": true
                                  });
                                }
                              });
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    LoginSignUpBtn(
                      onTap: () => context.push("/login"),
                      btnHeading: 'Sign In',
                      sideHeading: 'Already have an account?',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ));
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

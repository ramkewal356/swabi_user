// ignore_for_file: camel_case_types, depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/data/validatorclass.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20%20Button/customdropdown_button.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_search_location.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/res/custom_mobile_number.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/registration_view_model.dart';
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
  GlobalKey _phoneFieldKey = GlobalKey();
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _phoneFieldKey = GlobalKey();
    });
    controller[8].text = country;
    getCountry();
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
                context: context, token: accessToken, country: country);
      });
    } catch (e) {
      debugPrint('error $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
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

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    isLoading = context.watch<PostSignUpViewModel>().loading;
    List state =
        context.watch<GetCountryStateListViewModel>().getStateListModel;
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
                    // CustomDropdownButton(
                    //   controller: controllers[6],
                    //   // focusNode: focusNode3,
                    //   itemsList: country.map((country) {
                    //     return country['country_name'].toString();
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       controllers[6].text = value ?? '';
                    //     });
                    //     Provider.of<GetCountryStateListViewModel>(context,
                    //             listen: false)
                    //         .getStateList(
                    //             context: context,
                    //             token: accessToken,
                    //             country: value ?? '');
                    //   },
                    //   hintText: 'Select Country',

                    //   // validator: (p0) {
                    //   //   if (p0 == null || p0.isEmpty) {
                    //   //     return 'Please select gender';
                    //   //   }
                    //   //   return null;
                    //   // },
                    // ),
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
                      itemsList: state.map((state) {
                        return state['state_name'].toString();
                      }).toList(),

                      // itemsList: [],
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
                    // FormField<String>(
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     validator: (value) {
                    //       if (controller[3].text.isEmpty) {
                    //         return 'Please enter address';
                    //       }
                    //       return null;
                    //     },
                    //     builder: (FormFieldState<String> field) {
                    //       return Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 0),
                    //             height: 50,
                    //             child: GooglePlaceAutoCompleteTextField(
                    //               focusNode: addressFocus,
                    //               textEditingController: controller[3],
                    //               boxDecoration: BoxDecoration(
                    //                   color: background,
                    //                   borderRadius: BorderRadius.circular(5),
                    //                   border: Border.all(
                    //                       color: naturalGreyColor
                    //                           .withOpacity(0.3))),
                    //               googleAPIKey:
                    //                   // "AIzaSyADRdiTbSYUR8oc6-ryM1F1NDNjkHDr0Yo",
                    //                   'AIzaSyDhKIUQ4QBoDuOsooDfNY_EjCG0MB7Ami8',
                    //               inputDecoration: InputDecoration(
                    //                 contentPadding: const EdgeInsets.symmetric(
                    //                     horizontal: 10, vertical: 10),
                    //                 isDense: true,
                    //                 hintText: "Search your location",
                    //                 border: const OutlineInputBorder(
                    //                     borderSide: BorderSide.none),
                    //                 hintStyle: textTitleHint,
                    //                 filled: true,
                    //                 fillColor: background,
                    //                 disabledBorder: const OutlineInputBorder(
                    //                     borderRadius: BorderRadius.all(
                    //                         Radius.circular(5)),
                    //                     borderSide: BorderSide.none),
                    //               ),
                    //               textStyle: titleTextStyle,
                    //               debounceTime: 400,
                    //               countries: ["ae"],
                    //               isLatLngRequired: true,

                    //               getPlaceDetailWithLatLng: (prediction) {
                    //                 print(
                    //                     "Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
                    //                 // You can use prediction.lat and prediction.lng here as needed
                    //                 // Example: Save them to variables or perform further actions
                    //               },

                    //               itemClick: (prediction) {
                    //                 if (prediction.description
                    //                         ?.contains(controller[9].text) ??
                    //                     false) {
                    //                   controller[3].text =
                    //                       prediction.description ?? "";
                    //                   controller[3].selection =
                    //                       TextSelection.fromPosition(
                    //                           TextPosition(
                    //                     offset:
                    //                         prediction.description?.length ?? 0,
                    //                   ));
                    //                   field.didChange(prediction.description);
                    //                 } else {
                    //                   // Show a validation message or feedback to the user if the location is not valid
                    //                   print(
                    //                       "Please select a location in Dubai.");
                    //                   Utils.toastMessage(
                    //                       "Please select a location in ${controller[9].text}");
                    //                 }
                    //                 // controller[3].text =
                    //                 //     prediction.description ?? "";
                    //                 // controller[3].selection =
                    //                 //     TextSelection.fromPosition(TextPosition(
                    //                 //         offset: prediction
                    //                 //                 .description?.length ??
                    //                 //             0));
                    //                 // field.didChange(prediction.description);
                    //               },
                    //               seperatedBuilder: const Divider(),

                    //               // OPTIONAL// If you want to customize list view item builder
                    //               itemBuilder: (context, index, prediction) {
                    //                 return Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 10, horizontal: 5),
                    //                   child: Container(
                    //                     // color: background,
                    //                     child: Row(
                    //                       children: [
                    //                         const Icon(
                    //                           Icons.location_on,
                    //                           size: 15,
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 7,
                    //                         ),
                    //                         Expanded(
                    //                             child: Text(
                    //                           prediction.description ?? "",
                    //                           style: titleTextStyle,
                    //                         ))
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //               isCrossBtnShown: false,

                    //               // default 600 ms ,
                    //             ),
                    //           ),
                    //           if (field.hasError)
                    //             Padding(
                    //               padding: const EdgeInsets.only(left: 10),
                    //               child: Text(
                    //                 field.errorText!,
                    //                 style: TextStyle(color: redColor),
                    //               ),
                    //             ),
                    //         ],
                    //       );
                    //     }),
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
                    CustomMobilenumber(
                        controller: controller[5],
                        fillColor: background,
                        textLength: 9,
                        hintText: 'Enter phone number',
                        countryCode: countryCode),
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
                      loading: isLoading,
                      onTap: () {
                        setState(() {
                          load = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            load = true;
                          });
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
                          Provider.of<PostSignUpViewModel>(context,
                                  listen: false)
                              .fetchPostSingUp(context: context, body: body)
                              .then((value) {
                            final userPreference = Provider.of<UserViewModel>(
                                context,
                                listen: false);
                            userPreference.clearRememberMe();
                            setState(() {
                              load = false;
                            });
                          });
                        } else {
                          setState(() {
                            load = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Login_SignUpBtn(
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

  lableText(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: title, style: titleTextStyle),
        const TextSpan(text: ' *', style: TextStyle(color: redColor))
      ])),
    );
  }
}

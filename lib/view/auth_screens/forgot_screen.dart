import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/common_page_layout.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/core/utils/dimensions.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/view_model/auth_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/response/status.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  TextEditingController forgetPassController = TextEditingController();
  bool isloading = false;
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
      return 'Please enter your email';
      // return 'Please enter a valid email address';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return PageLayoutPage(
            child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding:
                  EdgeInsets.only(top: AppDimension.getHeight(context) / 6),
              child: Center(
                  child: Image.asset('assets/images/Asset 233000 1.png')),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Forgot Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Enter your email to reset your password'),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: 'Enter your Email', style: titleTextStyle),
                        const TextSpan(
                            text: ' *', style: TextStyle(color: redColor))
                      ])),
                      // const CustomText(
                      //   content: 'Enter your Email',
                      //   // style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                      // ),
                      const SizedBox(
                        height: 4,
                      ),
                      Customtextformfield(
                        controller: email,
                        hintText: 'Email@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        fillColor: background,
                        validator: _emailValidation,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      CustomButtonSmall(
                          loading: viewModel.sendOtpResponse.status ==
                              Status.loading,
                          btnHeading: 'Submit',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                           
                              viewModel
                                  .sendOtp(
                                      context: context, emailId: email.text)
                                  .then((onValue) {
                                if (onValue?.status?.httpCode == '200') {
                                  // ignore: use_build_context_synchronously
                                  context.push('/verifyOtp',
                                      extra: {"email": email.text,"forVerify":false});
                                }
                              });
                            
                            }
                          }),
                      const SizedBox(height: 10),
                      LoginSignUpBtn(
                        onTap: () => context.push("/login"),
                        btnHeading: 'Sign In',
                        sideHeading: 'Back to ',
                      ),
                    ],
                  )),
            ),
          ]),
        ));
      },
    );
  }
}

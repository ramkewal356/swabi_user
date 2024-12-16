import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/data/validatorclass.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpass = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<ResetPasswordViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: bgGreyColor,
          body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                    child: Image.asset('assets/images/Asset 233000 1.png')),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(text: 'New password', style: titleTextStyle),
                          const TextSpan(
                              text: ' *', style: TextStyle(color: redColor))
                        ])),
                        const SizedBox(
                          height: 5,
                        ),
                        Customtextformfield(
                          focusNode: focusNode1,
                          fillColor: background,
                          obscureText: !obscurePassword,
                          enableInteractiveSelection: obscurePassword,
                          // obscuringCharacter: '*',
                          controller: password,
                          hintText: 'New password',
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
                              return 'Please enter new password';
                            } else {
                              return Validatorclass.validatePassword(value);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'Confirm new password',
                              style: titleTextStyle),
                          const TextSpan(
                              text: ' *', style: TextStyle(color: redColor))
                        ])),
                        const SizedBox(
                          height: 4,
                        ),
                        Customtextformfield(
                          focusNode: focusNode2,
                          fillColor: background,
                          obscureText: !obscureConfirmPassword,
                          enableInteractiveSelection: obscureConfirmPassword,
                          // obscuringCharacter: '*',
                          controller: confirmpass,
                          hintText: 'Confirm new password',
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
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter confirm password';
                            } else if (value != password.text) {
                              return "Password do not match";
                            } else {
                              return Validatorclass.validatePassword(value);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButtonSmall(
                            loading: viewModel.isLoading2,
                            btnHeading: 'Submit',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                viewModel.resetPassword(
                                    context: context,
                                    email: widget.email,
                                    password: password.text);
                              }
                            }),
                        const SizedBox(height: 10),
                        Login_SignUpBtn(
                          onTap: () => context.push("/login"),
                          btnHeading: 'Sign In',
                          sideHeading: 'Back to',
                        ),
                      ],
                    )),
              ),
            ]),
          ),
        );
      },
    );
  }
}

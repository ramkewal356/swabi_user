import 'package:flutter/material.dart';
import 'package:flutter_cab/data/validatorclass.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/view_model/auth_view_model.dart';

import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String usr = '';
  String pass = '';
  bool value = false;
  bool rememberMe = false;
  bool obsucePassword = true;
  // List<TextEditingController> controller =
  //     List.generate(2, (index) => TextEditingController());
  TextEditingController userNameControlller = TextEditingController();
  TextEditingController passwordControlller = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    savecredential();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   controller[0].dispose();
  //   controller[1].dispose();
  // }
  savecredential() async {
    final prefsData = await SharedPreferences.getInstance();
   
    setState(() {
      userNameControlller.text = prefsData.getString('email') ?? '';
      passwordControlller.text = prefsData.getString('password') ?? '';
      rememberMe = prefsData.getBool('remember') ?? false;
      debugPrint('email id ${userNameControlller.text}');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    focusNode1.dispose();
    focusNode2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewMode = Provider.of<AuthViewModel>(context);
    // String message = Provider.of<AuthViewModel>();
    return Scaffold(
      backgroundColor: bgGreyColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(child: Image.asset(appLogo1)),
                    // child: Center(child: Image.asset(appLogo1)),
                  ),
                  const CustomTextWidget(
                      content: "Sign In\nPlease sign in to your account",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      maxline: 2,
                      align: TextAlign.start,
                      textColor: textColor),
                  const SizedBox(height: 4),

                  ///Login Field
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: 'Enter your email', style: titleTextStyle),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: redColor))
                    ])),
                  ),
                  Customtextformfield(
                    focusNode: focusNode1,
                    controller: userNameControlller,
                    fillColor: background,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email',
                    validator: (value) {
                      return Validatorclass.validateEmail(value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Enter your password', style: titleTextStyle),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: redColor))
                    ])),
                  ),
                  Customtextformfield(
                    focusNode: focusNode2,
                    controller: passwordControlller,
                    obscureText: !obsucePassword,
                    enableInteractiveSelection: obsucePassword,
                    // obscuringCharacter: '*',
                    keyboardType: TextInputType.visiblePassword,
                    fillColor: background,
                    hintText: 'Enter your password',
                    suffixIcons: IconButton(
                      icon: Icon(
                        obsucePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obsucePassword = !obsucePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        activeColor: btnColor,
                        value: rememberMe,
                        onChanged: (bool? value) {
                          FocusScope.of(context).unfocus();
                          focusNode1.unfocus();
                          focusNode2.unfocus();
                          setState(() {
                            rememberMe = !rememberMe;
                            debugPrint('rememberMe $rememberMe');
                          });
                        },
                      ),
                      Expanded(
                          child: Text('Remember Me',
                              style: GoogleFonts.lato(
                                  // fontSize:
                                  //     AppDimension.getWidth(context) * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
                      TextButton(
                        onPressed: () {
                          context.push('/forgotPassword');
                        },
                        child: Text('Forgot your password?',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                color: Colors.green)),
                      ),
                    ],
                  ),
                  CustomButtonBig(
                    btnHeading: "Sign In",
                    loading: authViewMode.loading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                      
                        authViewMode.userLoginApi(
                            context: context,
                            email: userNameControlller.text,
                            password: passwordControlller.text,
                            rememberMe: rememberMe);
                      }
                      // context.push('/');
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Login_SignUpBtn(
                    onTap: () => context.push("/signup"),
                    btnHeading: 'Signup',
                    sideHeading: " Don't have an account ? ",
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

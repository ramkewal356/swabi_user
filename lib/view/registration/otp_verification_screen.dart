import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool isloading = false;
  late Timer _timer; // Timer object
  int _start = 60; // Initial countdown time in seconds
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _isButtonDisabled = true; // Disable the button when the timer starts
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false; // Enable the button when countdown is over
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('email....${widget.email}');

    return Consumer<ResetPasswordViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: bgGreyColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: Center(
                          child:
                              Image.asset('assets/images/Asset 233000 1.png')),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Verify OTP',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Enter the OTP sent to your email',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: PinCodeTextField(
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        cursorColor: Colors.black,
                        // errorTextMargin: const EdgeInsets.only(top: 20),
                        errorTextSpace: 22,
                        appContext: context,
                        length: 6,
                        onChanged: (value) {
                          // Handle changes in the OTP input
                          debugPrint(value);
                        },
                        onCompleted: (value) {
                          // Handle when the user completes entering the OTP
                          debugPrint("Completed: $value");
                        },
                        // You can customize the appearance of the input field
                        pinTheme: PinTheme(
                            borderWidth: 1,
                            activeBorderWidth: 1,
                            inactiveBorderWidth: 1,
                            selectedFillColor: Colors.white,
                            shape: PinCodeFieldShape.box,
                            inactiveFillColor: Colors.white,
                            activeFillColor: Colors.white,
                            inactiveColor: Colors.grey,
                            activeColor: const Color.fromRGBO(0, 0, 0, 0.5),
                            borderRadius: BorderRadius.circular(10)),
                        controller: _otpController,
                        // Validator function for OTP
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          if (value.length != 6) {
                            return 'OTP must be 6 digits long';
                          }
                          // You can add more custom validation here if needed
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButtonSmall(
                        loading: viewModel.isLoading1,
                        btnHeading: 'Verify OTP',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.verifyOtp(
                                context: context,
                                email: widget.email,
                                otp: _otpController.text);
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive the code?",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 10),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: _isButtonDisabled
                                ? null
                                : () {
                                    _otpController.clear();
                                    setState(() {
                                      _start = 60; // Reset the countdown timer
                                      _isButtonDisabled = true;
                                    });
                                    startTimer();
                                    viewModel.sendOtp(
                                        context: context, email: widget.email);
                                  },
                            child: viewModel.isLoading
                                ? const SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: greenColor,
                                    )),
                                  )
                                : Text(
                                    _isButtonDisabled
                                        ? 'Resend OTP ($_start seconds)'
                                        : 'Resend OTP',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: _isButtonDisabled
                                            ? btnColor
                                            : greenColor),
                                  ))
                      ],
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}

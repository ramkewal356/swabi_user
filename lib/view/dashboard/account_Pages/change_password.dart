import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/data/validatorclass.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/Custom%20Widgets/custom_textformfield.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:flutter_cab/utils/utils.dart';
import 'package:flutter_cab/view_model/user_profile_view_model.dart';
import 'package:flutter_cab/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import '../../../utils/color.dart';

class ChangePassword extends StatefulWidget {
  final String userId;
  const ChangePassword({super.key, required this.userId});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  UserViewModel userViewModel = UserViewModel();
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _focasNode1 = FocusNode();
  final _focasNode2 = FocusNode();
  final _focasNode3 = FocusNode();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _focasNode1.dispose();
    _focasNode2.dispose();
    _focasNode3.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> query = {
        "userId": widget.userId,
        "oldPassword": _oldPasswordController.text,
        "newPassword": _newPasswordController.text
      };

      // Proceed with password update logic
      try {
        setState(() {
          isLoading = true;
        });
        Provider.of<ChangePasswordViewModel>(context, listen: false)
            .changePasswordViewModelApi(context: context, query: query)
            .then((onValue) {
          if (onValue?.status.httpCode == '200') {
            Utils.toastSuccessMessage(
              'Password changed successfully',
            );
            setState(() {
              isLoading = false;
            });
            context.pop();
          }
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        debugPrint('error $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change password',
                  style: buttonText,
                ),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: Text(
                      'X',
                      textAlign: TextAlign.end,
                      style: buttonText,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
           
            Customtextformfield(
              fillColor: background,
              obscureText: !_obscureOldPassword,
              // obscuringCharacter: '*',
              controller: _oldPasswordController,
              enableInteractiveSelection: _obscureOldPassword,
              hintText: 'Enter current password',
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^[\u0000-\u007F]*$'),
                ),
              ],
              suffixIcons: IconButton(
                icon: Icon(
                  _obscureOldPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureOldPassword = !_obscureOldPassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter current password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
           
            Customtextformfield(
              fillColor: background,
              obscureText: !_obscureNewPassword,
              // obscuringCharacter: '*',
              enableInteractiveSelection: _obscureNewPassword,
              controller: _newPasswordController,
              hintText: 'Enter new password',
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^[\u0000-\u007F]*$'),
                ),
              ],
              suffixIcons: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
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
            const SizedBox(height: 10.0),
          
            Customtextformfield(
              fillColor: background,
              obscureText: !_obscureConfirmPassword,
              // obscuringCharacter: '*',
              enableInteractiveSelection: _obscureConfirmPassword,
              controller: _confirmPasswordController,
              hintText: 'Enter confirm new password',
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^[\u0000-\u007F]*$'),
                ),
              ],
              suffixIcons: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter confirm new password';
                } else if (value != _newPasswordController.text) {
                  return "Password do not match";
                } else {
                  return Validatorclass.validatePassword(value);
                }
              },
            ),
            const SizedBox(height: 20),
            // Spacer(),
            CustomButtonSmall(
              loading: isLoading,
              btnHeading: "Submit",
              onTap: () => _updatePassword(),
            ),
            // const SizedBox(height: 10),
          ],
        ),
      ),
    );
 
  }
}

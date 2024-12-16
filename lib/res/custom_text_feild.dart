import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';

class CustomTextFeildWidget extends StatefulWidget {
  const CustomTextFeildWidget({super.key});

  @override
  State<CustomTextFeildWidget> createState() => _CustomTextFeildWidgetState();
}

class _CustomTextFeildWidgetState extends State<CustomTextFeildWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        width: AppDimension.getWidth(context) * .9,
        decoration: BoxDecoration(
            border: Border.all(color: naturalGreyColor),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          decoration: InputDecoration(
              // contentPadding: EdgeInsets.only(top: 5),
              prefixIcon: const Icon(Icons.email_outlined),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye),
              ),
              border: const UnderlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}

class ValidationForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ValidationForm({super.key});

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Enter valid email';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: naturalGreyColor.withOpacity(0.3))),
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          filled: true,
          fillColor: background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // Example condition to decide whether to validate or not
          bool shouldValidate = true; // Adjust based on your logic
          if (shouldValidate) {
            return validateEmail(value);
          }
          return null; // Validation skipped
        },
      ),
     
    );
  }
}

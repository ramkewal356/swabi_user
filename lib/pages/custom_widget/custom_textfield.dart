import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String? Function(String?) validator;
  final String hintText;
  final bool? obscureText;
  const CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.validator,
      this.obscureText = false,
      required this.hintText});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
          obscureText: widget.obscureText ?? false,
          controller: widget.textEditingController,
          decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              filled: true,
              fillColor: const Color.fromRGBO(255, 255, 255, 1),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none)),
          keyboardType: TextInputType.emailAddress,
          validator: widget.validator),
    );
  }
}

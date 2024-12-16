import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFeild extends StatelessWidget {
  final FocusNode? focusNode;
  final String heading;
  final String img;
  final String hint;
  final bool headingReq;
  final bool prefixIcon;
  final bool suffixIcon;
  final bool obscure;
  final int? digitNumber;
  final bool number;
  final double? width;
  final bool readOnly;

  final TextEditingController controller;
  final Function(String)? onChange;

  const CustomTextFeild(
      {this.focusNode,
      this.heading = "",
      this.img = "",
      this.hint = "",
      required this.headingReq,
      this.suffixIcon = false,
      this.number = false,
      this.digitNumber,
      this.width,
      this.prefixIcon = false,
      this.obscure = false,
      required this.controller,
      this.readOnly = false,
      this.onChange,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingReq
            ? Text(heading, style: titleTextStyle)
            : const SizedBox.shrink(),
        headingReq ? const SizedBox(height: 5) : const SizedBox(),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          color: background,
          child: Container(
            height: 50,
            width: width ?? AppDimension.getWidth(context) * .7,
            decoration: BoxDecoration(
                color: background,
                border: Border.all(color: naturalGreyColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              focusNode: focusNode,
              readOnly: readOnly,
              obscureText: obscure,
              controller: controller,
              style: titleTextStyle,
              keyboardType: number ? TextInputType.number : null,
              onChanged: onChange != null ? (value) => onChange!(value) : null,
              inputFormatters: number
                  ? [LengthLimitingTextInputFormatter(digitNumber ?? 10)]
                  : null,
              decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(top: 5),
                  prefixIcon: prefixIcon
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            img,
                            color: naturalGreyColor,
                          ))
                      : null,
                  hintText: hint,
                  hintStyle: loginTextStyle,
                  suffixIcon: suffixIcon
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.remove_red_eye),
                        )
                      : null,
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: prefixIcon != true
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : null),
            ),
          ),
        )
      ],
    );
  }
}

class LoginTextFeild extends StatefulWidget {
  final FocusNode? focusNode;
  final String heading;
  final bool headingReq;
  final bool prefixIcon;
  final String img;
  final bool suffixIcon;
  final TextEditingController controller;
  bool obscure;
  final bool readOnly;
  final bool number;
  final String hint;
  final String? Function(String?)? validator;
  LoginTextFeild(
      {this.focusNode,
      this.heading = "",
      this.img = "",
      required this.headingReq,
      required this.controller,
      this.suffixIcon = false,
      this.prefixIcon = false,
      this.hint = "",
      this.number = false,
      this.obscure = false,
      this.readOnly = false,
      this.validator,
      super.key});

  @override
  State<LoginTextFeild> createState() => _LoginTextFeildState();
}

class _LoginTextFeildState extends State<LoginTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headingReq
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: widget.heading, style: titleTextStyle),
                  TextSpan(text: ' *', style: TextStyle(color: redColor))
                ])),
              )
            : const SizedBox.shrink(),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(5),
          color: background,
          child: Container(
            height: 50,
            width: AppDimension.getWidth(context) * .9,
            decoration: BoxDecoration(
                border: Border.all(color: naturalGreyColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(5),
                color: widget.readOnly ? curvePageColor : background),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              focusNode: widget.focusNode,
              obscuringCharacter: '*',
              readOnly: widget.readOnly,
              style: titleTextStyle,
              keyboardType: widget.number ? TextInputType.number : null,
              inputFormatters:
                  widget.number ? [LengthLimitingTextInputFormatter(10)] : null,
              obscureText: widget.obscure,
              controller: widget.controller,
              decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.lato(color: greyColor1),
                  // contentPadding: EdgeInsets.only(top: 5),
                  prefixIcon: widget.prefixIcon
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Image.asset(
                            widget.img,
                            height: 5,
                            width: 5,
                            color: naturalGreyColor,
                          ),
                        )
                      : null,
                  suffixIcon: widget.suffixIcon
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              widget.obscure = !widget.obscure;
                            });
                          },
                          icon: widget.obscure
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.remove_red_eye),
                        )
                      : null,
                  contentPadding: widget.prefixIcon || widget.suffixIcon
                      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 13)
                      : const EdgeInsets.symmetric(horizontal: 10),
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none)),
              validator: widget.validator,
            ),
          ),
        )
      ],
    );
  }
}

class CommonTextFeild extends StatefulWidget {
  final String heading;
  final bool headingReq;
  final bool prefixIcon;
  final bool initiValueReq;
  final String img;
  final bool suffixIcon;
  final TextEditingController? controller;
  final String initialValueText;
  bool obscure;
  final bool readOnly;
  final bool number;
  final String hint;
  CommonTextFeild(
      {this.heading = "",
      this.img = "",
      this.initialValueText = "",
      required this.headingReq,
      this.initiValueReq = false,
      this.controller,
      this.suffixIcon = false,
      this.prefixIcon = false,
      this.hint = "",
      this.number = false,
      this.obscure = false,
      this.readOnly = false,
      super.key});

  @override
  State<CommonTextFeild> createState() => _CommonTextFeildState();
}

class _CommonTextFeildState extends State<CommonTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headingReq
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(widget.heading, style: titleTextStyle),
              )
            : const SizedBox.shrink(),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 50,
            width: AppDimension.getWidth(context) * .9,
            decoration: BoxDecoration(
                border: Border.all(color: naturalGreyColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(5),
                color:
                    widget.readOnly ? greyColor1.withOpacity(.2) : background),
            child: TextFormField(
              obscuringCharacter: '*',
              readOnly: widget.readOnly,
              style: titleTextStyle1,
              keyboardType: widget.number ? TextInputType.number : null,
              inputFormatters:
                  widget.number ? [LengthLimitingTextInputFormatter(10)] : null,
              obscureText: widget.obscure,
              controller: widget.controller,
              initialValue:
                  widget.initiValueReq ? widget.initialValueText : null,
              decoration: InputDecoration(
                  hintText: widget.hint,
                  // contentPadding: EdgeInsets.only(top: 5),
                  prefixIcon: widget.prefixIcon
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Image.asset(
                            widget.img,
                            height: 5,
                            width: 5,
                            color: naturalGreyColor,
                          ),
                        )
                      : null,
                  suffixIcon: widget.suffixIcon
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              widget.obscure = !widget.obscure;
                            });
                          },
                          icon: widget.obscure
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.remove_red_eye),
                        )
                      : null,
                  contentPadding: widget.prefixIcon || widget.suffixIcon
                      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 13)
                      : const EdgeInsets.symmetric(horizontal: 10),
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
        )
      ],
    );
  }
}

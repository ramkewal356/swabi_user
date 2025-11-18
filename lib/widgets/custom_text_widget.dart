import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWidget extends StatelessWidget {
  final String content;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? align;
  final int? maxline;
  final bool sideLogo;
  final bool textEllipsis;
  const CustomTextWidget({
    super.key,
    required this.content,
    this.fontSize,
    this.fontWeight,
    this.align,
    this.textColor,
    this.textEllipsis = true,
    this.sideLogo = false,
    this.maxline,
  });

  @override
  Widget build(BuildContext context) {
    String addNewlineEvery20Chars(String input) {
      final buffer = StringBuffer();
      for (int i = 0; i < input.length; i++) {
        if (i > 0 && i % 60 == 0) {
          buffer.write('\n');
        }
        buffer.write(input[i]);
      }
      return buffer.toString();
    }

    return Row(
      children: [
        sideLogo
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  width: 5,
                  height: fontSize,
                  color: btnColor,
                ),
              )
            : const SizedBox(),
        Text(
          addNewlineEvery20Chars(content),
          style: GoogleFonts.lato(
            fontWeight: fontWeight ?? FontWeight.w500,
            color: textColor ?? textColor,
            fontSize: fontSize ?? 14,
          ),
          textAlign: align ?? TextAlign.center,
          overflow: textEllipsis ? TextOverflow.ellipsis : null,
          maxLines: maxline ?? 1,
        ),
      ],
    );
  }
}

class CustomText extends StatelessWidget {
  final String content;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? align;
  final int? maxline;
  final int? textLenght;
  final bool needTextLenght;
  final bool textEllipsis;
  const CustomText(
      {super.key,
      required this.content,
      this.fontSize,
      this.fontWeight,
      this.align,
      this.textColor,
      this.textEllipsis = true,
      this.maxline,
      this.needTextLenght = false,
      this.textLenght});

  @override
  Widget build(BuildContext context) {
    String addNewlineEvery20Chars(String input) {
      final buffer = StringBuffer();
      for (int i = 0; i < input.length; i++) {
        if (i > 0 && i % (textLenght ?? 60) == 0) {
          buffer.write('\n');
        }
        buffer.write(input[i]);
      }
      return buffer.toString();
    }

    return Text(
      needTextLenght ? addNewlineEvery20Chars(content) : content,
      style: GoogleFonts.lato(
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor ?? blackColor,
        fontSize: fontSize ?? 16,
      ),
      textAlign: align ?? TextAlign.center,
      overflow: textEllipsis ? TextOverflow.ellipsis : null,
      maxLines: maxline ?? 1,
    );
  }
}

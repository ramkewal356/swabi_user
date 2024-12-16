import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
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

class ExpandableTextWidget extends StatelessWidget {
  final TextAlign align;
  final String content;
  final double fontSize;
  final int maxline;
  final bool textEllipsis;
  final Color textColor;
  final FontWeight fontWeight;

  const ExpandableTextWidget({
    Key? key,
    required this.align,
    required this.content,
    required this.fontSize,
    required this.maxline,
    required this.textEllipsis,
    required this.textColor,
    required this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: align,
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
        overflow: textEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
      ),
      maxLines: maxline,
    );
  }
}

class ExpandableText extends StatefulWidget {
  final List<String> words;
  final int totalWords;
  final Color textColor;
  final Color redColor;

  const ExpandableText({
    Key? key,
    required this.words,
    required this.totalWords,
    required this.textColor,
    required this.redColor,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          align: TextAlign.start,
          content:
              widget.words.take(isExpanded ? widget.totalWords : 30).join(' '),
          fontSize: 12,
          maxline: 100,
          textEllipsis: true,
          textColor: widget.textColor,
          fontWeight: FontWeight.w200,
        ),
        if (widget.words.length >= 30)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'View Less' : 'View More',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: widget.redColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

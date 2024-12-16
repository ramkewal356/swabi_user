import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class CustomViewmoreViewless extends StatelessWidget {
  final String moreText;
  const CustomViewmoreViewless({super.key, required this.moreText});

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      '$moreText. ',
      trimCollapsedText: 'view more',
      trimExpandedText: 'view less',
      trimLength: 150,
      style: GoogleFonts.lato(
        fontSize: 15,
        color: blackColor,
        fontWeight: FontWeight.w400,
      ),
      moreStyle: const TextStyle(
          fontWeight: FontWeight.w600, color: greenColor, fontSize: 15),
      lessStyle: const TextStyle(
          fontWeight: FontWeight.w600, color: greenColor, fontSize: 15),
    );
  }
}

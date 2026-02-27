// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String text;
  const NoDataFoundWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_rounded, size: 64, color: greyColor1.withOpacity(0.5)),
        const SizedBox(height: 16),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: greyColor1,
          ),
        ),
      ],
    ));
  }
}

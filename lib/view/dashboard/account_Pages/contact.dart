import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20Page%20Layout/commonPage_Layout.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/assets.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgGreyColor,
      appBar: CustomAppBar(
        heading: "Contact",
      ),
      body: PageLayout_Page(
          child: Column(
            children: [
              SizedBox(height: 20),
               CustomContainer(
                img: email1,
                title: "Email",
                contect: "ev.support@example.com",
              ),
              SizedBox(height: 20),
              CustomContainer(
                img: phone1,
                title: "Call Us",
                contect: "(671) 555-0110",
              )
            ],
          )),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String img;
  final String title;
  final String contect;
  const CustomContainer({super.key, required this.img, required this.title, required this.contect});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
        borderRadius: BorderRadius.circular(10),
      color: background,
      child: Container(
        height: AppDimension.getHeight(context)*.2,
        width: AppDimension.getWidth(context)*.85,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: naturalGreyColor.withOpacity(0.3),),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50)
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(img),
              ),
            ),
            const SizedBox(height: 5),
            Text(title,style: GoogleFonts.lato(
              color: greyColor,
              fontSize: 16,
              fontWeight:FontWeight.w600
            ),),
            const SizedBox(height: 5),
            Text(contect,style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: 18,
                fontWeight:FontWeight.w600
            ),)

          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/res/custom_appbar_widget.dart';
import 'package:flutter_cab/utils/color.dart';

class TermCondition extends StatelessWidget {
  const TermCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: "Terms & Conditions",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Intro Card
            Card(
              color: background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Our Terms & Conditions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please read these terms and conditions carefully before using our services. "
                      "By accessing or using the app, you agree to be bound by these terms.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Section 1
            _section(
              "1. Usage Policy",
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. "
                  "Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices.",
            ),

            /// Section 2
            _section(
              "2. Privacy & Security",
              "We respect your privacy and are committed to protecting it. All user data is stored securely "
                  "and will not be shared without consent.",
            ),

            /// Section 3
            _section(
              "3. Payments & Refunds",
              "Payments must be completed before service confirmation. Refunds are subject to our refund policy "
                  "and may take 7–10 business days.",
            ),

            /// Section 4
            _section(
              "4. Termination",
              "We reserve the right to terminate or suspend your account if any terms are violated.",
            ),

            const SizedBox(height: 20),

            /// Agree Button
            Center(
              child: CustomButtonSmall(
                width: 200,
                height: 45,
                btnHeading: "I Agree",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 🔹 Helper widget for section formatting
  Widget _section(String title, String content) {
    return Card(
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.article, size: 20, color: btnColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String minimumBookingAmount;
  final String discountPercentage;
  final String maxDiscountAmount;
  final String code;
  final String description;
  final String endDate;
  final String termsAndConditions;

  const OfferCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.minimumBookingAmount,
    required this.discountPercentage,
    required this.maxDiscountAmount,
    required this.code,
    required this.endDate,
    required this.description,
    required this.termsAndConditions,
  });

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool isCopied = false;
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      setState(() {
        isCopied = true;
      });
      // Optionally reset "Copied" text after a few seconds
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isCopied = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Icon(Icons.local_offer, color: Colors.green),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrl,
                    width: 90,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Get ${widget.discountPercentage} % OFF on ${widget.title}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                          '● Min. Booking Amount: AED ${widget.minimumBookingAmount}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.black54)),
                      Text(
                          '● Max Discount Amount: AED ${widget.maxDiscountAmount}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.black54)),
                      Text('● Expire On: ${widget.endDate}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.black54))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade300, height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => copyToClipboard(widget.code),
                label: Text(isCopied ? "Copied" : widget.code,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                icon: Icon(
                  isCopied ? Icons.check : Icons.copy,
                  size: 16,
                  color: isCopied ? Colors.green : Colors.black,
                ),
                iconAlignment: IconAlignment.end,
              ),
              TextButton.icon(
                onPressed: () {
                  showCustomBottomSheet(context,
                      description: widget.description,
                      termsAndConditions: widget.termsAndConditions);
                },
                label: const Text("View T&C",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                icon: const Icon(Icons.arrow_forward_ios, size: 12),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

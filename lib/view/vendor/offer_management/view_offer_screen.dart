import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view_model/offer_view_model.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';

class ViewOfferScreen extends StatefulWidget {
  final String offerId;
  const ViewOfferScreen({super.key, required this.offerId});

  @override
  State<ViewOfferScreen> createState() => _ViewOfferScreenState();
}

class _ViewOfferScreenState extends State<ViewOfferScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      getOfferDetails();
    });
  }

  void getOfferDetails() {
    context.read<OfferViewModel>().getOfferDetailsApi(offerId: widget.offerId);
  }

  List<String> _splitTerms(String termsAndConditions) {
    // Split on \n, ; or . if used as delimiter, ignoring single line breaks in paragraphs
    // Prefer splitting on newlines, fallback to semicolon, then period.
    if (termsAndConditions.contains('\n')) {
      return termsAndConditions
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (termsAndConditions.contains(';')) {
      return termsAndConditions
          .split(';')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    // Don't split on '.' if it's a paragraph, only if obviously numbered/short.
    if (termsAndConditions.contains('.')) {
      // Only split when '.' appears at the end of a segment (to avoid decimal numbers)
      return termsAndConditions
          .split(RegExp(r'\.(\s|$)'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    // Fallback: one term
    return [termsAndConditions];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: const Text(
          "View Offer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: background,
      ),
      body: Consumer<OfferViewModel>(
        builder: (context, offerViewModel, child) {
          final offerResponse = offerViewModel.getOfferDetails;
          if (offerResponse.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (offerResponse.status == Status.error) {
            return Center(child: Text("Error: ${offerResponse.message}"));
          } else if (offerResponse.status == Status.completed &&
              offerResponse.data?.data != null) {
            final offer = offerResponse.data!.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: offer.imageUrl != null && offer.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              offer.imageUrl!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.image_not_supported,
                                size: 120,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 120,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      offer.offerName ?? "No Offer Name",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (offer.offerCode != null)
                    Row(
                      children: [
                        const Text("Code: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SelectableText(offer.offerCode!),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (offer.discountPercentage != null)
                    Row(
                      children: [
                        const Text("Discount: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            "${offer.discountPercentage?.toStringAsFixed(2) ?? "0"} %"),
                      ],
                    ),
                  if (offer.minimumBookingAmount != null)
                    const SizedBox(height: 10),
                  if (offer.minimumBookingAmount != null)
                    Row(
                      children: [
                        const Text("Minimum Booking Amount: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${offer.minimumBookingAmount}"),
                      ],
                    ),
                  if (offer.maxDiscountAmount != null)
                    const SizedBox(height: 10),
                  if (offer.maxDiscountAmount != null)
                    Row(
                      children: [
                        const Text("Max Discount Amount: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${offer.maxDiscountAmount}"),
                      ],
                    ),
                  if (offer.usageLimitPerUser != null)
                    const SizedBox(height: 10),
                  if (offer.usageLimitPerUser != null)
                    Row(
                      children: [
                        const Text("Usage Limit Per User: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${offer.usageLimitPerUser}"),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (offer.offerType != null)
                    Row(
                      children: [
                        const Text("Offer Type: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(offer.offerType ?? ""),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (offer.offerStatus != null)
                    Row(
                      children: [
                        const Text("Status: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(offer.offerStatus ?? ""),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (offer.startDate != null || offer.endDate != null)
                    Row(
                      children: [
                        if (offer.startDate != null)
                          Text("From: ${offer.startDate}   ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        if (offer.endDate != null)
                          Text("To: ${offer.endDate}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  const SizedBox(height: 18),
                  if (offer.description != null &&
                      offer.description!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Description:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(offer.description!),
                      ],
                    ),
                  const SizedBox(height: 18),
                  if (offer.termsAndConditions != null &&
                      offer.termsAndConditions!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Terms & Conditions:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        // Show numbered list
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._splitTerms(offer.termsAndConditions!)
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final term = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(child: Text(term)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No Offer details available."));
          }
        },
      ),
    );
  }
}

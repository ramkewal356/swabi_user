// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../data/models/get_my_enquiry_model.dart';

class ReusableInquiryCard extends StatelessWidget {
  final TravelInquiry? inquiry;
  final int bidCount;
  final VoidCallback? onTap;

  const ReusableInquiryCard({
    super.key,
    required this.inquiry,
    this.bidCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final countries = inquiry?.countries ?? [];
    final destinations = inquiry?.destinations ?? [];
    final bool multi = countries.length > 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Destination + Budget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _destinationHeader(
                    multi: multi,
                    countries: countries,
                    destinations: destinations,
                  ),
                ),
                Text(
                  "${inquiry?.currency ?? ''} ${inquiry?.budget ?? ''}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Info Chips
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _infoChip(Icons.hotel, inquiry?.accommodationPreferences ?? ''),
                _infoChip(Icons.restaurant, inquiry?.meals ?? ''),
                _infoChip(Icons.directions_car, inquiry?.transportation ?? ''),
              ],
            ),

            const SizedBox(height: 12),

            /// Date + Bid Count
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Builder(builder: (context) {
                    final hasTentative = inquiry?.tentativeDates != null &&
                        inquiry!.tentativeDates!.isNotEmpty;
                    return Text(
                      hasTentative
                          ? '${inquiry?.tentativeDates},${inquiry?.tentativeDays}Days'
                          : inquiry?.travelDates ?? 'No date selected',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    );
                  }),
                ),
                if (bidCount > 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      bidCount.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _destinationHeader({
    required bool multi,
    required List countries,
    required List destinations,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              multi ? Icons.public : Icons.location_on,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                multi
                    ? "Multi-Country Trip"
                    : (countries.isNotEmpty
                        ? countries.first.toString()
                        : "No Country"),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          multi ? countries.join(" • ") : destinations.join(" • "),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

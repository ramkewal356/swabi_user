// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/data/models/get_all_bid_model.dart' as bid_model;
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/core/utils/validation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/get_all_enquiry_model.dart';
import 'bid_form_card.dart';

class BidNowScreen extends StatefulWidget {
  final EnquiryContent? enquiryData;
  final bid_model.BidContent? bidData;
  final bool viewPage;

  const BidNowScreen({
    super.key,
    this.enquiryData,
    this.bidData,
    this.viewPage = false,
  });

  @override
  State<BidNowScreen> createState() => _BidNowScreenState();
}

class _BidNowScreenState extends State<BidNowScreen> {
  EnquiryContent? get _enquiry {
    final direct = widget.enquiryData;
    if (direct != null) return direct;
    final travelInquiry = widget.bidData?.travelInquiry;
    if (travelInquiry != null) return travelInquiry;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final enquiry = _enquiry;
    final isClosed = enquiry?.status == false;
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          widget.bidData == null
              ? "Show Enquiry & Send Bid"
              : widget.viewPage
                  ? "View Enquiry & Bid"
                  : "Show Enquiry & Update Bid",
          style: appBarTitleStyle,
        ),
        backgroundColor: background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              /// Enquiry Card (or Bid's Enquiry Data)
              if (enquiry != null)
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: btnColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.travel_explore_rounded,
                              size: 18,
                              color: btnColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enquiry Details",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: greyColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Created ${dateFormat(enquiry.createdAt)}",
                                  style: GoogleFonts.poppins(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          _statusPill(isClosed: isClosed),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _infoRow(
                          _miniInfo(
                              Icons.tag_rounded, 'ID', '${enquiry.id ?? '-'}'),
                          _miniInfo(Icons.currency_rupee_rounded, 'Budget',
                              '${enquiry.currency ?? ''} ${enquiry.budget ?? 'N/A'}')),
                      const SizedBox(height: 14),
                      _infoRow(
                          _miniInfo(
                              Icons.group_rounded,
                              'Guests',
                              formatParticipantType(
                                enquiry.participantType,
                              )),
                          _miniInfo(
                              Icons.date_range_rounded,
                              (enquiry.travelDates ?? '').isEmpty
                                  ? 'Tentative'
                                  : 'Travel Dates',
                              (enquiry.travelDates ?? '').isEmpty
                                  ? "${enquiry.tentativeDates ?? '--'}${(enquiry.tentativeDays ?? '').isNotEmpty ? ' (${enquiry.tentativeDays} days)' : ''}"
                                  : (enquiry.travelDates ?? '--'))),
                      const SizedBox(height: 14),
                      _infoRow(
                        _miniInfo(
                          Icons.hotel_rounded,
                          "Accommodation",
                          enquiry.accommodationPreferences ?? '--',
                        ),
                        _miniInfo(
                          Icons.directions_bus_rounded,
                          'Transportation',
                          enquiry.transportation == 'Sheared'
                              ? 'Sheared (${enquiry.shareCount} People)'
                              : enquiry.transportation ?? '',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _infoRow(
                        _miniInfo(
                          Icons.restaurant_rounded,
                          'Meal Type',
                          (enquiry.mealType ?? '').isNotEmpty
                              ? enquiry.mealType ?? ''
                              : '--',
                        ),
                        _miniInfo(
                          Icons.map_outlined,
                          'Meals Per Day',
                          enquiry.mealsPerDay ?? "--",
                        ),
                      ),
                      const SizedBox(height: 14),
                      _infoRow(
                        _miniInfo(
                          Icons.public_rounded,
                          "Region",
                          enquiry.region ?? '--',
                        ),
                        _miniInfo(
                          Icons.flight_rounded,
                          "Country Type",
                          enquiry.countryType ?? '--',
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (enquiry.countryType == 'MULTI')
                        _chipsRow(
                          title: 'Countries',
                          icon: Icons.flag_rounded,
                          items: enquiry.countries ?? [],
                          emptyText: '--',
                        )
                      else
                        Column(
                          children: [
                            _chipsRow(
                              title: 'Country',
                              icon: Icons.flag_rounded,
                              items: enquiry.countries ?? [],
                              emptyText: '--',
                            ),
                            const SizedBox(height: 10),
                            _chipsRow(
                              title: 'Destinations',
                              icon: Icons.location_on_rounded,
                              items: enquiry.destinations ?? [],
                              emptyText: '--',
                            ),
                          ],
                        ),
                      const SizedBox(height: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.note_alt_rounded,
                                  size: 18, color: btnColor.withOpacity(0.7)),
                              const SizedBox(width: 8),
                              Text(
                                'Special Requests',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (enquiry.specialRequests == null ||
                              enquiry.specialRequests!.isEmpty)
                            Text(
                              '--',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: greyColor,
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                enquiry.specialRequests!.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    '${index + 1}. ${enquiry.specialRequests![index].request?.toString() ?? ""}',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (enquiry.user?.firstName != null ||
                          enquiry.user?.email != null ||
                          enquiry.user?.address != null) ...[
                        const SizedBox(height: 16),
                        _subTitle('Customer'),
                        const SizedBox(height: 8),
                        _userTile(enquiry),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              VendorBidFormCard(
                enquiryData: widget.enquiryData,
                bidData: widget.bidData,
                viewPage: widget.viewPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _miniInfo(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: btnColor.withOpacity(0.7)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: greyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _statusPill({required bool isClosed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isClosed
            ? btnColor.withOpacity(0.08)
            : greenColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        isClosed ? 'Closed' : "Active",
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isClosed ? btnColor : greenColor,
        ),
      ),
    );
  }

  Widget _subTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: greyColor,
      ),
    );
  }

  Widget _chipsRow({
    required String title,
    required IconData icon,
    required List<String> items,
    String emptyText = '--',
  }) {
    final cleaned =
        items.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: btnColor.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              if (cleaned.isEmpty)
                Text(
                  emptyText,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: greyColor,
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 0,
                  children: cleaned
                      .map(
                        (t) => Chip(
                          label: Text(
                            t,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          side:
                              BorderSide(color: Colors.black.withOpacity(0.06)),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userTile(EnquiryContent enquiry) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgGreyColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: btnColor,
            child: ClipOval(
              child: Image.network(
                enquiry.user?.profileImageUrl ??
                    'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                height: 52,
                width: 52,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 34,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${enquiry.user?.firstName} ${enquiry.user?.lastName}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: greyColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  enquiry.user?.email ?? 'Email: N/A',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: greyColor.withOpacity(0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  enquiry.user?.address ?? 'Address: N/A',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: greyColor.withOpacity(0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view/vendor/enquiry_management/enquiry_management_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/models/customer_model.dart';

class ViewCustomerScreen extends StatelessWidget {
  final Content? customerData;
  const ViewCustomerScreen({super.key, required this.customerData});

  String _formatDateTime(dynamic epochMillis) {
    if (epochMillis == null) return '-';
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(
          epochMillis is int ? epochMillis : int.parse('$epochMillis'));
      return DateFormat('d MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return '-';
    }
  }

  Widget _buildHeaderSection(BuildContext context, Content? customer) {
    final user = customer?.user;
    final String imageUrl = user?.profileImageUrl ?? '';
    final String fullName =
        '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
    final bool verified = user?.accountVerified == true;
    final bool status = user?.status == true;
    final String type = user?.userType?.toString().toUpperCase() ?? '';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [greenColor.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 22),
      child: Row(
        children: [
          imageUrl.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 44,
                  backgroundColor: Colors.grey.shade200,
                )
              : CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.green.shade200,
                  child: Text(
                    fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        fullName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    verified
                        ? Tooltip(
                            message: "Verified",
                            child: const Icon(Icons.verified,
                                color: Colors.green, size: 22))
                        : Tooltip(
                            message: "Not Verified",
                            child: const Icon(Icons.error_outline,
                                color: Colors.grey, size: 20)),
                  ],
                ),
                const SizedBox(height: 7),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        status ? "Active" : "Inactive",
                        style: TextStyle(
                            color: status ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor:
                          status ? Colors.green.shade50 : Colors.red.shade50,
                      visualDensity: VisualDensity.compact,
                    ),
                    Chip(
                      label: Text(
                        type,
                        style: const TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: Colors.blueGrey.shade50,
                      visualDensity: VisualDensity.compact,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
            color: greenColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Divider(
        color: Colors.grey.shade200,
        thickness: 1.2,
      ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String value, String? label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade600),
          if (label != null) ...[
            const SizedBox(width: 10),
            Text("$label:",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 15)),
            const SizedBox(width: 7),
          ] else
            const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      width: 135,
      height: 125,
      margin: const EdgeInsets.only(right: 14, bottom: 6, top: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(.27), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 20,
                  letterSpacing: .5)),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.black87),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget _buildUserDetailsSection(Content? customer) {
    final user = customer?.user;
    final String email = user?.email ?? '-';
    final String mobile = (user?.countryCode != null && user?.mobile != null)
        ? '+${user?.countryCode} ${user?.mobile}'
        : (user?.mobile ?? '-');
    final String address = user?.address ?? '-';
    final String gender = user?.gender ?? '-';
    final String lastLogin = user?.lastLogin ?? '-';
    final String country = user?.country ?? '-';
    final String state = user?.state ?? '-';
    final String createdDate =
        user?.createdDate?.toString().split(' ').first ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Contact"),
        _buildInfoRow(icon: Icons.email, value: email, label: "Email"),
        _buildInfoRow(icon: Icons.phone, value: mobile, label: "Mobile"),
        _buildInfoRow(
            icon: Icons.location_on, value: address, label: "Address"),
        _buildDivider(),
        _buildSectionTitle("Personal"),
        _buildInfoRow(icon: Icons.person, value: gender, label: "Gender"),
        _buildInfoRow(
            icon: Icons.calendar_today, value: createdDate, label: "Joined"),
        _buildInfoRow(
            icon: Icons.login_rounded, value: lastLogin, label: "Last Login"),
        _buildInfoRow(icon: Icons.language, value: country, label: "Country"),
        _buildInfoRow(
            icon: Icons.apartment_rounded, value: state, label: "State"),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, Content? customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Statistics"),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 4.0, bottom: 5),
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              GestureDetector(
                onTap: () {
                  context.push("/vendor_dashboard/rentalManagement", extra: {
                    "userId": customer?.user?.userId.toString(),
                  });
                },
                child: _buildStatCard(
                  context: context,
                  value: customer?.totalRentalBookings?.toString() ?? '0',
                  label: 'Rental Bookings',
                  icon: Icons.directions_car_filled,
                  color: Colors.orange,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push("/vendor_dashboard/package_booking_management",
                      extra: {
                        "userId": customer?.user?.userId.toString(),
                      });
                },
                child: _buildStatCard(
                  context: context,
                  value: customer?.totalPackageBookings?.toString() ?? '0',
                  label: 'Package Bookings',
                  icon: Icons.card_travel,
                  color: Colors.blue,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push("/vendor_dashboard/enquiryManagement",
                      extra: EnquiryManagementScreen(
                        userId: customer?.user?.userId.toString(),
                      ));
                },
                child: _buildStatCard(
                  context: context,
                  value: customer?.totalInquiries?.toString() ?? '0',
                  label: 'Inquiries',
                  icon: Icons.help_outline,
                  color: Colors.purple,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push("/vendor_dashboard/bidManagement", extra: {
                    "userId": customer?.user?.userId.toString(),
                  });
                },
                child: _buildStatCard(
                  context: context,
                  value: customer?.totalBids?.toString() ?? '0',
                  label: 'Bids',
                  icon: Icons.gavel,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 6, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 7),
              Text(
                "Last booking: ",
                style: TextStyle(
                    color: Colors.black87.withOpacity(.84),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                _formatDateTime(customer?.lastBookingDate),
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: greenColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text('Customer Details',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: customerData == null
          ? const Center(child: Text('No Customer Data'))
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(context, customerData),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 9,
                            offset: const Offset(1, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserDetailsSection(customerData),
                          _buildDivider(),
                          _buildStatsSection(context, customerData),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

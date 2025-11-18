import 'package:flutter/material.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
class IssueContainer extends StatelessWidget {
  final String issueId;
  final String bookingId;
  final String userId;
  final String status;
  final String issueDate;
  final String bookingType;
  final VoidCallback onTap;
  final bool loader;

  const IssueContainer({
    super.key,
    required this.issueId,
    required this.bookingId,
    required this.userId,
    required this.status,
    required this.issueDate,
    required this.bookingType,
    required this.loader,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row: Issue ID & Booking ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile(Icons.confirmation_number, "Issue ID", issueId),
                _infoTile(Icons.assignment, "Booking ID", bookingId),
              ],
            ),
            const SizedBox(height: 8),

            /// Booking Type & Date
            _infoTile(Icons.calendar_today, "Issue Date", issueDate),
            _infoTile(
                Icons.directions_car,
                "Booking Type",
                bookingType == "RENTAL_BOOKING"
                    ? "Rental Booking"
                    : "Package Booking"),

            const Divider(height: 20),

            /// Status & Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statusBadge(status),
                CustomButtonSmall(
                  loading: loader,
                  height: 40,
                  width: 130,
                  btnHeading: 'View Details',
                  onTap: onTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: btnColor),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    switch (status) {
      case "OPEN":
        bgColor = Colors.redAccent;
        break;
      case "IN_PROGRESS":
        bgColor = Colors.orangeAccent;
        break;
      default:
        bgColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: bgColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bgColor, width: 1),
      ),
      child: Text(
        status == "IN_PROGRESS" ? "In Progress" : status,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: bgColor,
        ),
      ),
    );
  }
}

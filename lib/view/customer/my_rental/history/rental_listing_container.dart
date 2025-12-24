// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';

class RentalCarListingContainer extends StatelessWidget {
  final String carOrCustomerName;
  final String date;
  final String chargeOrCarTpe;
  final String status;
  // final List<dynamic> images;
  final String time;
  final String bookingID;
  final String pickUplocation;
  final VoidCallback onTapContainer;
  // final bool loader;
  const RentalCarListingContainer(
      {super.key,
      required this.onTapContainer,
      required this.carOrCustomerName,
      required this.date,
      required this.time,
      // required this.images,
      required this.bookingID,
      required this.pickUplocation,
      required this.chargeOrCarTpe,
      // required this.loader,
      required this.status});
  Color _getStatusColor() {
    switch (status.toUpperCase()) {
      case "BOOKED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      case "COMPLETED":
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row (Booking ID + Status)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking Id : $bookingID",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Title (Customer or Vehicle)
            Text(
              carOrCustomerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 4),

            // Subtitle (Location)
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    pickUplocation,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10),
            const Divider(height: 18),

            // Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(date,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(time,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Extra Info + Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chargeOrCarTpe,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: onTapContainer,
                  icon: const Icon(Icons.remove_red_eye_outlined,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    
  }
}

import 'package:flutter/material.dart';

enum CountryType { single, multi }

class BidSpecialRequestModel {
  int? id;
  final TextEditingController controller;
  String status;
  // bool isVendorCreated;
  String? specialRejectionReason;
  BidSpecialRequestModel(
      {this.id,
      String? request,
      this.status = 'PENDING',
      // this.isVendorCreated = false
      this.specialRejectionReason})
      : controller = TextEditingController(text: request ?? '');

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'request': controller.text,
        'status': status,
        "specialRejectionReason": specialRejectionReason
      };
}

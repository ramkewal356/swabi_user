// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view_model/enquiry_view_model.dart';
import 'package:flutter_cab/widgets/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/widgets/Custom%20Widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

import '../../data/models/get_my_enquiry_model.dart';

class ReusableInquiryCard extends StatefulWidget {
  final TravelInquiry? inquiry;
  final int bidCount;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;

  /// New: Function called when close confirmed. Passes reason and inquiry id.
  final VoidCallback? onConfirmClose;

  const ReusableInquiryCard({
    super.key,
    required this.inquiry,
    this.bidCount = 0,
    this.onTap,
    this.onEditTap,
    this.onConfirmClose,
  });

  @override
  State<ReusableInquiryCard> createState() => _ReusableInquiryCardState();
}

class _ReusableInquiryCardState extends State<ReusableInquiryCard> {
  bool _isClosing = false;

  void _showCloseDialog(BuildContext context) async {
    final TextEditingController reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool submitting = false;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black54,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, setModalState) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: 20 + bottomInset,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Text(
                    'Close Enquiry',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Are you sure you want to close this enquiry? Please provide a reason.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Customtextformfield(
                    controller: reasonController,
                    hintText: 'Enter Reason',
                    minLines: 2,
                    maxLines: 4,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Please provide a reason";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: OutlinedButton(
                            onPressed: submitting
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            child: const Text('Cancel'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButtonSmall(
                          btnHeading: 'Close',
                          borderRadius: BorderRadius.circular(25),
                          height: 45,
                          loading: submitting,
                          onTap: submitting
                              ? null
                              : () async {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    setModalState(() => submitting = true);
                                    setState(() => _isClosing = true);

                                    try {
                                      // Integrate close enquiry API directly
                                      final inquiryId = widget.inquiry?.id;
                                      final reason =
                                          reasonController.text.trim();

                                      final Map<String, dynamic> closeBody = {
                                        "id": inquiryId,
                                        "reason": reason,
                                      };

                                      bool result = await context
                                          .read<EnquiryViewModel>()
                                          .closeEnquiryApi(body: closeBody);

                                      if (result) {
                                        if (widget.onConfirmClose != null) {
                                          widget.onConfirmClose!();
                                        }
                                        if (mounted) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    } catch (e) {
                                      debugPrint('error $e');
                                    } finally {
                                      setModalState(() => submitting = false);
                                      setState(() => _isClosing = false);
                                    }
                                  }
                                },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final inquiry = widget.inquiry;
    final countries = inquiry?.countries ?? [];
    final destinations = inquiry?.destinations ?? [];
    final bool multi = countries.length > 1;

    return GestureDetector(
      onTap: widget.onTap,
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row with ID and Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    inquiry?.id != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: btnColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "ID: ${inquiry!.id}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: btnColor,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const Spacer(),
                    if ((widget.inquiry?.bids
                            ?.any((bid) => bid.accepted == true) ??
                        false))
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          'Accepted',
                          style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    // Else, check if inquiry is closed (status==true)
                    else if (widget.inquiry?.status == false)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            color: redColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          'Closed',
                          style: TextStyle(color: redColor),
                        ),
                      )
                    else ...[
                      InkWell(
                        onTap: () async {
                          final hasBids =
                              (widget.inquiry?.bids?.isNotEmpty ?? false);
                          if (hasBids) {
                            final confirmed = await showModalBottomSheet<bool>(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(18)),
                              ),
                              isScrollControlled: true,
                              builder: (ctx) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 24,
                                    bottom:
                                        MediaQuery.of(ctx).viewInsets.bottom +
                                            24,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 40,
                                          height: 4,
                                          margin:
                                              const EdgeInsets.only(bottom: 18),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Notice',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Editing this enquiry with received bids will CANCEL the existing enquiry and create it as a NEW enquiry. Do you want to proceed?',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(height: 26),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(false),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: blackColor),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        btnColor)),
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(true),
                                            child: const Text(
                                              'Yes, Continue',
                                              style:
                                                  TextStyle(color: background),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            if (confirmed == true) {
                              widget.onEditTap?.call();
                            }
                          } else {
                            widget.onEditTap?.call();
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.edit,
                              size: 20, color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap:
                            _isClosing ? null : () => _showCloseDialog(context),
                        splashColor: Colors.grey,
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: _isClosing
                              ? SizedBox(
                                  height: 22,
                                  width: 22,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.grey[500],
                                  size: 24,
                                ),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 6),

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
                    _infoChip(
                        Icons.hotel, inquiry?.accommodationPreferences ?? ''),
                    _infoChip(Icons.restaurant, inquiry?.mealType ?? ''),
                    _infoChip(
                        Icons.directions_car, inquiry?.transportation ?? ''),
                  ],
                ),

                const SizedBox(height: 12),

                /// Date + Bid Count
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Builder(builder: (context) {
                        final hasTentative = inquiry?.tentativeDates != null &&
                            inquiry!.tentativeDates!.isNotEmpty;
                        return Text(
                          hasTentative
                              ? '${inquiry.tentativeDates}, ${inquiry.tentativeDays} Days'
                              : inquiry?.travelDates ?? 'No date selected',
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        );
                      }),
                    ),
                    if (widget.bidCount > 0)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          widget.bidCount.toString(),
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

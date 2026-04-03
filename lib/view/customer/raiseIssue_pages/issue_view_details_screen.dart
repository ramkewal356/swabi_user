import 'package:flutter/material.dart';
import 'package:flutter_cab/core/utils/utils.dart';
import 'package:flutter_cab/widgets/custom_appbar_widget.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/view_model/raise_issue_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IssueViewDetails extends StatefulWidget {
  final String issueId;
  final String userType;
  const IssueViewDetails(
      {super.key, required this.issueId, this.userType = 'USER'});

  @override
  State<IssueViewDetails> createState() => _IssueViewDetailsState();
}

class _IssueViewDetailsState extends State<IssueViewDetails> {
  bool _changingStatus = false; // For showing loading on button press
  final TextEditingController _resolutionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIssueById();
    });
  }

  void getIssueById() {
    context
        .read<RaiseissueViewModel>()
        .getRaiseIssueDetails(issueId: widget.issueId);
  }

  Future<void> _showChangeStatusConfirmation(
      BuildContext context, String issueId, String status) async {
    bool isToResolve = status == 'IN_PROGRESS';

    bool confirmed = false;
    String? resolutionDesc = '';

    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 24),
          child: StatefulBuilder(builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Change Status',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 14),
                    isToResolve
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'You are about to mark this issue as "Resolved". Please enter the resolution description:',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _resolutionController,
                                minLines: 2,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: "Resolution Description",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Resolution description is required.';
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setSheetState(() {});
                                },
                              ),
                            ],
                          )
                        : const Text(
                            'Are you sure you want to mark this issue as "In Progress"?'),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                          ),
                          onPressed: () async {
                            if (isToResolve) {
                              if (_formKey.currentState!.validate()) {
                                confirmed = true;
                                resolutionDesc =
                                    _resolutionController.text.trim();
                                Navigator.pop(ctx);
                              }
                            } else {
                              confirmed = true;
                              Navigator.pop(ctx);
                            }
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyle(color: background),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );

    if (confirmed) {
      await _changeStatus(
        issueId,
        status,
        resolutionDescription: isToResolve ? resolutionDesc! : '',
      );
    }
  }

  Future<void> _changeStatus(String issueId, String status,
      {String resolutionDescription = ''}) async {
    setState(() {
      _changingStatus = true;
    });
    try {
      var resp = await context.read<RaiseissueViewModel>().changeIssueStatus(
          issueId: issueId,
          newStatus: status == "OPEN"
              ? 'IN_PROGRESS'
              : status == 'IN_PROGRESS'
                  ? "RESOLVED"
                  : "",
          resolutionDescription: resolutionDescription);
      getIssueById(); // Refresh to update status
      if (context.mounted) {
        Utils.toastSuccessMessage(resp.data?.body ?? '');
      }
    } catch (e) {
      if (context.mounted) {
        Utils.toastMessage('Changed status failed');
      }
    }
    setState(() {
      _changingStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final issueData =
        context.watch<RaiseissueViewModel>().issueDetail.data?.data;

    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: const CustomAppBar(
        heading: 'Issue Details',
      ),
      body: issueData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  /// 🔹 Status Card
                  Card(
                    color: background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Status",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          _statusBadge(issueData.issueStatus ?? "OPEN"),
                          // The change status button has been REMOVED from header according to instruction.
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Issue Information
                  Card(
                    color: background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoTile(Icons.confirmation_number, "Issue ID",
                              issueData.issueId.toString()),
                          _infoTile(Icons.assignment, "Booking ID",
                              issueData.bookingId.toString()),
                          _infoTile(
                              Icons.calendar_today,
                              "Created Date",
                              DateFormat('dd-MM-yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      issueData.createdDate ?? 0))),
                          _infoTile(
                            Icons.directions_car,
                            "Booking Type",
                            issueData.bookingType == 'PACKAGE_BOOKING'
                                ? "Package Booking"
                                : "Rental Booking",
                          ),
                          _infoTile(Icons.description, "Issue Description",
                              issueData.issueDescription ?? ''),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 User Details
                  Card(
                    color: background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoTile(
                            Icons.confirmation_number,
                            "Raised By ID",
                            '${issueData.raisedById}',
                          ),
                          _infoTile(
                            Icons.badge,
                            "Raised By Type",
                            '${issueData.raisedByRole}',
                          ),
                          _infoTile(
                            Icons.person,
                            "User Name",
                            '${issueData.user?.firstName} ${issueData.user?.lastName}',
                          ),
                          _infoTile(
                            Icons.email,
                            "User Email",
                            issueData.user?.email ?? 'N/A',
                          ),
                          _infoTile(
                            Icons.phone,
                            "User Phone",
                            '+${issueData.user?.countryCode} ${issueData.user?.mobile}',
                          ),
                          _infoTile(
                            Icons.location_on_outlined,
                            "User Address",
                            issueData.user?.address ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.userType.toString().toUpperCase() == 'VENDOR') ...[
                    const SizedBox(height: 12),
                  ],

                  /// Show Change Status button only if user is vendor and issue is OPEN (not in the header/card)
                  if ((issueData.issueStatus ?? "OPEN") != "RESOLVED" &&
                      widget.userType.toString().toUpperCase() == "VENDOR")
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: _changingStatus
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: btnColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.edit, size: 18),
                          label: const Text(
                            'Change Status',
                            style: TextStyle(fontSize: 15),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: btnColor,
                            side: BorderSide(color: btnColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                          ),
                          onPressed: _changingStatus
                              ? null
                              : () => _showChangeStatusConfirmation(
                                  context,
                                  issueData.issueId.toString(),
                                  issueData.issueStatus ?? ''),
                        ),
                      ),
                    ),

                  /// 🔹 Resolution (if available)
                  if (issueData.resolutionDescription != null &&
                      issueData.resolutionDescription!.isNotEmpty)
                    Card(
                      color: background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Resolution",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const Divider(),
                            Text(
                              issueData.resolutionDescription ?? '',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  /// 🔹 Info Row with Icon
  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: btnColor),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Status Badge
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

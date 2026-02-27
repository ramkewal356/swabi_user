// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';
import 'package:flutter_cab/data/response/status.dart';
import 'package:flutter_cab/view_model/subscription_view_model.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String? _selectedPlanId; // To keep track of user-selected subscription

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      fetchSubscriptionList();
      fetchSubscriptionByVendor();
    });
  }

  void fetchSubscriptionList() {
    context.read<SubscriptionViewModel>().fetchSubscriptions();
  }

  void fetchSubscriptionByVendor() {
    context.read<SubscriptionViewModel>().fetchSubscriptionByVendorId();
  }

  // Redesign: Brighter, more distinctive colors and highlights for cards
  final Map<String, Gradient> planGradients = {
    "FREE": LinearGradient(
      colors: [
        Color(0xffE3F0FF),
        Color(0xffF8FBFF),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    "SILVER": LinearGradient(
      colors: [
        Color(0xffcccccc),
        Color(0xfffafafa),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    "GOLD": LinearGradient(
      colors: [
        Color(0xffF9D423),
        Color(0xffFF4E50),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    "PLATINUM": LinearGradient(
      colors: [
        Color(0xffdadada),
        Color(0xffB0F3F1),
        Color(0xffCBDFF1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };

  final Map<String, Color> planAccentColors = {
    // Better visible accents
    "FREE": Color(0xff5B7DB1), // Muted blue
    "SILVER": Color(0xff979AA4), // Strong gray
    "GOLD": Color(0xffF9B500), // Bright gold
    "PLATINUM": Color(0xff20C3AF), // Turquoise
  };

  Widget buildDetailRow(String leading, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2, right: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leading,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF484B52),
                  fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced card highlight: thicker border if selected and no box shadow color
  BoxDecoration cardDecoration({
    required Gradient gradient,
    required bool isSelected,
    required Color accent,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: gradient,
      border: Border.all(
        color: isSelected ? accent : accent.withOpacity(0.12),
        width: isSelected ? 4.8 : 1.1,
      ),
      boxShadow: isSelected
          ? [
              BoxShadow(
                // No color for the box shadow
                color: Colors.transparent,
                blurRadius: 24,
                spreadRadius: 4,
                offset: Offset(0, 8),
              ),
            ]
          : [
              BoxShadow(
                // No color for the box shadow
                color: Colors.transparent,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
      backgroundBlendMode: BlendMode.screen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
      appBar: AppBar(
        title: Text(
          "Choose Your Subscription",
          style: appBarTitleStyle,
        ),
        backgroundColor: background,
        elevation: 1.7,
        centerTitle: true,
      ),
      body: Consumer<SubscriptionViewModel>(
        builder: (context, vm, _) {
          if (vm.subscriptionResponse?.status == Status.loading ||
              vm.subscriptionByVendorResponse?.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.subscriptionResponse?.status == Status.error) {
            return Center(
              child: Text(
                "Unable to load plans. Try again.",
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          }

          // if (vm.subscriptionByVendorResponse?.status == Status.error) {
          //   return Center(
          //     child: Text(
          //       "Unable to determine your current plan. Try again.",
          //       style: TextStyle(color: Colors.redAccent),
          //     ),
          //   );
          // }

          final plans = vm.subscriptionResponse?.data ?? [];
          final vendorPlan = vm.subscriptionByVendorResponse?.data;
          final vendorPlanId = vendorPlan?.id;

          // User can select card, fallback to vendor active plan for highlight
          final String currentSelectedId =
              _selectedPlanId ?? vendorPlanId.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Text(
                    "Pick the perfect plan for your business.",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  const SizedBox(height: 18),
                  // Plans Grid
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: plans.map((plan) {
                      final gradient =
                          planGradients[plan.subscriptionType ?? ""] ??
                              LinearGradient(
                                colors: [Colors.white, Colors.white],
                              );

                      final accent =
                          planAccentColors[plan.subscriptionType ?? ""] ??
                              Colors.blueAccent;

                      final isSelected =
                          plan.id.toString() == currentSelectedId;

                      return SizedBox(
                        width: MediaQuery.of(context).size.width > 700
                            ? 340
                            : double.infinity,
                        child: Container(
                          // Removed animation color: use a normal Container, not AnimatedContainer
                          decoration: cardDecoration(
                            gradient: gradient,
                            isSelected: isSelected,
                            accent: accent,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 24),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(26),
                            onTap: () {
                              setState(() {
                                _selectedPlanId = plan.id.toString();
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (isSelected)
                                  Positioned(
                                    top: -18,
                                    right: -18,
                                    child: Icon(Icons.check_circle_rounded,
                                        color: accent.withOpacity(0.60),
                                        size: 68),
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            if (plan.subscriptionType ==
                                                "GOLD") {
                                              return LinearGradient(
                                                colors: [
                                                  Color(0xffFFD700),
                                                  Color(0xffFFB347),
                                                  Color(0xffFEF253),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds);
                                            }
                                            if (plan.subscriptionType ==
                                                "PLATINUM") {
                                              return LinearGradient(
                                                colors: [
                                                  Color(0xffB0F3F1),
                                                  Color(0xffCBDFF1),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds);
                                            }
                                            if (plan.subscriptionType ==
                                                "SILVER") {
                                              return LinearGradient(
                                                colors: [
                                                  Color(0xffC0C0C0),
                                                  Color(0xfffafafa),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds);
                                            }
                                            if (plan.subscriptionType ==
                                                "FREE") {
                                              return LinearGradient(
                                                colors: [
                                                  Color(0xffB1DFFF),
                                                  Color(0xffF8FBFF),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds);
                                            }
                                            return LinearGradient(
                                              colors: [accent, accent],
                                            ).createShader(bounds);
                                          },
                                          child: Text(
                                            "${plan.subscriptionType ?? ''} Plan",
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.3,
                                              color: Colors.black87,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white
                                                      .withOpacity(0.16),
                                                  offset: Offset(1.2, 1.2),
                                                  blurRadius: 1.2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          const SizedBox(width: 8),
                                          Icon(Icons.verified_rounded,
                                              color: accent, size: 28),
                                        ]
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: 44,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        gradient: LinearGradient(
                                          colors: [
                                            accent.withOpacity(0.95),
                                            accent.withOpacity(0.55)
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    buildDetailRow(
                                        "Price",
                                        plan.price == 0 || plan.price == 0.0
                                            ? "Free"
                                            : "AED ${plan.price?.toStringAsFixed(2)}"),
                                    buildDetailRow("Listing Limit",
                                        "${plan.listingLimit ?? '-'}"),
                                    buildDetailRow("Discount (%)",
                                        "${plan.discountPercent ?? '-'}%"),
                                    buildDetailRow("Support Level",
                                        plan.supportLevel ?? '-'),
                                    buildDetailRow(
                                        "Premium Listing Access",
                                        (plan.premiumListingAccess ?? false)
                                            ? "Yes"
                                            : "No"),
                                    buildDetailRow("Duration (Months)",
                                        "${plan.durationInMonths ?? "-"}"),
                                    buildDetailRow("Active",
                                        (plan.active == true) ? "Yes" : "No"),
                                    const SizedBox(height: 28),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: accent,
                                              // Use accent only, remove opacity/animation color
                                              minimumSize: const Size(80, 48),
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              elevation: 4,
                                              shadowColor: Colors
                                                  .transparent, // remove shadow color
                                            ),
                                            onPressed: isSelected
                                                ? null // Button disabled for already selected/highlighted
                                                : () async {
                                                    setState(() {
                                                      _selectedPlanId =
                                                          plan.id.toString();
                                                    });
                                                    // Here, you could trigger your subscribe logic
                                                  },
                                            child: Text(
                                              isSelected
                                                  ? "Current Plan"
                                                  : "Subscribe",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.6,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

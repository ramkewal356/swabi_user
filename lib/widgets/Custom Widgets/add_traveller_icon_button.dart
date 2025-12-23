import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';

class AddTravellerIconButton extends StatelessWidget {
  final bool enabled;
  final String icon;
  final VoidCallback onTap;
  final bool showPlus;
  final double size;

  const AddTravellerIconButton({
    super.key,
    required this.enabled,
    required this.icon,
    required this.onTap,
    this.showPlus = false,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Material(
        elevation: 4,
        // color: enabled ? bgGreyColor : greyColor1,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: enabled ? bgGreyColor : greyColor1,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: btnColor),
          ),
          child: Stack(
            children: [
              Image.asset(
                icon,
                width: size,
                height: size,
                color: btnColor,
              ),
              if (showPlus)
                const Positioned(
                  right: -4,
                  bottom: -4,
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 12,
                    color: btnColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

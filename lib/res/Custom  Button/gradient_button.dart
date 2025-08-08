import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  final List<Color>? colors;
  final IconData? icon;

  const GradientButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.colors,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8), // px-3 py-1.5
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors ??
                [
                  const Color(0xFFEF4444),
                  const Color(0xFFB91C1C)
                ], // from-red-500 to-red-700
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50), // rounded-full
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2), // shadow-md
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.check,
                color: Colors.white, size: 15), // text-white
            // items-center gap-1
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12, // text-xs
                fontWeight: FontWeight.w600,
                color: Colors.white, // text-white
              ),
            ),
          ],
        ),
      ),
    );
  }
}

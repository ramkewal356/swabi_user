import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  const SectionCard({
    super.key,
    required this.title,
    required this.children,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: btnColor, width: 4)),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

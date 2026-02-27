import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class AppRadioGroup<T> extends StatelessWidget {
  final List<AppRadioItem<T>> items;
  final T? groupValue;
  final Function(T?)? onChanged;
  final bool isEnabled;
  final Axis direction;

  const AppRadioGroup({
    super.key,
    required this.items,
    required this.groupValue,
    required this.onChanged,
    this.isEnabled = true,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final children = items.map((item) {
      return Expanded(
        child: RadioListTile<T>(
          dense: true,
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          activeColor: btnColor,
          title: Text(
            item.title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: item.value,
          groupValue: groupValue,
          selected: groupValue == item.value,
          onChanged: isEnabled ? onChanged : null,
        ),
      );
    }).toList();

    return direction == Axis.horizontal
        ? Row(children: children)
        : Column(children: children);
  }
}

class AppRadioItem<T> {
  final String title;
  final T value;

  AppRadioItem({required this.title, required this.value});
}

import 'package:flutter/material.dart';
import 'package:flutter_cab/res/custom_text_widget.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class DynamicCounter extends StatefulWidget {
  final String label;
  final int initialValue;
  final int limit;  // New parameter for the upper limit
  final Function(int) onChanged;

  const DynamicCounter({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.limit,  // Add this line
    required this.onChanged,
  }) : super(key: key);

  @override
  _DynamicCounterState createState() => _DynamicCounterState();
}

class _DynamicCounterState extends State<DynamicCounter> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
  }

  void _increment() {
    if (_count < widget.limit) {  // Check if count is less than the limit
      setState(() {
        _count++;
        widget.onChanged(_count);
      });
    }
  }

  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
        widget.onChanged(_count);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: textTitleHeading),
        const SizedBox(width: 8),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: naturalGreyColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _decrement,
                child: const SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(Icons.remove, color: btnColor),
                ),
              ),
              SizedBox(
                width: 20,
                child: CustomText(content: '$_count'),
              ),
              InkWell(
                onTap: _increment,
                child: const SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(Icons.add, color: btnColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
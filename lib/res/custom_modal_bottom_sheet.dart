import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:go_router/go_router.dart';

class CustomModalbottomsheet extends StatefulWidget {
  final String title;
  final Widget child;
  final bool? exit;
  const CustomModalbottomsheet(
      {super.key, required this.title, required this.child, this.exit = false});

  @override
  State<CustomModalbottomsheet> createState() => _CustomModalbottomsheetState();
}

class _CustomModalbottomsheetState extends State<CustomModalbottomsheet> {
  @override
  Widget build(BuildContext context) {
    return CustomButtonSmall(
        btnHeading: widget.title,
        onTap: () {
          widget.exit == true ? context.pop() : null;
          _showModalBottomSheet(context);
        });
  }

  Future<void> _showModalBottomSheet(BuildContext context) {
    print('chxzbcbxnzc xzbnmxbmn nbmnc xkjchnxmc x');
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: background,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: widget.child,
              ),
            );
          });
        });
  }
}

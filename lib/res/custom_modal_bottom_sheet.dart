import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:go_router/go_router.dart';

class CustomModalbottomsheet extends StatefulWidget {
  final String title;
  final Widget child;
  final bool? exit;
  final bool isChangePassword;
  final double? buttonHeight;
  final bool isDismissible;
  const CustomModalbottomsheet(
      {super.key,
      required this.title,
      required this.child,
      this.exit = false,
      this.buttonHeight,
      this.isDismissible = false,
      this.isChangePassword = false});

  @override
  State<CustomModalbottomsheet> createState() => _CustomModalbottomsheetState();
}

class _CustomModalbottomsheetState extends State<CustomModalbottomsheet> {
  @override
  Widget build(BuildContext context) {
    return widget.isChangePassword
        ? TextButton.icon(
            style: ButtonStyle(
              // ignore: deprecated_member_use
              side: MaterialStateProperty.all(
                const BorderSide(
                  color: btnColor, // Border color
                  width: 1.5, // Border width
                ),
              ),
              // ignore: deprecated_member_use
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: Rounded corners
                ),
              ),
            ),
            onPressed: () {
              widget.exit == true ? context.pop() : null;
              _showModalBottomSheet(context);
            },
            label: Text(
              widget.title,
              style:
                  const TextStyle(color: btnColor, fontWeight: FontWeight.w600),
            ),
            icon: const Icon(
              Icons.lock,
              color: btnColor,
            ),
          )
        : CustomButtonSmall(
            btnHeading: widget.title,
            height: widget.buttonHeight,
            onTap: () {
              widget.exit == true ? context.pop() : null;
              _showModalBottomSheet(context);
            });
  }

  Future<void> _showModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: widget.isDismissible,
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

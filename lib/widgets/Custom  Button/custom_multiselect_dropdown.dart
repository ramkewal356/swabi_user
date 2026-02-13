import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class CustomMultiselectDropdown extends StatefulWidget {
  final String title;
  final String hintText;
  final IconData? icon;
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onChanged;
  final GlobalKey<FormFieldState>? fieldKey;
  final String? Function(List<dynamic>?)? validator;
  final AutovalidateMode? autovalidateMode;
  final Color? bgColor;
  final bool isDisabled;
  final bool isLoading;
  const CustomMultiselectDropdown(
      {super.key,
      required this.title,
      required this.hintText,
      this.icon,
      this.fieldKey,
      required this.items,
      required this.onChanged,
      required this.selectedItems,
      this.autovalidateMode,
      this.validator,
      this.isDisabled = false,
      this.bgColor,
      this.isLoading = false});

  @override
  State<CustomMultiselectDropdown> createState() =>
      _CustomMultiselectDropdownState();
}

class _CustomMultiselectDropdownState extends State<CustomMultiselectDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            IgnorePointer(
              ignoring: widget.isDisabled || widget.isLoading,
              child: MultiSelectDialogField(
                key: widget.fieldKey,
                items: widget.isLoading
                    ? []
                    : widget.items
                    .map((destination) =>
                        MultiSelectItem<String>(destination, destination))
                    .toList(),
                selectedColor: btnColor,
                initialValue: widget.selectedItems,
                dialogWidth: MediaQuery.of(context).size.width * 0.9,
                dialogHeight: MediaQuery.of(context).size.height * 0.5,
                title: Text(widget.title),
                searchable: false,
                buttonText: const Text(""),
                buttonIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.transparent,
                ),

              
                backgroundColor: background,
                decoration: BoxDecoration(
                  color: widget.bgColor ?? Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                chipDisplay: MultiSelectChipDisplay.none(), // Hide default chip

                onConfirm: (values) =>
                    widget.onChanged(List<String>.from(values)),
                validator: widget.validator,
                autovalidateMode: widget.autovalidateMode ??
                    AutovalidateMode.onUserInteraction,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true, // so taps go to the MultiSelectDialogField
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                   
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: Colors.grey),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          widget.isLoading
                              ? "Loading..."
                              : widget.selectedItems.isEmpty
                                  ? widget.hintText
                                  : widget.selectedItems.join(", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.isLoading ? greyColor1 : textColor,
                          ),
                        ),
                      ),

                      if (widget.isLoading) ...[
                        const SizedBox(width: 10),
                        const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: btnColor,
                          ),
                        ),
                      ] else ...[
                        const Icon(Icons.arrow_drop_down, color: greyColor1),
                      ],
                      // Text(
                      //   widget.hintText,
                      //   style: TextStyle(color: greyColor1),
                      // )
                      // Expanded(
                      //   child: Text(
                      //     widget.selectedItems.isEmpty
                      //         ? widget.hintText
                      //         : widget.selectedItems.join(", "),
                      //     style: const TextStyle(color: Colors.black),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 6,
          runSpacing: 0,
          children: widget.selectedItems.map((value) {
            return Chip(
              backgroundColor: const Color(0xff7B1E34),
              label: Text(
                value,
                style: const TextStyle(color: Colors.white),
              ),
              deleteIcon: const Icon(Icons.close, color: Colors.white),
              onDeleted: () {
                final updatedList = List<String>.from(widget.selectedItems)
                  ..remove(value);
                widget.onChanged(updatedList);

                if (widget.fieldKey?.currentState != null) {
                  widget.fieldKey!.currentState!.didChange(updatedList);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

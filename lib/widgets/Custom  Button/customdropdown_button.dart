
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/common/styles/app_color.dart';
import 'package:flutter_cab/common/styles/text_styles.dart';

// ignore: must_be_immutable
class CustomDropdownButton extends StatefulWidget {
  String? selecteValue;
  final String? hintText;
  final List<String> itemsList;
  final Function(String?)? onChanged;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final List Function(BuildContext)? selectedItemBuilder;
  final String? Function(String?)? validator;
  final bool withoutBorder;
  final bool isEditable;
  final bool isLoading;
  CustomDropdownButton(
      {super.key,
      required this.itemsList,
      this.onChanged,
      required this.hintText,
      this.selecteValue,
      this.focusNode,
      required this.controller,
      this.selectedItemBuilder,
      this.validator,
      this.withoutBorder = false,
      this.isEditable = true,
      this.isLoading = false});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  void _update() {
    setState(() {
      debugPrint('selecteditem ${widget.controller.text}');
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.itemsList.toSet().toList();


    return FormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        initialValue: widget.controller.text,
        builder: (FormFieldState<String> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton2<String>(
                underline: Container(),
                isExpanded: true,
                hint: Text(
                  widget.isLoading
                      ? "Loading..."
                      : (widget.hintText ?? 'Select item'),
                  style: textTitleHint,
                  overflow: TextOverflow.ellipsis,
                ),

                // hint: Text(
                //   widget.hintText ?? 'Select item',
                //   textAlign: TextAlign.start,
                //   style: textTitleHint,
                //   overflow: TextOverflow.ellipsis,
                // ),
                items: widget.isLoading
                    ? []
                    : widget.itemsList
                    .toSet()
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: titleTextStyle1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                        .toList(),
                // value: widget.controller.text == ''
                //     ? null
                //     : widget.controller.text,
                value: items.contains(widget.controller.text)
                    ? widget.controller.text
                    : null,
                onChanged: (widget.isEditable && !widget.isLoading)
                    ? (value) {
                        setState(() {
                          // widget.selecteValue = value;
                          widget.controller.text = value ?? '';
                        });
                        field.didChange(value);
                        // setState(() {});
                        // if (widget.onChanged != null) {
                        widget.onChanged?.call(value);
                        // }
                      }
                    : null,
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  padding: widget.withoutBorder
                      ? const EdgeInsets.only(left: 0, right: 4, bottom: 2)
                      : const EdgeInsets.only(left: 0, right: 10),
                  decoration: widget.withoutBorder
                      ? const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black54,
                              width: 1.2,
                            ),
                          ),
                          // color: background,
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black26,
                            width: 1.2,
                          ),
                          color: background,
                        ),
                  elevation: 0,
                ),
                iconStyleData: IconStyleData(
                  icon: widget.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: btnColor,
                          ),
                        )
                      : const Icon(Icons.keyboard_arrow_down_outlined),
                  iconSize: 24,
                  iconEnabledColor: Colors.black38,
                  iconDisabledColor: Colors.grey,
                ),

                // iconStyleData: const IconStyleData(
                //   icon: Icon(
                //     Icons.keyboard_arrow_down_outlined,
                //   ),
                //   iconSize: 24,
                //   iconEnabledColor: Colors.black38,
                //   iconDisabledColor: Colors.grey,
                // ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 250,
                  // width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: background,
                  ),
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(20),
                    // ignore: deprecated_member_use
                    thickness: MaterialStateProperty.all(6),
                    thumbColor: WidgetStateProperty.all(btnColor),
                    // ignore: deprecated_member_use
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  overlayColor: WidgetStatePropertyAll(greenColor),
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    field.errorText!,
                    style: const TextStyle(color: redColor),
                  ),
                )
            ],
          );
        });
  }
}

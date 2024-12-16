import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/text_styles.dart';

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
  CustomDropdownButton(
      {super.key,
      required this.itemsList,
      this.onChanged,
      required this.hintText,
      this.selecteValue,
      this.focusNode,
      required this.controller,
      this.selectedItemBuilder,
      this.validator});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  bool isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
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
    // TODO: implement dispose
    widget.controller.removeListener(_update);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        builder: (FormFieldState<String> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton2<String>(
                underline: Container(),
                isExpanded: true,
                hint: Text(
                  widget.hintText ?? 'Select item',
                  textAlign: TextAlign.start,
                  style: textTitleHint,
                  overflow: TextOverflow.ellipsis,
                ),
                items: widget.itemsList
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
                value: widget.controller.text == ''
                    ? null
                    : widget.controller.text,
                onChanged: (value) {
                  setState(() {
                    // widget.selecteValue = value;
                    widget.controller.text = value ?? '';
                    print('controller  ${widget.controller.text}');
                  });
                  field.didChange(value);
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                  print(widget.selecteValue);
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  // width: 160,
                  padding: const EdgeInsets.only(left: 0, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black12,
                    ),
                    color: background,
                  ),
                  elevation: 0,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                  ),
                  iconSize: 24,
                  iconEnabledColor: Colors.black38,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  // width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: background,
                  ),
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(20),
                    thickness: MaterialStateProperty.all(6),
                    thumbColor: WidgetStateProperty.all(btnColor),
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
                    style: TextStyle(color: redColor),
                  ),
                )
            ],
          );
        });

    
  }
}

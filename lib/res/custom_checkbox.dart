import 'package:flutter/material.dart';
import 'package:flutter_cab/res/Custom%20%20Button/custom_btn.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/utils/dimensions.dart';
import 'package:flutter_cab/utils/text_styles.dart';

class CustomCheckBox extends StatelessWidget {
  final VoidCallback onTap;
  final String contect;
  final bool value;
  const CustomCheckBox({super.key,
    required this.onTap,
    required this.contect,
    required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 20,
              width: 20,
            decoration: BoxDecoration(
              color: value? Colors.black:Colors.transparent,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black,width: 2.5),
            ),
            child: value?const Icon(Icons.check,color: Colors.white,size: 15,):null,
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(contect,style: titleTextStyle,),
        )
      ],
    );
  }
}



class CustomButton extends StatefulWidget {
  final VoidCallback onTap;
  final List<Map<String, dynamic>> options;
  const CustomButton({super.key, required this.options, required this.onTap});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize selected value to the first option's value
    if (widget.options.isNotEmpty) {
      _selectedValue = widget.options[0]['value'];
    }
  }

  void _handleValueChange(bool value) {
    setState(() {
      _selectedValue = value;
    });
  }

  void _handleTap() {
    if (_selectedValue == true) {
      print('Your Self');
    } else {
      print("For Other's");
    }
    widget.onTap();  // Call the original onTap callback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...widget.options.map((option) {
          return _buildButton(option['value'], option['name']);
        }).toList(),
        const SizedBox(height: 10.0),
        CustomButtonSmall(
          width: AppDimension.getWidth(context) * .4,
          btnHeading: _selectedValue == widget.options[0]['value'] ? 'Book' : 'OK',
          onTap: _handleTap)
      ],
    );
  }

  Widget _buildButton(bool value, String label) {
    return GestureDetector(
      onTap: () => _handleValueChange(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 24.0,
              width: 24.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedValue == value ? btnColor : Colors.grey,
                  width: 2.0,
                ),
              ),
              child: _selectedValue == value
                  ? Center(
                child: Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: btnColor,
                  ),
                ),
              )
                  : Container(),
            ),
            const SizedBox(width: 10.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: _selectedValue == value ? Colors.black : greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RadioField extends StatefulWidget {
  final String title;
  final bool isSelected;

  const RadioField({
    Key? key,
    required this.title,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<RadioField> createState() => _RadioFieldState();
}

class _RadioFieldState extends State<RadioField> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: widget.isSelected ? btnColor : greyColor,
                width: 2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isSelected ? btnColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.isSelected ? textColor : Colors.grey,
                fontSize: 14,
                // fontFamily: inter,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
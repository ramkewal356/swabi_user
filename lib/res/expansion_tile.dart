
import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';

class ExpansionTileWidget extends StatefulWidget {
  final Widget header;
  final List<Widget> children;
  final bool column_crossAlign;

  const ExpansionTileWidget({super.key, 
    required this.header,
    required this.children,
    this.column_crossAlign = false,
  });

  @override
  ExpansionTileWidgetState createState() => ExpansionTileWidgetState();
}

class ExpansionTileWidgetState extends State<ExpansionTileWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
       crossAxisAlignment: widget.column_crossAlign?CrossAxisAlignment.start:CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (_isExpanded) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              });
            },
            child: Material(
              elevation: 0,
              color: background,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                decoration: BoxDecoration(
                  color:background,
                    borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: naturalGreyColor.withOpacity(0.3))
                ),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.header,
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.25).animate(_controller),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: lightBrownColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.children),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';

class CommonContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final double? elevation;
  final Color? color;
  final Color? borderColor;
  final EdgeInsets padding;
  final bool borderReq;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const CommonContainer(
      {super.key,
      this.child,
      this.height,
      this.width,
      this.elevation,
      this.onTap,
      this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
      this.borderRadius,
      this.borderReq = false,
      this.color, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      elevation: elevation ?? 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
              color: color ?? background,
              border: borderReq ? Border.all(color: borderColor ?? Colors.transparent) : null,
              borderRadius: borderRadius ?? BorderRadius.circular(10)),
          child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              child: child),
        ),
      ),
    );
  }
}

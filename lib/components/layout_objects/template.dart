import 'package:creator_content/components/layout_objects/constant.dart';
import 'package:flutter/material.dart';

class Templete extends StatelessWidget {
  final EdgeInsetsGeometry? customPadding;
  final bool addPaddingHorizontal;
  final Widget child;
  const Templete(
      {Key? key,
      required this.child,
      this.addPaddingHorizontal = false,
      this.customPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: customPadding ??
              EdgeInsets.symmetric(
                  vertical: LayoutConstant.paddingVertical,
                  horizontal: addPaddingHorizontal
                      ? LayoutConstant.paddingVertical
                      : 0.0),
          child: child,
        ),
      ],
    );
  }
}

import 'package:creator_content/components/layout_objects/constant.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:flutter/material.dart';

import '../chipWidget.dart';

class Templete extends StatelessWidget {
  final EdgeInsetsGeometry? customPadding;
  final bool addPaddingHorizontal;
  final bool isPreview;
  final ObjectContent? obj;
  final Widget child;
  const Templete(
      {Key? key,
      required this.child,
      this.addPaddingHorizontal = false,
      this.customPadding,
      this.obj,
      this.isPreview = false})
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
                      ? LayoutConstant.paddingHorizontal
                      : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              ViewHashTageWidget(
                tags: obj?.hashTags,
                isPreview: isPreview,
              )
            ],
          ),
        ),
      ],
    );
  }
}

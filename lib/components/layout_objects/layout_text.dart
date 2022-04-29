import 'package:creator_content/components/layout_objects/template.dart';
import 'package:creator_content/utils/open_link.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

class LayoutText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final bool canTap;
  const LayoutText({
    Key? key,
    required this.data,
    required this.style,
    this.canTap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Templete(
        customPadding: const EdgeInsets.symmetric(
            horizontal: LayoutConstant.paddingHorizontal,
            vertical: LayoutConstant.paddingVertical),
        child: GestureDetector(
          child: Text(data, style: style),
          onTap: canTap
              ? () async {
                  await OpenLink.open(data);
                }
              : null,
        ));
  }
}

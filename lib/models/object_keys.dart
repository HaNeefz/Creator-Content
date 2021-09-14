import 'package:creator_content/components/default_textfield.dart';
import 'package:creator_content/themes/color_constants.dart';
import 'package:flutter/material.dart';

class ObjectKeys {
  GlobalKey<DefaultTextFieldState> objKey;
  int objId;
  bool? textIsLarge;
  bool? textIsBold;
  bool? textIsItalic;
  bool? textIsUnderline;
  Color? color;

  ObjectKeys({
    required this.objId,
    required this.objKey,
    this.textIsLarge,
    this.textIsBold,
    this.textIsItalic,
    this.textIsUnderline,
    this.color,
  });

  setStyle(
      {bool isLarge = false,
      bool isBold = false,
      bool isItalic = false,
      bool isUnderline = false,
      Color color = ColorConstant.black}) {
    this.textIsLarge = isLarge;
    this.textIsBold = isBold;
    this.textIsItalic = isItalic;
    this.textIsUnderline = isUnderline;
    this.color = color;
  }

  printValue() {
    debugPrint(
      "objId: $objId\ntextIsLarge: $textIsLarge\ntextIsBold: $textIsBold\ntextIsItalic: $textIsItalic\ntextIsUnderline: $textIsUnderline\ncolor : $color",
    );
  }
}

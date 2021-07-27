import 'package:creator_content/components/default_textfield.dart';
import 'package:flutter/material.dart';

class ObjectKeys {
  GlobalKey<DefaultTextFieldState> objKey;
  int objId;
  bool? textIsLarge;
  bool? textIsBold;
  bool? textIsItalic;
  bool? textIsUnderline;

  ObjectKeys({
    required this.objId,
    required this.objKey,
    this.textIsLarge,
    this.textIsBold,
    this.textIsItalic,
    this.textIsUnderline,
  });

  setStyle(
      {bool isLarge = false,
      bool isBold = false,
      bool isItalic = false,
      bool isUnderline = false}) {
    textIsLarge = isLarge;
    textIsBold = isBold;
    textIsItalic = isItalic;
    textIsUnderline = isUnderline;
  }

  printValue() {
    debugPrint(
      "objId: $objId\ntextIsLarge: $textIsLarge\ntextIsBold: $textIsBold\ntextIsItalic: $textIsItalic\ntextIsUnderline: $textIsUnderline",
    );
  }
}

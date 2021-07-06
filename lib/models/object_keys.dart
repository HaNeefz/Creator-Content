import 'package:creator_content/components/default_textfield.dart';
import 'package:flutter/material.dart';

class ObjectKeys {
  final GlobalKey<DefaultTextFieldState> objKey;
  final int objId;

  ObjectKeys(this.objId, {required this.objKey});
}

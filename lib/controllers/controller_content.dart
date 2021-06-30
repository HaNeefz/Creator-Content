import 'dart:convert';

import 'package:creator_content/models/object_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/object_content.dart';

class ControllerContent extends GetxController {
  static ControllerContent get to => Get.find();
  var contents = <ObjectContent>[].obs;

  bool get hasContent => contents.length > 1;

  ObjectContent? firstItem;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    firstItem = ObjectContent(
      CONTENT_TYPE.CONTROLLER,
    );
    contents.add(firstItem!);
  }

  isFocus(int index) {
    return (_findIndexOfController() - 1 == index);
  }

  int _findIndexOfController() => contents.indexOf(firstItem);

  void addContent(ObjectContent objContent) {
    debugPrint("add index : ${_findIndexOfController()}");
    contents.insert(
        _findIndexOfController() == 0 ? 0 : _findIndexOfController(),
        objContent);
    // contents.add(objContent);
  }

  void removeContent() {
    debugPrint("remove index : ${_findIndexOfController()}");
    contents.removeAt(
        _findIndexOfController() == 0 ? 0 : _findIndexOfController() - 1);
  }

  bool isSwapUp([int? _currentIndex]) {
    int? currentIndex;
    if (_currentIndex != null) {
      currentIndex = _currentIndex;
    } else {
      currentIndex = _findIndexOfController();
    }
    return currentIndex - 1 >= 0;
  }

  bool isSwapDown([int? _currentIndex]) {
    int? currentIndex;
    if (_currentIndex != null) {
      currentIndex = _currentIndex;
    } else {
      currentIndex = _findIndexOfController();
    }
    return currentIndex + 1 < contents.length;
  }

  void swapUp() {
    int currentIndex = _findIndexOfController();
    if (isSwapUp(currentIndex)) {
      // ObjectContent temp = contents.elementAt(currentIndex - 1);
      // contents.insert(currentIndex, temp);
      contents.removeAt(currentIndex);
      contents.insert(currentIndex - 1, firstItem!);
      // contents.removeAt(currentIndex + 1);
    }
  }

  void swapDown() {
    int currentIndex = _findIndexOfController();
    if (isSwapDown(currentIndex)) {
      contents.removeAt(currentIndex);
      contents.insert(currentIndex + 1, firstItem!);
    }
  }

  onSaveData() {
    Map<String, dynamic> temp = {};
    contents.forEach((element) {
      temp.addAll(element.saveDataObj());
    });
    // var _temp = jsonEncode(temp);
    JsonEncoder encoder = JsonEncoder.withIndent(" ");
    String prettyprint = encoder.convert(temp);
    debugPrint(prettyprint);
    print(prettyprint);

    Get.defaultDialog(
      title: "Sendind data",
      content: SingleChildScrollView(
        child: Text(
          prettyprint,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

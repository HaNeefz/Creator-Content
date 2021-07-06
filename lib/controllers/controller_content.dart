import 'dart:convert';

import 'package:creator_content/components/default_textfield.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:creator_content/models/object_keys.dart';
import 'package:creator_content/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/object_content.dart';

class ControllerContent extends GetxController {
  static ControllerContent get to => Get.find();
  var contents = <ObjectContent>[].obs;
  var selectedContent = <int>{}.obs;
  var isSelectedContent = false.obs;
  var isEditLayout = false.obs;
  var isModify = false.obs;

  var _textIsBold = false.obs;
  var _textIsItalic = false.obs;
  var _textIsUnderline = false.obs;

  var objKeys = <ObjectKeys>[];
  var modifyIndexAt = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  bool get hasContent => contents.length > 1;

  bool get showIconDelete =>
      selectedContent.length > 0 && isSelectedContent.value;

  bool get isSelectedAll => selectedContent.length == contents.length;

  bool get hasEditObjectOrSelected =>
      isSelectedContent.value || isEditLayout.value;

  bool get hasModify => isModify.value;

  ObjectKeys _findKeysByObjId() {
    ObjectKeys key =
        objKeys.firstWhere((_objKeys) => _objKeys.objId == modifyIndexAt);
    return key;
  }

  void setBigText() =>
      _findKeysByObjId().objKey.currentState!.changeTextSize(TEXT_SIZE.BIG);

  void setNormalText() =>
      _findKeysByObjId().objKey.currentState!.changeTextSize(TEXT_SIZE.NORMAL);

  void setBoldText() {
    _findKeysByObjId().objKey.currentState!.changeTextSize(TEXT_SIZE.BOLD);
    _textIsBold.toggle();
  }

  void setItalicText() {
    _findKeysByObjId()
        .objKey
        .currentState!
        .changeTextDecoration(TEXT_STYLE.ITALIC);
    _textIsItalic.toggle();
  }

  void setUnderlineText() {
    _findKeysByObjId()
        .objKey
        .currentState!
        .changeTextDecoration(TEXT_STYLE.UNDERLINE);
    _textIsUnderline.toggle();
  }

  // void setLinethroughText() => _findKeysByObjId()
  //     .objKey
  //     .currentState!
  //     .changeTextDecoration(TEXT_STYLE.LINETHROUGH);

  bool get textIsBold => _textIsBold.value;
  bool get textIsItalic => _textIsItalic.value;
  bool get textIsUnderLine => _textIsUnderline.value;

  void getTextIsBold() {
    _textIsBold(_findKeysByObjId().objKey.currentState!.bold);
  }

  void getTextIsItalic() {
    _textIsItalic(_findKeysByObjId().objKey.currentState!.italic);
  }

  void getTextIsUnderline() {
    _textIsUnderline(_findKeysByObjId().objKey.currentState!.underline);
  }

  void confirmEditUI() {
    if (isEditLayout.value)
      onEditContent();
    else if (isSelectedContent.value)
      onSelectedObject();
    else
      onSaveData();
  }

  void addContent(ObjectContent objContent, {int? index}) {
    if (index == null)
      contents.add(objContent);
    else {
      contents.insert(index, objContent);
    }
    // if (objContent.type == CONTENT_TYPE.BULLET ||
    //     objContent.type == CONTENT_TYPE.TEXT ||
    //     objContent.type == CONTENT_TYPE.TEXT_BOLD ||
    //     objContent.type == CONTENT_TYPE.URL)
    objKeys.add(ObjectKeys(
      objContent.id!,
      objKey: GlobalKey<DefaultTextFieldState>(),
    ));
  }

  void selectedObj(int index) {
    if (selectedContent.contains(index))
      selectedContent.remove(index);
    else
      selectedContent.add(index);
  }

  void removeSelectedObject() {
    Popup.actions(
      'Are you sure delete.',
      onConfirm: () {
        selectedContent.forEach((objId) {
          contents.removeWhere((obj) => objId == obj.id);
        });
        selectedContent.clear();
        _checkCompletedOnEdit();
      },
    );
  }

  void _checkCompletedOnEdit() {
    if (contents.length == 0 && isEditLayout.value) isEditLayout.toggle();
  }

  void removeContentAt(int index) {
    contents.removeAt(index);
    _checkCompletedOnEdit();
  }

  onSelectedObject() {
    if (contents.length > 0) {
      isSelectedContent.toggle();
      if (!isSelectedContent.value) selectedContent.clear();
    } else if (contents.length == 0 && isSelectedContent.value) {
      isSelectedContent.toggle();
    } else
      Popup.error('No have object.');
  }

  onEditContent() {
    if (contents.length > 0) {
      isEditLayout.toggle();
    } else
      Popup.error('No have object.');
  }

  onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ObjectContent item = contents.removeAt(oldIndex);
    contents.insert(newIndex, item);
  }

  onModify([int? objId]) {
    isModify.toggle();
    if (objId != null) {
      modifyIndexAt = objId;
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

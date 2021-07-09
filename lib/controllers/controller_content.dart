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

  var lastFocus = FocusNode().obs;
  var contents = <ObjectContent>[].obs;
  var selectedContent = <int>{}.obs;
  var objKeys = <ObjectKeys>[].obs;
  var modifyIndexAt = 0.obs;
  var currentStyleObject =
      ObjectKeys(objId: 1, objKey: GlobalKey<DefaultTextFieldState>()).obs;
  var isSelectedContent = false.obs;
  var isEditLayout = false.obs;
  var isModify = false.obs;

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

  bool get isSelectedAll =>
      selectedContent.length == contents.length && contents.length > 0;

  bool get hasEditObjectOrSelected =>
      isSelectedContent.value || isEditLayout.value;

  bool get hasModify => isModify.value;

  ObjectKeys _findKeysByObjId() {
    ObjectKeys key =
        objKeys.firstWhere((_objKeys) => _objKeys.objId == modifyIndexAt.value);
    return key;
  }

  setCurrentStyleObj(ObjectKeys objStyle) {
    currentStyleObject.value.objId = objStyle.objId;
    currentStyleObject.value.objKey = objStyle.objKey;
    currentStyleObject.value.textIsLarge = objStyle.objKey.currentState!.large;
    currentStyleObject.value.textIsBold = objStyle.objKey.currentState!.bold;
    currentStyleObject.value.textIsItalic =
        objStyle.objKey.currentState!.italic;
    currentStyleObject.value.textIsUnderline =
        objStyle.objKey.currentState!.underline;
    currentStyleObject.update((val) {});
    currentStyleObject.value.printValue();
  }

  void setBigText() {
    _findKeysByObjId().objKey.currentState!.changeTextSize(TEXT_SIZE.BIG);
    setCurrentStyleObj(_findKeysByObjId());
  }

  void setNormalText() {
    _findKeysByObjId().objKey.currentState!.changeTextSize(TEXT_SIZE.NORMAL);
    setCurrentStyleObj(_findKeysByObjId());
  }

  void setBoldText() {
    _findKeysByObjId().objKey.currentState!.changeTextSize(TEXT_SIZE.BOLD);
    setCurrentStyleObj(_findKeysByObjId());
  }

  void setItalicText() {
    _findKeysByObjId()
        .objKey
        .currentState!
        .changeTextDecoration(TEXT_STYLE.ITALIC);
    setCurrentStyleObj(_findKeysByObjId());
  }

  void setUnderlineText() {
    _findKeysByObjId()
        .objKey
        .currentState!
        .changeTextDecoration(TEXT_STYLE.UNDERLINE);
    setCurrentStyleObj(_findKeysByObjId());
  }

  bool getTextIsLarge() {
    return currentStyleObject.value.textIsLarge ?? false;
  }

  bool getTextIsBold() {
    return currentStyleObject.value.textIsBold ?? false;
  }

  bool getTextIsItalic() {
    return currentStyleObject.value.textIsItalic ?? false;
  }

  bool getTextIsUnderline() {
    return currentStyleObject.value.textIsUnderline ?? false;
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
    //     // objContent.type == CONTENT_TYPE.TEXT_BOLD ||
    //     objContent.type == CONTENT_TYPE.URL) {
    objKeys.add(ObjectKeys(
      objId: objContent.id!,
      objKey: GlobalKey<DefaultTextFieldState>(),
    ));
    lastFocus(objContent.focusNode);
    debugPrint('addContent obj.focus = ${lastFocus.value.debugLabel}');
    // }
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

  onSelectedAll(bool selected) {
    if (selected)
      contents.forEach((obj) {
        if (!selectedContent.contains(obj.id)) {
          selectedContent.add(obj.id!);
        }
      });
    else {
      selectedContent.clear();
    }
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
      modifyIndexAt(objId);
      setCurrentStyleObj(_findKeysByObjId());
      setNewFocus(objId);
    }
  }

  setNewFocus(int objId) {
    lastFocus(contents.firstWhere((obj) => obj.id == objId).focusNode);
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

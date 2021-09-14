import 'dart:convert';

import 'package:creator_content/components/default_textfield.dart';
import 'package:creator_content/config/config.dart';
import 'package:creator_content/models/model_view.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:creator_content/models/object_keys.dart';
import 'package:creator_content/pages/preview_data.dart';
import 'package:creator_content/themes/color_constants.dart';
import 'package:creator_content/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_picker/entities/localization_item.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/place_picker.dart';
import 'package:place_picker/widgets/place_picker.dart';

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
  var lastTypeObj = CONTENT_TYPE.TEXT.obs;
  var finalView = false.obs;
  var loadingImages = false.obs;
  var periodsDate = <ShowDateTime>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void setLoadingImages() {
    loadingImages.toggle();
  }

  bool get hasContent => contents.length > 1;

  bool get showIconDelete =>
      selectedContent.length > 0 && isSelectedContent.value;

  bool get isSelectedAll =>
      selectedContent.length == contents.length && contents.length > 0;

  bool get hasEditObjectOrSelected =>
      isSelectedContent.value || isEditLayout.value;

  bool get hasModify => isModify.value;

  CONTENT_TYPE _getLastTypeObj() {
    debugPrint(
        "type : ${contents[contents.length - 1].type}, focus : ${contents[contents.length - 1].focusNode}");
    return contents[contents.length - 1].type;
  }

  bool checkLastType() {
    return _getLastTypeObj() == CONTENT_TYPE.IMAGE ||
        _getLastTypeObj() == CONTENT_TYPE.TIKTOK ||
        _getLastTypeObj() == CONTENT_TYPE.VIDEO ||
        _getLastTypeObj() == CONTENT_TYPE.YOUTUBE;
  }

  ObjectKeys _findKeysByObjId() {
    ObjectKeys key =
        objKeys.firstWhere((_objKeys) => _objKeys.objId == modifyIndexAt.value);
    return key;
  }

  void setModifyAt(objId) => modifyIndexAt(objId);

  setCurrentStyleObj(ObjectKeys objStyle) {
    currentStyleObject.value.objId = objStyle.objId;
    currentStyleObject.value.objKey = objStyle.objKey;
    currentStyleObject.value.textIsLarge = objStyle.objKey.currentState?.large;
    currentStyleObject.value.textIsBold = objStyle.objKey.currentState?.bold;
    currentStyleObject.value.textIsItalic =
        objStyle.objKey.currentState?.italic;
    currentStyleObject.value.textIsUnderline =
        objStyle.objKey.currentState?.underline;
    currentStyleObject.value.color = objStyle.objKey.currentState?.color;

    var objKey = objKeys[objKeys.indexOf(objStyle)];
    currentStyleObject.update((val) {
      objKey.setStyle(
          isBold: val?.textIsBold ?? false,
          isItalic: val?.textIsItalic ?? false,
          isLarge: val?.textIsLarge ?? false,
          isUnderline: val?.textIsUnderline ?? false,
          color: val?.color ?? ColorConstant.black);
    });
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

  void setColorText(Color color) {
    _findKeysByObjId()
        .objKey
        .currentState!
        .changeTextDecoration(TEXT_STYLE.COLOR, color: color);
    setCurrentStyleObj(_findKeysByObjId());
  }

  Color getTextColor() => currentStyleObject.value.color ?? ColorConstant.black;

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

  bool hasInput() => contents.any((obj) =>
      obj.type == CONTENT_TYPE.BULLET ||
      obj.type == CONTENT_TYPE.TEXT ||
      obj.type == CONTENT_TYPE.URL);

  void confirmEditUI() {
    if (isEditLayout.value)
      onEditContent();
    else if (isSelectedContent.value)
      onSelectedObject();
    else
      gotoPreviewPage();
    // previewData();
  }

  void addContent(ObjectContent objContent, {int? index}) {
    //Calculator c = Calculator();

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
    lastTypeObj(objContent.type);
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
          contents.removeWhere((obj) => obj.id == objId);
          objKeys.removeWhere((obj) => obj.objId == objId);
        });

        selectedContent.clear();
        _checkCompletedOnEdit();
      },
    );
  }

  void _checkCompletedOnEdit() {
    debugPrint('contents.length : ${contents.length}');
    debugPrint('isEditLayout.value : ${isEditLayout.value}');
    if (contents.length == 0 && isEditLayout.value) {
      isEditLayout.toggle();
    }
    // onSelectedObject();
  }

  void removeContentAt(int index) {
    int _index = index;
    if (_index-- > 0) {
      onModify(objKeys
          .firstWhere((objKey) => objKey.objId == contents[_index].id)
          .objId);
    } else {
      onModify(objKeys
          .firstWhere((objKey) => objKey.objId == contents[index].id)
          .objId);
    }
    objKeys.removeAt(index);
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
    final ObjectKeys keepData = objKeys.removeAt(oldIndex);
    contents.insert(newIndex, item);
    objKeys.insert(newIndex, keepData);
  }

  onModify([int? objId]) {
    if (objId != null) {
      modifyIndexAt(objId);
      setCurrentStyleObj(_findKeysByObjId());
      setNewFocus(objId);
    }
  }

  setNewFocus(int objId) {
    lastFocus(contents.firstWhere((obj) => obj.id == objId).focusNode);
  }

  onUpdateTextHtml(int index, String data) {
    contents[index].data = data;
    contents.refresh();
  }

  Future<LocationResult?> onSelectLocation([String? latlong]) async {
    LocationResult? result;
    try {
      result = await Get.to(() => PlacePicker(
            AppConfig.geoApiKey,
            displayLocation: latlong != null
                ? LatLng(double.parse(latlong.split(',').first),
                    double.parse(latlong.split(',')[1]))
                : null,
            localizationItem: LocalizationItem(
                languageCode: 'th',
                tapToSelectLocation: "กดเพื่อเลือก",
                nearBy: "สถานที่ใกล้คุณ"),
          ));
      // debugPrint("formattedAddress : ${result.formattedAddress}");
      // debugPrint("latLng : ${result.latLng}");
      // debugPrint("name : ${result.name}");
      return result;
    } catch (e) {
      Popup.error('Error Select location : $e');
      return null;
    }
  }

  onEditLocation(int obj) async {
    var tempObj = contents.firstWhere((element) => element.id == obj);
    String latlong = tempObj.data;
    LocationResult? result = await onSelectLocation(latlong.split("|")[1]);
    if (result != null) {
      int index = contents.indexOf(tempObj);
      var _obj = contents.removeAt(index);
      _obj.data =
          "${result.formattedAddress}|${result.latLng?.latitude}, ${result.latLng?.longitude}";
      contents.insert(index, _obj);
    }
  }

  gotoPreviewPage() {
    previewData();
    Get.to(() => PreviewData());
  }

  List<KeepData> popData() {
    List<KeepData> temp = [];
    for (var item in contents) {
      periodsDate.add(ShowDateTime(item.createDate));
      int index = contents.indexOf(item);
      temp.add(item.saveDataObj(objKeys[index], item.createDate));
    }

    return temp;
  }

  previewData({List<String> rangDate = const []}) {
    clearDataPreview();
    Set<String> listDate = {};
    for (var date in contents) {
      listDate.add(date.createDate.split(' ').first);
    }
    if (rangDate.length > 0) {
      for (var date in rangDate) {
        listDate.add(date);
      }
      listDate.toList().sort();
    }

    debugPrint('listDate : ${listDate.length}');
    listDate.forEach((element) {
      debugPrint('date : $element');
    });
    if (rangDate.length == 0) {
      for (var item in contents) {
        var temp = <KeepData>[];
        int index = contents.indexOf(item);
        if (listDate.contains(item.createDate.split(' ').first)) {
          temp.add(item.saveDataObj(objKeys[index], item.createDate));
        }
        periodsDate
            .add(ShowDateTime(item.createDate.split(' ').first, item: temp));
      }
    } else {
      for (var item in contents) {
        var temp = <KeepData>[];
        int index = contents.indexOf(item);
        if (rangDate.contains(item.createDate.split(' ').first)) {
          temp.add(item.saveDataObj(objKeys[index], item.createDate));
          periodsDate
              .add(ShowDateTime(item.createDate.split(' ').first, item: temp));
        }
      }
    }
  }

  clearDataPreview() => periodsDate.clear();

  showData() {
    List<KeepData> temp = [];
    JsonEncoder encoder = JsonEncoder.withIndent(" ");
    for (var item in contents) {
      int index = contents.indexOf(item);
      temp.add(item.saveDataObj(objKeys[index], item.createDate));
    }
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "${temp.map((e) => encoder.convert(e.toJson())).toList()}",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ));
  }
}

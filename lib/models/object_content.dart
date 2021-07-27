import 'package:creator_content/components/checkbox_content.dart';
import 'package:creator_content/components/content_layout.dart';
import 'package:creator_content/components/default_textfield.dart';
import 'package:creator_content/components/video_player_widget.dart';
import 'package:creator_content/components/webview_tool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:video_player/video_player.dart';

import 'model_view.dart';
import 'object_keys.dart';

enum CONTENT_TYPE {
  TEXT,
  BULLET,
  URL,
  IMAGE,
  VIDEO,
  LOCATION,
  YOUTUBE,
  TIKTOK,
}

class ObjectContent {
  final CONTENT_TYPE type;
  late TextEditingController textController;
  FocusNode? focusNode;
  int? id;
  dynamic data;
  int _currentTextLength = 0;
  ObjectKeys? objKey;

  ObjectContent(this.type, {this.data}) {
    this.id = DateTime.now().microsecondsSinceEpoch;
    if (this.type == CONTENT_TYPE.BULLET ||
        this.type == CONTENT_TYPE.TEXT ||
        this.type == CONTENT_TYPE.URL) {
      textController = TextEditingController(text: data ?? '');
      focusNode = FocusNode(debugLabel: this.id.toString());
      debugPrint("create focusNode : ${focusNode!.debugLabel}");
    }
  }

  /// [onSelect] if true is selecting Object.
  /// else is editing layout Object.
  Widget createWidget(bool onSelect, int objId,
      {ObjectKeys? objKey, int? index, bool readOnly = false}) {
    if (objKey != null) {
      this.objKey = objKey;
    }
    Widget child = Container();
    switch (type) {
      case CONTENT_TYPE.TEXT:
        child = DefaultTextField(
          key: objKey?.objKey,
          focusNode: focusNode,
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
          readOnly: readOnly,
          hintText: 'some text ...',
          onChanged: (value) => data = value,
        );
        break;
      case CONTENT_TYPE.BULLET:
        child = DefaultTextField(
          key: objKey!.objKey,
          focusNode: focusNode,
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
          readOnly: readOnly,
          hintText: '• text',
          onChanged: (newText) {
            //'\u2022 '
            if (newText.length > 0) {
              if (newText[0] != '•') {
                newText = '• ' + newText;
                textController.text = newText;
                textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textController.text.length));
              }
              if (newText[newText.length - 1] == '\n' &&
                  newText.length > _currentTextLength) {
                textController.text = newText + '• ';
                textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textController.text.length));
              }
              _currentTextLength = textController.text.length;
            }
            data = newText;
          },
        );
        break;
      case CONTENT_TYPE.URL:
        child = DefaultTextField(
          key: objKey!.objKey,
          focusNode: focusNode,
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
          textColor: Colors.blue,
          hintText: 'URL...',
          onChanged: (value) => data = value,
        );
        break;
      case CONTENT_TYPE.IMAGE:
        child = Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          width: Get.width,
          height: 200,
          child: AssetThumb(
            asset: (data),
            width: Get.width.toInt(),
            height: 200,
          ),
        );
        break;
      case CONTENT_TYPE.VIDEO:
        child = VideoPlayerWidget(data: (data as VideoPlayerController));
        break;
      case CONTENT_TYPE.YOUTUBE:
        final url =
            "https://www.youtube.com/embed/${data.toString().split('/').last}";
        child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: WebViewTools(
                  url: url,
                ),
              ),
              Text("Youtube : $url"),
            ],
          ),
        );
        break;
      case CONTENT_TYPE.TIKTOK:
        final url = "${data.toString().split('?').first}";
        data = url;
        child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 400,
                child: WebViewTools(
                  url: data,
                ),
              ),
              Text("Tiktok : $data"),
            ],
          ),
        );
        break;

      case CONTENT_TYPE.LOCATION:
        child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.pin_drop),
              SizedBox(width: 10),
              Expanded(child: Text(data.toString().split("|").first)),
            ],
          ),
        );
        break;
      default:
        child = DefaultTextField(
          key: objKey!.objKey,
          focusNode: focusNode,
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
          hintText: 'some text ...',
          readOnly: readOnly,
          onChanged: (value) => data = value,
        );
    }
    return Container(
      child: onSelect
          ? SelectObjectWidget(objId: objId, child: child)
          : ContentLayout(
              key: ValueKey(objId),
              type: type,
              objId: objId,
              child: child,
              focusNode: focusNode,
            ),
    );
  }

  KeepData saveDataObj(ObjectKeys? objKey) {
    // Map<String, dynamic> dataMap = {};
    Map<String, dynamic> styles = {
      "Bold": objKey?.textIsBold,
      "Italic": objKey?.textIsItalic,
      "Large": objKey?.textIsLarge,
      "Underline": objKey?.textIsUnderline,
      "Color": type == CONTENT_TYPE.URL ? "0xFF2196F3" : "",
    };
    KeepData keepData = KeepData(
        id: "$id",
        rawData: "",
        type: "TEXT",
        data: "",
        styles: (type == CONTENT_TYPE.TEXT ||
                type == CONTENT_TYPE.BULLET ||
                type == CONTENT_TYPE.URL)
            ? Styles.fromJson(styles)
            : null);

    switch (type) {
      case CONTENT_TYPE.TEXT:
        keepData.styles = Styles.fromJson(styles);
        keepData.data = data;
        break;
      case CONTENT_TYPE.BULLET:
        keepData.type = "BULLET";
        keepData.data = data.toString();
        break;
      case CONTENT_TYPE.URL:
        keepData.type = "URL";
        keepData.data = data;

        break;
      case CONTENT_TYPE.IMAGE:
        keepData.type = "IMAGE";
        keepData.rawData = (data as Asset);
        keepData.data = "Base64";

        break;
      case CONTENT_TYPE.VIDEO:
        keepData.type = "VIDEO";
        keepData.rawData = data;
        keepData.data = "Base64";
        // keepData.rawData = base64Encode((data as File).readAsBytesSync());
        // {"VIDEO|$id": base64Encode((data as File).readAsBytesSync())}); // For prod

        break;
      case CONTENT_TYPE.YOUTUBE:
        keepData.type = "YOUTUBE";
        keepData.data = data;
        break;
      case CONTENT_TYPE.TIKTOK:
        keepData.type = "TIKTOK";
        keepData.data = data;
        break;
      case CONTENT_TYPE.LOCATION:
        keepData.type = "LOCATION";
        keepData.data = data;
        break;

      default:
    }
    return keepData;
  }
}

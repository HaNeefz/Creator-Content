import 'package:creator_content/components/checkbox_content.dart';
import 'package:creator_content/components/content_layout.dart';
import 'package:creator_content/components/default_textfield.dart';
import 'package:creator_content/components/video_player_widget.dart';
import 'package:creator_content/components/webview_tool.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:video_player/video_player.dart';

enum CONTENT_TYPE {
  TEXT,
  BULLET,
  TEXT_BOLD,
  URL,
  IMAGE,
  VIDEO,
  LOCATION,
  YOUTUBE,
  TIKTOK
}

class ObjectContent {
  final CONTENT_TYPE type;
  late TextEditingController textController;
  int? id;
  dynamic data;
  int _currentTextLength = 0;

  ObjectContent(this.type, {this.data}) {
    this.id = DateTime.now().microsecondsSinceEpoch;
    if (this.type == CONTENT_TYPE.BULLET ||
        this.type == CONTENT_TYPE.TEXT ||
        this.type == CONTENT_TYPE.TEXT_BOLD ||
        this.type == CONTENT_TYPE.URL)
      textController = TextEditingController(text: data ?? '');
  }

  /// [onSelect] if true is selecting Object.
  /// else is editing layout Object.
  Widget createWidget(bool onSelect, int objId) {
    Widget child = Container();
    switch (type) {
      case CONTENT_TYPE.TEXT:
        child = DefaultTextField(
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
          hintText: 'some text ...',
          onChanged: (value) => data = value,
        );
        break;
      case CONTENT_TYPE.BULLET:
        child = DefaultTextField(
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
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
      case CONTENT_TYPE.TEXT_BOLD:
        child = DefaultTextField(
          controller: textController,
          textSize: TEXT_SIZE.BIG_BOLD,
          hintText: 'some text ...',
          onChanged: (value) => data = value,
        );
        break;
      case CONTENT_TYPE.URL:
        child = DefaultTextField(
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
          textColor: Colors.blue,
          hintText: 'URL...',
          onChanged: (value) => data = value,
        );
        break;
      case CONTENT_TYPE.IMAGE:
        child = Container(
          padding: const EdgeInsets.only(top: 5),
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
          padding: const EdgeInsets.only(top: 5),
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
          padding: const EdgeInsets.only(top: 5),
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
      default:
        return Text(data.toString());
    }
    return Container(
      child: onSelect
          ? SelectObjectWidget(objId: objId, child: child)
          : ContentLayout(child: child),
    );
  }

  Map<String, dynamic> saveDataObj() {
    Map<String, dynamic> dataMap = {};
    switch (type) {
      case CONTENT_TYPE.TEXT:
        dataMap.addAll({"TEXT|$id": data});
        break;
      case CONTENT_TYPE.BULLET:
        dataMap.addAll({"BULLET|$id": data.toString().replaceAll('• ', '')});
        break;
      case CONTENT_TYPE.URL:
        dataMap.addAll({"URL|$id": data});
        break;
      case CONTENT_TYPE.IMAGE:
        dataMap.addAll(
            // {"IMAGE|$id": base64Encode((data as File).readAsBytesSync())}); // For prod
            {"IMAGE|$id": 'base64'}); // For test
        break;
      case CONTENT_TYPE.VIDEO:
        dataMap.addAll(
            // {"VIDEO|$id": base64Encode((data as File).readAsBytesSync())}); // For prod
            {"VIDEO|$id": 'base64'}); // For test
        break;
      case CONTENT_TYPE.YOUTUBE:
        dataMap.addAll({"YOUTUBE|$id": data});
        break;
      case CONTENT_TYPE.TIKTOK:
        dataMap.addAll({"TIKTOK|$id": data});
        break;

      default:
      // return Text(data);
    }
    return dataMap;
  }
}

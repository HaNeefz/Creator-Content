import 'package:creator_content/components/default_textfield.dart';
import 'package:creator_content/components/selector_object.dart';
import 'package:creator_content/components/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

enum CONTENT_TYPE {
  TEXT,
  BULLET,
  URL,
  IMAGE,
  VIDEO,
  LOCATION,
  YOUTUBE,
  TIKTOK,
  CONTROLLER
}

class ObjectContent {
  final CONTENT_TYPE type;
  late TextEditingController textController;
  int? id;
  dynamic data;

  ObjectContent(this.type, {this.data}) {
    this.id = DateTime.now().microsecondsSinceEpoch;
    if (this.type == CONTENT_TYPE.BULLET ||
        this.type == CONTENT_TYPE.TEXT ||
        this.type == CONTENT_TYPE.URL)
      textController = TextEditingController(text: data ?? '');
  }

  Widget createWidget([bool? isFocus]) {
    Widget child = Container();
    switch (type) {
      case CONTENT_TYPE.TEXT:
        child = DefaultTextField(
          controller: textController,
          textSize: TEXT_SIZE.NORMAL,
          onChanged: (value) => data = value,
        );
        break;
      case CONTENT_TYPE.BULLET:
        child = DefaultTextField(
          controller: textController,
          textSize: TEXT_SIZE.BIG_BOLD,
          prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: '\u2022 ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ))),
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
        child = SizedBox(
          width: Get.width,
          height: 200,
          child: Image.file(
            data,
            fit: BoxFit.cover,
          ),
        );
        break;
      case CONTENT_TYPE.VIDEO:
        child = VideoPlayerWidget(data: (data as VideoPlayerController));
        break;
      case CONTENT_TYPE.CONTROLLER:
        child = SelectorObject();
        break;
      default:
        return Text(data);
    }
    if (isFocus!) {
      return Container(
          decoration:
              BoxDecoration(border: Border.all(width: 5, color: Colors.red)),
          child: child);
    } else {
      return child;
    }
  }

  Map<String, dynamic> saveDataObj() {
    Map<String, dynamic> dataMap = {};
    switch (type) {
      case CONTENT_TYPE.TEXT:
        dataMap.addAll({"TEXT|$id": data});
        break;
      case CONTENT_TYPE.BULLET:
        dataMap.addAll({"BULLET|$id": data});
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
      case CONTENT_TYPE.CONTROLLER:

      default:
      // return Text(data);
    }
    return dataMap;
  }
}

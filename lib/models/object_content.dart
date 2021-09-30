import 'package:creator_content/components/checkbox_content.dart';
import 'package:creator_content/components/content_layout.dart';
import 'package:creator_content/components/default_textfield.dart';
import 'package:creator_content/components/layout_objects/layout_image.dart';
import 'package:creator_content/components/layout_objects/layout_location.dart';
import 'package:creator_content/components/layout_objects/layout_video.dart';
import 'package:creator_content/components/layout_objects/layout_view_html.dart';
import 'package:creator_content/components/layout_objects/layout_webview.dart';
import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/themes/color_constants.dart';
import 'package:creator_content/utils/content_types.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:html_editor_enhanced/html_editor.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';

import 'model_view.dart';
import 'object_keys.dart';

enum CONTENT_TYPE {
  TEXT,
  BULLET,
  URL,
  TEXT_HTML,
  IMAGE,
  VIDEO,
  LOCATION,
  YOUTUBE,
  TIKTOK,
  TWITTER,
  INSTAGRAM,
}

class ObjectContent {
  final CONTENT_TYPE type;
  late TextEditingController textController;
  late HtmlEditorController htmlController;
  late String createDate;
  String? hashTag;
  // late HtmlEditorController htmlController;
  FocusNode? focusNode;
  int? id;
  dynamic data;
  int _currentTextLength = 0;
  ObjectKeys? objKey;

  ObjectContent(this.type, {this.data}) {
    this.id = DateTime.now().microsecondsSinceEpoch;
    // this.createDate = DateTime.now().toString();
    final controller = ControllerContent.to;
    debugPrint('controller : ${controller.contents.length}');

    if (controller.contents.length == 0)
      this.createDate = DateTime.now().toString();
    else
      this.createDate = DateTime.now()
          .subtract(Duration(days: controller.contents.length))
          .toString();
    if (this.type == CONTENT_TYPE.BULLET ||
            this.type == CONTENT_TYPE.TEXT ||
            this.type == CONTENT_TYPE.URL
        // ||this.type == CONTENT_TYPE.TEXT_HTML
        ) {
      // htmlController = HtmlEditorController();
      textController = TextEditingController(text: data ?? '');
      focusNode = FocusNode(debugLabel: this.id.toString());
      debugPrint("create focusNode : ${focusNode!.debugLabel}");
    } else if (this.type == CONTENT_TYPE.TEXT_HTML) {
      htmlController = HtmlEditorController();
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
      case CONTENT_TYPE.TEXT_HTML:
        // child = WebViewPlusExampleMainPage(html: data);
        child = ViewHtml(
          html: data,
          index: index!,
          isEdit: true,
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
        child = LayoutImage(data: data);
        break;
      case CONTENT_TYPE.VIDEO:
        child = LayoutVideo(data: data);
        break;
      case CONTENT_TYPE.YOUTUBE:
        child = child =
            LayoutWebview(data: data, type: LAYOUT_WEBVIEW_TYPE.YOUTUBE);
        break;
      case CONTENT_TYPE.TIKTOK:
        child = LayoutWebview(data: data, type: LAYOUT_WEBVIEW_TYPE.TIKTOK);
        break;
      case CONTENT_TYPE.TWITTER:
        child = LayoutWebview(data: data, type: LAYOUT_WEBVIEW_TYPE.TWTTER);
        break;
      case CONTENT_TYPE.INSTAGRAM:
        child = LayoutWebview(data: data, type: LAYOUT_WEBVIEW_TYPE.INSTAGRAM);
        break;
      case CONTENT_TYPE.LOCATION:
        child = LayoutLocation(data: data);
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

  KeepData saveDataObj(ObjectKeys? objKey, String createDate) {
    // Map<String, dynamic> dataMap = {};
    Map<String, dynamic> styles = {
      "Bold": objKey?.textIsBold,
      "Italic": objKey?.textIsItalic,
      "Large": objKey?.textIsLarge,
      "Underline": objKey?.textIsUnderline,
      "Color": type == CONTENT_TYPE.URL
          ? ColorConstant.blue
          : objKey?.color ?? ColorConstant.black,
    };

    KeepData keepData = KeepData(
        id: "$id",
        rawData: "",
        createDate: createDate,
        type: ContentTypes.text,
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
        keepData.type = ContentTypes.bullet;
        keepData.data = data.toString();
        break;
      case CONTENT_TYPE.URL:
        keepData.type = ContentTypes.url;
        keepData.data = data;
        break;
      case CONTENT_TYPE.TEXT_HTML:
        keepData.type = ContentTypes.textHtml;
        keepData.data = data;
        break;
      case CONTENT_TYPE.IMAGE:
        keepData.type = ContentTypes.image;
        keepData.rawData = (data as XFile);
        keepData.data = "Base64";

        break;
      case CONTENT_TYPE.VIDEO:
        keepData.type = ContentTypes.video;
        keepData.rawData = data;
        keepData.data = "Base64";
        // keepData.rawData = base64Encode((data as File).readAsBytesSync());
        // {"VIDEO|$id": base64Encode((data as File).readAsBytesSync())}); // For prod

        break;
      case CONTENT_TYPE.YOUTUBE:
        keepData.type = ContentTypes.youtube;
        keepData.data = data;
        break;
      case CONTENT_TYPE.TIKTOK:
        keepData.type = ContentTypes.tiktok;
        keepData.data = data;
        break;
      case CONTENT_TYPE.LOCATION:
        keepData.type = ContentTypes.location;
        keepData.data = data;
        break;

      default:
    }
    return keepData;
  }
}

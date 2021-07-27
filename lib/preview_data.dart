import 'dart:ui';

import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'components/video_player_widget.dart';
import 'components/webview_tool.dart';
import 'models/model_view.dart';

class PreviewData extends StatelessWidget {
  final List<KeepData> data;
  const PreviewData({Key? key, this.data = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        actions: [
          TextButton(
            child: Text(
              'Show Data',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              controller.showData();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.popData().map((e) => createWidget(e)).toList(),
                SizedBox(height: 100),
              ],
            )),
      ),
    );
  }

  TextStyle _setStyle(KeepData keepData) {
    TextStyle style = TextStyle();
    switch (keepData.type) {
      case "TEXT":
      case "BULLET":
        style = style.copyWith(
          fontSize: keepData.styles!.large! ? 22 : 18,
          fontWeight:
              keepData.styles!.bold! ? FontWeight.bold : FontWeight.normal,
          fontStyle:
              keepData.styles!.italic! ? FontStyle.italic : FontStyle.normal,
          decoration:
              keepData.styles!.underline! ? TextDecoration.underline : null,
        );
        break;
      case "URL":
        style = style.copyWith(
          fontSize: keepData.styles!.large! ? 22 : 18,
          fontWeight:
              keepData.styles!.bold! ? FontWeight.bold : FontWeight.normal,
          fontStyle:
              keepData.styles!.italic! ? FontStyle.italic : FontStyle.normal,
          decoration:
              keepData.styles!.underline! ? TextDecoration.underline : null,
          color: Colors.blue,
        );
        break;
      default:
    }
    return style;
  }

  Widget textCustom(String data,
      {required TextStyle style, bool canTap = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GestureDetector(
        child: Text(data, style: style),
        onTap: canTap
            ? () async {
                if (await canLaunch(data)) {
                  await launch(data);
                } else {
                  Popup.error("Can't open url ( $data )");
                  throw "Can't launch $data";
                }
              }
            : null,
      ),
    );
  }

  Widget createWidget(KeepData keepData) {
    TextStyle style = _setStyle(keepData);
    Widget child = Container();
    switch (keepData.type) {
      case "TEXT":
        child = textCustom(keepData.data, style: style);
        break;
      case "BULLET":
        child = textCustom(keepData.data, style: style);
        break;
      case "URL":
        child = textCustom(
          keepData.data,
          style: style,
          canTap: true,
        );
        break;
      case "IMAGE":
        child = Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          width: Get.width,
          height: 200,
          child: AssetThumb(
            asset: (keepData.rawData as Asset),
            width: Get.width.toInt(),
            height: 200,
          ),
        );
        break;
      case "VIDEO":
        child = VideoPlayerWidget(
            data: (keepData.rawData as VideoPlayerController));
        break;
      case "YOUTUBE":
        final url =
            "https://www.youtube.com/embed/${keepData.rawData.toString().split('/').last}";
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
      case "TIKTOK":
        final url = "${keepData.rawData.toString().split('?').first}";
        keepData.rawData = url;
        child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 400,
                child: WebViewTools(
                  url: keepData.rawData,
                ),
              ),
              Text("Tiktok : ${keepData.rawData}"),
            ],
          ),
        );
        break;

      case "LOCATION":
        child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.pin_drop),
              SizedBox(width: 10),
              Expanded(
                  child: Text(keepData.rawData.toString().split("|").first)),
            ],
          ),
        );
        break;
      default:
        child = Text(keepData.rawData);
    }
    return Container(
      child: child,
    );
  }
}

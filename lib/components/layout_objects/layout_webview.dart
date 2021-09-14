import 'package:creator_content/utils/open_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../webview_tool.dart';
import 'template.dart';

enum LAYOUT_WEBVIEW_TYPE { YOUTUBE, TIKTOK, TWTTER, INSTAGRAM }

class LayoutWebview extends StatelessWidget {
  final LAYOUT_WEBVIEW_TYPE type;
  final String data;
  final bool isPreview;
  const LayoutWebview({
    Key? key,
    this.type = LAYOUT_WEBVIEW_TYPE.YOUTUBE,
    required this.data,
    this.isPreview = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectType(type);
  }

  Widget selectType(LAYOUT_WEBVIEW_TYPE type) {
    switch (type) {
      case LAYOUT_WEBVIEW_TYPE.YOUTUBE:
        final url =
            "https://www.youtube.com/embed/${data.toString().split('/').last}";
        return Templete(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: WebViewTools(
                  key: ValueKey(url),
                  url: url,
                ),
              ),
              showUrl("Youtube", url)
            ],
          ),
        );
      case LAYOUT_WEBVIEW_TYPE.TIKTOK:
        final url = "${data.toString().split('?').first}";
        return Templete(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 400,
                key: ValueKey(url),
                child: WebViewTools(
                  url: url,
                ),
              ),
              showUrl("Tiktok", url)
            ],
          ),
        );
      case LAYOUT_WEBVIEW_TYPE.TWTTER:
        final url = "$data";
        return Templete(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 500,
                child: WebViewTools(
                  key: ValueKey(url),
                  url: url,
                ),
              ),
              showUrl("Twitter", url)
            ],
          ),
        );
      case LAYOUT_WEBVIEW_TYPE.INSTAGRAM:
        final url = "$data";
        return Templete(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 600,
                child: WebViewTools(
                  key: ValueKey(url),
                  url: url,
                ),
              ),
              showUrl("Instagram", url)
            ],
          ),
        );

      default:
        return Container();
    }
  }

  Widget showUrl(String title, String url) {
    return InkWell(
      child: SizedBox(
        width: Get.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("$url")),
      ),
      onTap: isPreview
          ? () async {
              await OpenLink.open(url);
            }
          : null,
    );
  }
}

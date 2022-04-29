import 'dart:ui';

import 'package:creator_content/components/dateRangPicker.dart';
import 'package:creator_content/components/layout_objects/layout_image.dart';
import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/utils/content_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/layout_objects/layout_location.dart';
import '../../components/layout_objects/layout_video.dart';
import '../../components/layout_objects/layout_view_html.dart';
import '../../components/layout_objects/layout_webview.dart';
import '../../models/model_view.dart';
import 'controllers/preview_controller.dart';

class ShowDateTime {
  final String createDate;
  final bool showDate;
  List<KeepData> item;
  ShowDateTime(this.createDate, {this.showDate = false, this.item = const []});
}

// ignore: must_be_immutable
class PreviewData extends StatefulWidget {
  final List<KeepData> data;
  final bool showOnlytag;
  final String? tag;
  PreviewData(
      {Key? key, this.data = const [], this.showOnlytag = false, this.tag = ''})
      : super(key: key);

  @override
  State<PreviewData> createState() => PreviewDataState();
}

class PreviewDataState extends State<PreviewData> {
  bool layoutList = false;

  @override
  Widget build(BuildContext context) {
    final controllerPagePreview = Get.put(PreviewController());
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    final controller = ControllerContent.to;
    return Scaffold(
      appBar: AppBar(
        title: Text(!widget.showOnlytag ? 'Preview' : widget.tag!),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            controller.clearDataPreview();
            Get.back();
          },
        ),
        actions: !widget.showOnlytag
            ? [
                // TextButton(
                //   child: Text(
                //     r"<\>",
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   onPressed: () {
                //     controller.showData();
                //   },
                // ),
                IconButton(
                  icon: Text(
                    r"<\>",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => controller.showData(),
                ),
                // IconButton(
                //   icon: Icon(Icons.tag),
                //   onPressed: () => controller.searchHashTags(),
                // ),
                IconButton(
                  icon: Icon(Icons.filter_alt_rounded),
                  onPressed: () async {
                    final result = await Get.to(DateRangPicker());
                    // debugPrint('result : $result');
                    if (result != null) {
                      List<String> rang = result
                          .toString()
                          .splitMapJoin(' ', onMatch: (e) => '')
                          .split('to');

                      // debugPrint(
                      //     'count : ${DateTime.parse(rang[1]).difference(DateTime.parse(rang.first)).inDays}');

                      int countRangDate = DateTime.parse(rang[1])
                          .difference(DateTime.parse(rang.first))
                          .inDays;
                      List<String> allRang = [];
                      for (var i = 0; i < countRangDate + 1; i++) {
                        allRang.add(DateTime.parse(rang.first)
                            .add(Duration(days: i))
                            .toString()
                            .split(' ')
                            .first);
                      }

                      debugPrint("allRang : $allRang");

                      controller.previewData(rangDate: allRang);
                    }

                    // debugPrint('allRang : $allRang');
                  },
                ),
                IconButton(
                  icon: Obx(() => Icon(controllerPagePreview.isListLayout.value
                      ? Icons.view_list_sharp
                      : Icons.auto_awesome_mosaic_rounded)),
                  onPressed: () => controllerPagePreview.changeLayout(),
                ),

                // TextButton(
                //   style: ButtonStyle(
                //       foregroundColor:
                //           MaterialStateProperty.all<Color>(Colors.white)),
                //   child: Icon(Icons.filter_alt_rounded),
                //   onPressed: () {},
                // ),
              ]
            : null,
      ),
      body: Obx(() => Stack(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: controller.periodsDate.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = controller.periodsDate.toList()[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controllerPagePreview.isListLayout.value)
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.black,
                                    minRadius: 6),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    data.createDate,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        else
                          return Container();
                      }),
                      Obx(() {
                        if (controllerPagePreview.isListLayout.value)
                          return Card(
                            // color: Colors.red,
                            child: Column(children: [
                              ...data.item
                                  .map((ee) => createWidget(ee))
                                  .toList()
                            ]),
                          );
                        else
                          return Column(children: [
                            ...data.item.map((ee) => createWidget(ee)).toList()
                          ]);
                      })
                    ],
                  );
                },
              ),
              // SingleChildScrollView(
              //   physics: ClampingScrollPhysics(),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       ...controller.periodsDate.map((e) {
              //         return
              // Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             if (controllerPagePreview.isListLayout.value)
              //               Padding(
              //                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              //                 child: Row(
              //                   children: [
              //                     CircleAvatar(
              //                         backgroundColor: Colors.black,
              //                         minRadius: 6),
              //                     SizedBox(width: 10),
              //                     Expanded(
              //                       child: Text(
              //                         e.createDate,
              //                         style: TextStyle(
              //                             fontWeight: FontWeight.bold),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             if (controllerPagePreview.isListLayout.value)
              //               Card(
              //                 child: Column(children: [
              //                   ...e.item.map((ee) => createWidget(ee)).toList()
              //                 ]),
              //               )
              //             else
              //               Column(children: [
              //                 ...e.item.map((ee) => createWidget(ee)).toList()
              //               ])
              //           ],
              //         );
              //       }).toList(),
              //       // ...controller.popData().map((e) {
              //       //   return Column(
              //       //     children: [
              //       //       createWidget(e, layoutList),
              //       //     ],
              //       //   );
              //       // }).toList(),
              //       SizedBox(height: 100),
              //     ],
              //   ),
              // ),
              if (controller.loadingImages.value) ...[
                Positioned.fill(
                    child: ModalBarrier(color: Colors.grey.withOpacity(0.3))),
                Positioned.fill(
                    child: Center(
                  // child: CupertinoActivityIndicator(),
                  child: CircularProgressIndicator(),
                )),
              ]
            ],
          )),
    );
  }

  TextStyle _setStyle(KeepData keepData) {
    TextStyle style = TextStyle();
    switch (keepData.type) {
      case ContentTypes.text:
      case ContentTypes.bullet:
        style = style.copyWith(
            fontSize: keepData.styles!.large ? 22 : 18,
            fontWeight:
                keepData.styles!.bold ? FontWeight.bold : FontWeight.normal,
            fontStyle:
                keepData.styles!.italic ? FontStyle.italic : FontStyle.normal,
            decoration:
                keepData.styles!.underline ? TextDecoration.underline : null,
            color: keepData.styles!.color!);
        break;
      case ContentTypes.url:
        style = style.copyWith(
          fontSize: keepData.styles!.large ? 22 : 18,
          fontWeight:
              keepData.styles!.bold ? FontWeight.bold : FontWeight.normal,
          fontStyle:
              keepData.styles!.italic ? FontStyle.italic : FontStyle.normal,
          decoration:
              keepData.styles!.underline ? TextDecoration.underline : null,
          color: Colors.blue,
        );
        break;
      default:
    }
    return style;
  }

  static Widget createWidget(KeepData keepData) {
    // TextStyle style = _setStyle(keepData);
    Widget child = Container();
    switch (keepData.type) {
      // case ContentTypes.text:
      //   child = LayoutText(data: keepData.data, style: style);
      //   break;
      // case ContentTypes.bullet:
      //   child = LayoutText(data: keepData.data, style: style);
      //   break;
      // case ContentTypes.url:
      //   child = LayoutText(data: keepData.data, style: style, canTap: true);
      //   break;
      case ContentTypes.textHtml:
        child = ViewHtml(
          html: keepData.data,
          index: null,
          isPreview: true,
          isEdit: false,
          obj: keepData.obj,
        );
        break;
      case ContentTypes.image:
        child = LayoutImage(
          id: keepData.id,
          data: keepData.rawData,
          isPreview: true,
          obj: keepData.obj,
        );
        break;
      case ContentTypes.video:
        child = LayoutVideo(
          data: keepData.rawData,
          obj: keepData.obj,
        );
        break;
      case ContentTypes.youtube:
        child = LayoutWebview(
          data: keepData.data,
          type: LAYOUT_WEBVIEW_TYPE.YOUTUBE,
          obj: keepData.obj,
          isPreview: true,
        );
        break;
      case ContentTypes.tiktok:
        child = LayoutWebview(
            data: keepData.data,
            type: LAYOUT_WEBVIEW_TYPE.TIKTOK,
            obj: keepData.obj,
            isPreview: true);
        break;
      case ContentTypes.location:
        child = LayoutLocation(
          data: keepData.data,
          obj: keepData.obj,
          isPreview: true,
        );
        break;
      default:
        child = Text(keepData.rawData);
    }
    return Container(
      key: ValueKey(keepData.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
        ],
      ),
    );
  }
}

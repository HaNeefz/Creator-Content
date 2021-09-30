import 'package:creator_content/components/layout_objects/template.dart';
import 'package:creator_content/utils/open_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'constant.dart';
import 'layout_html_text.dart';

class WebViewPlusExampleMainPage extends StatefulWidget {
  final String html;

  const WebViewPlusExampleMainPage({Key? key, required this.html})
      : super(key: key);
  @override
  _WebViewPlusExampleMainPageState createState() =>
      _WebViewPlusExampleMainPageState();
}

class _WebViewPlusExampleMainPageState
    extends State<WebViewPlusExampleMainPage> {
  WebViewPlusController? _controller;
  double _height = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: WebViewPlus(
        javascriptChannels: null,
        // initialUrl: 'assets/index.html',
        onWebViewCreated: (controller) {
          this._controller = controller;
          this._controller!.loadString("${widget.html}");
        },
        onPageFinished: (url) {
          _controller?.getHeight().then((double height) {
            print("Height: " + height.toString());
            setState(() {
              _height = height;
            });
          });
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
    // ListView(
    //   shrinkWrap: true,
    //   children: [

    //   ],
    // ),;
  }
}

class ViewHtml extends StatelessWidget {
  final String html;
  final bool isPreview;
  final bool isEdit;
  final int? index;
  const ViewHtml({
    Key? key,
    required this.html,
    required this.index,
    required this.isEdit,
    this.isPreview = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isPreview)
          Get.to(HtmlEditorExample(
            data: html,
            index: index!,
            isEdit: isEdit,
          ));
      },
      child: SingleChildScrollView(
        child: Templete(
          customPadding: const EdgeInsets.symmetric(
              vertical: LayoutConstant.paddingVertical - 10,
              horizontal: LayoutConstant.paddingHorizontal),
          child: Container(
            alignment: Alignment.centerLeft,
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            child: HtmlWidget(
              html,
              onTapUrl: (url) async {
                if (isPreview)
                  await OpenLink.open(url);
                else {
                  Get.to(HtmlEditorExample(
                    data: html,
                    index: index!,
                    isEdit: isEdit,
                  ));
                }
                return true;
              },
              textStyle: TextStyle(fontSize: 16),
              customStylesBuilder: (element) {
                // debugPrint("element localName : ${element.localName}");
                // debugPrint(
                //     "element localName : ${element.localName == "font"}");
                if (element.localName == 'td' ||
                    element.localName == 'th' ||
                    element.localName == 'table') {
                  return {
                    "border": "1px solid black",
                    "padding-left": "3px",
                    "border-collapse": "collapse"
                  };
                }

                // if (element.localName == 'font') {
                //   return {"font-size": "40px"};
                // }
              },

              onErrorBuilder: (context, element, error) =>
                  Text('$element error: $error'),
              // style: {
              //   "table": Style(
              //       backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
              //       width: MediaQuery.of(context).size.width),
              //   "tr": Style(
              //       border: Border(
              //         bottom: BorderSide(color: Colors.grey),
              //       ),
              //       width: MediaQuery.of(context).size.width),
              //   "th": Style(
              //       padding: EdgeInsets.all(6),
              //       backgroundColor: Colors.grey,
              //       width: MediaQuery.of(context).size.width),
              //   "td": Style(
              //       padding: EdgeInsets.all(6),
              //       alignment: Alignment.topLeft,
              //       width: MediaQuery.of(context).size.width),
              // },
              // customRender: {
              //   "table": (context, child) {
              //     // return SingleChildScrollView(
              //     //   scrollDirection: Axis.horizontal,
              //     //   child: (context.tree as TableLayoutElement).toWidget(context),
              //     // );
              //     return Container(
              //       // color: Colors.green,
              //       child: (context.tree as TableLayoutElement).toWidget(context),
              //     );
              //   },
              //   "tr": (context, child) {
              //     return Container(
              //       width: MediaQuery.of(Get.context!).size.width,
              //       child:
              //           (context.tree as TableRowLayoutElement).toWidget(context),
              //     );
              //   },
              //   // "td": (context, child) {
              //   //   return Container(
              //   //     width: MediaQuery.of(Get.context!).size.width,
              //   //     child:
              //   //         (context.tree as TableRowLayoutElement).toWidget(context),
              //   //   );
              //   // },
              //   "bird": (RenderContext context, Widget child) {
              //     return TextSpan(text: "🐦");
              //   },
              //   "flutter": (RenderContext context, Widget child) {
              //     return FlutterLogo(
              //       style:
              //           (context.tree.element!.attributes['horizontal'] != null)
              //               ? FlutterLogoStyle.horizontal
              //               : FlutterLogoStyle.markOnly,
              //       textColor: context.style.color!,
              //       size: context.style.fontSize!.size! * 5,
              //     );
              //   },
              // },
              // customImageRenders: {
              //   networkSourceMatcher(domains: ["flutter.dev"]):
              //       (context, attributes, element) {
              //     return FlutterLogo(size: 36);
              //   },
              //   networkSourceMatcher(domains: ["mydomain.com"]):
              //       networkImageRender(
              //     headers: {"Custom-Header": "some-value"},
              //     altWidget: (alt) => Text(alt ?? ""),
              //     loadingWidget: () => Text("Loading..."),
              //   ),
              //   // On relative paths starting with /wiki, prefix with a base url
              //   (attr, _) =>
              //           attr["src"] != null && attr["src"]!.startsWith("/wiki"):
              //       networkImageRender(
              //           mapUrl: (url) => "https://upload.wikimedia.org" + url!),
              //   // Custom placeholder image for broken links
              //   networkSourceMatcher():
              //       networkImageRender(altWidget: (_) => FlutterLogo()),
              // },
              // onLinkTap: (url, _, __, ___) {
              //   print("Opening $url...");
              //   if (isPreview)
              //     OpenLink.open(url!);
              //   else {
              //     Get.to(HtmlEditorExample(
              //       data: html,
              //       index: index!,
              //       isEdit: isEdit,
              //     ));
              //   }
              // },
              // onImageTap: (src, _, __, ___) {
              //   print(src);
              // },
              // onImageError: (exception, stackTrace) {
              //   print(exception);
              // },
              // onCssParseError: (css, messages) {
              //   print("css that errored: $css");
              //   print("error messages:");
              //   messages.forEach((element) {
              //     print(element);
              //   });
              // },
            ),
          ),
        ),
      ),
    );
  }
}

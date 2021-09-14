import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum LOADING_TYPE { BAR, CIRCLE }

class WebViewTools extends StatelessWidget {
  final String? url;
  final bool? showProgress;
  final bool? authHeader;
  final LOADING_TYPE? loadingType;
  final Function(double)? onProgressChanged;
  const WebViewTools(
      {Key? key,
      this.url,
      this.showProgress,
      this.authHeader,
      this.loadingType,
      this.onProgressChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // InAppWebViewController? webView;
    return Scaffold(
      body: Container(
          child: Column(children: <Widget>[
        // if (showProgress! && loadingType == LOADING_TYPE.BAR)
        //   Container(
        //       child: progress < 1.0
        //           ? LinearProgressIndicator(value: progress)
        //           : Container())
        // else
        //   Container(),
        Expanded(
          child: Container(
            child: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(this.url ?? "https://flutter.dev/"),
                  ),
                  // initialUrl: widget?.url ?? "https://flutter.dev/",

                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions()),
                  onWebViewCreated: (InAppWebViewController controller) {
                    // webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, url) {
                    // if (stopWhenLoading!) {
                    //   webView?.stopLoading();
                    // }
                    // setState(() {
                    //   this.url = url!.origin;
                    // });
                  },
                  onLoadStop: (InAppWebViewController controller, url) async {
                    // setState(() {
                    //   this.url = url!.origin;
                    // });
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    // setState(() {
                    //   this.progress = progress / 100;
                    //   onProgressChanged?.call(this.progress);
                    // });
                  },
                ),
                // if (showProgress! && loadingType == LOADING_TYPE.CIRCLE)
                //   Align(
                //     alignment: Alignment.center,
                //     child: Container(
                //         child: progress < 1.0
                //             ? CircularProgressIndicator(value: progress)
                //             : Container()),
                //   ),
              ],
            ),
          ),
        ),
        // ButtonBar(
        //   alignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     RaisedButton(
        //       child: Icon(Icons.arrow_back),
        //       onPressed: () {
        //         if (webView != null) {
        //           webView.goBack();
        //         }
        //       },
        //     ),
        //     RaisedButton(
        //       child: Icon(Icons.arrow_forward),
        //       onPressed: () {
        //         if (webView != null) {
        //           webView.goForward();
        //         }
        //       },
        //     ),
        //     RaisedButton(
        //       child: Icon(Icons.refresh),
        //       onPressed: () {
        //         if (webView != null) {
        //           webView.reload();
        //         }
        //       },
        //     ),
        //   ],
        // ),
      ])),
    );
  }
}
// class WebViewTools extends StatefulWidget {
//   final String? url;
//   final bool? showProgress;
//   final bool? authHeader;
//   final LOADING_TYPE? loadingType;
//   final Function(double)? onProgressChanged;

//   const WebViewTools(
//       {Key? key,
//       this.url,
//       this.showProgress = true,
//       this.onProgressChanged,
//       this.loadingType = LOADING_TYPE.BAR,
//       this.authHeader = false})
//       : super(key: key);
//   @override
//   _WebViewToolsState createState() => _WebViewToolsState();
// }

// class _WebViewToolsState extends State<WebViewTools>
//     with AutomaticKeepAliveClientMixin {
//   InAppWebViewController? webView;
//   String? url;
//   double progress = 0;
//   @override
//   void initState() {
//     super.initState();
//     this.url = widget.url;
//   }

//   URLRequest setURLRequest() {
//     return URLRequest(
//       url: Uri.parse(this.url ?? "https://flutter.dev/"),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       body: Container(
//           child: Column(children: <Widget>[
//         if (widget.showProgress! && widget.loadingType == LOADING_TYPE.BAR)
//           Container(
//               child: progress < 1.0
//                   ? LinearProgressIndicator(value: progress)
//                   : Container())
//         else
//           Container(),
//         Expanded(
//           child: Container(
//             child: Stack(
//               children: [
//                 InAppWebView(
//                   initialUrlRequest: setURLRequest(),
//                   // initialUrl: widget?.url ?? "https://flutter.dev/",

//                   initialOptions: InAppWebViewGroupOptions(
//                       crossPlatform: InAppWebViewOptions(clearCache: true)),
//                   onWebViewCreated: (InAppWebViewController controller) {
//                     webView = controller;
//                   },
//                   onLoadStart: (InAppWebViewController controller, url) {
//                     // if (stopWhenLoading!) {
//                     //   webView?.stopLoading();
//                     // }
//                     // setState(() {
//                     //   this.url = url!.origin;
//                     // });
//                   },
//                   onLoadStop: (InAppWebViewController controller, url) async {
//                     // setState(() {
//                     //   this.url = url!.origin;
//                     // });
//                   },
//                   onProgressChanged:
//                       (InAppWebViewController controller, int progress) {
//                     setState(() {
//                       this.progress = progress / 100;
//                       widget.onProgressChanged?.call(this.progress);
//                     });
//                   },
//                 ),
//                 if (widget.showProgress! &&
//                     widget.loadingType == LOADING_TYPE.CIRCLE)
//                   Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                         child: progress < 1.0
//                             ? CircularProgressIndicator(value: progress)
//                             : Container()),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         // ButtonBar(
//         //   alignment: MainAxisAlignment.center,
//         //   children: <Widget>[
//         //     RaisedButton(
//         //       child: Icon(Icons.arrow_back),
//         //       onPressed: () {
//         //         if (webView != null) {
//         //           webView.goBack();
//         //         }
//         //       },
//         //     ),
//         //     RaisedButton(
//         //       child: Icon(Icons.arrow_forward),
//         //       onPressed: () {
//         //         if (webView != null) {
//         //           webView.goForward();
//         //         }
//         //       },
//         //     ),
//         //     RaisedButton(
//         //       child: Icon(Icons.refresh),
//         //       onPressed: () {
//         //         if (webView != null) {
//         //           webView.reload();
//         //         }
//         //       },
//         //     ),
//         //   ],
//         // ),
//       ])),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

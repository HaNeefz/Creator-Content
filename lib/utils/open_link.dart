import 'package:url_launcher/url_launcher.dart';

import 'popup.dart';

class OpenLink {
  static open(String url) async {
    String _url = url;
    if (!url.contains('http://') && !url.contains('https://')) {
      _url = "http://" + url;
    }
    // if (await canLaunch(_url)) {
    await launch(_url)
        .onError((error, stackTrace) => Popup.error("error ( $error )"));
    // } else {
    //   Popup.error("Can't open url ( $_url )");
    //   throw "Can't launch $_url";
    // }
  }
}

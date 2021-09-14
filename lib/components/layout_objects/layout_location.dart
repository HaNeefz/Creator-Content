import 'package:creator_content/utils/open_link.dart';
import 'package:flutter/material.dart';

import 'template.dart';

class LayoutLocation extends StatelessWidget {
  final String data;
  final bool isPreview;
  const LayoutLocation({Key? key, required this.data, this.isPreview = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Templete(
        addPaddingHorizontal: true,
        child: Row(
          children: [
            Icon(Icons.map),
            SizedBox(width: 10),
            Expanded(child: Text(data.toString().split("|").first)),
          ],
        ),
      ),
      onTap: isPreview
          ? () async {
              String latlong =
                  data.toString().split("|")[1].replaceAll(", ", ",");
              String url =
                  'https://www.google.com/maps/search/?api=1&query=$latlong';
              await OpenLink.open(url);
            }
          : null,
    );
  }
}

import 'package:creator_content/models/object_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopupMenuContentType extends StatefulWidget {
  final Function(CONTENT_TYPE type) onSelected;
  const PopupMenuContentType({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  _PopupMenuContentStateType createState() => _PopupMenuContentStateType();
}

class _PopupMenuContentStateType extends State<PopupMenuContentType> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CONTENT_TYPE>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Icon(Icons.add),
      onSelected: (CONTENT_TYPE result) {
        widget.onSelected.call(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CONTENT_TYPE>>[
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.TEXT,
          child: Icon(Icons.text_fields),
        ),
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.BULLET,
          child: Icon(Icons.format_list_bulleted_rounded),
        ),
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.URL,
          child: Icon(Icons.add_link_rounded),
        ),
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.IMAGE,
          child: Icon(Icons.photo_library),
        ),
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.VIDEO,
          child: Icon(Icons.video_collection_rounded),
        ),
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.LOCATION,
          child: Icon(Icons.location_on_outlined),
        ),
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.YOUTUBE,
          child: Icon(FontAwesomeIcons.youtube),
        ),
        const PopupMenuItem<CONTENT_TYPE>(
          value: CONTENT_TYPE.TIKTOK,
          child: Icon(FontAwesomeIcons.tiktok),
        ),
      ],
    );
  }
}

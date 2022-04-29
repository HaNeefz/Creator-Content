import 'package:creator_content/components/layout_objects/template.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../video_player_widget.dart';

class LayoutVideo extends StatelessWidget {
  final dynamic data;
  final ObjectContent? obj;
  const LayoutVideo({Key? key, this.data, this.obj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Templete(
        addPaddingHorizontal: true,
        obj: obj,
        isPreview: true,
        child: VideoPlayerWidget(data: (obj?.data as VideoPlayerController)));
  }
}

import 'package:creator_content/components/layout_objects/template.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../video_player_widget.dart';

class LayoutVideo extends StatelessWidget {
  final dynamic data;
  const LayoutVideo({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Templete(
        child: VideoPlayerWidget(data: (data as VideoPlayerController)));
  }
}

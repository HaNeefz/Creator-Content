import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    Key? key,
    required this.data,
    this.height = 200,
    this.autoPlay = false,
    this.looping = false,
  }) : super(key: key);

  final VideoPlayerController data;
  final double height;
  final bool autoPlay;
  final bool looping;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  // bool
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      initailVideo();
    });
  }

  initailVideo() async {
    _controller = widget.data;
    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      aspectRatio: _controller!.value.aspectRatio,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 200,
      child: _chewieController != null
          ? Chewie(
              controller: _chewieController!,
            )
          : Container(),
    );
  }
}
// class VideoPlayerWidget extends StatefulWidget {
//   const VideoPlayerWidget({
//     Key? key,
//     required this.data,
//   }) : super(key: key);

//   final VideoPlayerController data;

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   VideoPlayerController? _controller;
//   // bool
//   @override
//   void initState() {
//     super.initState();
//     initailVideo();
//   }

//   initailVideo() async {
//     _controller = widget.data;
//     await _controller?.initialize();
//     await _controller?.pause();
//   }

//   // @override
//   // void dispose() {
//   //   _controller?.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _controller!.value.isPlaying
//               ? _controller?.pause()
//               : _controller?.play();
//         });
//       },
//       child: AspectRatio(
//         aspectRatio: _controller!.value.aspectRatio,
//         child: Stack(
//           children: [
//             VideoPlayer(widget.data),
//             Align(
//               alignment: Alignment.center,
//               child: Icon(
//                 _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 color: Colors.black,
//                 size: 50,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

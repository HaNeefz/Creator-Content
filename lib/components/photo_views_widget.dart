import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewWidget extends StatelessWidget {
  final Uint8List? image;
  const PhotoViewWidget({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: image != null
            ? Stack(
                children: [
                  PhotoView(
                    imageProvider: MemoryImage((image!)),
                    minScale: 0.1,
                  ),
                  Positioned(
                      right: 10,
                      top: 10,
                      child: SafeArea(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close)),
                        ),
                      ))
                ],
              )
            : SizedBox(),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:creator_content/components/layout_objects/template.dart';
import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/models/model_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../module_view_image/view_images.dart';
import 'constant.dart';

class LayoutImage extends StatelessWidget {
  final String? id;
  final dynamic data;
  final bool isPreview;
  const LayoutImage({
    Key? key,
    this.data,
    this.isPreview = false,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Templete(
          customPadding: const EdgeInsets.symmetric(
              vertical: LayoutConstant.paddingVertical - 10),
          child: Container(
            alignment: Alignment.center,
            height: (data as Asset).isPortrait ? 280 : 200,
            child: Stack(
              children: [
                AssetThumb(
                  asset: (data as Asset),
                  width: Get.width.toInt(),
                  height: (data as Asset).isPortrait ? 280 : 200,
                ),
                // if ((data as Asset).isPortrait)
                //   Center(
                //     child: Container(
                //       color: Colors.white,
                //       child: Text(
                //         'isPortrait',
                //         style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   )
                // else
                //   Center(
                //     child: Container(
                //       color: Colors.white,
                //       child: Text(
                //         'isLandscape',
                //         style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   )
              ],
            ),
          )),
      onTap: isPreview
          ? () async {
              final controller = ControllerContent.to;
              List<KeepData> tempData = List.of(controller.popData());
              List<ModelImage> modelImages = [];
              String currentImage = "";
              controller.setLoadingImages();
              for (var keepData in tempData) {
                if (keepData.type == "IMAGE") {
                  if (keepData.id == id) {
                    currentImage = id!;
                  }
                  modelImages.add(ModelImage(
                      id: keepData.id,
                      image: ((await (keepData.rawData as Asset).getByteData())
                          .buffer
                          .asUint8List())));
                }
              }
              controller.setLoadingImages();
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false, // set to false
                  fullscreenDialog: true,
                  reverseTransitionDuration: const Duration(milliseconds: 10),
                  pageBuilder: (_, __, ___) => PhotoViewPage(
                    currentIndex: modelImages.indexOf(modelImages
                        .firstWhere((element) => element.id == currentImage)),
                    heroTag: currentImage,
                    isImageBase64: true,
                    image: modelImages,
                  ),
                ),
              );
            }
          : null,
    );
  }
}

class ModelImage {
  final String id;
  final Uint8List? image;

  ModelImage({required this.id, this.image});
}

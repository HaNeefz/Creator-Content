import 'dart:io';
import 'dart:typed_data';

import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/models/model_view.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../module_view_image/view_images.dart';
import 'template.dart';

class LayoutImage extends StatelessWidget {
  final String? id;
  final dynamic data;
  final bool isPreview;
  final ObjectContent? obj;
  const LayoutImage({
    Key? key,
    this.data,
    this.isPreview = false,
    this.id,
    this.obj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Templete(
          addPaddingHorizontal: true,
          obj: obj,
          isPreview: isPreview,
          child: Container(
            // color: Colors.white,
            child: Hero(
              tag: id ?? UniqueKey().toString(),
              transitionOnUserGestures: true,
              child: Image.file(
                File((data as XFile).path),
                width: Get.width,
                height: 280,
                // cacheWidth: Get.width.toInt(),
                // cacheHeight: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
          )
          // FlutterLogo(
          //   size: 150,
          // ),
          // child: AssetThumb(
          //   asset: (data as Asset),
          //   width: Get.width.toInt(),
          // ),
          ),
      // Templete(
      //   customPadding: const EdgeInsets.symmetric(
      //     vertical: LayoutConstant.paddingVertical - 10,
      //   ),
      //   child: AssetThumb(
      //     asset: (data as Asset),
      //     width: 200, //Get.width.toInt(),
      //     height: 200, //(data as Asset).isPortrait ? 280 : 200,
      //   ),
      // ),
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
                  modelImages.add(
                    ModelImage(
                      id: keepData.id,
                      image: (await (keepData.rawData as XFile).readAsBytes()),
                    ),
                  );
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

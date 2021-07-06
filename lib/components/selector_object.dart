import 'dart:io';

import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'popup_menu_content_type.dart';

class SelectorObject extends StatelessWidget {
  SelectorObject({Key? key}) : super(key: key);
  final controller = ControllerContent.to;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
        decoration: BoxDecoration(
          // color: Colors.blue,
          border: Border.all(color: Colors.blue, width: 5),
          // borderRadius: BorderRadius.circular(5),
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PopupMenuContentType(
                onSelected: (CONTENT_TYPE type) {
                  debugPrint(type.toString());
                  addContentObject(type);
                },
              ),
              // iconButtonCustom(
              //   icon: Icons.keyboard_arrow_up_outlined,
              //   onPressed: controller.hasContent && controller.isSwapUp()
              //       ? () => controller.swapUp()
              //       : null,
              // ),
              // iconButtonCustom(
              //   icon: Icons.keyboard_arrow_down_outlined,
              //   onPressed: controller.hasContent && controller.isSwapDown()
              //       ? () => controller.swapDown()
              //       : null,
              // ),
              // iconButtonCustom(
              //   icon: Icons.remove,
              //   onPressed: controller.hasContent && controller.isSwapUp()
              //       ? () => controller.removeContent()
              //       : null,
              // ),
            ],
          ),
        ));
  }

  Widget iconButtonCustom({IconData? icon, Function()? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }

  void addContentObject(CONTENT_TYPE type) async {
    switch (type) {
      case CONTENT_TYPE.TEXT:
        controller.addContent(ObjectContent(type, data: ""));
        break;
      case CONTENT_TYPE.BULLET:
        controller.addContent(ObjectContent(type, data: ""));

        break;
      case CONTENT_TYPE.URL:
        controller.addContent(ObjectContent(type, data: ""));

        break;
      case CONTENT_TYPE.IMAGE:
        final _picker = ImagePicker();
        final PickedFile? pickedFile =
            await _picker.getImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File file = File(pickedFile.path);
          controller.addContent(ObjectContent(type, data: file));
        }
        break;
      case CONTENT_TYPE.VIDEO:
        final _picker = ImagePicker();
        final PickedFile? pickedFile = await _picker.getVideo(
            source: ImageSource.gallery,
            maxDuration: const Duration(seconds: 10));
        if (pickedFile != null) {
          controller.addContent(ObjectContent(
            type,
            data: VideoPlayerController.file(
              File(pickedFile.path),
            ),
          ));
        }
        break;
      default:
    }
  }
}

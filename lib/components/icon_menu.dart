import 'dart:io';

import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:creator_content/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
// import 'import 'package:multi_image_picker2/multi_image_picker2.dart';';
import 'package:place_picker/place_picker.dart';
import 'package:video_player/video_player.dart';

import 'layout_objects/layout_html_text.dart';

class IconMenu extends StatelessWidget {
  IconMenu({Key? key, this.isInsert = false, this.indexAt}) : super(key: key);
  final controller = ControllerContent.to;
  final bool isInsert;
  final int? indexAt;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconButtonGroup(
          title: "Text",
          children: [
            // _iconButton(Icons.text_fields_rounded, CONTENT_TYPE.TEXT),
            // _iconButton(
            //     Icons.format_list_bulleted_rounded, CONTENT_TYPE.BULLET),
            // _iconButton(Icons.http_rounded, CONTENT_TYPE.HTML_EDITOR),
            _iconButton(Icons.text_fields_rounded, CONTENT_TYPE.TEXT_HTML),
          ],
        ),
        _iconButtonGroup(
          title: "Image & Video",
          children: [
            _iconButton(Icons.photo_library, CONTENT_TYPE.IMAGE),
            _iconButton(Icons.video_collection_rounded, CONTENT_TYPE.VIDEO),
          ],
        ),
        _iconButtonGroup(
          title: "Social",
          children: [
            // _iconButton(Icons.add_link_rounded, CONTENT_TYPE.URL),
            _iconButton(FontAwesomeIcons.youtube, CONTENT_TYPE.YOUTUBE),
            _iconButton(FontAwesomeIcons.tiktok, CONTENT_TYPE.TIKTOK),
            // _iconButton(FontAwesomeIcons.twitter, CONTENT_TYPE.TWITTER),
            // _iconButton(FontAwesomeIcons.instagram, CONTENT_TYPE.INSTAGRAM),
          ],
        ),
        _iconButtonGroup(
          title: "Location",
          children: [
            _iconButton(Icons.pin_drop, CONTENT_TYPE.LOCATION),
          ],
        ),
      ],
    );
  }

  Widget _iconButtonGroup(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // spacing: 10,
          children: children.map((child) => child).toList(),
        ),
        // SizedBox(height: 5),
        Divider(),
      ],
    );
  }

  Widget _iconButton(IconData icon, CONTENT_TYPE type) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        if (!isInsert) {
          Get.back();
          addContentObject(type);
        } else {
          Popup.insertObject(
            selected: (i) {
              Get.back();
              Get.back();
              final _index = indexAt! + i;
              if (_index < 0)
                addContentObject(type, index: 0);
              else
                addContentObject(type, index: _index);
            },
          );
        }
      },
    );
  }

  void addContentObject(CONTENT_TYPE type, {int? index}) async {
    final defualtText = '<p>Some text.</p>';
    switch (type) {
      case CONTENT_TYPE.TEXT:
        controller.addContent(
          ObjectContent(type, data: ""),
          index: index,
        );
        break;
      case CONTENT_TYPE.BULLET:
        controller.addContent(
          ObjectContent(type, data: ""),
          index: index,
        );
        break;
      case CONTENT_TYPE.URL:
        controller.addContent(
          ObjectContent(type, data: ""),
          index: index,
        );
        break;
      case CONTENT_TYPE.TEXT_HTML:
        final data = await Get.to(HtmlEditorExample(
          index: index ?? 0,
          isEdit: false,
        ));
        debugPrint('data : $data');
        if (data != null && data.toString().isNotEmpty)
          controller.addContent(
            ObjectContent(type, data: data),
            index: index,
          );
        break;
      case CONTENT_TYPE.IMAGE:
        List<Asset> images = <Asset>[];
        images = await MultiImagePicker.pickImages(
          maxImages: 300,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(
            takePhotoIcon: "chat",
            doneButtonTitle: "Selected",
          ),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Example App",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
        if (images.isNotEmpty) {
          images.forEach((image) {
            controller.addContent(
              ObjectContent(type, data: image),
              index: index,
            );
            // controller.addContent(
            //   ObjectContent(CONTENT_TYPE.TEXT, data: ""),
            //   index: index,
            // );
            controller.addContent(
              ObjectContent(CONTENT_TYPE.TEXT_HTML, data: defualtText),
              index: index,
            );
          });
        }
        break;
      case CONTENT_TYPE.VIDEO:
        final _picker = ImagePicker();
        final PickedFile? pickedFile = await _picker.getVideo(
            source: ImageSource.gallery,
            maxDuration: const Duration(seconds: 10));
        if (pickedFile != null) {
          controller.addContent(
            ObjectContent(
              type,
              data: VideoPlayerController.file(
                File(pickedFile.path),
              ),
            ),
            index: index,
          );
          // controller.addContent(
          //   ObjectContent(CONTENT_TYPE.TEXT, data: ""),
          //   index: index,
          // );
          controller.addContent(
            ObjectContent(CONTENT_TYPE.TEXT_HTML, data: defualtText),
            index: index,
          );
        }
        break;
      case CONTENT_TYPE.YOUTUBE:
        await Popup.inputText(
          'Enter Youtube URL :',
          keyword: 'youtu',
          onConfirm: (text) {
            controller.addContent(
              ObjectContent(type, data: text),
              index: index,
            );
            // controller.addContent(
            //   ObjectContent(CONTENT_TYPE.TEXT, data: ""),
            //   index: index,
            // );
            controller.addContent(
              ObjectContent(CONTENT_TYPE.TEXT_HTML, data: defualtText),
              index: index,
            );
          },
        );
        break;
      case CONTENT_TYPE.TIKTOK:
        await Popup.inputText(
          'Enter Tiktok URL :',
          keyword: 'tiktok',
          onConfirm: (text) {
            controller.addContent(
              ObjectContent(type, data: text),
              index: index,
            );
            // controller.addContent(
            //   ObjectContent(CONTENT_TYPE.TEXT, data: ""),
            //   index: index,
            // );
            controller.addContent(
              ObjectContent(CONTENT_TYPE.TEXT_HTML, data: defualtText),
              index: index,
            );
          },
        );
        break;
      case CONTENT_TYPE.TWITTER:
        await Popup.inputText(
          'Enter Twitter URL :',
          keyword: 'twitter',
          onConfirm: (text) {
            controller.addContent(
              ObjectContent(type, data: text),
              index: index,
            );
            // controller.addContent(
            //   ObjectContent(CONTENT_TYPE.TEXT, data: ""),
            //   index: index,
            // );
            controller.addContent(
              ObjectContent(CONTENT_TYPE.TEXT_HTML, data: defualtText),
              index: index,
            );
          },
        );
        break;
      case CONTENT_TYPE.INSTAGRAM:
        await Popup.inputText(
          'Enter Instagram URL :',
          keyword: 'instagram',
          onConfirm: (text) {
            controller.addContent(
              ObjectContent(type, data: text),
              index: index,
            );
            // controller.addContent(
            //   ObjectContent(CONTENT_TYPE.TEXT, data: ""),
            //   index: index,
            // );
            controller.addContent(
              ObjectContent(CONTENT_TYPE.TEXT_HTML, data: defualtText),
              index: index,
            );
          },
        );
        break;

      case CONTENT_TYPE.LOCATION:
        LocationResult? result = await controller.onSelectLocation();
        if (result != null) {
          controller.addContent(
            ObjectContent(type,
                data:
                    "${result.name}\n${result.formattedAddress}|${result.latLng!.latitude}, ${result.latLng!.longitude}"),
            index: index,
          );
        }

        break;
      default:
    }
  }
}

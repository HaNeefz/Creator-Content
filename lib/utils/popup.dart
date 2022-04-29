import 'package:creator_content/components/chipWidget.dart';
import 'package:creator_content/components/default_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../components/icon_menu.dart';
import 'image_picker.dart';

class Popup {
  static Future iconMenu({bool isInsert = false, int? indexAt}) {
    return Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text("Menu"),
      content: IconMenu(
        isInsert: isInsert,
        indexAt: indexAt,
      ),
    ));
  }

  static actions(String title, {Function? onConfirm, Function? onCancel}) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: Text(title),
      actions: [
        _buttonCancel(() => onCancel?.call()),
        _buttonSuccess(() => onConfirm?.call())
      ],
    ));
  }

  static Future<bool> suceess(String message) async {
    final data = await Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // title: Text("Menu"),
      content: Text(message),
      actions: [_buttonSuccess()],
    ));
    return data ?? false;
  }

  static Future<bool> error(String message) async {
    final value = await Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // title: Text("Menu"),
      content: Text(message),
      actions: [_buttonCancel()],
    ));
    return value ?? false;
  }

  static inputText(String message,
      {required String keyword,
      Function(String)? onConfirm,
      Function()? onCancel}) async {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(message),
      content: InputText(
        message: message,
        onConfirm: onConfirm,
        onCancel: onCancel,
        keyword: keyword,
      ),
    ));
  }

  static insertObject({Function(int)? selected}) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text('Insert object Up/Down'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.arrow_upward),
            title: Text('Insert to top'),
            onTap: () => selected?.call(0),
          ),
          ListTile(
            leading: Icon(Icons.arrow_downward),
            title: Text('Insert to bottom'),
            onTap: () => selected?.call(1),
          ),
        ],
      ),
    ));
  }

  static loading() {
    Get.dialog(Container(
      width: 100,
      height: 100,
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: CircularProgressIndicator()),
      ),
    ));
  }

  static dismiss() async {
    Get.back();
  }

  static Future<List<XFile?>> imagesPicker() async {
    List<XFile?> images = <XFile>[];

    final _data = await Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text('Select the image source.'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: Icon(Icons.add_a_photo_rounded, color: Colors.black),
              title: Text('Capture a photo'),
              onTap: () async {
                final image = await ImagePickerUtils.singleImageCamera();
                if (image != null) images.add(image);
                Get.back(result: images);
              }),
          ListTile(
              leading:
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.black),
              title: Text('Pick an image'),
              onTap: () async {
                await Popup.loading();
                images.addAll(await ImagePickerUtils.multiImage());
                await Popup.dismiss();
                Get.back(result: images);
              }),
        ],
      ),
    ));

    if (_data != null) images = _data;

    if (images.length == 0)
      return [];
    else
      return images;
  }

  static Future<XFile?> videosPicker() async {
    XFile? video;

    final _data = await Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text('Select the video source.'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: Icon(Icons.video_call_rounded, color: Colors.black),
              title: Text('Capture a video.'),
              onTap: () async {
                final image = await ImagePickerUtils.videoCapture();
                if (image != null) video = image;
                Get.back(result: video);
              }),
          ListTile(
              leading:
                  Icon(Icons.video_collection_outlined, color: Colors.black),
              title: Text('Pick a video'),
              onTap: () async {
                final image = await ImagePickerUtils.videoGallery();
                if (image != null) video = image;
                Get.back(result: video);
              }),
        ],
      ),
    ));
    if (_data != null) video = _data;
    return video;
  }

  static Future<String> addHashTag([String? hashTags]) async {
    List<String> tags = [];
    if (hashTags != null) {
      if (hashTags.split(', ').length > 0) {
        tags = hashTags.split(', ');
      } else {
        tags.add(hashTags);
      }
    }

    tags = await Get.dialog(AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text('Add a Hashtag.'),
          content: AddHashTagesWidget(tags: tags),
        )) ??
        [];

    return tags.length > 0 ? tags.join(', ') : '';
  }

  static Widget _buttonCancel([Function()? onCancel]) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
      child: Text('Cancel', style: TextStyle(color: Colors.white)),
      onPressed: () {
        onCancel?.call();
        Get.back(result: false);
      },
    );
  }

  static Widget _buttonSuccess([Function()? onSuccess]) {
    return TextButton(
      child: Text('OK', style: TextStyle(color: Colors.black)),
      onPressed: () {
        onSuccess?.call();
        Get.back(result: true);
      },
    );
  }
}

class InputText extends StatelessWidget {
  final String message;
  final String keyword;
  final Function()? onCancel;
  final Function(String)? onConfirm;
  const InputText({
    Key? key,
    required this.keyword,
    this.message = '',
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextField(
          controller: controller,
          hintText: 'https://exmaple.com',
          prefixIcon: Icon(Icons.link_rounded),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                onCancel?.call();
                Get.back(result: false);
              },
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (controller.text.isNotEmpty &&
                    controller.text.contains(keyword)) {
                  onConfirm?.call(controller.text);
                  Get.back(result: true);
                } else if (controller.text.isNotEmpty &&
                    !controller.text.contains(keyword)) {
                  Popup.error('Please enter URL is contains ($keyword)');
                } else
                  Popup.error('Please enter url');
              },
            )
          ],
        )
      ],
    );
  }
}

class AddHashTagesWidget extends StatefulWidget {
  final List<String> tags;
  const AddHashTagesWidget({Key? key, required this.tags}) : super(key: key);

  @override
  _AddHashTagesWidgetState createState() => _AddHashTagesWidgetState();
}

class _AddHashTagesWidgetState extends State<AddHashTagesWidget> with Popup {
  final TextEditingController tagController = TextEditingController(text: '');
  List<String> _tags = [];
  int currentlengthTags = 0;
  @override
  void initState() {
    super.initState();
    _tags = widget.tags;
    currentlengthTags = _tags.length;
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.tag_rounded,
                        ),
                        // suffixIcon: IconButton(
                        //   onPressed: () {
                        //     _tags.add("#${tagController.text}");
                        //     tagController.clear();
                        //     setState(() {});
                        //   },
                        //   icon: Icon(Icons.add_circle),
                        // ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: () {
                      if (tagController.text != '') {
                        _tags.add("#${tagController.text}");
                        tagController.clear();
                        setState(() {});
                      }
                    },
                  )
                  // TextButton(
                  //   style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all(Colors.blue),
                  //       foregroundColor:
                  //           MaterialStateProperty.all(Colors.white),
                  //       shape:
                  //           MaterialStateProperty.all<RoundedRectangleBorder>(
                  //               RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //       ))),
                  //   child: Icon(Icons.add),
                  //   onPressed: () {
                  //     _tags.add("#${tagController.text}");
                  //     tagController.clear();
                  //     setState(() {});
                  //   },
                  // )
                ],
              ),
              ViewHashTageWidget(
                tags: _tags.join(', '),
                isEdit: true,
                onCancel: (e) {
                  _tags.remove(e);
                  setState(() {});
                },
              ),
              // Wrap(
              //   spacing: 5.0,
              //   children: [
              //     ..._tags.map((e) {
              //       return InputChip(
              //         label: Text(
              //           e.toString(),
              //         ),
              //         onDeleted: () {
              //           _tags.remove(e);
              //           setState(() {});
              //         },
              //       );
              //     }).toList(),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Get.back(result: <String>[]);
                    },
                  ),
                  if (currentlengthTags != _tags.length) ...[
                    SizedBox(width: 5),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue)),
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Get.back(result: _tags.length > 0 ? _tags : <String>[]);
                      },
                    ),
                  ]
                ],
              ),
            ],
          ),
        ));
  }
}

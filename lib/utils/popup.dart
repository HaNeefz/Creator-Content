import 'package:creator_content/components/default_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/icon_menu.dart';

class Popup {
  static iconMenu({bool isInsert = false, int? indexAt}) {
    Get.dialog(AlertDialog(
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
    return await Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // title: Text("Menu"),
      content: Text(message),
      actions: [_buttonSuccess()],
    ));
  }

  static Future<bool> error(String message) async {
    return await Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      // title: Text("Menu"),
      content: Text(message),
      actions: [_buttonCancel()],
    ));
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

import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color_picker_widget.dart';

class TextToolsBar extends StatelessWidget {
  const TextToolsBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Obx(
        // () => controller.hasModify ? showButtons(controller) : Container());
        () {
      if (controller.contents.length > 0 &&
          controller.hasInput() &&
          !(controller.isSelectedContent.value))
        return showButtons(context, controller);
      else
        return Container();
    });
  }

  Widget showButtons(context, ControllerContent controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: activeStyle(
              child: IconButton(
                icon: Text(
                  "A",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                onPressed: () => controller.setNormalText(),
              ),
              active: !controller.getTextIsLarge(),
            ),
          ),
          Expanded(
            child: activeStyle(
              child: IconButton(
                icon: Text(
                  "A",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                onPressed: () => controller.setBigText(),
              ),
              active: controller.getTextIsLarge(),
            ),
          ),
          Expanded(
            child: activeStyle(
                child: IconButton(
                  icon: Icon(
                    Icons.format_bold_rounded,
                  ),
                  onPressed: () => controller.setBoldText(),
                ),
                active: controller.getTextIsBold()),
          ),
          Expanded(
            child: activeStyle(
                child: IconButton(
                  icon: Icon(
                    Icons.format_italic_rounded,
                  ),
                  onPressed: () => controller.setItalicText(),
                ),
                active: controller.getTextIsItalic()),
          ),
          Expanded(
            child: activeStyle(
                child: IconButton(
                  icon: Icon(
                    Icons.format_underline_rounded,
                  ),
                  onPressed: () => controller.setUnderlineText(),
                ),
                active: controller.getTextIsUnderline()),
          ),
          Expanded(
            child: activeStyle(
              child: IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: controller.getTextColor(),
                  ),
                ),
                onPressed: () {
                  Get.dialog(AlertDialog(
                    title: const Text('Pick a color!'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    content: SingleChildScrollView(
                      child: ColorPickerWidget(
                        recentColor: controller.getTextColor(),
                        onChange: (Color color) {
                          controller.setColorText(color);
                        },
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('close'),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget activeStyle({required Widget child, bool active = false}) {
    // debugPrint('active : $active');
    return Container(
        decoration: BoxDecoration(
            color: active ? Colors.white70 : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(3),
        child: child);
  }
}

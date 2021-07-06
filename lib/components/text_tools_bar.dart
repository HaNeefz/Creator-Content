import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextToolsBar extends StatelessWidget {
  const TextToolsBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Obx(() => controller.hasModify
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: activeStyle(
                  child: IconButton(
                    icon: Icon(
                      Icons.text_format_rounded,
                    ),
                    onPressed: () => controller.setBigText(),
                  ),
                ),
              ),
              Expanded(
                child: activeStyle(
                  child: IconButton(
                    icon: Icon(
                      Icons.text_format_rounded,
                      size: 20,
                    ),
                    onPressed: () => controller.setNormalText(),
                  ),
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
                    active: controller.textIsBold),
              ),
              Expanded(
                child: activeStyle(
                    child: IconButton(
                      icon: Icon(
                        Icons.format_italic_rounded,
                      ),
                      onPressed: () => controller.setItalicText(),
                    ),
                    active: controller.textIsItalic),
              ),
              Expanded(
                child: activeStyle(
                    child: IconButton(
                      icon: Icon(
                        Icons.format_underline_rounded,
                      ),
                      onPressed: () => controller.setUnderlineText(),
                    ),
                    active: controller.textIsUnderLine),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3)),
                  child: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: () => controller.onModify(),
                  ),
                ),
              ),
            ],
          )
        : Container());
  }

  Widget activeStyle({required Widget child, bool active = false}) {
    debugPrint("active $active");
    return Container(
        decoration: BoxDecoration(
            color: active ? Colors.grey : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(3),
        child: child);
  }
}

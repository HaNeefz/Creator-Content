import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ContentLayout extends StatelessWidget {
  final Widget child;
  final int objId;
  const ContentLayout({Key? key, required this.child, required this.objId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Container(
      child: Obx(() => Row(
            children: [
              Expanded(
                child: IgnorePointer(
                  ignoring: controller.isEditLayout.value ||
                      (controller.hasModify &&
                          objId != controller.modifyIndexAt),
                  child: child,
                ),
              ),
              if (controller.isEditLayout.value)
                Container(
                  width: 25,
                  // height: 50,
                  constraints: BoxConstraints(minHeight: 50),
                  color: Colors.grey,
                  child: Icon(
                    Icons.menu_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                )
            ],
          )),
    );
  }
}

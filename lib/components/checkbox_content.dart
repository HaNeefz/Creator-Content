import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SelectObjectWidget extends StatelessWidget {
  const SelectObjectWidget({
    Key? key,
    required this.child,
    required this.objId,
  }) : super(key: key);

  final Widget child;
  final int objId;

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Obx(() => Row(
          children: [
            Checkbox(
                value: controller.selectedContent.contains(objId),
                onChanged: (v) => controller.selectedObj(objId)),
            Expanded(
              child: IgnorePointer(
                ignoring: controller.isSelectedContent.value,
                child: child,
              ),
            )
          ],
        ));
  }
}

import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';

class ContentLayout extends StatefulWidget {
  final Widget child;
  final int objId;
  const ContentLayout({Key? key, required this.child, required this.objId})
      : super(key: key);

  @override
  _ContentLayoutState createState() => _ContentLayoutState();
}

class _ContentLayoutState extends State<ContentLayout> {
  final controller = ControllerContent.to;
  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      if (FocusScope.of(context).canRequestFocus) {
        FocusScope.of(context).requestFocus(controller.lastFocus.value);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() => Row(
            children: [
              Expanded(
                child: IgnorePointer(
                  ignoring: controller.isEditLayout.value ||
                      (controller.hasModify &&
                          widget.objId != controller.modifyIndexAt.value),
                  child: widget.child,
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

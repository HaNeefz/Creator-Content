import 'package:creator_content/components/slidable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/button_add_content.dart';
import 'components/text_tools_bar.dart';
import 'controllers/controller_content.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerContent());
    return Scaffold(
      appBar: AppBar(
        title: Text('Creator content'),
        leading: Obx(() {
          if (controller.showIconDelete) {
            return IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => controller.removeSelectedObject(),
            );
          } else
            return Container();
          // if (controller.isSelectedContent.value) {
          //   return Checkbox(
          //     value: controller.isSelectedAll,
          //     onChanged: (v) {

          //     },
          //   );
          // }
          // else
          //   return Container();
        }),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(!controller.hasEditObjectOrSelected
                  ? Icons.send
                  : Icons.check),
              onPressed: controller.confirmEditUI,
            ),
          )
        ],
      ),
      body: Obx(() => Column(
            children: [
              TextToolsBar(),
              Expanded(
                  child: ReorderableListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                buildDefaultDragHandles: controller.isEditLayout.value,
                children: [
                  ...controller.contents.map((data) {
                    int index = controller.contents.indexOf(data);
                    return SlidableWidget(
                        key: ValueKey(data.id),
                        objId: data.id!,
                        contentTpye: data.type,
                        index: index,
                        child: Container(
                            key: ValueKey(data.id),
                            child: data.createWidget(
                              controller.isSelectedContent.value,
                              data.id!,
                              objKey: controller.objKeys.firstWhere(
                                  (objKey) => objKey.objId == data.id!),
                              index: index,
                            )));
                  }).toList(),
                  SizedBox(key: UniqueKey(), height: 150)
                ],
                onReorder: controller.onReorder,
              ))
            ],
          )),
      floatingActionButton: ButtonAddContent(),
    );
  }
}

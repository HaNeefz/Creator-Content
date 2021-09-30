import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/button_add_content.dart';
import 'components/slidable_widget.dart';
import 'components/text_tools_bar.dart';
import 'controllers/controller_content.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerContent());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Content Creator'),
          leading: Obx(() {
            if (controller.isSelectedContent.value)
              return Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Checkbox(
                        // value: controller.checkSelectedAll(),
                        value: controller.isSelectedAll,
                        onChanged: (v) {
                          controller.onSelectedAll(v!);
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(child: Text('All')),
                  ],
                ),
              );
            return Container();
          }),
          actions: [
            Obx(
              () => Row(
                children: [
                  if (controller.showIconDelete) ...[
                    SizedBox(width: 15),
                    IconButton(
                      icon: Icon(Icons.delete_sweep_rounded),
                      onPressed: () => controller.removeSelectedObject(),
                    )
                  ] else
                    Container(),
                  IconButton(
                    icon: Icon(!controller.hasEditObjectOrSelected
                        ? Icons.send
                        : Icons.check),
                    onPressed: controller.confirmEditUI,
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.gps_off),
                  //   onPressed: () async {
                  //     var result = await Get.to(() => HtmlEditorExample());
                  //     debugPrint('result : $result');
                  //   },
                  // )
                ],
              ),
            ),
          ],
          elevation: 0.0,
        ),
        body: Column(
            children: [TextToolsBar(), Expanded(child: ContentWidget())]),
        floatingActionButton: ButtonAddContent(),
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget>
    with AutomaticKeepAliveClientMixin {
  late ControllerContent controller;
  @override
  void initState() {
    super.initState();
    controller = ControllerContent.to;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => ReorderableListView(
          physics: ClampingScrollPhysics(),
          // physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          dragStartBehavior: DragStartBehavior.down,
          proxyDecorator: (child, _, animated) {
            return FocusDragWidget(
              child: child,
            );
          },
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
                        objKey: controller.objKeys
                            .firstWhere((objKey) => objKey.objId == data.id!),
                        index: index,
                      )));
            }).toList(),
            SizedBox(key: UniqueKey(), height: 150)
          ],
          onReorder: controller.onReorder,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class FocusDragWidget extends StatelessWidget {
  final Widget child;
  const FocusDragWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 5,
              color: Colors.blueGrey,
              offset: Offset(0, 2.5),
            ),
          ],
        ),
        child: Material(child: child),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/controller_content.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerContent());
    return Scaffold(
      appBar: AppBar(
        title: Text('Creator content'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => controller.onSaveData(),
          )
        ],
      ),
      body: Obx(() => Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: controller.contents.length,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, i) {
                  var data = controller.contents[i];
                  return Container(
                      key: ValueKey(data.id),
                      child: data.createWidget(controller.isFocus(i)));
                },
              ))
            ],
          )),
    );
  }
}

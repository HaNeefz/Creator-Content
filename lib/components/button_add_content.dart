import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/state_manager.dart';

import '../utils/popup.dart';

class ButtonAddContent extends StatelessWidget {
  const ButtonAddContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Obx(() => SpeedDial(
          /// both default to 16
          marginEnd: 18,
          marginBottom: 20,
          // animatedIcon: AnimatedIcons.menu_close,
          // animatedIconTheme: IconThemeData(size: 22.0),
          /// This is ignored if animatedIcon is non null
          icon: Icons.add,
          activeIcon: Icons.remove,
          // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
          /// The label of the main button.
          // label: Text("Open Speed Dial"),
          /// The active label of the main button, Defaults to label if not specified.
          // activeLabel: Text("Close Speed Dial"),
          /// Transition Builder between label and activeLabel, defaults to FadeTransition.
          // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
          /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
          buttonSize: 56.0,
          visible: !controller.hasEditObjectOrSelected,

          /// If true user is forced to close dial manually
          /// by tapping main button and overlay is not rendered.
          closeManually: false,

          /// If true overlay will render no matter what.
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.3,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Add Content',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 3.0,
          shape: CircleBorder(),
          // orientation: SpeedDialOrientation.Up,
          // childMarginBottom: 2,
          // childMarginTop: 2,
          children: [
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
              label: 'Add Content',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: Colors.white,
              onTap: () => Popup.iconMenu(),
              // onLongPress: () => print('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.layers_outlined),
              backgroundColor: Colors.red,
              label: 'Edit Layout',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: Colors.white,
              onTap: () => controller.onEditContent(),
              // onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.checklist_rounded),
              backgroundColor: Colors.grey,
              labelBackgroundColor: Colors.white,
              label: 'Select Object',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => controller.onSelectedObject(),
              // onLongPress: () => print('THIRD CHILD LONG PRESS'),
            ),
          ],
        ));
  }
}

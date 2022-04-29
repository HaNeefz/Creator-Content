import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/models/object_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../utils/popup.dart';

class SlidableWidget extends StatelessWidget {
  final Widget child;
  final int index;
  final int objId;
  final CONTENT_TYPE contentTpye;
  const SlidableWidget(
      {Key? key,
      required this.child,
      required this.index,
      required this.contentTpye,
      required this.objId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Obx(() => Slidable(
          key: key,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.15,
          actions: <Widget>[
            // IconSlideAction(
            //   caption: 'Archive',
            //   color: Colors.blue,
            //   icon: Icons.archive,
            //   onTap: () {},
            // ),
            // IconSlideAction(
            //   caption: 'Share',
            //   color: Colors.indigo,
            //   icon: Icons.share,
            //   onTap: () {},
            // ),
          ],
          secondaryActions: <Widget>[
            // if (!controller.hasEditObjectOrSelected) ...[
            if (!controller.isSelectedContent.value) ...[
              IconSlideAction(
                caption: 'Insert',
                color: Colors.black45,
                icon: Icons.more_horiz,
                onTap: () {
                  Popup.iconMenu(isInsert: true, indexAt: index);
                },
              ),
              if (contentTpye == CONTENT_TYPE.LOCATION)
                IconSlideAction(
                  caption: 'Edit',
                  foregroundColor: Colors.white,
                  color: Colors.lightBlueAccent,
                  icon: Icons.map_sharp,
                  onTap: () async {
                    await controller.onEditLocation(objId);
                  },
                ),
              // if (contentTpye == CONTENT_TYPE.BULLET ||
              //     contentTpye == CONTENT_TYPE.TEXT ||
              //     // contentTpye == CONTENT_TYPE.TEXT_BOLD ||
              //     contentTpye == CONTENT_TYPE.URL)
              //   IconSlideAction(
              //     caption: 'Style',
              //     color: Colors.blue,
              //     icon: !controller.hasModify
              //         ? Icons.font_download_rounded
              //         : Icons.check,
              //     onTap: () {
              //       controller.onModify(objId);
              //     },
              //   ),
              if (!controller.hasModify) ...[
                IconSlideAction(
                  caption: 'Hashtag',
                  foregroundColor: Colors.white,
                  color: Colors.blue,
                  icon: Icons.tag_rounded,
                  onTap: () async {
                    controller.addHashTags(
                        index,
                        await Popup.addHashTag(
                            controller.contents[index].hashTags));
                  },
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    Popup.actions('Confirm to delete.',
                        onConfirm: () => controller.removeContentAt(index));
                  },
                )
              ]
              // if (!controller.hasModify)
              //   IconSlideAction(
              //     caption: 'Delete',
              //     color: Colors.red,
              //     icon: Icons.delete,
              //     onTap: () {
              //       Popup.actions('Confirm to delete.',
              //           onConfirm: () => controller.removeContentAt(index));
              //     },
              //   ),
            ]
            // IconSlideAction(
            //   caption: 'More',
            //   color: Colors.black45,
            //   icon: Icons.more_horiz,
            //   onTap: () {},
            // ),
            // IconSlideAction(
            //   caption: 'Delete',
            //   color: Colors.red,
            //   icon: Icons.delete,
            //   onTap: () {},
            // ),
          ],
          child: child,
        ));
  }
}

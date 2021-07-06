import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/popup.dart';

class SlidableWidget extends StatelessWidget {
  final Widget child;
  final int index;
  const SlidableWidget({Key? key, required this.child, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Slidable(
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
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              Popup.actions('Confirm to delete.',
                  onConfirm: () => controller.removeContentAt(index));
            },
          ),
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
    );
  }
}

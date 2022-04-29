import 'package:creator_content/controllers/controller_content.dart';
import 'package:flutter/material.dart';

class ViewHashTageWidget extends StatelessWidget {
  final String? tags;
  final bool isEdit;
  final bool isPreview;
  final Function(String)? onCancel;
  const ViewHashTageWidget(
      {Key? key,
      required this.tags,
      this.isEdit = false,
      this.onCancel,
      this.isPreview = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentController = ControllerContent.to;
    return Container(
      child: tags != null
          ? Wrap(
              spacing: 5,
              children: [
                if (tags!.length > 0)
                  if (tags!.split(', ').length > 0)
                    ...tags?.split(', ').map((e) {
                          if (e != '') {
                            if (isEdit) {
                              return InputChip(
                                label: Text(
                                  e.toString(),
                                ),
                                onDeleted: () => onCancel?.call(e),
                              );
                            } else
                              return GestureDetector(
                                child: Chip(
                                  label: Text(e),
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  if (isPreview)
                                    contentController.gotoHashTagPage(e);
                                },
                              );
                          } else
                            return Container();
                        }).toList() ??
                        [Container()]
              ],
            )
          : Container(),
    );
  }
}

import 'package:creator_content/controllers/controller_content.dart';
import 'package:creator_content/pages/preview/preview_data.dart';
import 'package:flutter/material.dart';

class HashTagsPage extends StatelessWidget {
  final String? tag;
  const HashTagsPage({Key? key, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ControllerContent.to;
    return Scaffold(
      appBar: AppBar(
        title: Text(tag ?? ''),
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: controller.tagPeriodsDate.length,
          itemBuilder: (BuildContext context, int index) {
            var data = controller.tagPeriodsDate.toList()[index];
            return Column(children: [
              ...data.item
                  .map((ee) => PreviewDataState.createWidget(ee))
                  .toList()
            ]);
          },
        ),
      ),
    );
  }
}

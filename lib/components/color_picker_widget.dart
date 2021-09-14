import 'package:creator_content/themes/color_constants.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color recentColor;
  final ValueChanged<Color>? onChange;
  ColorPickerWidget(
      {Key? key, this.onChange, this.recentColor = ColorConstant.black})
      : super(key: key);

  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(ColorConstant.black): 'black',
    ColorTools.createPrimarySwatch(ColorConstant.red): 'red',
    ColorTools.createPrimarySwatch(ColorConstant.pink): 'pink',
    ColorTools.createPrimarySwatch(ColorConstant.purple): 'purple',
    ColorTools.createPrimarySwatch(ColorConstant.deepPurple): 'deepPurple',
    ColorTools.createPrimarySwatch(ColorConstant.indigo): 'indigo',
    ColorTools.createPrimarySwatch(ColorConstant.blue): 'blue',
    ColorTools.createPrimarySwatch(ColorConstant.lightBlue): 'lightBlue',
    ColorTools.createPrimarySwatch(ColorConstant.cyan): 'cyan',
    ColorTools.createPrimarySwatch(ColorConstant.teal): 'teal',
    ColorTools.createPrimarySwatch(ColorConstant.green): 'green',
    ColorTools.createPrimarySwatch(ColorConstant.lightGreen): 'lightGreen',
    ColorTools.createPrimarySwatch(ColorConstant.lime): 'lime',
    ColorTools.createPrimarySwatch(ColorConstant.yellow): 'yellow',
    ColorTools.createPrimarySwatch(ColorConstant.amber): 'amber',
    ColorTools.createPrimarySwatch(ColorConstant.orange): 'orange',
    ColorTools.createPrimarySwatch(ColorConstant.deepOrange): 'deepOrange',
    ColorTools.createPrimarySwatch(ColorConstant.brown): 'brown',
    ColorTools.createPrimarySwatch(ColorConstant.blueGrey): 'blueGrey',
    ColorTools.createPrimarySwatch(ColorConstant.grey): 'grey',
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: ColorPicker(
            pickersEnabled: {
              ColorPickerType.custom: true,
              ColorPickerType.primary: false,
              ColorPickerType.accent: false,
            },
            // Use the screenPickerColor as start color.
            color: recentColor,
            customColorSwatchesAndNames: colorsNameMap,
            onColorChanged: (Color color) {
              debugPrint("$color");
              onChange?.call(color);
            },
            width: 44,
            height: 44,
            borderRadius: 22,
            // showColorCode: true,
            // copyPasteBehavior: const ColorPickerCopyPasteBehavior(
            //   longPressMenu: true,
            // ),
            // showRecentColors: true,
            // recentColorsSubheading: Text('Recent Color'),
            enableShadesSelection: false,
          ),
        ),
      ],
    );
  }
}

/*
 ColorPicker(
              // Use the dialogPickerColor as start color.
              color: Color(0xff000000),
              // Update the dialogPickerColor using the callback.
              onColorChanged: (Color color) {},
              width: 40,
              height: 40,
              borderRadius: 4,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 155,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              wheelSubheading: Text(
                'Selected color and its shades',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              showMaterialName: true,
              showColorName: true,
              showColorCode: true,
              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                longPressMenu: true,
              ),
              materialNameTextStyle: Theme.of(context).textTheme.caption,
              colorNameTextStyle: Theme.of(context).textTheme.caption,
              colorCodeTextStyle: Theme.of(context).textTheme.caption,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: false,
                ColorPickerType.custom: true,
                ColorPickerType.wheel: true,
              },
              customColorSwatchesAndNames: colorsNameMap,
            ).showPickerDialog(
              context,
              constraints: const BoxConstraints(
                  minHeight: 460, minWidth: 300, maxWidth: 320),
            );
*/

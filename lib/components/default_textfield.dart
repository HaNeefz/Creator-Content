import 'package:flutter/material.dart';

enum TEXT_SIZE { NORMAL, NORMAL_BOLD, BIG, BIG_BOLD }

// ignore: must_be_immutable
class DefaultTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final Function()? onTap;
  final String hintText;
  final Color textColor;
  final TEXT_SIZE textSize;
  final Widget? prefixIcon;
  DefaultTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.hintText = '...',
    this.textSize = TEXT_SIZE.NORMAL,
    this.prefixIcon,
    this.textColor = Colors.black,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: 18,
      color: textColor,
    );
    switch (textSize) {
      case TEXT_SIZE.NORMAL_BOLD:
        // style.copyWith(fontWeight: FontWeight.bold);
        style = TextStyle(
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.bold,
        );
        break;
      case TEXT_SIZE.BIG:
        // style.copyWith(fontSize: 22);
        style = TextStyle(
          fontSize: 22,
          color: textColor,
        );
        break;
      case TEXT_SIZE.BIG_BOLD:
        // style.copyWith(
        //   fontSize: 22,
        //   fontWeight: FontWeight.bold,
        // );
        style = TextStyle(
          fontSize: 22,
          color: textColor,
          fontWeight: FontWeight.bold,
        );
        break;
      default:
        style = TextStyle(
          fontSize: 18,
          color: textColor,
        );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
        controller: controller,
        style: style,
        onTap: () {
          onTap?.call();
        },
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(),
            prefixIcon: prefixIcon,
            border: InputBorder.none,
            hintText: hintText,
            contentPadding: const EdgeInsets.all(8)),
        minLines: null,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        onChanged: (value) => onChanged?.call(value),
      ),
    );
  }
}

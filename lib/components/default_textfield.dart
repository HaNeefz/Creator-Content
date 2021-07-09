import 'package:flutter/material.dart';

enum TEXT_SIZE { NORMAL, NORMAL_BOLD, BIG, BIG_BOLD, BOLD }
enum TEXT_STYLE { ITALIC, UNDERLINE, LINETHROUGH }

// ignore: must_be_immutable
class DefaultTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
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
    this.focusNode,
  }) : super(key: key);

  @override
  DefaultTextFieldState createState() => DefaultTextFieldState();
}

class DefaultTextFieldState extends State<DefaultTextField> {
  TextStyle? style;
  bool _italic = false;
  bool _underline = false;
  bool _bold = false;
  bool _large = false;

  bool get large => _large;
  bool get underline => _underline;
  bool get italic => _italic;
  bool get bold => _bold;

  @override
  void initState() {
    super.initState();
    setStyle(widget.textSize);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
        autofocus: true,
        controller: widget.controller,
        focusNode: widget.focusNode,
        showCursor: true,
        style: style,
        onTap: () {
          widget.onTap?.call();
        },
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(),
            prefixIcon: widget.prefixIcon,
            border: InputBorder.none,
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.all(8)),
        minLines: null,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        onChanged: (value) => widget.onChanged?.call(value),
      ),
    );
  }

  setStyle(TEXT_SIZE textSize) {
    if (style == null) {
      style = TextStyle(fontSize: 18, color: widget.textColor);
      _large = false;
    } else
      switch (textSize) {
        case TEXT_SIZE.NORMAL_BOLD:
          style = style!.copyWith(fontSize: 18, fontWeight: FontWeight.bold);
          break;
        case TEXT_SIZE.BIG:
          style = style!.copyWith(fontSize: 22);
          _large = true;
          break;
        case TEXT_SIZE.BIG_BOLD:
          style = style!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          );
          break;
        case TEXT_SIZE.BOLD:
          if (!_bold)
            style = style!.copyWith(fontWeight: FontWeight.bold);
          else
            style = style!.copyWith(fontWeight: FontWeight.normal);
          _bold = !_bold;
          break;
        default:
          style = style!.copyWith(fontSize: 18);
          _large = false;
      }
  }

  changeTextSize(TEXT_SIZE size) {
    setStyle(size);
    setState(() {});
  }

  changeTextDecoration(TEXT_STYLE styleDecoration) {
    switch (styleDecoration) {
      case TEXT_STYLE.ITALIC:
        if (!_italic)
          style = style!.copyWith(fontStyle: FontStyle.italic);
        else
          style = style!.copyWith(fontStyle: FontStyle.normal);

        _italic = !_italic;
        break;
      case TEXT_STYLE.UNDERLINE:
        if (!_underline)
          style = style!.copyWith(decoration: TextDecoration.underline);
        else
          style = style!.copyWith(decoration: TextDecoration.none);

        _underline = !_underline;

        break;
      default:
    }
    setState(() {});
  }
}

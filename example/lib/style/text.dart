import 'color.dart';
import 'size.dart';
import 'package:flutter/material.dart';

class StandardTextStyle {
  static const TextStyle big = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SysSize.big,
    color: ColorPlate.darkGray,
    height: 1.2,
    inherit: true,
  );
  static const TextStyle normalW = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    height: 1.2,
    inherit: true,
  );
  static const TextStyle normal = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    height: 1.2,
    inherit: true,
  );
  static const TextStyle small = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: SysSize.small,
    color: ColorPlate.gray,
    height: 1.4,
    inherit: true,
  );
}

class StText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextStyle? defaultStyle;
  final int? maxLines;

  const StText({
    Key? key,
    this.text,
    this.style,
    this.defaultStyle,
    this.maxLines,
  }) : super(key: key);

  const StText.small(
    String text, {
    Key? key,
    TextStyle? style,
    bool? enableOffset,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.small,
          maxLines: maxLines,
        );

  const StText.normal(
    String text, {
    TextStyle? style,
    Key? key,
    bool? enableOffset,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.normal,
          maxLines: maxLines,
        );

  const StText.big(
    String text, {
    Key? key,
    TextStyle? style,
    bool? enableOffset,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.big,
          maxLines: maxLines,
        );

  @override
  Widget build(BuildContext context) {
    var finalText = text;
    return Container(
      child: DefaultTextStyle(
        style: defaultStyle ?? TextStyle(),
        child: Text(
          finalText ?? '',
          maxLines: maxLines ?? 5,
          style: style,
        ),
      ),
    );
  }
}

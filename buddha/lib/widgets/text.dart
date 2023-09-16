import 'package:flutter/cupertino.dart';

displayText({
  String? text,
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  String? fontFamily,
  int? maxLines,
}) {
  return Text(
    text.toString(),
    style: TextStyle(
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
    maxLines: maxLines,
  );
}

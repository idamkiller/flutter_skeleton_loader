import 'package:flutter/material.dart';
import '../interfaces/base_skeleton_provider.dart';
import '../widgets/skeletons/text_field_skeleton.dart';

class TextFieldSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) =>
      widget is TextField || widget is TextFormField;

  @override
  int get priority => 9;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    double width;
    double height;
    bool isMultiline = false;
    bool hasDecoration = true;

    if (originalWidget is TextField) {
      isMultiline = (originalWidget.maxLines ?? 1) > 1;
      hasDecoration = originalWidget.decoration !=
          InputDecoration.collapsed(hintText: null);
    } else if (originalWidget is TextFormField) {
      isMultiline = false;
      hasDecoration = true;
    }

    if (isMultiline) {
      width = 300;
      height = 120;
    } else {
      width = 250;
      height = 56;
    }

    width = sanitizeDimension(width, 250);
    height = sanitizeDimension(height, 56);

    return TextFieldSkeleton(
      baseColor: baseColor,
      width: width,
      height: height,
      isMultiline: isMultiline,
      hasDecoration: hasDecoration,
    );
  }
}

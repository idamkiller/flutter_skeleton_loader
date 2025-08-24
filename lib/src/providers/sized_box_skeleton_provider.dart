import 'package:flutter/material.dart';
import '../interfaces/base_skeleton_provider.dart';
import '../widgets/skeletons/sized_box_skeleton.dart';

class SizedBoxSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is SizedBox;

  @override
  int get priority => 6;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final sizedBox = originalWidget as SizedBox;

    double? width = sizedBox.width;
    double? height = sizedBox.height;
    bool isEmpty = sizedBox.child == null;

    if (width == null && height == null && !isEmpty) {
      width = 100;
      height = 40;
    }

    width = width != null ? sanitizeDimension(width, 100) : null;
    height = height != null ? sanitizeDimension(height, 40) : null;

    return SizedBoxSkeleton(
      baseColor: baseColor,
      width: width,
      height: height,
      isEmpty: isEmpty,
    );
  }
}

import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/checkbox_skeleton.dart';

class CheckboxSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Checkbox;

  @override
  int get priority => 6;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    originalWidget as Checkbox;

    double size = 18.0;

    size = sanitizeDimension(size, 18.0);

    return CheckboxSkeleton(
      baseColor: baseColor,
      width: size,
      height: size,
    );
  }
}

import 'package:flutter/material.dart';
import '../interfaces/base_skeleton_provider.dart';
import '../widgets/skeletons/switch_skeleton.dart';

class SwitchSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Switch;

  @override
  int get priority => 6;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    originalWidget as Switch;

    double width = 56.0;
    double height = 32.0;

    width = sanitizeDimension(width, 56.0);
    height = sanitizeDimension(height, 32.0);

    return SwitchSkeleton(
      baseColor: baseColor,
      width: width,
      height: height,
    );
  }
}

import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/icon_skeleton.dart';

class IconSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Icon;

  @override
  int get priority => 6;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final icon = originalWidget as Icon;

    double iconSize = icon.size ?? 24.0;

    iconSize = sanitizeDimension(iconSize, 24.0);

    return IconSkeleton(
      baseColor: baseColor,
      size: iconSize,
    );
  }
}

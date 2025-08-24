import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/icon_button_skeleton.dart';

class IconButtonSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is IconButton;

  @override
  int get priority => 7;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final iconButton = originalWidget as IconButton;

    double iconSize = iconButton.iconSize ?? 24.0;

    double buttonSize = iconSize + 24.0;

    buttonSize = sanitizeDimension(buttonSize, 48.0);

    return IconButtonSkeleton(
      baseColor: baseColor,
      width: buttonSize,
      height: buttonSize,
    );
  }
}

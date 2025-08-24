import 'package:flutter/material.dart';
import '../../flutter_skeleton_loader.dart';
import '../interfaces/base_skeleton_provider.dart';

class DropdownButtonSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is DropdownButton;

  @override
  int get priority => 6;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final dropdown = originalWidget as DropdownButton;

    final double iconSize = dropdown.iconSize;
    final double itemHeight = dropdown.itemHeight ?? 48.0;

    double calculatedWidth;

    calculatedWidth = 150.0 + iconSize + 16.0;

    double calculatedHeight = itemHeight;

    if (dropdown.underline != null) {
      calculatedHeight += 8.0;
    }

    calculatedWidth = calculatedWidth.clamp(112.0, 400.0);

    calculatedHeight = calculatedHeight.clamp(48.0, 72.0);

    calculatedWidth = sanitizeDimension(calculatedWidth, 150.0);
    calculatedHeight = sanitizeDimension(calculatedHeight, 48.0);

    return DropdownButtonSkeleton(
      baseColor: baseColor,
      width: calculatedWidth,
      height: calculatedHeight,
    );
  }
}

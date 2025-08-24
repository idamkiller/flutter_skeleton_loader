import 'package:flutter/material.dart';
import '../interfaces/base_skeleton_provider.dart';
import '../widgets/skeletons/container_skeleton.dart';

class ContainerSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Container;

  @override
  int get priority => 8;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final container = originalWidget as Container;

    double? width;
    double? height;

    if (container.constraints != null) {
      final constraints = container.constraints!;

      if (constraints.maxWidth.isFinite && constraints.maxWidth > 0) {
        width = constraints.maxWidth;
      }

      if (constraints.maxHeight.isFinite && constraints.maxHeight > 0) {
        height = constraints.maxHeight;
      }

      if (width == null &&
          constraints.minWidth.isFinite &&
          constraints.minWidth > 0) {
        width = constraints.minWidth;
      }

      if (height == null &&
          constraints.minHeight.isFinite &&
          constraints.minHeight > 0) {
        height = constraints.minHeight;
      }
    }

    width = sanitizeDimension(width, 100);
    height = sanitizeDimension(height, 100);

    return ContainerSkeleton(
      baseColor: baseColor,
      width: width,
      height: height,
    );
  }
}

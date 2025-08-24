import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/image_skeleton.dart';

class ImageSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Image;

  @override
  int get priority => 8;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final image = originalWidget as Image;

    double? width = image.width;
    double? height = image.height;

    if (width == null && height == null) {
      width = 100;
      height = 100;
    } else if (width == null && height != null) {
      width = height;
    } else if (height == null && width != null) {
      height = width;
    }

    width = sanitizeDimension(width, 100);
    height = sanitizeDimension(height, 100);

    return ImageSkeleton(
      baseColor: baseColor,
      width: width,
      height: height,
    );
  }
}

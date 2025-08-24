import 'package:flutter/material.dart';
import '../interfaces/skeleton_provider.dart';
import '../widgets/skeletons/radio_skeleton.dart';

class RadioSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) =>
      widget.runtimeType.toString().startsWith('Radio<');

  @override
  int get priority => 6;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    double size = 20.0;

    size = sanitizeDimension(size, 20.0);

    return RadioSkeleton(
      baseColor: baseColor,
      width: size,
      height: size,
    );
  }
}

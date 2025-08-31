import 'package:flutter/material.dart';
import '../../flutter_skeleton_loader.dart';
import '../interfaces/base_skeleton_provider.dart';

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

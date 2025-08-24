import 'package:flutter/material.dart';
import '../../flutter_skeleton_loader.dart';

class SliderSkeletonProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Slider;

  @override
  int get priority => 5;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    final double calculatedHeight = 20;

    return SliderSkeleton(
      baseColor: baseColor,
      height: calculatedHeight,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class LowPriorityProvider implements SkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Image;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(color: baseColor),
    );
  }

  @override
  int get priority => 1;
}

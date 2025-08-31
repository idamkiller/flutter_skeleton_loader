import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class HighPriorityProvider implements SkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Icon;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: baseColor),
    );
  }

  @override
  int get priority => 10;
}

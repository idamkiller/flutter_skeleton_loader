import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class DefaultPrioritySkeletonProvider implements SkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is SizedBox;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: baseColor),
    );
  }

  @override
  int get priority => 0;
}

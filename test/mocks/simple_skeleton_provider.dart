import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class SimpleSkeletonProvider implements SkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is Text;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container(
      width: 100,
      height: 20,
      decoration: BoxDecoration(color: baseColor),
    );
  }

  @override
  int get priority => 3;
}

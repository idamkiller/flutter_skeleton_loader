import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class NegativePriorityProvider implements SkeletonProvider {
  @override
  bool canHandle(Widget widget) => false;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container();
  }

  @override
  int get priority => -5;
}

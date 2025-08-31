import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/src/interfaces/base_skeleton_provider.dart';

class DefaultPriorityProvider extends BaseSkeletonProvider {
  @override
  bool canHandle(Widget widget) => false;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container();
  }
}

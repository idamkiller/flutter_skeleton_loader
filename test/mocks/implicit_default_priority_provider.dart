import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

class ImplicitDefaultPriorityProvider extends SkeletonProvider {
  @override
  bool canHandle(Widget widget) => widget is FloatingActionButton;

  @override
  Widget createSkeleton(Widget originalWidget, Color baseColor) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: baseColor,
        shape: BoxShape.circle,
      ),
    );
  }

  // NO sobrescribimos priority - usa la implementación por defecto de SkeletonProvider
}

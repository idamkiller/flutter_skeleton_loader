import 'package:flutter/material.dart';
import '../utils/skeleton_registry.dart';

class SkeletonBuilder {
  final Color baseColor;

  const SkeletonBuilder({required this.baseColor});

  Widget buildSkeleton(Widget originalWidget) =>
      SkeletonRegistry.buildSkeleton(originalWidget, baseColor);
}

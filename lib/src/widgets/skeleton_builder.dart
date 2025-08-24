import 'package:flutter/material.dart';
import 'package:flutter_skeleton_loader/flutter_skeleton_loader.dart';

/// [SkeletonBuilder] Builder that uses the new OptimizedSkeletonRegistry to take advantage of
/// all performance and architectural improvements implemented.
///
class SkeletonBuilder {
  final Color baseColor;

  const SkeletonBuilder({required this.baseColor});

  /// [OPTIMIZED MAIN METHOD]
  /// Now uses OptimizedSkeletonRegistry instead of the legacy registry
  Widget buildSkeleton(Widget originalWidget) =>
      OptimizedSkeletonRegistry.buildSkeleton(originalWidget, baseColor);
}

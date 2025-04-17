import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class IconSkeleton extends BaseSkeleton {
  final double? size;

  const IconSkeleton({super.key, required super.baseColor, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
    );
  }
}

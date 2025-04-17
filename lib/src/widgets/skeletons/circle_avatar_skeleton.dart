import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class CircleAvatarSkeleton extends BaseSkeleton {
  final double? radius;

  const CircleAvatarSkeleton({
    super.key,
    required super.baseColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius ?? 40,
      height: radius ?? 40,
      decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
    );
  }
}

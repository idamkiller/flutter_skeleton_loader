import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class CircleAvatarSkeleton extends BaseSkeleton {
  final double radius;

  const CircleAvatarSkeleton({
    super.key,
    required super.baseColor,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
    );
  }
}

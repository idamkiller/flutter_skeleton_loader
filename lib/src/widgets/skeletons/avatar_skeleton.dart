import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class AvatarSkeleton extends BaseSkeleton {
  final double size;
  final bool isCircular;

  const AvatarSkeleton({
    super.key,
    required super.baseColor,
    this.size = 40,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: baseColor,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(size / 4),
      ),
    );
  }
}

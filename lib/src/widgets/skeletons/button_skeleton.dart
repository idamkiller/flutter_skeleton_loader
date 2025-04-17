import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class ButtonSkeleton extends BaseSkeleton {
  final double width;
  final double height;
  final double borderRadius;

  const ButtonSkeleton({
    super.key,
    required super.baseColor,
    this.width = 120,
    this.height = 40,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

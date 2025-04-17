import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class TextFieldSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;
  final double borderRadius;

  const TextFieldSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 48,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

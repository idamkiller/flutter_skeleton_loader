import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class SwitchSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;

  const SwitchSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 40,
      height: height ?? 24,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

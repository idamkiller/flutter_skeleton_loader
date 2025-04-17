import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class SizedBoxSkeleton extends BaseSkeleton {
  final double width;
  final double height;

  const SizedBoxSkeleton({
    super.key,
    required super.baseColor,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 100,
      height: height ?? 10,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

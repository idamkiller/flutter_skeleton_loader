import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class DefaultSkeleton extends BaseSkeleton {
  final double width;
  final double height;

  const DefaultSkeleton({
    super.key,
    required super.baseColor,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class IconButtonSkeleton extends BaseSkeleton {
  final double width;
  final double height;

  const IconButtonSkeleton({
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
      decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
    );
  }
}

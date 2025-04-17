import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class CheckboxSkeleton extends BaseSkeleton {
  final double height;
  final double width;

  const CheckboxSkeleton({
    super.key,
    required super.baseColor,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

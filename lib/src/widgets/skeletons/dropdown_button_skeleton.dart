import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class DropdownButtonSkeleton extends BaseSkeleton {
  final double height;
  final double width;

  const DropdownButtonSkeleton({
    super.key,
    required super.baseColor,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

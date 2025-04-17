import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class DropdownButtonSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;

  const DropdownButtonSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 160,
      height: height ?? 48,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

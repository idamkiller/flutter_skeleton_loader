import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class CheckboxSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;

  const CheckboxSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 36,
      height: height ?? 36,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

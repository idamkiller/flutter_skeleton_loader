import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class SizedBoxSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;
  final bool isEmpty;

  const SizedBoxSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
    required this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: !isEmpty
          ? BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
    );
  }
}

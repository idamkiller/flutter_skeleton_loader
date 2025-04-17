import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class SliderSkeleton extends BaseSkeleton {
  final double height;

  const SliderSkeleton({
    super.key,
    required super.baseColor,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

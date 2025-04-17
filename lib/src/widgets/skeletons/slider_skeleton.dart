import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class SliderSkeleton extends BaseSkeleton {
  final double? height;

  const SliderSkeleton({super.key, required super.baseColor, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 20,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'base_skeleton.dart';

class RadioSkeleton extends BaseSkeleton {
  final double? width;
  final double? height;

  const RadioSkeleton({
    super.key,
    required super.baseColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 20,
      height: height ?? 20,
      decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
    );
  }
}
